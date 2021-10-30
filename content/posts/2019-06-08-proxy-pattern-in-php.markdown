---
layout: post
date:   2019-06-08
comments: true
title: "Proxy Design Pattern"
---

# Proxy Design Pattern

First, some definitions.

Wikipedia:  
> In computer programming, the proxy pattern is a software design pattern. A proxy, in its most general form, is a class functioning as an interface to something else

Design Patterns. Elements of Reusable Object-Oriented Software:
> Provide a surrogate or placeholder for another object to control access to it.

There are a few reasons to use Proxy pattern and control access to the underlying object:
- underlying object is heavy and it is very costly to create it, e.g. it may do some media processing, multiple HTTP calls, etc. a.k.a. **Virtual Proxy**  
- access regulation, before giving up the real object, you may want to check first if client/user has an access to it. a.k.a. **Protection Proxy**  
- executes additional operations when the real subject is accessded(c) Ocramius  a.k.a. **Smart Reference**

Example of Virtual Proxy in PHP:

```

<?php
declare(strict_types=1);

// it is usually recommended to bound both classes by a contract
// but are going to just extend underlying object and
// comply this way with LSP

class NetflixFilm {

    protected $title;

    protected $path;

    public function __construct(string $title)
    {
        $this->title = $title;
    }

    public function getFilm()
    {
        if ($this->path == null) {
            // doing time and/or memory consuming computation here
            print 'Searching for film...' . PHP_EOL;
            $this->path = '/tmp/' . $this->title;
        }

        return $this->path;
    }
}

class NetflixFilmProxy {
    protected $title;

    protected $netflixFilm;

    public function __construct(string $title)
    {
        $this->title = $title;
    }

    public function getFilm()
    {
        if (!$this->netflixFilm instanceof NetflixFilm) {
            $this->netflixFilm = new NetflixFilm($this->title);
        }

        return $this->netflixFilm->getFilm();
    }
}

print 'And underlying object is not instantiated when we create Proxy.' . PHP_EOL;
$proxy = new NetflixFilmProxy('Our Planet');
$reflectionObject = new ReflectionObject($proxy);
$reflectionProperty = $reflectionObject->getProperty('netflixFilm');
$reflectionProperty->setAccessible(true);

var_dump($reflectionProperty->getValue($proxy));

print 'And here it is.' . PHP_EOL;
var_dump($proxy->getFilm()); // heavy instance creation on demand

```








