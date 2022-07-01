---
layout: post
date: 2021-09-04
title: "Golang concurrency tricks and patterns"
---

Concurrency is the composition of independently executing computations.  

Goroutines are not threads, but it is not wrong to think about goroutines as threads. 
In fact in runtime goroutines are multiplexed onto threads that are created as needed in order to make sure
no goroutine ever blocks. 

- [Generator](#generator)
- [Multiplexer](#multiplexer)
- [nil channel trick](#nil-channel-trick)
- [Worker pool](#worker-pool)
- [Confinement](#confinement)
- [Error handling](#error-handling)

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

### Confinement   
#### safety operations with concurrent code   

Apart from well know way to work with concurrent code in Go, sync primitives and channels, 
there are other two: *data confinement* and *data immutability*.   

Data immutability is a simple and yet powerfull techique. Every goroutine operates on its own
copy of a data. This leads to easied data management and low cognitive load.       

Data confinement makes data implicitly available only to one process/goroutine at a time.    
Data confinements comes in two flavors: ad-hoc and lexical.    

Ad-hoc confinement is a convention between programmers and your code base on how data is used.   
In some sense, generator pattern from above is a good example of data confinement. Generator can be used
concurrently but only one goroutine can get generated value at a time.    

Lexical confinement. Lexical confinement means usage of lexical scope to hide data we do not want to be used
concurrently. Example:
```
func example() <-chan int {
	a := make(chan int)

	go func() {
		defer close(a)
		for i := 0; i < 5; i++ {
				a <- i
		}
	}()

	return a
}
```

Main benefit of a confinement is a reduced cognitive load and "better" simplicity of a program.   

### Error handling
#### Or how to be a good lad and stop ignoring/hiding your errors

In terms of concurrency sometimes it might be hard to understand how, when and who should handle an error.   

Do not skip/ignore/hide an error that happened inside your goroutine. Bind err with response/outcome and return them together,
e.g. in a `Result` struct:  

```
type Result struct {
    Error error
    Response *http.Response
}
```

This will allow you to take more intelligent decision about error at the layer where we actually process results.  


### Additional but very important notes
> Goroutines are **not** garbage collected
____

Sources:
- https://www.youtube.com/watch?v=f6kdp27TYZs
- https://www.youtube.com/watch?v=QDDwwePbDtw
- Concurrency in Go by Cox-Buday K.
- https://web.mit.edu/6.005/www/fa15/classes/20-thread-safety/#strategy_1_confinement
- https://web.mit.edu/6.005/www/fa15/

