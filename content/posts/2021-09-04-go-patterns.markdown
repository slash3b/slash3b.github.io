---
layout: post
date: 2021-09-04
title: "All sizes of go patterns"
---

Concurrency is the composition of independently executing computations.  

Goroutines are not threads, but it is not wrong to think about goroutines as threads. 
In fact in runtime goroutines are multiplexed onto threads that are created as needed in order to make sure
no goroutine ever blocks. 

### Patterns. 

Generator. 
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

Fan-in function or Multiplexer.

```
package main

import (
	"fmt"
)

func sayHey() <-chan string {
	heyCh := make(chan string)

	go func() {
		for {
			// imagine it takes some random time to output "hey"
			heyCh <- "hey"
		}
	}()

	return heyCh
}

func fanIn(a, b <-chan string) <-chan string {
	fanInChannel := make(chan string)

	go func() {

		for {
			select {
			case ans := <-a:
				fanInChannel <- ans
			case ans := <-b:
				fanInChannel <- ans
			}
		}
	}()

	return fanInChannel
}

func main() {

	a := sayHey()
	b := sayHey()

	fan := fanIn(a, b)

	for i := 0; i < 6; i++ {
		fmt.Println(i, <-fan)
	}

	fmt.Println("done!")
}
```

NOTE.

In these examples individual components we use are a sequential code and we are composing
their independent execution. 


Worker pool
```
todo
```


Rate limiter
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
