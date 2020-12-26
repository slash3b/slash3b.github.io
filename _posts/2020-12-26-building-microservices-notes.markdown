---
layout: post
date:   2020-12-26
comments: true
title: Notes on Building Microservices by Sam Newman 
---

#### Chapter 3 notes. How to model services.

What makes a good service:
- loose coupling
- high cohesion

Loose coupling means a change to one service should not require a change in another service. Tight coupling might means
"chatty" communication, or wrong integration style was chosen that binds services tightly.

High cohesion — we want related behavior to be in the same service, and unrelated behavior to live in another
service.

Bounded context helps with those two aspects of a good service. Todo: to learn more about bounded context.  

#### Chapter 4 notes. Integration.

Avoid database sharing between services at all cost. It becomes an api available to all services. A change for one server most likely break other services/clients.

There are two modes of communications: request/response and event-based, or a.k.a. synchronous and asynchronous communication. 

In request/response client fires a requests and wait for the response. When client receives response it knows for sure
what happened. 

In event-based communication client declares that something happend and expect all other dependent
parties to react. 

Orchestration vs. Choreography. 
Orchestration means we have a central brain that governs the process, driving communication between all the services. 
With choreography we inform every sub-system of its job and let them figure out how to do it. 

The example of a client trying to be as flexible as possible in consuming a service
demonstrates Postel’s Law (otherwise known as the robustness principle), which states:
“Be conservative in what you do, be liberal in what you accept from others.”

Versioning.
- semver for containers
- probably most successful approarch is to have different endpoint to coexists
- coexisting services with old and updated api. Users move from old to the new one, and eventually old one gets down.
  Like blue-green deployment. That is actually hard.


#### Chapter 5 notes. Splitting the monolith.

A seam is a part of your code base that can be isolated and treated independently not affecting other code. 
Seams help to recognize service boundaries.

First step in breaking a monolith is to identify these seams. 

Reasons to split the monolith:
- pace of change
- team structure
- security
- technology

Author discusses the database changes when splitting the monolith with a few usefull examples.  
Yes, we will most likely have to split tables so each service calls it own set of tables.  
Usually perfomance concerns are raised here — now instead of one call we have to make 2+ calls to the database! In my
experience no one usually measures performance impact in that case but everyone talks about it. Author says that
sometimes you have to sacrifice performance in order to do things right.

Transactional boundaries. When you do the split you lose transactions, kind of. Transactions themselves are very useful
and ensure consistency of the data. 
In a distrubuted system you won't ever had this consistency, instead you have to accept what is called _eventual
consincy_. This means that sometimes data is not consistent — you wrote to one table in the service, but other service
failed to write another record in its own table. Eventual consistency means the system will need some time to "balance"
itself and remove/correct any inconsitencies. 

You can manage any data problems manually by trying to write again or deleting other records related to the failed one.
Or you can you _distributed transations_. Distributed transactions means using some kind of transaction manager that
keep an eye on a several independently launched transaction. 

Two-phase commit is classic example of distributed transaction. First "transaction manager" asks every unit if it is ready to 
proceede with transaction. Second step is when everybody is ready manager commands to start transaction.

#### Chapter 6 notes. Deployment. 

CI makes sure that new code integrates with existing code. CI should runs test to verify this and builds an artifact(s) as a 
final stage of new code integration. 

Avoid deploying multiple services at once. Why? If I make a one line change in one microservice, I have to wait for all microservices to be built.
This takes a lot of time and slows down development. 
Lock-step releases.
A variation of this approach is to have the same single repository and just have multiple CI builds for different parts of repository. 
An ideal approach is to have a repository per service and for that service to have one pipeline. You get one build in the end.

Ideally all services should be built, deployed independently, each on its own host. All services on the same host means if one service is under high load then other will likely suffer resource starvation. Having everything on one host means we have to treat all services equally even when services needs are different.

Next-level option to deploy is PaaS (Platform as a Service), you give it your code and it deploys it for you, handles scaling up and down automatically and much much more. 

Automation.
Hypervisor maps resources from physical to virtual machines and allows to control virtual machines.
The downside of hypervisor is that it also takes some cpu, io, resources to manage vms. At some point when you have many vms, hypervisor takes a significant chunk of machine resources.  

Linux containers. LXC is the most popular ones for Linux. LXC is a userspace interface for the Linux kernel containment features. Through a powerful API and simple tools, it lets Linux users easily create and manage system or application containers. The goal of LXC is to create an environment as close as possible to a standard Linux installation but without the need for a separate kernel. LXC achieves this by using instruments such as kernel namespaces, pivot_root, kernel capabilities, CGroups, apparmor/selinux and etc.

In general LXC is faster then hypervisor-solutions, it is more transparent and easier to control/manager.  

Having a uniform interface to deploy is vital. Capistrano, ansistrano, boto for aws, and many other tools exist to hepl you with deployment. 

#### Chapter 7 notes. Testing. 

Unit tests. Are very fast and let us know if our functionality is good.  
Service tests. Are disigned to bypass user interface and test services directly. In order to test a service we have to stub all of its dependencies and use its public interface to test the service. I'd personally call these integration testing and we are testing how one service integratest with another.  
End-to-end tests. Are running against the whole system. 

When implementing service test, mock or stubs might be used. The difference is the following:  
- mocks are harder to work with, but they allow you control precisely what is happening in your code — e.g. what methods were called, how many times, with what parameters and what was returned
- stubs are a "light weight", independent implementation of service dependency. It does not care how much it was used, it has some predefined data to return. It is not so smart as a mock.

Mocks, stubs, fakes, spies and dummies are called _test doubles_ by Martin Fowler. 

In end-to-end testing, if you have flaky tests, you have to track them down and if necessary delete them from the suite. Deleted flaky tests might either fixes or rewritten to service tests. 

In deploying you might use blue-green deployment or "canary-releasing" deployment. Canary releasing means we are directing a portion of a production traffic to the newly release service thus ensuring that it works "good enough". Both cases might help to ensure deployed micro-service works as expected.  

MTBF — mean time between failures
MTTR — mean time to repair

_Nonfunctional requirements_ is an umbrella term that describes system properties — how many users system can hold, what is the maximum acceptable page latency, how accessible is a service/web page, how secure your product should be.  


#### Chapter 8 notes. Monitoring. 

For a monolith you need this kind of monitoring: 
- monitor the host itself. CPU, memory, network and etc
- have to have an access to logs on the server
- track application itself. Errors, response time, those thigs

With one application per multiple hosts, we want to aggreage all host metrics but at the same time be able to drill down if necessary. We also need to track down load balancer as well. 

If we have a multi-host, distributed app, then the only way to not go crazy is to aggreage all logs, store them somewhere safe. Collect, aggregate and store as much as possible. 

Correct and properly implemented monitoring allows us to calculate capacity planning. 


**Service metrics** Service itself might expose some basic metrics — a number of errors per minute, CPU load, memory, io. 

In a distributed system, in case of an error we want to have a chain of call to be able to "track down" error, just like
a stack trace help us to see what stack was like before error happened. One helpful trick is to use _corellation ID_. Idea is simple, you generate a unique ID for a call and then this id is passed to all underlying calls. That id might be stored in logs. 


#### Chapter 9 notes. Security. 

SSO — single sign on. 

Instead of having every service to call an Indetity provider for authentication, probably using some shared library, we can do authentication in one centralized place — SSO Gateway. This Gateway acs like a proxy, sitting between outside world and your services.   

Next problem to solve. We need to somehow pass user information/model and authorization attributes(roles, permissions) to the downstream services.   
*Service-to-Service Authentication and Authorization*   
- Allow everything inside the perimiter is a common option but not a very good one. Should a malicious user penetrate your server, nothing is stopping her from going rampage  
- You can use SAML or OpenID. Every service basically has its own credentials to authorize call  
- Another option is to use TLS advantage and user client sertificates. Every client would have to have a X.509 sertification to establish connection with other servises  
- HMAC over HTTP option is also viable, JWT does something similar. You probably need to establish secure connection before using them as it is still will be possible to read packets. Also although JWT seems to be simple, it is tricky to implement it correctly  
- Api keys, there is a possibility you want to have two gateways — SSO gateway for usual users and API gateway that uses api key to authenticate caller  

Securing your data.  
Do not implement you own encryption, use well known encryption algorightms. Encode sensitive data first time you see it, decode on demand only. Encrypt your backups.  

Defence in depth.  
Use firewalls, have a good logging so you can detect if somebody is abusing the system. 
But make sure you do not leak sensitive information in your log records. Patch your software regularly. 

#### Chapter 11 notes. Microservices at scale. 

Distributed system will have all sort of different failures eventually. You have to be prepared for this.   

Architectural safety measures. 
- Timeouts. Put them everywhere and log when timeout happens 
- Circuit breaker. Circuit breaker helps to fail fast in case a downstream service is ill. When circuit breaker is "blown" it will immediately return an error. After some time if downstream service is healthy again circuit breaker reopens again.  
While circuit breaker is blown you might decide to hold ongoing requests for awhile. This might be appropriate if you are doing some async stuff. 
- Bulkheads.  
The Bulkhead pattern is a type of application design that is tolerant of failure. In a bulkhead architecture, elements of an application are isolated into pools so that if one fails, the others will continue to function. It's named after the sectioned partitions (bulkheads) of a ship's hull. If the hull of a ship is compromised, only the damaged section fills with water, which prevents the ship from sinking.

**Scaling** 
Scaling helps with reducing risk, spreading workload effectively and cheaply. Author talks about load balancers and workers-based systems. 

Jeff Dean said — "design for ~10× growth, but plan to rewrite before ~100×"  
The need to change our systems to deal with scale isn’t a sign of failure. It is a sign of success.  

**Scaling Databases** 

- Scaling for writes, scaling for reads. If necessary to optimize for reads — do the caching first. It is easier and faster solution. 
- Sharding and replication 
- CQRS might be a very interesting approach to scale your system, but the whole team have to know it well, before actual implementation.  

**Caching** 

- client side caching  
- proxy caching, think CDN  
- server side caching  

Caching HTTP. `cache_control` tells client if caching is necessary, also `Expires` header tells cache expiration date. These headers prevent client from even
making a call.  
Entity Tag or ETag allows you to make a what is called conditional GET. Imagine this case scenario. I make a call and receive ETag along with Expires tag. When Expires tells me that cached content is stale I make another request. **If** there is indeed a fresh version of stored content or a model on the server I receive a 200 HTTP status and fresh ETag. If nothing changed I receive 304 Not Modified HTTP status.  
ETag is fucking amazing.   

Cache poisoning. Example about all users having `Expires: never` header, which happened due to some bug. There is no way to nuke that cache from server side. THe only solution they came up with — change URL so user will receive proper headers.  

Autoscaling.

CAP Theorem. You can not have consistency, availability and partition tolerance at the same time.  

Consistency is a system feature that lets me do the same call for different parts of a system and always get the same response.  
Availability means that every requests receives a response. 
Partition tolerance means that sometimes a communication between system parst is not possible and system should be able to handle this.  

Service discovery. 
- DNS is a good start
- dynamic service registers. Consul, Zookeeper and etc.

Summary. Principles of microservices.  
- use bounded context to define domain boundaries 
- adopt culture of automation 
- hide internal implementation details 
- decentralize all the things  
- independent deploy 
- isolate failures 
- highly observable 










