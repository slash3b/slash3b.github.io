---
layout: post
date: 2021-09-04
title: "Golang channel tricks and patterns"
---

Concurrency is the composition of independently executing computations.  

Goroutines are not threads, but it is not wrong to think about goroutines as threads. 
In fact in runtime goroutines are multiplexed onto threads that are created as needed in order to make sure
no goroutine ever blocks. 

- [Generator](#generator)
- [Multiplexer](#multiplexer)
- [nil channel trick](#nil-channel-trick)
- [Worker pool](#worker-pool)

### <a name="generator"> Generator. Function that returns never closed channel. </a>  

Basically `generate` func returns unbuffered channel that is never closed and hence returns ever increasing counter. 

```
package main

import (
	"fmt"
	"strconv"
)

func main() {
	out := generate()

	for i := 0; i < 5; i++ {
		fmt.Printf("Generated %s \n", <-out)
	}

	fmt.Println("Done!")
}

func generate() <-chan string {
	a := make(chan string)

	go func() {
		i := 0
		for {
			a <- strconv.Itoa(i)
			i++
		}
	}()

	return a
}

```

### Multiplexer 
#### Otherwise knows as fan-in function

Simple pattern in which two channels communicate with "fan in" channel concurrently. 

```
package main

import (
    "fmt"
    "math/rand"
    "time"
)

func sayHey(prefix string) <-chan string {
    heyCh := make(chan string)

    go func() {
        for {
            // so it takes some time to output "hey"
            time.Sleep(time.Second * time.Duration(rand.Intn(4)))
            heyCh <- fmt.Sprintf("hey %s", prefix)
        }
    }()

    return heyCh
}

func fanIn(a, b <-chan string) <-chan string {
    fanInChannel := make(chan string)

    go func() {

        for {
            select {
            case fanInChannel <- <-a:
            case fanInChannel <- <-b:
            }
        }
    }()

    return fanInChannel
}

func main() {
    rand.Seed(time.Now().UnixNano())

    a := sayHey("A")
    b := sayHey("B")

    fan := fanIn(a, b)

    for i := 0; i < 6; i++ {
        fmt.Println(i, <-fan)
    }

    fmt.Println("done!")
}

```

#### NOTE.

> In these examples individual components we use are a sequential code and we are composing
> their independent execution. 
> 
> Channels are a first-class values in go. It means we can pass a channel to a channel, or e.g. a function to a function. 
> 


### nil channel trick 
#### way to disable a `case` in `select` 

```

package main

import (
    "fmt"
    "math/rand"
    "time"
)

func main() {

    rand.Seed(time.Now().UnixNano())
    a, b := make(chan string), make(chan string)
    go func() { a <- "A" }()
    go func() { b <- "B" }()

    // here, we randomly "nullifying" one of the channels,
    // effectively disabling `case` in `select`
    if 0 == rand.Intn(2) {
        a = nil
    } else {
        b = nil
    }

    select {
    case out := <-a:
        fmt.Println(out)
    case out := <-b:
        fmt.Println(out)
    }

}


```

### Worker pool
#### a pool of workers eager to process your data 

A pool of worker goroutines ready to process incoming channel. 
Example below uses unbuffered channel but it can use buffered as well if you need it.

```
package main

import (
    "fmt"
)

func main() {
    in := make(chan int)
    out := make(chan int)

    for i := 0; i < 5; i++ {
        go worker(i, in, out)
    }

    go func() {
        defer close(in)
        for i := 0; i < 5; i++ {
            in <- i
        }
    }()

    for i := 0; i < 5; i++ {
        fmt.Printf("--> reseived result %d from `out` channel \n", <-out)
    }

    fmt.Println("END")

}

func worker(id int, in <-chan int, out chan<- int) {
    for v := range in {
        result := v * 2
        out <- v
        fmt.Printf(" <-- worker #%d have sent value: %d \n", id, result)
    }

    fmt.Println("exiting worker #", id)
}
```


### Rate limiter

simple rate limiter using a buffered channel 
wrap handler with a func that tries to add to channel
and defers release. If lenght of buffered channel is 10
then when we have 10 ongoing requests will be pending 

```
	rateLimiterMiddleware := func(f func(http.ResponseWriter, *http.Request)) func(http.ResponseWriter, *http.Request) {

		limitingBuffer := make(chan struct{}, 10)
		return func(w http.ResponseWriter, r *http.Request) {

			limitingBuffer <- struct{}{}
			defer func() { <-limitingBuffer }()

			f(w, r)
		}
	}
```

Sources:
- https://www.youtube.com/watch?v=f6kdp27TYZs
- https://www.youtube.com/watch?v=QDDwwePbDtw
