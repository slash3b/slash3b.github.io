---
layout: post
date:   2019-03-15
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
One of the main drawbacks of this protocol version, in my opinion.

Since that version, HTTP started to support caching, multipart messages, contenct encoding, authorization and much more.

Read more in [RFC 1945](https://tools.ietf.org/html/rfc1945)

## HTTP 1.1 features:

* Persistent connections to allow connection reuse. This one significantly increases performance, three way handshake and slow start are happening only in the beginning, not on every request like it used to be with 1.0 version.

* Chunked transfer encoding to allow response streaming

* Request pipelining to allow parallel request processing


Read more in [RFC 2616](https://www.ietf.org/rfc/rfc2616.txt)

## HTTP 2 features:

* Data compression of HTTP headers

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
