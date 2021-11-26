---
title: "Notes on System Design"
date: 2021-10-30T17:29:38+03:00
tags: ["system design", "cache", "high load"]
draft: true
---


_chapter 1_


- **read-through cache strategy** — check if we have a response cached, if we do return it, if not then fetch data from a 
database, cache it and return result

- **GeoDNS** is a patch for BIND DNS server software that allows for geographical split horizon 

A few words about caching strategy.
Your caching strategy depends on your data access patterns. Is your system write heavy, read heavy, results are always
  should be unique ?

Caching strategies:
- **cache-aside** — cache sits "aside" and application interacts directly with cache and database layers. Most common
  approach
- **read-through cache**  — an applications reads through cache, in other words application interacts with cache only.
  When there is a cache miss, cache itself requests data from database, caches it and returns response 
- **write-through cache** — first data is written to the cache and then to the database. Writes are going through cache
  and to the database
- **write-around** — writes are going to the database and only reads are saved in cache 
- **write-back** — writes are coming to cache layer and immediately acknowledge. Cache layer, later on, write to the
  database 

[Caching strategies](https://codeahoy.com/2017/08/11/caching-strategies-and-how-to-choose-the-right-one/)


--- 
_chapter 2_

Common back-of-the-envelope estimation questions: qps, peak qps, cache, number of servers and etc. 

Latency Numbers Every Programmer Should Know:
{{< gist jboner 2841832 >}}

---
_chapter 3_

4 steps for effective system design interview
- understand the problem and establish design scope. Get all the basic params and features of a system to be designed  
- propose high-level desing and get an appoval for it, so you can move forward with design  
- deep dive into details — identify bottlenecks, system performance, resource estimation 
- wrap up, propose some other possible solutions, talk to your interviewer etc.. 

---
_chapter 4_

Rate limiting algorithms:
- token bucket
- leaking bucket 
- fixed window counter
- sliding window log
- sliding window counter 

---
_chapter 5_

Consistent Hashing

What is it?

A technique called hash ring is used to implement consistent hashing.

A ring is an array, which end is connected to the beginning, thus making it a ring:
- hash servers `S0`, `S1`, `S2`, `S3`
- 9, 1, 2, 3, 4, 5 are cache keys that are assigned to S0 server
- 6, 7 keys that are assigned to S1
- so on.. 

```


     ┌────────────────────────────────────────────────────────────┐
     ▼                                                            │
     start                                                    end
     ───────────S0───────────S1──────────────S2────────────S3──────
      1,2,3,4,5      6,7            8               11


```
If it is a ring, then moving clock wise from key value will give you server it is assigned to. 

A techinique called virtual nodes helps to spread keys evently, in cases then servers are added or
removed. A bunch of virtual nodes represent a cache server, and virtual nodes are evently spread on the ring.


---
_chapter 6_

key-value store 

Even with data compression or/and swapping less frequently used data to disc, a single server implementation will 
reach capacity very quickly handling big data. The answer to this is a distributed key-value store, also known as 
distributed hash table.

When designing a distributed system it is important to know about CAP theorem. CAP stands for:
- Consistency. All nodes are synced, user always receives correct response no matter what node used connected to
- Availability. Even if some nodes are down, client always gets a response 
- Partition tolerance. System continues to operate even if some of its nodes are down — network partitions 

Theorem states, that you can have any two of features above, but not all of them together. 

Thus you can have:
- CP, Consistency + Partition tolerance
- AP, Availability + Partition tolerance 
- CA, Consistenty + Availability

In a real world network partitions will happen, so Consitency + Availability combination can not happen in real
world because you always need Partition tolerance. So that leaves us with wether CP or AP. When discussing design
approach you either may choose availability, which means stale reads but working writes, or you can choose consitency,
which means no writes but correct reads. 

Building blocks of a system:
- data partition. Use consistent hashing, which gives you equal distrinbution of data between servers and also gives you
  heterogenity, meaning a server with bigger capacity will have more virtual nodes placed on a hash ring
- data replication, replication might be done by just replicating to the first 3 nodes you find on hash ring moving
  clock wise 
- consistency, with number of servers (N), writes quorum (W) and read quorum (R) you can tune your system parameters as
  needed. e.g. R=1, W=3 means system is designed for fast reads — "coordinator" should get response from only 1 node.
- consistency modes are strong consistency, weak consistency and eventual consistency
- inconsistency resolution — versioning, vector clocks 

Failure is inevitable in a distributed system. For failure detection — use gossip protocol. 

---
_chapter 7_









