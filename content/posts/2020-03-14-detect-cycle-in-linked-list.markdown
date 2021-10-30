---
layout: post
date:   2020-03-11
comments: true
title: "Detect cycle in singly linked list (python)"
---

As I'm improving my data structures knowledge and understanding I'm trying to solve different puzzles. One of them is to detect cycle in a sigly-linked list.

Singly-linked list consits of nodes that reference one another. A node could look like this:
```

class Node:
    def __init__(self, value=None):
        self.next = None
        self.value = value

```
So it has two properties — _next_ that contains next element, and _value_ that contains data. Could be more complex than this but lets not complicate.

Lets create linked list of 12 nodes and connect them in a circle.
```

a = Node(1)
b = Node(2)
c = Node(3)
d = Node(4)
e = Node(5)
f = Node(6)
g = Node(7)
h = Node(8)
i = Node(9)
j = Node(10)
k = Node(11)
l = Node(12)

a.next = b
b.next = c
c.next = d
d.next = e
e.next = f
f.next = g
g.next = h
h.next = i
i.next = j
j.next = k
k.next = l
l.next = a

```

Now how would you go about solving this? And solving efficiently, namely `O(n)` time and `O(1)` space complexity ? I could not solve it. I've been thinking about something horrible like "I need to have an additional dictionary with node values as keys and linked list of nodes as values of a dictionary as we may have a duplicates..." Feels overly complex and wrong 🤔   

There is an elegant algorithm that is called "Floyd's cycle-finding algorithm" and it was coined by computer scientist [Robert W. Floyd](https://en.wikipedia.org/wiki/Robert_W._Floyd).

Here is algorithm description carefully paster from wiki:  
> Floyd's cycle-finding algorithm is a pointer algorithm that uses only two pointers, which move through the sequence at different speeds. It is also called the "tortoise and the hare algorithm", alluding to Aesop's fable of The Tortoise and the Hare. 

My wife [Tatiana Timoshina](https://onboard.studio/) made this nice animation: 

<img src="/assets/images/hare.gif">  

Blue runner runs twice as fast. Orange and blue runners meet exactly when orange finishes its first circle. 

And solution:  

```

def detect_cycle(head):
    if head == None:
        return False

    runner1 = head
    runner2 = head.next

    while runner1 != None and runner2 != None:
        if runner1 == runner2:
            return True

        # runner1 makes one step ahead
        # runner2 makes two steps, moving twice as fast
        runner1 = runner1.next
        runner2 = runner2.next.next

    return False

print(detect_cycle(a))

```

To everyone who is looking for a way to improve data structures knowledge I'd recommend [Python for Data Structures, Algorithms, and Interviews! ](https://www.udemy.com/course/python-for-data-structures-algorithms-and-interviews/) course.

