---
layout: post
date:   2017-10-08
comments: true
title: "New features in PHP 7+"
---

This post serves as a reminder, it is so easy to forget things nowadays. So here you go all in one list of PHP 7+ new features.

Beware though, it is not 100% full, but 85-90% I think, I did omit some not-so-important features. I would be so glad if this article helped to save your time.

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

    $test = $_POST['surprise'] ?? 'nothing';

So in case post variable does not exists or it is null, we'll get the value after `??`

**Spaceship operator**    

    echo $x <=> $b;


Will return 0 in case variables are equal, -1 if $b is more\equal to the be and 1 if vise versa.

**Anonymous classes:**  

    new class extends SomeOtherClass
    {}

So yeah, it's an old plain class which can extend, implement and etc.

**Unicode codepoint escape syntax**  

    echo "\u{6879}";

Will output 桹 

**Closure::call**  
Shorthand way to get everything you need from the class.  
Could we say we do not need Reflection any more ?

    class A {private $x = 42;} 
    print (function(){ return $this->x;})->call(new A); 


**Filtered unserialize function**  
Now unserialize have an optional option `allowed_classes` for better security:

    unserialize($some_string, ['allowed_classes' => ['MyA', 'MyB']]);

Interestingly enough, in case we pass some other class we will get instance of `__PHP_Incomplete_Class`

**IntlChar**  
Intl extension received new class IntlChar, it holds a number of useful method to work with unicode characters.  
For instance `charAge` which lets you have a Unicode version when this character was introduced, or `charName` 
which well, lets you get char name and etc.

**Expectation**  
It is `assert` enhancement, previously you could use it like this:

    var_dump(assert('true !== false'));

which would be validated to true or false roughly speaking. But in PHP7 `assert()` is a language construct so the first parameter - assertion can be an expression and the second parameter can be now of type `throwable` so we can throw Exception.

**Group use declaration**  
We can them like this:

    use some\namespace\{ClassA, ClassB, ClassC as C};

Though it kind of contradicts with [PSR-4](https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-4-autoloader.md#2-specification) which does not allow grouping.

**Generator return expressions**  
With new Generator function `getReturn()` we may retrieve the final expression like this:

    $gen = (function(){
        yield 1;
        return 'The end' . PHP_EOL;
    })();

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

**Nullable types**  
Nullable type means that along with specified type we can pass or return NULL.  
Here is quite silly but legit example.

    function a(?string $line): ?string
    {
        return $line;
    }


**Void functions**   
New return type `void` that is used in case we omit `return` or we do `return;`

**Symmetric array destructuring**   
Means that now along with classical `list()` we can do this:

    $data = ['blah', 'ping-pong'];
    [$first, $second] = $data;

`$first` will be created and equal to 'blah' and `$second` will be equal to'ping-pong',
hence the name - _symmetric array destructturing_ : )

**Class constant visibility**  
Well, constants can now be `private`, `protected` and `public`

**iterable pseudo-type**  
New return type, similar to `callable()` - `iterable`  
Of course it can be user for array or object implemeting `Traversable` interface

**Multi catch exception handling**  
Catch block may now have multiple exceptions specified with pipe `|` character like this

    ...
    } catch( LigicException | RuntimeException $e) {
    ...


**Support for keys in list() or in [] array desctucuring**   
`list` and symmetric array destructuring support keys, so we can do it like this:

    $data = [
        ["id" => 1, "name" => 'Tom'],
        ["id" => 2, "name" => 'Fred'],
    ];

    list("name" => $name, "id" => $id) = $data[0];

    ["name" => $name, "id" => $id] = $data[0];


**Support for negative string offsets**  
With negative offset we can do `var_dump("testy"[-1]);` and receive y letter.  
Also all [string manipulation function](http://php.net/manual/en/book.strings.php) are able to use negative offset as well.

**Convert callables to Closures with Closure::fromCallable()**   


**Asynchronous signal handling**  


**HTTP/2 server push support in ext/curl**  


**Things deprecated:**  
{: style="color:red;" }
- extension ext/mcrypt
- the _e_ pattern modifier is deprecated for the mb_ereg_replace() and mb_eregi_replace() functions.

### Changes introduced in 7.2

**New object type**  
It can be used as type hint and as return type as well:

    function(object $obj): object {
        return new SplFileInfo();
    }

**Extension loading by name**  
No need to write extension name along with file extension, _.so_ in Unix case.  

**Abstract method override**   
Now we are able to create child abstact class and override parent's abstract methods:


    abstract class A
    {
        abstract function test(string $s);
    }
    abstract class B extends A
    {
        abstract function test($s) : int;
    }


**password_hash will support Argon2 hashing algorithm**  
All `password_...`functions have a bunch of ARGON2 constants available to them.

**New cryptographic extension - Sodium**    

**object as type hint and return type**  

**Parameter Type Widening**  


    interface A
    {
            public function Test(array $input);
    }

    class B implements A
    {
            public function Test($input){}
    }


**Trailing comma is alowed in grouped namespaces**  

**Things deprecated:**  
{: style="color:red;" }
- unquoted strings in php7.2+ will emir E_WARNING instead of E_NOTICE
- `__autload()` deprecated in favor of superior `spl_autoload_register()`
- useless `(unset)` cast
- `create_function()`
- using `parse_str()` function without second argument
- `each()` function due to slowness
- `assert()` with string argument 

### Changes introduced in 7.3   

&#9642; **JSON throw on error**    
As fourth parameter `json_decode()` and `json_encode` functions receive bitmask of JSON decode options.  
`JSON_THROW_ON_ERROR` will be added to these options, it wont change behavior of `json_last_error()` and `json_last_error_msg()`.
With that additional option `json_decode()` and `json_encode` functions will throw `JsonException`.


**Things deprecated:**   
{: style="color:red;" }
- not yet


