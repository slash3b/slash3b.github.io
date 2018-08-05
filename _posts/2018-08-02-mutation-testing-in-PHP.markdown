---
layout: post
date:   2018-08-02
comments: true
title: Mutation testing in PHP
---

Today at my job I did an internal presentation on mutation testing in PHP. Here is the presentation:

<iframe src="https://docs.google.com/presentation/d/e/2PACX-1vT-UcEE3Y6YwRb6FLX3Q1Ep7_TMJEFVPm816lHYw6-cyWs-mX23wk0VufYGwD1tZ9oR9r16Kv4YJQBV/embed?start=false&loop=false&delayms=3000" frameborder="0" width="480" height="299" allowfullscreen="true" mozallowfullscreen="true" webkitallowfullscreen="true"></iframe>

What it lacks is the live example of how it is done. So I'm going to just short list here an example.  
For this code intro I'm going to use PHP7.2. The only PHP class we have is this one below, and it is pretty much naive but is usefull for our example:
{% highlight PHP %}
<?php
declare(strict_types=1);

namespace Ex1;

class WeirdCalculator
{
    public function adds(int $x, int $y)
    {
        return $x + $y;
    }

    public function subtracts(int $x, int $y)
    {
        return $x + $y;
    }

    public function inArray($arr, $needle)
    {
        foreach ($arr as $elem){
            if($elem == $needle) {
                $result = $elem;
                break;
            }
        }
        return $result;
    }

    public function filterArray($array)
    {
        return array_filter($array, function($elem) {
                return $elem > 10;
                });

    }
}
{% endhighlight %}

We also have test class that covers all out "codebase" so to speak.

{% highlight PHP %}
<?php
declare(strict_types=1);

use Ex1\WeirdCalculator;
use PHPUnit\Framework\TestCase;

class CalculatorTest extends TestCase
{

    public function test_adds()
    {
        $calc = new WeirdCalculator();
        $result = $calc->adds(1,2);
        $this->assertTrue(is_int($result));
    }

    public function test_subtracts()
    {
        $calc = new WeirdCalculator();
        $result = $calc->subtracts(1,2);
        $this->assertTrue(is_int($result));
    }

    public function test_in_array()
    {
        $calc = new WeirdCalculator();
        $result = $calc->inArray(['a','b'], 'a');
        $this->assertTrue(is_string($result));
    }

    public function test_filter_array()
    {
        $calc = new WeirdCalculator();
        $result = $calc->filterArray([1,2,3,10,20,30]);
        $this->assertCount(2, $result);
    }

}

{% endhighlight %}

Now, if you run `vendor/bin/phpunit --coverage-text` you'll see 100% coverage. Yay!
But lets run Infection over the code with `vendor/bin/infection`. The result is the following:   

{% highlight bash %}
$ vendor/bin/infection
You are running Infection with xdebug enabled.
Running initial test suite...

PHPUnit version: 7.2.6

9 [============================] < 1 sec

Generate mutants...

Processing source code files: 1/1
Creating mutated files and processes: 14/14
.: killed, M: escaped, S: uncovered, E: fatal error, T: timed out

M.M.MM...M..S.                                       (14 / 14)

14 mutations were generated:
8 mutants were killed
1 mutants were not covered by tests
5 covered mutants were not detected
0 errors were encountered
0 time outs were encountered

Metrics:
Mutation Score Indicator (MSI): 57%
Mutation Code Coverage: 93%
Covered Code MSI: 62%

Please note that some mutants will inevitably be harmless (i.e. false positives).

{% endhighlight %}

So the output is pretty self-explanatory, but if you want to see more verbose output you can check infection-log.txt file which can be found in the root of the project. This file contains detailed info on what mutations were created, which of them were "caught" and which of them were "killed" and so on.  

As you may have noticed the MSI metrics is low, which means that only 57% of all mutations were caught. Basically that means that the test is not very efficient. 
So lets go on and fix it!  

{% highlight diff %}
index db16273..9f1393e 100644
--- a/mutation_testing_presentation/ex1/tests/CalculatorTest.php
+++ b/mutation_testing_presentation/ex1/tests/CalculatorTest.php
@@ -12,6 +12,7 @@ public function test_adds()
        $calc = new WeirdCalculator();
        $result = $calc->adds(1,2);
        $this->assertTrue(is_int($result));
+       $this->assertEquals(3, $result);
    }

    public function test_subtracts()
@@ -19,6 +20,7 @@ public function test_subtracts()
        $calc = new WeirdCalculator();
        $result = $calc->subtracts(1,2);
        $this->assertTrue(is_int($result));
+       $this->assertEquals(-1, $result);
    }
{% endhighlight %}

If you run infection again, MSI score will be up to 71% which is much better.  
This is how mutation testing help us to improve our testing suite. We did check the test suite quality and it turned out to be not so great and then Infection showed us all the weak spots and we fixed some of them and test quality improved a lot! You may play with the examples above just to get deeper understanging of what is going on.  

Also note that sometime some of the mutations do not make sense, so it is not necessary to strive for 100% MSI.

