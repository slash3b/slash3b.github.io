---
layout: post
date:   2020-04-11
comments: true
title: "Designing Data-Intensive Applications: The Big Ideas Behind Reliable, Scalable, and Maintainable Systems"
---

Designing Data-Intensive Applications by Martin Kleppmann is an amazing journey into the world of distributed systems. It is a must read, especially if you are like me — self-taught programmer. I think it will be usefull even if you do not plan to work with distributed systems, it is just interesting per se.   
I really learned a lot, than you Martin!   

I have a feeling like I managed to digest and remember like 5% not more of the information, and the book contains a lot of good stuff, I mean **a lot**. So for myself I decided to get table of book contents and augment it with little hints and notes that will be helpful in case I want to remember something quickly. 

> Computing is pop culture. [...] Pop culture holds a disdain for history. Pop culture is all about identity and feeling like you're participating. It has nothing to do with cooperation, the past or the furute — it's living in the present. I think the same is true of most people who write code for money. They have no idea where [their culture came from].
> Alan Kay, in interview with Dr. Dobb's journal(2012) 


**Table of Contents**

**I. Foundations of Data Systems**
- 1\. Reliable, Scalable, and Maintainable Applications
  - Thinking About Data Systems
  - Reliability
    - Hardware Faults
    - Software Errors
    - Human Errors
    - How Important Is Reliability?
  - Scalability
    - Describing Load
    - Describing Performance
    - Approaches for Coping with Load
  - Maintainability
    - Operability: Making Life Easy for Operations
    - Simplicity: Managing Complexity
    - Evolvability: Making Change Easy
  - Summary   

#### Highlights and exerpts:   
Many applications today are data-intensive and not compute-intensive. Scalability is the term we use to describe a system's ability to cope with increased load. Load paramenters — e.g. requests per second, number of simultaneous user online, the ration of reads to writes in a database. Percentiles — e.g. with a sorted list of responses, you can see that if the 95th percentile response time is 1.5 seconds, that means 95 out of 100 requests take less than 1.5 seconds and 5 out of 100 requests take 1.5 seconds or more. Percentiles are used in Service Level Objectives and Service Level Agreements. 
 - Making a system simpler does not necessarily mean reducing its functionality; it can also mean removing accidental complexity. Reliability means making systems work correctly, even when faults occur. 
 - Scalability means having strategies for keeping performance good, even when load increases.
 - Maintainability it's about making life better for the engineering and operations teams who need to work with the system.

---   
<br>   


- 2\. Data Models and Query Languages
  - Relational Model Versus Document Model
    - The Birth of NoSQL
    - The Object-Relational Mismatch    
    - Many-to-One and Many-to-Many Relationships
    - Are Document Databases Repeating History?
    - Relational Versus Document Databases Today
  - Query Languages for Data
    - Declarative Queries on the Web
    - MapReduce Querying
  - Graph-Like Data Models
    - Property Graphs
    - The Cypher Query Language
    - Graph Queries in SQL
    - Triple-Stores and SPARQL
    - The Foundation: Datalog
  - Summary

#### Highlights and exerpts:   
It ... seems likely that in ther foreseeable future relational databases will continue to be used alongside a broad viriety  of nonrelational datastore — an idea that is called *polyglot persistence*.   
... However if your application does use many-to-many relations, the document model becomes less appealing.   
When you most likely have many interconnected entities, where everything migh relate to everything — graph database is a good choice.  

Storage engines can be divided in two categories:  
 - optimized for transaction processing — OLTP, a.k.a. Online Transaction Processing. This is where typical CRUD lives and thrives.  
 - optimized for analytics — OLAP, a.k.a. Online Analytical Processing.  

---   
<br>   


- 3\. Storage and Retrieval
  - Data Structures That Power Your Database
    - Hash Indexes
    - SSTables and LSM-Trees
    - B-Trees
    - Comparing B-Trees and LSM-Trees
    - Other Indexing Structures
  - Transaction Processing or Analytics?
    - Data Warehousing
    - Stars and Snowflakes: Schemas for Analytics
  - Column-Oriented Storage
    - Column Compression
    - Sort Order in Column Storage
    - Writing to Column-Oriented Storage
    - Aggregation: Data Cubes and Materialized Views
  - Summary
- 4\. Encoding and Evolution
  - Formats for Encoding Data
    - Language-Specific Formats
    - JSON, XML, and Binary Variants
    - Thrift and Protocol Buffers
    - Avro
    - The Merits of Schemas
  - Modes of Dataflow
    - Dataflow Through Databases
    - Dataflow Through Services: REST and RPC
    - Message-Passing Dataflow
  - Summary

#### Highlights and exerpts:   
...rolling upgrades allow new versions of a service to be released without downtime, thus encouraging frequent small releases over rare big releases and make deployments less risky — allowing faulty releases to be detected and rolled back before they affect a large number of users.    
Several data encoding formats were discussed:  
 - language specific encoding
 - textual formats like XML, JSON or CSV
 - binary schema-driven formats like Avro, Thrift or Protocol Buffers allow quick and efficient encoding

Several modes of dataflow:
 - database — communication between processes happens by writing and reading from db, probably the most simple approach
 - RPC and REST APIs
 - asynchronous message passing using message brokers or actors, e.g. RabbitMQ

---   
<br>   

**II. Distributed Data**
- 5\. Replication
  - Leaders and Followers
    - Synchronous Versus Asynchronous Replication
    - Setting Up New Followers
    - Handling Node Outages
    - Implementation of Replication Logs
  - Problems with Replication Lag
    - Reading Your Own Writes
    - Monotonic Reads
    - Consistent Prefix Reads
    - Solutions for Replication Lag
  - Multi-Leader Replication
    - Use Cases for Multi-Leader Replication
    - Handling Write Conflicts
    - Multi-Leader Replication Topologies
  - Leaderless Replication
    - Writing to the Database When a Node Is Down
    - Limitations of Quorum Consistency
    - Sloppy Quorums and Hinted Handoff
    - Detecting Concurrent Writes
  - Summary
- 6\. Partitioning
  - Partitioning and Replication
  - Partitioning of Key-Value Data
    - Partitioning by Key Range
    - Partitioning by Hash of Key
    - Skewed Workloads and Relieving Hot Spots
  - Partitioning and Secondary Indexes
    - Partitioning Secondary Indexes by Document
    - Partitioning Secondary Indexes by Term
  - Rebalancing Partitions
    - Strategies for Rebalancing
    - Operations: Automatic or Manual Rebalancing
  - Request Routing
    - Parallel Query Execution
  - Summary
- 7\. Transactions
  - The Slippery Concept of a Transaction
    - The Meaning of ACID
    - Single-Object and Multi-Object Operations
  - Weak Isolation Levels
    - Read Committed
    - Snapshot Isolation and Repeatable Read
    - Preventing Lost Updates
    - Write Skew and Phantoms
  - Serializability
    - Actual Serial Execution
    - Two-Phase Locking (2PL)
    - Serializable Snapshot Isolation (SSI)
  - Summary
- 8\. The Trouble with Distributed Systems
  - Faults and Partial Failures
    - Cloud Computing and Supercomputing
  - Unreliable Networks
    - Network Faults in Practice
    - Detecting Faults
    - Timeouts and Unbounded Delays
    - Synchronous Versus Asynchronous Networks
  - Unreliable Clocks
    - Monotonic Versus Time-of-Day Clocks
    - Clock Synchronization and Accuracy
    - Relying on Synchronized Clocks
    - Process Pauses
  - Knowledge, Truth, and Lies
    - The Truth Is Defined by the Majority
    - Byzantine Faults
    - System Model and Reality
  - Summary
- 9\. Consistency and Consensus
  - Consistency Guarantees
  - Linearizability
    - What Makes a System Linearizable?
    - Relying on Linearizability
    - Implementing Linearizable Systems
    - The Cost of Linearizability
  - Ordering Guarantees
    - Ordering and Causality
    - Sequence Number Ordering
    - Total Order Broadcast
  - Distributed Transactions and Consensus
    - Atomic Commit and Two-Phase Commit (2PC)
    - Distributed Transactions in Practice
    - Fault-Tolerant Consensus
    - Membership and Coordination Services
  - Summary

**III. Derived Data**
- 10\. Batch Processing
  - Batch Processing with Unix Tools
    - Simple Log Analysis
    - The Unix Philosophy
  - MapReduce and Distributed Filesystems
    - MapReduce Job Execution
    - Reduce-Side Joins and Grouping
    - Map-Side Joins
    - The Output of Batch Workflows
    - Comparing Hadoop to Distributed Databases
  - Beyond MapReduce
    - Materialization of Intermediate State
    - Graphs and Iterative Processing
    - High-Level APIs and Languages
  - Summary
- 11\. Stream Processing
  - Transmitting Event Streams
    - Messaging Systems
    - Partitioned Logs
  - Databases and Streams
    - Keeping Systems in Sync
    - Change Data Capture
    - Event Sourcing
    - State, Streams, and Immutability
  - Processing Streams
    - Uses of Stream Processing
    - Reasoning About Time
    - Stream Joins
    - Fault Tolerance
  - Summary
- 12\. The Future of Data Systems
  - Data Integration
    - Combining Specialized Tools by Deriving Data
    - Batch and Stream Processing
  - Unbundling Databases
    - Composing Data Storage Technologies
    - Designing Applications Around Dataflow
    - Observing Derived State
  - Aiming for Correctness
    - The End-to-End Argument for Databases
    - Enforcing Constraints
    - Timeliness and Integrity
    - Trust, but Verify
  - Doing the Right Thing
    - Predictive Analytics
    - Privacy and Tracking
  - Summary
- Glossary
- Index


Resourse:   
[Design Data Intesive Applications](https://www.amazon.com/Designing-Data-Intensive-Applications-Reliable-Maintainable-ebook/dp/B06XPJML5D/ref=sr_1_1?crid=24WFQ31Q3MIOA&dchild=1&keywords=design+data+intensive+applications&qid=1585083016&sprefix=design+data+in%2Caps%2C277&sr=8-1) 


