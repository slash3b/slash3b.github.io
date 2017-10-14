---
layout: post
date:   2017-10-08
title: "New features in PHP tl;dr"
---
Sorry, this is Work In Progress article but I need it to be published.

## Changes introduced in 7.0

**Scalar type declarations**  
An option to make PHP more stict on typing. We have the following types:
- int
- float
- string
- bool

**Return type declarations**  
Up to PHP7.1 the types are:
- class
- interface
- self
- array
- callable
- bool
- float
- int
- stiring
- iterable

**Null coalescing operator**   
It is an eleagant way to get rid of isset():
{% highlight PHP %}
    $test = $_POST['surprise'] ?? 'nothing';
{% endhighlight %}
So in case post variable does not exists or it is null, we'll get the value after `??`

**Spaceship operator**    
{% highlight PHP %}
    echo $x <=> $b;
{% endhighlight %}

Will return 0 in case variables are equal, -1 if $b is more\equal to the be and 1 if vise versa.

**Constant array using define()** 
**Anonymous classesi**  
{% highlight PHP %}
    new class extends SomeOtherClass
    {}
{% endhighlight %}
So yeah, it's an old plain class which can extend, implement and etc.

**Unicode codepoint escape syntax**  
{% highlight PHP %}
    echo "\u{6879}";
{% endhighlight %}
Will output 桹 

**Closure::call**  

**Filtered unserialize function**  
**IntlChar**  
**Expectation**  
**Group use declaration**  
**Generator return expressions**  
**Generator delegation**   
    with yeild from  
**Two new functions for CSPRNG**  

**Things deprecated:**  
- PHP 4 style constructors
- Static calls to non-static methods
- password_hash() salt option


## Changes introduced in 7.1

Nullable types  
Void functions  
Symmetric array destructuring  
Class constant visibility  
iterable pseudo-type  
Multi catch exception handling  
Support for keys in list() or in [] array desctucuring   
Support for negative string offsets  
Support for AEAD in ext/openssl   
Convert callables to Closures with Closure::fromCallable()   
Asynchronous signal handling   
HTTP/2 server push support in ext/curl  

### Changes introduced in 7.2

New cryptographic extension - Sodium  
password_hash will support Argon2 hashing algorithm
object as type hint and return type
Parameter Type Widening
