---
layout: post
date: 2021-02-18
title: "Notes on competitive programming"
---

Modular arithmetic. 

An important property of the remainder is that in addition, subtraction and
multiplication, the remainder can be taken before the operation:
```
( a + b ) mod m = ( a mod m + b mod m ) mod m
( a − b ) mod m = ( a mod m − b mod m ) mod m
( a · b ) mod m = ( a mod m · b mod m ) mod m
```

Math. 
An arithmetic progression is a sequence of numbers where the difference between any two consecutive numbers is constant. 
The sum of an arithmetic progression can be calculated by using formula ((a+b)n)/2 where a is the first number, b is the
last number in sequence, n is the number of values in sequence. This formula is based on the fact that each number in
the sequence in can be expressed as (a+b)/2 where a is the number itself and b is the corresponding number in the
sequence from the other end. e.g. in sequence 1,2,3,4,5 (1+5)/2, (2+4)/2 equal to 3, as well as the number on position 2
which is also 3!

A geometric progression is a sequence of numbers where the ratio between any two consecutive numbers is constant. e.g.
in sequence 3,6,12,24 the ratio is 2. 

A set is a collection of elements. For example, the set X = {2, 4, 7} contains elements 2, 4 and 7. The symbol ∅ denotes 
an empty set, and |S| denotes the size of a set S , i.e., the number of elements in the set. For example, in the above 
set, |X| = 3. If an element belong to the set we write 2 ∈ X, and when element does not belong to set we write 8 ∉ X. 

Intersection of sets are denoted with ∩ sign, for instance here are sets A = {1,2,3} and B = {3,8}, an intersection is A
∩ B = {3}. Union of sets above includes all elements from both sets and is A ∪ B = {1,2,3,8} 

The complement Ā consists of elements that are not in A. What is included in Ā depends on universal set which represents
all possible values. For example universal set is {1,2...10}, and A = {1,2,3,4,5,6,7,8} then Ā = {9,10} 

The difference A / B consists of elements that are in A but not in B. e.g. A = {2,3,7,8} and B = {3,5,8}, then A / B =
{2,7}

If each element of A may be found in B then we say A is a subset of B. 

Big O complexity.
If there is another variable in the nested loops, check example, then the complexity is O(nm):
```
for (int i = 1; i <= n; i++) {
  for (int j = 1; j <= m; j++) {
    // code
  }
}
```
Note: Logarithimc algorithm halves the input size at each iteration. 

... given the input size we can try to guess the required space complexity of an algorithm.  
A simple idea here is that with bigger input we should strive towards better performance, up to O(1),
with little input nobody cares about performance. 

Sorting.

A userful concept — inversion, a pair of array elements array[a] and array[b], such that a < b and array[a] > array[b].
A number of invesions shows how much work is needed to be done to sort array. 
Example of an efficient sorting algorithm is a merge sort. Doing recursive sorting it halves size of a sub-array each
time. 

It is not possible to sort faster than n log n using sorting that compares values. 
For instance counting sort does not compare values so it can sort in O(n) time.  

Complete search.  
The idea of coplete search is to generate all possible solutions to the problem using brute force and then select the
best ones. It is a pretty valid idea if you have enough time to do it.

Backtracking algorithm. The core idea of this algorithm is that we start from empty solution and expand it step by step,
abandoning branches that do not lead to correct solution. From wikipedia "Backtracking is a general algorithm for finding
all (or some) solutions to some computational problems, notably constraint satisfaction problems, that incrementally
builds candidates to the solutions, and abandons a candidate ("backtracks") as soon as it determines that the candidate
cannot possibly be completed to a valid solution."  
Using simple observations we can effectively prune search greatly. Remember the problem of calculating the number of paths in an n × n grid from the upper-left corner to the lower-right corner such that the path visits each square exactly once.

Greedy algorithms. 

A greedy algorithm constructs a solution to the problem by always making a choice that looks the best at the moment. A
greedy algorithm never takes back its choices, but directly constructs the final solution.

Dynamic programming.

Dynamic programming is a technique that combines the correctness of complete search and efficiency of greedy algorithm.  
Dynamic programming can be applied if the problem can be divided into overlapping subproblems that can be solved
independently. Two types of dynamic programming are: finding an optimal solution that is as large as
possible or as minimum as possible, count a number of solutions. 








