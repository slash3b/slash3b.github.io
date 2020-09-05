---
layout: post
date: 2020-09-05
comments: true
title: "A philosophy of software design by John Ousterhout"
---

I like that book and decided to make a "short" version for myself to remember it better.  
The book is only 190 pages long but it has lots of valuable advices and author takes things straight to the point. 

This is just my own "retelling" of the book. If you are reading this I encourage you to first buy and read the whole
book and only then this text below __might__ make sense to you. Or not.  


#### Chapter 1. Introduction   
...All programming requires is a creative mind and the ability to organize your thoughts. If you can visualize a system,
you can probably implement it in a computer program. Any system inevitably becomes complex over time — as it grows and
more and more people work on it. Complexity growth makes it next to impossible to hold a clear and complete picture of
a system in one's head.  
Bottom line is — complexity will grow anyway but it is your reponsibility and duty to hold that growth as much as you
can.   

There are two ways to fight complexity:
- make code more simple and obvious
- incapsulation of a complexity using _modular design_ 

Sofware design is never done, it happens through the lifetime of a software. You should always think about system desing
and ways to improve it.

#### Chapter 2. The nature of complexity  

Complexity is anything related to the structure of a software system that makes it hard to understand, modify and
maintain the system. Another view at complexity is a cost of development — it takes much time to implement event the
simple features, usually you have to change lots of files to do it and overall it is a bit chaotic.  

Symptoms of complexity:
- change amplification. Seemingly simple change requres change in a lot of different places 
- cognitive load. A developer has to know a lot about the system in order to complete a task 
- unknown unknowns. It is not obvious which part of the code should be modified to complete a task

Complexity is caused by:
- dependencies. When a given piece code can not be understood and modified independently. Often that kind of code is
  tightly coupled with other modules, in that case you always have to think about coupled modules and modify them as
  well most likely.
- obscurity. Important information is not obvious, e.g. it is not clear what method does by its name so you have to scan
  throug its body to figure that out.

#### Chapter 3. Working code is not enough  

Author distinguished two types of mindset — tactical and strategic  

Tactical programming means implementing features as quickly as possible. It is almost impossible to produce good design
in this case. Perhaps developer is forced to work under a tight deadline and there is simply no room to think about
consequences. In this case you do not plan for future you are coming up with a quick and probably dirty solution. In
this environment complexity accumulates quickly.

Strategic programming means that you have to get more time to think about design of a particular solution. It will
definitely has its toll in the beginning but will pay off in a long run with clear and simple design that is easy to work.

The first step on a path to a become a better programming is to realize — working code is not enough. It is simply no
enough to "make things work". You should double check if any unnecessary complexities has been introduced and eliminate
them.  

Strategic programming requires investment mindset. Instead of just shipping features fast you want to take time to
improve design of your system. You should strive to do it every time you touch the code.

#### Chapter 4. Modules should be deep   
Modular desing allows a programmer to face a portion of design complexity of the system. Author distinguish two types of
modules with shallow and deep design. Shallow desing provide lots of method to work with, it gives us "bloated"
interface that hide not so much functionality. On the other side well designed deep modules effectively hide complexity
and provide a lot of benefit using slim interface.
There is a brillian example of file I/O provided by UNIX operating system that gives us 4 simple but yet very powerfull
system call to work with. 

#### Chapter 5. Information hiding
The basic idea of information hiding is for the module to conceal information that represents design decisions inside.
This information is not exposed from the API.

Information hiding and deep modules are closely related. If a module hides a lot of information that tends to increase the
amount of benefit api provides that makes module really deep. 

Flat/shallow modules with a lot of noise in the api tend to hide little information.

Also be aware of temporal decomposition — module split into many classes guided by the order in which operations happen
in the runtime or a similar cause. In case of temporal decomposition, classes tend to leak information between each
other that makes the whole design cumbersome. That is where deep modules design come into play.

#### Chapter 6. General purpose modules are deeper.   

There are two approaches to the module design — general-purpose and special-purpose. General purpose design allows for
better system design and deeper module, it is preferrable. General purpose interface reduces cognitive load as well,
since developer have to learn just a few simple method to be productive.  

Here is a list of questions that will help to find balance between general-purpose and special-purpose design:
- What is the simplest interface that will cover all my current needs? If you managed to reduce a number of API methods
  without losing any benefit provided then your module becomes more general-purpose. Note: if you are in a process of
  simplifying an api but method signature becomes complex with lots of arguments then you are not really simplifying
  things.  
- In how many situations this method will be used? 
- Is this API is easy to use for my current needs?


#### Chapter 7. Different layer, different abstraction  

Software systems consist of layers. Each layer has its own purpose and is able to change data flowing through it. Think
OSI model for instance.  
It is a red flag if a system has a fewer adjacent layers on the same level.  

Pass-through methods are methods that do nothing or almost nothing and passing arguments down to the next level. 
There are ways to solve it with:  
- merging both layers into one making the interface of a new layer deeper
- splitting layer and re-distibuting functionality
- just call methods of underlying layer directly

Pass-throught variables is another red flag tend to unnecessarily "extend" all underlying layer APIs. Those kind of
variables add complexity as well forcing every layer to be aware of their existence but not using it much.  
One of the ways to fight it is to analyse if there is an object/struct that is already passed through layers. It might
make sense to include pass-through variable into this object.  

Another approach is to store that variable in a global variable accessible everywhere or may be inside environment
variable accessible to the entire process/container.  

#### Chapter 8. Pull complexity downwards  

If you are developing a new module and there is an unavoidable complexity it is better to strive to provide simple
interface for this module. Module is always has more users then developers, users of your module should not deal with
all the complexity you have.  

#### Chapter 9. Better together or better apart?  

This chapter discusses the following question — if you have two pieces of functionality how you should deal with them?
Should you merge them, should you split them, should you combine them in some clever way? 

In order to answer this question you have to always remember your ultimate goal — hide complexity, make module/method
more deep, increase modularity, strive to simplicity.  

- Bring together if information is shared
- Bring together if it will simplify the interface
- Bring together to eliminate duplication
- Separate general-purpose and special purpose code 

#### Chapter 10. Define errors out of existence    

Error/exception handling is one of the worst sources of complexity. Exceptions/error might happen due numerous reasons
and usually programmer tries to throw all kinds of different exceptions. Most of the times exceptions are handled
poorly and code that tends to handle exceptions is bloated trying to consider all possible exception cases. 

One of the ways to combat exceptions and errors is to get rid of the them at all. Consider this example — you are using
menthod "Delete" to remove a node from linked list. In case node is not present in the list you might be tempted to
throw Exception telling about it to the user. Instead return a successful result as if it was deleted.  

Another technique is called exception masking and it means you should not throw exception but try to correct the
situation. Like in TCP protocol when packet gets lost, protocol does not report an error but instead lost packet is
requested again.

Third way to solve it by exception aggregation, in this case you have one place to catch and handle exceptions instead
of doing it all over your code base.  

Another interesting way is to just crash an application. Some types of errors render any handling next to useless so it
makes sense in case of an error to pring debug info and just cransh an application. 

#### Chapter 11. Design it twice   

For each major design decision you want to consider few different options, you should "measure" and design twice.  
Try to get different appoaches attacking problem at hand from different angles. It will 

#### Chapter 12. Why write comments the four excuses  

This chapter explains all excuses there are to not write a comments. 
The core idea of the comments in the system is to express information that is in the mind of the writer and could not be
reflected in the code. So comments are highly important. 

#### Chapter 13. Comments should describe things that are not obvious from the code 

One of the best benefits of comments is abstractions — it includes a lot of not obvious information. Comment should
provide a simple, high-level overview of the code. It should be possible to understand what method does by reading a
comment and method name. 

Pick convetion for commenting and stick to it. Convention will ensure consistency and readability of your comments.

In order to write a good comment, you may/should:
- use different words in the comment from those in the method signature/entity/etc..
- augment the code by providing a different level of detail. Sometimes you need to provide comment at much lower level
  than the code is. Such comments add _precision_. On the other hand there are comments that provide a high-level
  overview of what is going on, those comments provide _intuition_. Intuition helps you to understand what, how and why
  was implemented in a particular way. 

Code should be obvious to the reader. Part of an information about the system, implementation is represented in the
code, but not all the information can be received by reading code. Comments fill that gap and tell readed the whole
story of the system or implementation.  

Important note — code should be obvious to the reader during code review.  

#### Chapter 14. Choosing names  

Naming is hard but important, good name decreases complexity, remove any misunderstanding and ambiguities.  

#### Chapter 15. Write the comment first  

This short chapter boils down to neccessity to write comments first since it is an excellent design tool. It may be
sub-optimal to start writing code. Write comments first and use them to shape your understandng of what is going to be
implemented. 

#### Chapter 16. Modifying existing code  

While you are modifying existing code you should apply strategic instead of tactical approach. When you are doing any
change you should strive to impove/polish design decisions you are having at hand. If you are not doing it, you are
probably making it worse.  

#### Chapter 17. Consistency  

Consistency is another simple concept that helps you to decrease complexity. What should be consisten in the system: 
- naming
- coding style
- interfaces with multiple implementation helps to understand system better
- well know and wisely applied design patterns. You should think twice before applying any pattern

In order to ensure consistency you might write a documentation page about it which is easy to find, also you should
definitely add some tools to your pipeline that enforce consistency.

#### Chapter 18. Code should be obvious  

Obvious code means you do not have to spend a lot of time to read it in order to understand it. Best way to detect
non-obvious code is through code review since to you your code is almost always obvious. 

Consistency, good naming, properly formatted comments make your code more obvious.  

If code is not obvious then a reader of your code does not have important information about your code. Thus reader might
get a wrong assumption about code and do incorrect implementation or spend too much time on implementation.

#### Chapter 19. Software trends  

In my opinion this chapter boils down to the wise and old saying — "Question everything".  
My favourite part is about Design Patterns. I do respect pattern and I think you should at least know why do we need
them and how to implement them. And the greates risk with pattern is over-application, when a programmer starts to apply
pattern in such places where a patter does not fit or does not fill well. It is like a hammer for which everything is a
nail.  

That over-application is also true for almost everything else. I've seen "clean architecture" applied to the simple CRUD
application which made it over-engeneered right of the bat. It is like you finally understood some fucking DDD or
whatnot and now you have to apply it at all cost to prove something to yourself or others.  

#### Chapter 20. Designing for performance  

Main conclusion of this chapter is that clean design and high performance are compatible. Simplicity leads to more
performant code.  

If you have to increase performance of you programm do not rely on your intuition and rush to make changes here and
ther. First step is to measure you program's performance/behaviour and identify bottlenecks you have. Second step is to
an actual improvement aroung bottleneck. Author writes that the only way to optimize "critical path" is to do a
fundamental change, for example introduce caching, or start to use more efficient data structure that helps you to
decrease time/space complexity of an algorithm.  


