---
layout: post
date:   2020-02-29
comments: true
title: "Variance in PHP"
---

**Disclaimer**: I might be wrong about variance. Buyer beware!  


Variance is a property of class hierarchies describing how the types of a type constructor affect subtypes. Type constructor is a thingy that builds new types from the old ones.  


In general, a type constructor can be:

- **Invariant**: if the type of the super-type constrain the type of the subtype. In plain english if you say you return an `array` in some method of your super class — all sub-classes must comply and return `array` as well.   
- **Covariant**: if the ordering of types is preserved (types are ordered from more specific to more generic). You can imagine hierarchy tree and follow it from leaves to the root (top most superclass).
- **Contravariant**: if it reverses the order (types are ordered from more generic to more specific). Traversing type hierarchy from the root to the leaves.

Here is an example of invariant return type in class hierarchy, note **same** return types:

```

class A
{
    function test() : self
    {
        return $this;
    }
}

class B extends A
{
    function test() : A
    {
        return $this;
    }
}

var_dump((new B)->test());

```

In case you want to return `self` in `B::test()` PHP7.3 will return:  
```

Fatal error: Declaration of B::test(): B must be compatible with A::test(): A in /in/1pF3k on line 18

Process exited with code 255.

```

Since PHP7.4 we have a covariance and contravariance in parameter and return types. It boils down to the following:  
- return type might be more specific — contravariance   
- parameter types might be less specific — covariance    

I can not yet explain why both parameter and return types are not having both type of variance 🤔 
You will be able to find much more info in original RFC linked below.  

An example of covariance:


```

class A
{
    function test(stdClass $param)
    {
        return $param;
    }
}

class B extends A
{
    function test(object $param)
    {
        return $param;
    }
}

var_dump((new B)->test(new ArrayObject));

```
In this example above we are being less specific expecting a more general type `object` instead of `stdClass`  

And contravariance looks like this:


```

class A
{
    function test(): A
    {
        return $this;
    }
}

class B extends A
{
    function test(): B
    {
        return $this;
    }
}

var_dump((new B)->test());

```

Note that B return type is more specific and that hierarchy works just fine. But you can not use e.g. `object` retur type as it will be a covariant return type and you get an error:


```

Fatal error: Declaration of B::test(): object must be compatible with A::test(): A in /tmp/preview on line 14


```

Resources:  
[What’s New in PHP 7.4 (Features, Deprecations, Speed)](https://kinsta.com/blog/php-7-4)  
[PHP RFC: Covariant Returns and Contravariant Parameters](https://wiki.php.net/rfc/covariant-returns-and-contravariant-parameters)  
[Wiki: Covariance and contravariance (computer science)](https://en.wikipedia.org/wiki/Covariance_and_contravariance_(computer_science)) [Type constructor](https://en.wikipedia.org/wiki/Type_constructor)   



