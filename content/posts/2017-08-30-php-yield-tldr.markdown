---
layout: post
date:   2017-08-30
comments: true
title: "PHP yield tl;dr"
---
_If you would like to run some php code samples, your own machine is fine, but I would recomment you to use [3v4l.org](3v4l.org) as a way to execute the code with ~200 different PHP version. That is pretty awesome._

So for some time I avoided the `yeild` and all generator related stuff, honestly I did not get it from the first time and from the second time too... as usual It took some time
and perseverence from my side to grok that.

Before we begin here is some specs from the local machine, I'm showing what seems reasonable so bear with me:

    ~ $ php -v
    PHP 7.1.8 (cli) (built: Aug  2 2017 08:32:24) ( NTS )
    Copyright (c) 1997-2017 The PHP Group
    Zend Engine v3.1.0, Copyright (c) 1998-2017 Zend Technologies

    ~ $ lscpu
    Architecture:        x86_64
    CPU op-mode(s):      32-bit, 64-bit
    CPU(s):              4
    Thread(s) per core:  2
    Core(s) per socket:  2
    Socket(s):           1
    Vendor ID:           GenuineIntel
    CPU family:          6
    Model:               142
    Model name:          Intel(R) Core(TM) i5-7200U CPU @ 2.50GHz
    Stepping:            9
    CPU max MHz:         3100.0000
    L1d cache:           32K
    L1i cache:           32K
    L2 cache:            256K
    L3 cache:            3072K


    ~ $ free --total -h
    total          used
    Mem:           7.7G
    Swap:          7.8G
    Total:          15G

Well, now lets start right of the bat. You probably know the usual foreach control structure:

    <?php
    function grabArray() {
        $arr = [];
        for($i = 0; $i <= 100000000; $i++) {
            $arr[] = $i;
        }
        return $arr;
    }

You can also do something like this:

    <?php
    function yieldArray() {
        for($i = 0; $i <= 100000000; $i++) {
           yield $i; 
        }
    }

While the `grabArray()` will store the whole array in the memory and then obediently return this huge array, the `yieldArray()` will return the object instance of the `Generator` class.
Generator is a special type of class which can **not** be instantiated with the _new_ keyword, it extents `Iterator` interface and can be traversed with the usual
foreach.

Also you can notice a huge difference in consumed RAM (tested files with function above may be found [here](https://github.com/slash3b/sand`box/tree/master/php`yield`blog`post)):

    ~ $ php array_test.php
    4098Mb           
    ~ $ php yield_test.php
    2Mb

_later on I found out that the paragraph below is almost the same as in the "couroutines" article by Nikita Popov. Does it mean I understood it that good or I just subconsciously stole it?_

It happens because the `yieldArray()` is not executed fully, instead it returns `Generator` instance when it stumbles on the first `yield` keyword.
Returned generator has a "state" and "remembers" current state of the function, more on that later. 

Lets take into account some other important generator features:
- `yeild()` can take key-value pairs, just like this `yield $key => $value`
- in order to yeild null just `yield;` it 
- generators are one-way only highway, you can't get the previous value from the generator
- generators can not be cloned and when it is closed the `valid()` method will return false

In php7, we have a possibility to yeild form another generator, array, Iterator, well... anything that can be pushed into the genereator.

    <?php
    function secondGen()
    {
        yield 9;
    }
    function getGen()
    {
        yield 1;
        yield from [2,3];
        yield from secondGen();
    }

    getGen();

Now, lets continue with the generators, on the rfc page, link down below, there is super awesome example by [Nikita Popov](https://twitter.com/nikita_ppv) of how the generator is working.   
I preserved it with author's comments but added a couple of lines in the end, for better understanding:

    <?php
    function gen() {
        for($i = 0; $i <= 1; $i++) {
            echo 'start' . PHP_EOL;
            yield 'middle' . PHP_EOL;
            echo 'end' . PHP_EOL;
        }

    }

    // Initial call does not output anything
    $gen = gen();

    // Call to current() resumes the generator, thus "start" is echo'd.
    // Then the yield expression is hit and the string "middle" is returned
    // as the result of current() and then echo'd.
    echo $gen->current();

    // Execution of the generator is resumed again, thus echoing "end"
    $gen->next();
    // Then again, current() returns us the "start" and the "middle"
    echo $gen->current();
    // and next() executes what is left in the function
    $gen->next();

And this will resut in:
        
        start
        middle
        end
        start
        middle
        end

to be continued ...
I will update this article with coroutine examples.

**Used materials:**   
[Cooperative multitasking using coroutines (in PHP!)](ihttps://nikic.github.io/2012/12/22/Cooperative-multitasking-using-coroutines-in-PHP.html)
[What Generators Can Do For You](http://blog.ircmaxell.com/2012/07/what-generators-can-do-for-you.html)   
[Generators in action](https://habrahabr.ru/post/189796/)    
[man](http://php.net/manual/en/language.generators.syntax.php)   
[rfc](https://wiki.php.net/rfc/generators)
