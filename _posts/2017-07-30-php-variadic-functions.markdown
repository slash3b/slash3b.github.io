---
layout: post
date:   2017-07-30
Title: "PHP variadic functions"
---
So at first what is a variadic function ? A variadic function is a function that accepts a variable number of arguments, that is it!

Starting from PHP 5.6 version we can write it using a special "splat" operator = `...`
So the simplest example would be this:

{% highlight PHP%}
    function variadic(...$args) {
        return $args;
    } 
    var_dump(variadic(1,2,3,4)); //  and you get it in form of the array [1,2,3,4]
{%endhighlight%}

In the earlier versions of PHP `func_get_args()` and `func_num_args()` were used in order to create variadic functions.
The first one gets you all the args in array form and the second you might've guessed just gives you a number of args.

Well the most trivial usage examples are - calculate average for a bunch of numbers, strig concatenation, ... you get the idea.
 
