---
layout: post
date: 2017-01-14
updated: 2017-02-19
Title: Pragmatic Programmer synopsis
---

Here are all the tips from the book Pragmatic Programmer. It was published in October, 1999 and since then became one the best known books about software engineering.
Just as I started to write this post, I found that Jeff Atwood already [wrote](https://blog.codinghorror.com/a-pragmatic-quick-reference) about this post.
But I like to finish what I started, so let there be yet another post praising this great book.
The list is mostly copy-paste, some day I'll have time to add my own comments to each Tip, though most if the Tips are pretty self-explanatory.

* Tip 1: Care about your craft
* Tip 2: Think!
* Tip 3: Provide options, don't make lame excuses
* Tip 4: Don't live with broken windows
* Tip 5: Be a catalyst for change
* Tip 6: Remember the big picture
* Tip 7: Make quality a requirements issue
* Tip 8: Invest regularly in your knowledge portfolio
* Tip 9: Critically analyze what you read and hear
* Tip 10: It's both what you say and the way you say it
* Tip 11: DRY—Don't Repeat Yourself
* Tip 12: Make it easy to reuse
* Tip 13: Eliminate effects between unrelated things. (As the helicopter example illustrates, nonorthogonal systems are inherently more complex to change and control.
When components of any system are highly interdependent, there is no such thing as a local fix). 
* Tip 14: There Are No Final Decisions (The mistake lies in assuming that any decision is cast in stone—and in not preparing for the contingencies that might arise. Instead of carving decisions in stone, think of them more as being written in the sand at the beach. A big wave can come along and wipe them out at any time.)
* Tip 15: Use Tracer Bullets to Find the Target (Tracer bullets work because they operate in the same environment and under the same constraints as the real bullets.
They get to the target fast, so the gunner gets immediate feedback. And from a practical standpoint they're a
relatively cheap solution. The distinction is important enough to warrant repeating. Prototyping generates disposable code. Tracer code is lean
but complete, and forms part of the skeleton of the final system. Think of prototyping as the reconnaissance and
intelligence gathering that takes place before a single tracer bullet is fired.)
* Tip 16: Prototype to Learn (Prototyping is a learning experience. Its value lies not in the code produced, but in the lessons learned. That's really the point of prototyping.)
* Tip 17: Program Close to the Problem domain. (With the proper support in place, you can program much closer to the application domain.
We're not suggesting that your end users actually program in these languages. Instead, you're giving yourself a tool
that lets you work closer to their domain.)
* Tip 18: Estimate to Avoid Surprises 
* Tip 19: Iterate the Schedule with the Code (This may not be popular with management, who typically want a single, hard-and-fast number before the projecteven starts. You'll have to help them understand that the team, their productivity, and the environment will determine the schedule. By formalizing this, and refining the schedule as part of each iteration, you'll be giving them the mostaccurate scheduling estimates you can.) What to Say When Asked for an Estimate - You say "I'll get back to you."
* Tip 20: Keep Knowledge in Plain Text
* Tip 21: Use the Power of Command Shells
* Tip 22: Use a Single Editor Well
* Tip 23: Always Use Source Code Control
* Tip 24: Fix the Problem, Not the Blame
* Tip 25: Don't Panic
* Tip 26: "select" Isn't Broken (We now use the phrase "select is broken" as a gentle reminder whenever one of us starts blaming the system for a fault that is likely to be our own.)
* Tip 27: Don't Assume It—Prove It

Debugging Checklist
	• Is the problem being reported a direct result of the underlying bug, or merely a symptom?
	• Is the bug really in the compiler? Is it in the OS? Or is it in your code?
	• If you explained this problem in detail to a coworker, what would you say?
	• If the suspect code passes its unit tests, are the tests complete enough? What happens if you run the unit test with this data?
	• Do the conditions that caused this bug exist anywhere else in the system?
* Tip 28: Learn a Text Manipulation Language. Spending 30 minutes trying out a crazy idea is a whole lot
better that spending five hours. Spending a day automating important components of a project is acceptable;
spending a week might not be. 
* Tip 29: Write Code That Writes Code
* Tip 30: You Can't Write Perfect Software
* Tip 31: Design with Contracts(DBS). If all the routine's preconditions are met by the caller, the routine shall guarantee that all postconditions and invariants will be true when it completes.
* Tip 32: Crash Early. All errors give you information. You could convince yourself that the error can't happen, and choose to ignore it. Instead, Pragmatic Programmers tell themselves that if there is an error, something very, very bad has happened.
* Tip 33: If It Can't Happen, Use Assertions to Ensure That It Won't. Whenever you find yourself thinking "but of course that could never happen," add code to check it.
"This code won't be used 30 years from now, so two-digit dates are fine." "This application will never be used
abroad, so why internationalize it?" "count can't be negative." "This printf can't fail."
* Tip 34: Use Exceptions for Exceptional Problems. One of the problems with exceptions is knowing when to use them. We believe that exceptions should rarely be used
as part of a program's normal flow; exceptions should be reserved for unexpected events. Assume that an uncaught
exception will terminate your program and ask yourself, "Will this code still run if I remove all the exception
handlers?" If the answer is "no," then maybe exceptions are being used in nonexceptional circumstances.
* Tip 35: Finish What You Start. The finish what you start tip tells us that, ideally, the routine that allocates a resource should also free it.
* Tip 36: Minimize Coupling Between Modules (By writing "shy" code that honors the Law of Demeter as much as possible)
* Tip 37: Configure, Don't Integrate
* Tip 38: Put Abstractions in Code Details in Metadata (But we want to go beyond using metadata for simple preferences. We want to configure and drive the application via metadata as much as possible. Our goal is to think declaratively (specifying what is to be done, not how) and create highly dynamic and adaptable programs. We do this by adopting a general rule: program for the general case, and put the specifics somewhere else—outside the compiled code base.)
* Tip 39: Analyze Workflow to Improve Concurrency
* Tip 40: Design Using Services
This example also shows a way to get quick and dirty load balancing among multiple consumer processes: the hungry consumer
model. In a hungry consumer model, you replace the central scheduler with a number of independent consumer tasks and a centralized work queue. Each consumer task grabs a piece from the work queue and goes on about the business of processing it. As each task finishes its work, it goes back to the queue for some more. This way, if any particular task gets bogged down, the others can pick up the slack, and each individual component can proceed at its own pace. Each component is temporally decoupled from the others.
Instead of components, we have really created services—independent, concurrent objects behind well-defined, consistent interfaces.

* Tip 41: Always Design for Concurrency
* Tip 42: Separate Views from Models
* Tip 43: Use Blackboards to Coordinate Workflow. (A blackboard, in combination with a rules engine that encapsulates the legal requirements, is an elegant solution to the difficulties found here. Order of data arrival is irrelevant: when a fact is posted it can trigger the appropriate rules. Feedback is easily handled as well: the output of any set of rules can post to the blackboard and cause the triggering of yet more applicable rules.)
* Tip 44: Don't Program by Coincidence. 
We want to spend less time churning out code, catch and fix errors as early in the development cycle as possible, and create fewer
errors to begin with. It helps if we can program deliberately:
•Always be aware of what you are doing. Fred let things get slowly out of hand, until he ended up boiled, like the frog in
Stone Soup and Boiled Frogs.
•
Don't code blindfolded. Attempting to build an application you don't fully understand, or to use a technology you aren't
familiar with, is an invitation to be misled by coincidences.
•
Proceed from a plan, whether that plan is in your head, on the back of a cocktail napkin, or on a wall-sized printout from a
CASE tool.
•
Rely only on reliable things. Don't depend on accidents or assumptions. If you can't tell the difference in particular
circumstances, assume the worst.
•
Document your assumptions. Design by Contract, can help clarify your assumptions in your own mind, as well as help
communicate them to others.
•
Don't just test your code, but test your assumptions as well. Don't guess; actually try it. Write an assertion to test your
assumptions (see Assertive Programming). If your assertion is right, you have improved the documentation in your code. If
you discover your assumption is wrong, then count yourself lucky.
•
Prioritize your effort. Spend time on the important aspects; more than likely, these are the hard parts. If you don't have
fundamentals or infrastructure correct, brilliant bells and whistles will be irrelevant.
•
Don't be a slave to history. Don't let existing code dictate future code. All code can be replaced if it is no longer
appropriate. Even within one program, don't let what you've already done constrain what you do next—be ready to refactor
(see Refactoring). This decision may impact the project schedule. The assumption is that the impact will be less than the
cost of not making the change. [1]

* Tip 45: Estimate the Order of Your Algorithms

The O() notation is a mathematical way of dealing with approximations. When we write that a particular sort routine sorts n records
in O(n2) time, we are simply saying that the worst-case time taken will vary as the square of n. Double the number of records, and the
time will increase roughly fourfold. Think of the O as meaning on the order of. The O() notation puts an upper bound on the value of
the thing we're measuring (time, memory, and so on). If we say a function takes O(n2) time, then we know that the upper bound of
the time it takes will not grow faster than n2. Sometimes we come up with fairly complex O() functions, but because the highest-order
term will dominate the value as n increases, the convention is to remove all low-order terms, and not to bother showing any constant multiplying factors. O(n2/2+ 3n) is the same as O(n2/2), which is equivalent to O(n2). This is actually a weakness of the O()
notation—one O(n2) algorithm may be 1,000 times faster than another O(n2) algorithm, but you won't know it from the notation.

* Tip 46: Test Your Estimates.
Every developer should have a feel for how algorithms are designed and analyzed. Robert Sedgewick has written a series of
accessible books on the subject ([Sed83, SF96, Sed92] and others). We recommend adding one of his books to your
collection, and making a point of reading it.

* Tip 47: Refactor Early, Refactor Often. Regression tests

* Tip 48: Design to Test
* Tip 49: Test Your Software, or Your Users Will
* Tip 50: Don't Use Wizard Code You Don't Understand
* Tip 51: Don't Gather Requirements—Dig for Them
* Tip 52: Work with a User to Think Like a User
* Tip 53: Abstractions Live Longer than Details
* Tip 54: Use a Project Glossary
* Tip 55: Don't Think Outside the Box—Find the Box
* Tip 56: Listen to Nagging Doubts—Start When You're Ready
* Tip 57:	Some Things Are Better Done than Described
* Tip 58: Don't Be a Slave to Formal Methods
* Tip 59: Expensive Too Do Not Produce Better Designs
* Tip 60: Organize Around Functionality, Not Job Functions
* Tip 61: Don't Use Manual Procedures
* Tip 62: Test Early. Test Often. Test Automatically.
* Tip 63: Coding Ain't Done 'Til All the Tests Run
* Tip 64: Use Saboteurs to Test Your Testing
Unit Testing
A unit test is code that exercises a module.

Integration Testing
Integration testing shows that the major subsystems that make up the project work and play well with each other. Integration testing is really just an extension of the unit testing we've described—only now you're testing how entire
subsystems honor their contracts.

Validation and Verification
As soon as you have an executable user interface or prototype, you need to answer an all-important question: the
users told you what they wanted, but is it what they need?
Does it meet the functional requirements of the system? This, too, needs to be tested. A bug-free system that answers
the wrong question isn't very useful. Be conscious of end-user access patterns and how they differ from developer
test data (for an example, see the story about brush strokes on page 92).


Performance Testing
Performance testing, stress testing, or testing under load may be an important aspect of the project as well.

Usability Testing
Usability testing is different from the types of testing discussed so far. It is performed with real users, under real
environmental conditions.

Regression Testing
A regression test compares the output of the current test with previous (or known) values. We can ensure that bugs
we fixed today didn't break things that were working yesterday. This is an important safety net, and it cuts down on
unpleasant surprises.
All of the tests we've mentioned so far can be run as regression tests, ensuring that we haven't lost any ground as we
develop new code. We can run regressions to verify performance, contracts, validity, and so on.



* Tip 65: Test State Coverage, Not Code Coverage
* Tip 66: Find Bugs Once
* Tip 67: Treat English as Just Another Programming Language
* Tip 68: Build Documentation In, Don't Bolt It On
* Tip 69: Gently Exceed Your Users' Expectations
* Tip 70: Sign Your Work

