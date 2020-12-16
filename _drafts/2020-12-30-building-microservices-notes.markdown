-----------------------
Chapter 3 notes. How to model services.

What makes a good service:
- loose coupling
- high cohesion

Loose coupling means a change to one service should not require a change in another service. Tight coupling might means
"chatty" communication, or wrong integration style was chosen that binds services tightly.

High cohesion — we want related behaviour to be in the same service, and unrelated behaviour to live in another
service.

Bounded context helps with twose two aspects of a good service. Todo: to learn more about bounded context.

-----------------------
Chapter 4 notes. Integration.
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


-----------------------
Chapter 5 notes. Splitting the monolith.

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

-----------------------
Chapter 6 notes. Deployment. 

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


-----------------------
Chapter 7 notes. Testing. 

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


-----------------------
Chapter 8 notes. Monitoring. 




