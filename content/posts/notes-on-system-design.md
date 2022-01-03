---
title: "Notes on System Design"
date: 2021-10-30T17:29:38+03:00
tags: ["system design", "cache", "high load"]
draft: false
---

These are hectic notes on a book "System design interview" by Alex Xu.


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


Additional notes for the chapter. 

Lamport timestamps.

Key idea is: **each node and each client keeps track of maximum value it has seen so far and includes that value on every request**. 

- each node tracks a number of operation it processed
- each node has a unique identifier
- each node and every client includes its own version of max value they have seen so far
- value with greater counter value is bigger
- if counter values are equal then node with greated node id is bigger timestamp 

```
           Lamport timestamp: (counter, node id)

Max value    0             1                      4        5
Client 1   ───────▲────────────────────────▲───────────▲──────►
                  │                        │           │
                 A│                       E│          G│
                  │                        │           │
 Node 1    ───────▼────────────────────────┼───────────▼──────►
 Timestamp  (0,1)         (1,1)            │             (5,1)
                                           │
                                           │
 Timestamp  (0,2)  (1,2)   (2,2)   (3,2)   │ (4,2)   (5,2)
 Node 2    ───────▲──────▲──────▲──────────▼──────▲───────────►
                  │      │      │                 │
                 B│     C│     D│                F│
                  │      │      │                 │
Client 2   ───────▼──────▼──────▼─────────────────▼───────────►
Max value     0       1      2      3                  5
```

todo: like... find an example, come up with example yourself 

---
_chapter 7_

Design unique ID generator

Requirement:
- sortable by time
- 64 bits length
- unique
- numeric only

UUID is a great solution, but it is 128 bits length. For us Twitter Showflake ID generator fits perfectly.

It is simple and efficient and looks like this:

```
   ┌─┬─────────────────────────┬───────────────┬────────────┬───────────────────┐
   │0│       timestamp         │ datacenter ID │ machine ID │  sequence number  │
   └─┴─────────────────────────┴───────────────┴────────────┴───────────────────┘
     ▲                         ▲               ▲            ▲                   ▲
1 bit│        41 bits          │    5 bits     │  5 bits    │    12 bits        │
─────┴─────────────────────────┴───────────────┴────────────┴───────────────────┘
```
First bit is not used and reserved for future uses. 
Interestingly, sequence number is reset to 0 every millisecond. 


---
_chapter 8_

URL shortener  

Types of redirect — 301 and 302 http statuses.
301 means permanent redirect, which means browser will cache it and next time will hit long url directly. 
302 meand temporary redirect so that the browser hits short url every time.

301 reduces server load
302 allows to have better tracking and analytics 

Two types of hash functions along with collision detection are mentioned.
First one is to use well known hash function MD5, SHA-1 and etc. to calculate hash. If there is a collision
we might approach it the following way:
- generate hash for the long url
- check if database has this hash key
- if yes then append some predefined string to long url and generate it again
- do prev step recursively until collision is resolved

Method above works, but it might be expensive to always fetch from database in
order to know if record is already exists — collision exists. In this situation
a bloom filter is an elegant solution for this problem.  

Second method is base 62 conversion.
base 62 is a way to use 62 characters for encoding, that is 0-0, 1-1, 10-a, 11-b, 35-z, 36-A, 61-Z. 
Leaving us with "alphabet" that looks like this "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"


---
_chapter 9_

Web crawler  

nothing notable (?), I probably need to review it one more time.


---
_chapter 10_

Notification system

nothing notable (?), I probably need to review it one more time.


---
_chapter 11_ 

News feed system

Feed system includes fanout service. That is when a fried, e.g. posts something to the feed, all frieds should
receive/see that post in their feeds. For this fanout service is used. This kind of service delivers data to all
interested parties. There are two types of fanout services: fanout on write and fanout on read.

Fanout on write, writes/updates feed of all the friends/people interested in. Pros: updates feeds immediately, that is
feeds are being pre-computed and feed delivery is fast. Cons: pre-computation takes time and might be inefficient since
some of the people are reading their feeds rarely. Pre-computation might take a lot of time when user have many friends
— this is called hotkey problem. 

Fanout on read means feed is updated when user requests it. Pros: no extra pre-computation required. Cons: feed request might be executing slowly.


--- 
_chapter 12_  

Chat system 

Ways to simulate full-duplex connection: polling, long polling.  
Polling is simple and a well-known techinque — you just ask server periodically about new messages. Client opens
connection, asking for any info for it, and closes it. And then again opens it. 
Long polling is a bit more complex — client keeps connection open until server does have some info/messages. Client
gets the messages, closes connection and immediately opens up a new connection.  

Web socket is the most common solution to establish full-duplex connection. WS uses HTTP connection to establish
connection between client and server. When connection is established, WS does protocol switch from HTTP to web socket
protocol. 

Storage.
For user profile, settings, friend list and etc. a robust relational database is a good solution. For chat messages,
when users access only recent chat story, a key-value storage is a optimal solution. Facebook messenger uses HBase
storage and Discord uses Cassandra.


---
_chapter 13_

Autocomplete system

Can be made of Data gathering service and Data query service. Data gathering happens as user types search queries.
Search queries are being saved into simple query frequency table which is a key-value table where key is a search term 
and values is the number of times user did query. Data query service basically returns all matching keys from frequency
table. e.g. "tw" would match and return terms like "twitter", "twitch", "two" (terms are sorted by desc search frequency)

It works for a smaller system, but it does not scale very much. 
Trie data structure is needed for a mature, more fit solution to autocomplete system.  

Each node in a trie, we are going to use, should also have a frequency number (weight) which is used to get top _k_
queries by given prefix. We can also cache top _k_ search queries for every node.


---
_chapter 14_

Design Youtube


Video streaming flow.
Streaming protocol — is a standardized way to control data transfer for video streaming. There are a few streaming
protocols to chose from: MPEG-DASH, Apple HLS, microsoft smooth streaming, Adobe HDS.

There are many types of encoding formats, but most of them consist of two parts — container and codec.
You can tell container by file extension, e.g. .avi, .mpeg, .mkv and etc. A container is like a box that contains video,
audio and metadata altogether. Codec is a compression and decompression algorithm that should reduce size of a files in
container not loosing any quality.  

Safety optimization — pre-signed URL. Client, first, does request to e.g. `/upload` endpoint that does auth checks and
returns pre-signed URL, which client uses to upload a file. Amazon S3 call is pre-signed URL, while Microsoft Asure
calls it Shared Access Signature. 

Cost saving optimization. 
- Not everything should be stored in CDN. CDN on a large scale is expensive. We can store in CDN only the most popular videos.
- Less popular videos we can store in our own storage and for these videos we can make less kinds of video formats.
- Sometimes video is popular in a specific region only, so it makes less sense to store it globally.


--- 
_chapter 15_  

Google drive 

One of the notable features of any mature file sync system is that it must have a block server. Block server is able to
split a file by blocks, e.g. Dropbox max block size is 6Mb. Every block is identified by hash value. A file can be
re-assembled from these blocks. In order to understand which blocks to what file belong and in what order, block server
should somehow save metadata information about original file and blocks. Typically metadata is being saved in some
database. 

Files that are accessed rarely might/should be moved to the "cold" storage. It is a typically much slower but cheaper
type of storage.

