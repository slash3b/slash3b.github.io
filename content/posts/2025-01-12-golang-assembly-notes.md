---
title: "Go assembly notes"
date: "2025-01-12T15:48:38+03:00"
tags: ["go", "assembly"]
---

mention a few words about go pseudo assembly 

Trying to compile and disassembly code of the whole project makes no sense. Use small snippets of code.


example code in `main.go` file:
```golang
package main

func main() {
    println("hello")
}
```

use `go tool compile` to get object files.  
`go tool compile main.go`  

`go tool objdump main.o` output:
```
TEXT main.main(SB) /tmp/test/main.go
  main.go:3		0x524			493b6610		CMPQ SP, 0x10(R14)	
  main.go:3		0x528			762a			JBE 0x554		
  main.go:3		0x52a			55			PUSHQ BP		
  main.go:3		0x52b			4889e5			MOVQ SP, BP		
  main.go:3		0x52e			4883ec10		SUBQ $0x10, SP		
  main.go:4		0x532			e800000000		CALL 0x537		[1:5]R_CALL:runtime.printlock<1>	
  main.go:4		0x537			488d0500000000		LEAQ 0(IP), AX		[3:7]R_PCREL:go:string."hello\n"	
  main.go:4		0x53e			bb06000000		MOVL $0x6, BX		
  main.go:4		0x543			90			NOPL			
  main.go:4		0x544			e800000000		CALL 0x549		[1:5]R_CALL:runtime.printstring<1>	
  main.go:4		0x549			e800000000		CALL 0x54e		[1:5]R_CALL:runtime.printunlock<1>	
  main.go:5		0x54e			4883c410		ADDQ $0x10, SP		
  main.go:5		0x552			5d			POPQ BP			
  main.go:5		0x553			c3			RET			
  main.go:3		0x554			e800000000		CALL 0x559		[1:5]R_CALL:runtime.morestack_noctxt	
  main.go:3		0x559			ebc9			JMP main.main(SB)	
```


Links:
- [GopherCon 2016: The Design of the Go Assembler - Rob Pike](https://www.youtube.com/watch?v=KINIAgRpkDA)
- [A Quick Guide to Go's Assembler](https://go.dev/doc/asm)
- [go-internals](https://github.com/teh-cmc/go-internals/blob/master/chapter1_assembly_primer/README.md
)

