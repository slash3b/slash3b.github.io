---
title: "Go slices mind-twister"
date: "2024-05-05T15:48:38+03:00"
tags: ["go"]
---


This [snippet](https://gist.github.com/janosdebugs/f0a3b91a0a070ffb067de4dc22a93c64) of code got me off guard.  
Having a somewhat decent experience with golang I could not explain what is it doing and it took me embarrassingly a lot of time to figure out a sound explanation for what was going on.  

After I figured out the answer, I think that my sleep deprivation just played tricks on me. Still let's dig into this.  

Down below is the same snippet but with a slice of integers for simplicity:

```golang
package main

import (
    "fmt"
)

func main() {
    firstSlice := []int{1,2,3,4,5,6}
    firstSlice = firstSlice[:5]
    secondSlice := firstSlice
    firstSlice = append(firstSlice, 8)

    // This will print: [1 2 3 4 5 8]
    fmt.Println(firstSlice)

    secondSlice = append(secondSlice, 10)

    // This will print: [1 2 3 4 5 10]
    fmt.Println(firstSlice)
    // This will print: [1 2 3 4 5 10]
    fmt.Println(secondSlice)

    // Bonus:

    firstSlice = append(firstSlice, 11)
    secondSlice = append(secondSlice, 13)
    // This will print: [1 2 3 4 5 10 11]
    fmt.Println(firstSlice)
    // This will print: [1 2 3 4 5 10 13]
    fmt.Println(secondSlice)
}

```

We created a slice of integers, then we re-sliced it down by one last element.  

> Hold on a second. What is a slice really?  

There is a ton of material online on that subject. I only mention that slice is a 3 word data structure, that looks like this:
```
$ go doc reflect SliceHeader
package reflect // import "reflect"

type SliceHeader struct {
        Data uintptr
        Len  int
        Cap  int
}
...
```
Each slice points to the underlying array in memory.  

Back to code.  

On line 10 we copied `firstSlice` to `secondSlice`. Remember, that we only copied 3 word data structure, not the array itself. 

I am going to use `dlv` and  run `dlv debug main.go` and put a breakpoint on line 11 with `break ./main.go:11`.
Now let's see how both slices look like in memory:
```
(dlv) examinemem -fmt hex -size 8 -count 3 -x &firstSlice
0xc000192e70:   0x000000c0001a6000   0x0000000000000005   0x0000000000000006
(dlv) examinemem -fmt hex -size 8 -count 3 -x &secondSlice
0xc000192e58:   0x000000c0001a6000   0x0000000000000005   0x0000000000000006
```
As you can see both slices are of length 5 and have capacity 6.
Both slices point to the same address in memory.  
But what is that address `0x000000c0001a6000`?  
This address points to the __first__ element in contiguous block of memory allocated for array.  

By knowing the address of the first element of array and knowing its capacity we can see the whole array in memory, like this:
```
(dlv) examinemem -fmt dec -size 8 -count 6 -x 0x000000c0001a6000
0xc0001a6000:   000000000000000000000001   000000000000000000000002   000000000000000000000003   000000000000000000000004   000000000000000000000005   000000000000000000000006
```

Let's go further. On line 11 we append `8` int to the `firstSlice`.  
Slice having len 5 and cap 6 takes in another integer and overwrites value `6`.  
Observe that pointer address to the first element did not change.
```
(dlv) examinemem -fmt hex -size 8 -count 3 -x &firstSlice
0xc000192e70:   0x000000c0001a6000   0x0000000000000006   0x0000000000000006
```
And when I print the `firstSlice` I see it is of len 6 with `8` being the last element:
```
(dlv) p firstSlice
[]int len: 6, cap: 6, [1,2,3,4,5,8]
```

Now, let's jump straight to the line 21. A new integer was added to `secondSlice`, but somehow it did change the `firstSlice` as well! What the hell? And the answer is quite simple.  

Both slices point to the same region in memory, namely first element of an array. **The lenght and capacity is what is unique for every slice**.
With this knowledge it is clear that while an `8` was added to the `firstSlice` it was also added to the `secondSlice`. The catch is that `secondSlice` did not know about this because its len was at 5. So when `secondSlice` took in `10` value it effectively replaced `8`.  


Moving further.

Jumping straight to the end of our code snippet, line 30.
Clearly appending `11` to the `firstSlice` and `13` to the `secondSlice` does not have the same effect we observed before.  

What happened?  

Slices grew up. Both slices were at the point when slice lenght and capacity were equal. When new element is added, a couple of things happen. A new, larger array is allocated in memory, then all values from old array are copied to new one. All that happens in `append` builtin function. So on lines 25 and 26, `append` created two new **separate** slices, each with its own underlying array in memory.
```
(dlv) examinemem -fmt hex -size 8 -count 3 -x &firstSlice
0xc0001b1e70:   0x000000c00018c060   0x0000000000000007   0x000000000000000c
(dlv) examinemem -fmt hex -size 8 -count 3 -x &secondSlice
0xc0001b1e58:   0x000000c00018c0c0   0x0000000000000007   0x000000000000000c
```

Note how `firstSlice` and `secondSlice` are no longer point to the same `Data` pointer address.  

And both now live a separate life.
```
(dlv) p firstSlice
[]int len: 7, cap: 12, [1,2,3,4,5,10,11]
(dlv) p secondSlice
[]int len: 7, cap: 12, [1,2,3,4,5,10,13]
```

That is it. Thanks for reading!  
Please sleep normal hours if you can.  


Links:
- [slices intro](https://go.dev/blog/slices-intro)
- [research.swtch.com/godata](https://research.swtch.com/godata)
- [slice header explanation](https://www.youtube.com/watch?v=fF68HELl78E)

