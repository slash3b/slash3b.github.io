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

**Anonymous classes:**  
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
Shorthand way to get everything you need from the class.  
Could we say we do not need Reflection any more ?
{% highlight PHP %}
    class A {private $x = 42;} 
    print (function(){ return $this->x;})->call(new A); 
{% endhighlight %}

**Filtered unserialize function**  
Now unserialize have an optional option `allowed_classes` for better security:
{% highlight PHP %}
    unserialize($some_string, ['allowed_classes' => ['MyA', 'MyB']]);
{% endhighlight %}
Interestingly enough, in case we pass some other class we will get instance of `__PHP_Incomplete_Class`

**IntlChar**  
Intl extension received new class IntlChar, it holds a number of useful method to work with unicode characters.  
For instance `charAge` which lets you have a Unicode version when this character was introduced, or `charName` 
which well, lets you get char name and etc.

**Expectation**  
It is `assert` enhancement, previously you could use it like this:
{% highlight PHP %}
    var_dump(assert('true !== false'));
{% endhighlight %}
which would be validated to true or false roughly speaking. But in PHP7 `assert()` is a language construct so the first parameter - assertion can be an expression and the second parameter can be now of type `throwable` so we can throw Exception.

**Group use declaration**  
We can them like this:
{% highlight PHP %}
    use some\namespace\{ClassA, ClassB, ClassC as C};
{% endhighlight %}
Though it kind of contradicts with [PSR-4](https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-4-autoloader.md#2-specification) which does not allow grouping.

**Generator return expressions**  
With new Generator function `getReturn()` we may retrieve the final expression like this:
{% highlight PHP %}
    $gen = (function(){
        yield 1;
        return 'The end' . PHP_EOL;
    })();
{% endhighlight %}
Only when generator is done yielding values, we can use `$gen->getReturn()` and see the final result. Pretty handy!

**Generator delegation**   
The generator can do `yield from` and suck in other generator, array or any Traversable object.

**Things deprecated:**  
{: style="color:red;" }
- PHP 4 style constructors
- Static calls to non-static methods
- calling `assert()` with string argument
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
