---
layout: post
date:   2019-04-13
comments: true
title: "Composition vs. Inheritance in PHP, tl;dr version"
---

After reading a numerous resources on what is composition in terms of OOP and how it plays versus inheritance, I came up with following understanding:


Inheritance is just another way to inherit other classes. 
Basically you do not inherit class directly but get it injected into the consttuctor or via setter method. For instance:  

Typical inheritance:
{%highlight php%}

class MusicalIntstrument
{
    ...
}

class Violin extends MusicalInstrument
{
    ...
}

{%endhighlight%}

In this case you inherit everything from parent class and there is nothing wrong with it if that is what you want. But PHP does not support multi-inheritance - you can not inherit from muptiple classes simultaneously and sometimes you do **not** want to inherit everything from parent class. That is when composition helps. For example:


{%highlight php%}

class MusicalIntstrument
{
    ...
}

class Violin
{
    // typed properties will be available in PHP 7.4
    private MusicalInstrument $instrument;

    // we can go with constructor injection
    public function __construct($instrument)
    {
        $this->instrument = $instrument;
    }

    // or you can do setter injection whenever you need
    public function setInstrument($instrument)
    {
        $this->instrument = $instrument;
    }

}

{%endhighlight%}

Of course stackoverflow has much much better examples and explanations, please check the link below.

Resources:
[stackovewflow#1](https://stackoverflow.com/questions/49002/prefer-composition-over-inheritance?rq=1)
