Chapter 1. Introduction
...All programming requires is a creative mind and the ability to organize your thoughts. If you can visualize a system,
you can probably implement it in a computer program. Any system inevitably becomes complex over time — as it grows and
more and more people work on it. Complexity groth makes it next to impossible to hold a clear and complete picture of
a system in one's head.  
Bottom line is — complexity will grow anyway but it is your reponsibility and duty to hold that growth as much as you
can.   

There are two ways to fight complexity:
- make code more simple and obvious
- incapsulation of a complexity using _modular design_ 

Sofware design is never done, it happens through the lifetime of a software. You should always think about system desing
and ways to improve it.

Chapter 2. The nature of complexity.

Complexity is anything related to the structure of a software system that makes it hard to understand, modify and
maintain the system. Another view at complexity is a cost of development — it takes much time to implement event the
simple features, usually you have to change lots of files to do it and overall it is a bit chaotic.  

Symptoms of complexity:
- change amplification. Seemingly simle change requres change in a lot of different places 
- cognitive load. A developer has to know a lot about the system in order to complete a task 
- unknown unknowns. It is not obvious which part of the code should be modified to complete a task

Complexity is caused by:
- dependencies. When a given piece code can not be understood and modified independently. Often that kind of code is
  tightly coupled with other modules, in that case you always have to think about coupled modules and modify them as
  well most likely.
- obscurity. Important information is not obvious, e.g. it is not clear what method does by its name so you have to scan
  throug its body to figure that out.

Chapter 3. Working code is not enough.

Author distinguished two types of mindset — tactical and strategic.

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


Chapter 4. Modules should be deep.   
Modular desing allows a programmer to face a portion of design complexity of the system. Author distinguish two types of
modules with shallow and deep design. Shallow desing provide lots of method to work with, it gives us "bloated"
interface that hide not so much functionality. On the other side well designed deep modules effectively hide complexity
and provide a lot of benefit using slim interface.
There is a brillian example of file I/O provided by UNIX operating system that gives us 4 simple but yet very powerfull
system call to work with. 

Chapter 5. Information hiding
The basic idea of information hiding is for the module to conceal information that represents design decisions inside.
This information is not exposed from the API.

Information hiding and deep modules are closely related. If a module hides a lot of information that tends to increase the
amount of benefit api provides that makes module really deep. 

Flat/shallow modules with a lot of noise in the api tend to hide little information.

Also be aware of temporal decomposition — module split into many classes guided by the order in which operations happen
in the runtime or a similar cause. In case of temporal decomposition, classes tend to leak information between each
other that makes the whole design cumbersome. That is where deep modules design come into play.

Chapter 6. General purpose modules are deeper.   
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


Chapter 7. Different layer, different abstraction.  





