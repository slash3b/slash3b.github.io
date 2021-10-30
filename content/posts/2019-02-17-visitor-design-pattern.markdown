---
layout: post
date:   2019-02-17
comments: true
title: "Visitor Design Pattern"
---

Visitor design pattern is one of many patterns that fall under category "Behavioral patterns"

Allows to **move part of the logic/algorithm from one class to another**, so you can extend/add new behavior to the initial class without changing its code.

One of the ways to follow "open/closed" principle.

Here is an example:

```

interface Visitor {
    // quite reasonable to a visitor to be able to "visit" other classes
    public function visit(Person $person);
}

interface Person {
    public function accept(Visitor $visitor);
}

// so these two interfaces know about each other

class RealVisitor implements Visitor
{
    public function visit(Person $person)
    {
        // this sequence of "operations" is quite naive
        // but you can implement here whatever you want
        // instance of Person interface can be changed however you want
        // no need to update/change class itself
        $person->name = 'Mr. Whiskers';
        print $person->name . PHP_EOL;
        print $person->surname . PHP_EOL;
        print $person->address . PHP_EOL;
    }
}

class RealPerson implements Person 
{
    public function accept(Visitor $visitor)
    {
        $visitor->visit($this);
    }
}

// camera, action!

$realVisitor = new RealVisitor;
$realPerson = new RealPerson;
$realPerson->name = 'David';
$realPerson->surname = 'Hamster';
$realPerson->address = 'Holland';

$realPerson->accept($realVisitor);


// output:
// Mr. Whiskers
// Hamster
// Holland   



```


Hope it helps. Thanks!

Resources:  
[refactoring.guru](https://refactoring.guru)  
[sourcemaking.com](https://sourcemaking.com/design_patterns/visitor/php)



