---
layout: post
date: 2020-02-08
comments: true
title: "ACID concept"
---

I really like how Martin Kleppmann described ACID in his book, hence a little excerpt to remember.  

ACID stands for _Atomicity_, _Consistency_, _Isolation_, and _Durability_    

It was first coined by Andreas Reuter and Theo Härder in 1983 in attempt to describe all that is necessary for the database to be fault-tolerant as much as possible.

- **Atomicity**    
Database should support transaction, namely you should be able to group you request statemets and execute them at once. The very important feature here is _abortability_ — ability to rollback any changes done in case we have an error in transaction somewhere along the way.  

- **Consistency**  
The idea of consitency is that you may have some statements about your data (invariants) that must always be true, like in accounting you should always have credits and debits balanced. The thing is that database can not actually do this, your application should govern consistency of the data, database has nothing to do with this, database does not know about your domain logic.   
_Fun fact: it seems that C was tossed in original paper in order to just have a nice acronym, and it was not considered important at the time._ 

- **Isolation**  
Isolation is very important and means that although you might have two concurrent writes, the database will make them look like _serial_ executions and not _concurrent_. This way data won't be lost.

- **Durability** 
Durability is the promice that once a transaction has committed successfully, any data it has written will not be forgotten, even if there is a hardware fault or the database creashes.

Resourses:  
[Designing Data-Intensive Applications](https://dataintensive.net/)

