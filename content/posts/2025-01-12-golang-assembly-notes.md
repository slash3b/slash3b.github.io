---
title: "Few notes on Go assembly"
date: "2025-01-12T15:48:38+03:00"
tags: ["go", "assembly"]
---

A collection of practical notes and references for understanding Go's assembly language and pseudo-assembly compilation process.

<!--more-->


**Note #1**: If you do not know assembly, here is a well written introduction to assembly: https://github.com/hackclub/some-assembly-required

**Note #2**: Trying to compile and disassembly code of the whole project makes no sense. Use small snippets of code. Seems to be obvious, eh?

**Note #3**: Go uses pseudo assembly. From that assembly go can build/link/compile for any architecture.

**Note #4**: Use `go tool compile` to compile package code to the object file. Use `go tool objdump` to see what gets into the binary. Do not forget that you can always view documentation for these commands with `go doc cmd/compile` or `go doc cmd/objdump`.

**Note #5**: In 1.17 calling convention has changed from stack based to registers based. Calling convention is a part of Application Binary Interface.

Links:
- [A Quick Guide to Go's Assembler](https://go.dev/doc/asm)
- [GopherCon 2016: The Design of the Go Assembler - Rob Pike](https://www.youtube.com/watch?v=KINIAgRpkDA)
- [go-internals](https://github.com/teh-cmc/go-internals/blob/master/chapter1_assembly_primer/README.md)
- [Register-based calling convention, GO? (in Russian)](https://habr.com/en/articles/571420)
- [Golang by Rebrain: GO Assembly](https://www.youtube.com/watch?v=f0rU4M42s9Q)


