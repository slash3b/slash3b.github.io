---
title: "Case of a leaking timer in go"
date: 2022-11-13T17:29:38+02:00
tags: ["memory leak", "go", "time.After"]
---

It was only an accident that I read a [post on ArangoDB site](https://www.arangodb.com/2020/09/a-story-of-a-memory-leak-in-go-how-to-properly-use-time-after)
and found the same leak in one of our projects at work. So this is going to be quite short, but nevertheless I want for have 
it in form of a blogpost.

Here is how leak looked like:
```golang
package main

import (
        "fmt"
        "runtime"
        "time"
)


func main() {
        messags := make(chan string)
        for {
                select {
                case msg := <- messages:
                        // do smth with msg
                        fmt.Println(msg)
                        return msg
                case <-time.After(time.Second * 3):
                        // do smth else
                        fmt.Println("3 sec timer fired")
                case <-time.After(time.Second * 30):
                        fmt.Println("30 sec timer fired")
                        return
                }
        }
}
```

### What is wrong with it?  

There is a lot:

#### Lets remember what doc says about `time.After`

> ```
> package time // import "time"
>
> // After waits for the duration to elapse and then sends the current time
> // on the returned channel.
> // It is equivalent to NewTimer(d).C.
> // The underlying Timer is not recovered by the garbage collector
> // until the timer fires. If efficiency is a concern, use NewTimer
> // instead and call Timer.Stop if the timer is no longer needed.
> func After(d Duration) <-chan Time {
>       return NewTimer(d).C
> }

That means that on first iteration we create **2 timers**.

#### Now, depending on the logic, here is what we have:
- note: a great catch here is that 30s times is always leaking. It never has a chance to fire!
- ever spinning loop,   
in case `messages` are not sent at all,   
_two new timers created on each iteration_ with only 3s timer firing  
- if anything is sent to `messages` channel then we quit, but leave 2 more timers hanging. 

A good question to ask is — how exactly timers are leaking? I imagine it this way, this loop exists in one stack frame.
So once stack frame is removed, any data living on that stack is removed as well. 
Well, sometimes it is not that easy.
> Stack allocation requires that the lifetime and memory footprint of a variable can be determined at compile time.  

And I am thinking, timer itself is an uncertain data type. Timer channel (it is a part of timer) can be used in many ways and be used concurrently by
other variables, so we can not "just" delete it from stack! That is why timer escapes to heap.  

#### How to fix?
I'd go with `context.WithDeadline()` to be able to timeout loop and also I'd use `time.Ticker` instead of `time.After`. But I guess you can get creative with it
as much as you like. 
