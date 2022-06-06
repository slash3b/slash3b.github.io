---
title: "Notes on Garbage Collection in Golang"
date: 2022-06-05T17:29:38+02:00
tags: ["GC", "garbage", "sweep", "golang"]
---

Garbage Collection is a process of freeing memory that is allocated and contains some data that is not being used.     

Notes:   
- by doing __escape analysis__ GC mechanism decides what goes to heap and what stays on stack
- use `-gcflags '-m'` flag to get escape analysis info, e.g. `go run -gcflags '-m' main.go` 
- another way to look into what GC is doing during runtime is to run program with `GODEBUG=gctrace=1`
- GC runs consurrently with main program running 
- main running program is called "mutator" 
- Golang Garbage Collection uses "tricolor algorithm" otherwise known as tricolor mark and sweep algorithm. 
- GC represents data in the heap as graph of elements/objects
- channels are also garbage collected when they become unreachable, even if channel is not closed 

Sources:
- [very simple, down to earth overview of GC algorithms by Ken
  Fox](https://spin.atomicobject.com/2014/09/03/visualizing-garbage-collection-algorithms)
- https://jameshfisher.com/2016/11/11/tricolor-gc/
- https://www.packtpub.com/product/mastering-go-third-edition/9781801079310
- https://en.wikipedia.org/wiki/Tracing_garbage_collection#Tri-color_marking
- https://lamport.azurewebsites.net/pubs/garbage.pdf
- https://gchandbook.org/
- https://go.dev/doc/faq#stack_or_heap
- https://github.com/ardanlabs/gotraining/tree/master/reading#garbage-collection
