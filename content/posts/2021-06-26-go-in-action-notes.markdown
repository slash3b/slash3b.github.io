---
layout: post
date: 2021-07-18
title: "Notes on 'Go in action' book"
---

Slice takes 24 bit of memory — 8 bit for pointer, 8 for len and 8 for capacity.  
Passing a slice between functions is okay, since it is copied BUT in the copied version we still have the correct pointer. 

Reference types in Go:
- string
- slice
- map
- channel
- interface
- function

The decision to use value or pointer receiver should not be based on whether method is mutating given value or not. 
Decision should be based on a nature of a given type. e.g. time is always a copy, you can't really change time. A File
can be changed so it should be passed as a reference. See how it is implemented in core library.  


Method set define rules around interface compliance.  
Method set is associated with value or pointer of given type and vice-versa. 

Method set rules. 
```
Values 			Methods Receivers
-----------------------------------------------
T			(t T)
*T			(t T) and (t *T)

Methods Receivers 	Values
-----------------------------------------------
(t T)			T and *T
(t *T)			*T
```

Exporting and unexporting indentifiers.

Identifiers are exported or unexported, not values. That means that it is possible to export "unexported" value. 
The short variable declaration operator is capable of inferring the type and creating a variable of the unexported type. 
You can never explicitly create a variable of an unexported type, but the short variable declaration operator can. 

Concurrency. 

Each process that is run by the system has at least one thread. This thread is called **main thread**.   

Concurrency is not parallelism. Parallelism can only be achieved when multiple pieces of code are executing simultaneously against different physical processors. Parallelism is about doing a lot of things at once. Concurrency is about managing a lot of things at once. In many cases, concurrency can outperform parallelism, because the strain on the operating system and hardware is much less, which allows the system to do more. This less-is-more philosophy is a mantra of the language.

Based on the internal algorithms of the scheduler, a running goroutine can be stopped and rescheduled to run again before it finishes its work. The scheduler does this to prevent any single goroutine from holding the logical processor hostage. It will stop the currently running goroutine and give another runnable goroutine a chance to run.

Suprisingly useful and light package "sync/atomic" to work with primitives while running goroutines. e.g. simple `atomic.StoreInt64()` can be used as a signal for all goroutines to stop work and return. 

Being able to receive on a closed channel is a very usefull since it allows to dry channel and not lost any data. 

Concurrency patterns. 

- Runner
- Pooling 
- Work

Standard library. 
Includes many useful things if you are just starting to learn the language. 

Testing and benchmarking.
Good introduction for those who start to learn language. 



