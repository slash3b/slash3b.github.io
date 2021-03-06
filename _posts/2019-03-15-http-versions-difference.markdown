---
layout: post
date:   2019-03-15
updated: 2019-05-01
comments: true
title: "HTTP versions difference"
---

Here is the differences between HTTP versions with comments in plain english.

## HTTP 1.0 capabilities:  

* Request may consist of multiple newline separated header fields.

* Response object is prefixed with a response status line.

* Response object has its own set of newline separated header fields.

* Response object is not limited to hypertext.  
So basically since this version it is not hypertext but hypermedia protocol.

* The connection between server and client is closed after every request.  
One of the main drawbacks of this protocol version.

Since that version, HTTP started to support caching, multipart messages, content encoding, authorization and much more.

Read more in [RFC 1945](https://tools.ietf.org/html/rfc1945)

## HTTP 1.1 features:

* Persistent connections to allow connection reuse. This one significantly increases performance, three way handshake and slow start are happening only in the beginning, not on every request like it used to be with 1.0 version. Persistent connection even when it is not being used is sutained by client via sending empty packets.

* Chunked transfer encoding to allow response streaming. What is awesome about it is that you do not have to wait until your content is being generated, you can send it right away in chunks. Imagine to able to send your users a lengthy video file rigth away while this file is being generated at the same ime. The end of stream is done by special termination chunk which has length equal to 0.

* Request pipelining to allow parallel request processing. I struggled to understand what is piplining is but after I read this [zine](https://github.com/lrlna/sketchin/blob/master/zines/http2.md) by amazing Irina I think I have an explanation. Imagine transporter line for the baggage in the airport, each baggage is your request that uses the same connection(transporter line). You send it all at once and expect from the other side in the same sequence. HOL problem can be easily pictured here — one of the packages is stuck then the whole line is blocked!       
 Check additional info [here](https://hpbn.co/http1x/). 


Read more in [RFC 2616](https://www.ietf.org/rfc/rfc2616.txt)

## HTTP 2 features:
HTTP 2 was born out of SPDY protocol developed in Google. All the speed that comes with HTTP2 comes from *binary framing layer*, in other words in HTTP 1.x all comuunication is done in plaintext but in HTTP 2 it is done in binary.

* Data compression of HTTP headers. This is truly awesome feature! Imagine you send multiple requests with almost the same headers, the difference could be only in that you ask each time different resource. So HTTP 2 use only that difference in headers and do not sent the same headers on and on again. This is called "compression of HTTP headers".

* HTTP/2 Server Push

* Pipelining of requests

* Fixing the head-of-line blocking problem in HTTP 1.x

* Multiplexing multiple requests over a single TCP connection  
One of the coolest features, improves speed significantly, decreases number of connections.

Read more in [RFC 2068](https://tools.ietf.org/html/rfc2068)

## HTTP 3 features:

One of the problems of HTTP2 is that it is still using TCP protocol, so in case a single packet is dropped/lost the entire connection stops and waits for this packet. This is called 'TCP head of line blocking'

* Stream multiplexing

* Per-stream flow control

* Low latency connection establishement

* Secure by default with TLS 1.3

* Much faster handshake

* Fix for TCP head of line blocking


Resources used:

[High Performance Browser Networking](https://hpbn.co)  
[QUICK internet draft](https://quicwg.org/base-drafts/draft-ietf-quic-http.html)  
[HTTP3 explained](https://http3-explained.haxx.se/)
[HTTP encoding/compression](https://en.wikipedia.org/wiki/HTTP_compression)
[HTTP3. It is all about the transport!](https://speakerdeck.com/bitone/3)
