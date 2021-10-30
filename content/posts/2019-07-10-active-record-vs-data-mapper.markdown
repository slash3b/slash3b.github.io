---
layout: post
date:   2019-07-10
comments: true
title: "Active record vs. Data Mapper"
---

In Object-oriented programming we often need to persist object to the database for later retrieval. For that to work smart people invented Object-Relation Mapper that does object to db conversion and vise versa. Such ORM object are usually called _entities_ and are passed around in application and are subject to CRUD operations.  

ORM implies existence of DBAL(Database Abstraction Layer) and Data Access Layer.   
+ DBAL abstracts Quering language details of different databases and supports many databases at once. Theoretically you can switch seamlessly from one database to another, though I never heard of practical execution of this feature.
+ _Active record_ and _Data Mapper_ are Data Access Layer patterns or better to say paradigms.

ORM advantages:
- Most of the time you do not have to write SQL, ORM does that for you behind the scenes
- Entities are very flexible, you can pass them around, change and when needed persist
- More clean domain visibility - you have an entity filled with values and comments and annotations and lots of functionality provided by e.g. EntityManager. This lets you abstract away from SQL and operate on domain level

ORM disadvantages:
- ORM may be suboptimal in efficiency - internal conversion and compilation to SQL takes time, also ORM could do multiple inefficient queries instead of one e.g. N+1 problem
- It may be very difficult to write complex queries with ORM tooling, actually ORM can not compete with SQL on this field
- ORMs are also called "leaky abstractions" which means that even though you abstract away from low level details, SQL, you still need to understand what is going on a low level in order to use abstraction efficiently.

# Active record

According to [Martin Fowler](https://martinfowler.com/eaaCatalog/activeRecord.html) Active Directory is:  
> An object that wraps a row in a database table or view, encapsulates the database 
access, and adds domain logic on that data. Object carries both data and behavior.

My interpretaion in plain english:  
> Active Record implies that an entity represents a table from database and each 
instance of an entity represents one row from the table, also that entity contains 
not only data **but** also all methods/operations to deal with that data. So it 
typically contains CRUD methods like `save()`, `delete()`, `update()`, `find()` and etc.   

Examples of AR:
- Ruby on Rails
- Laravel’s Eloquent
- Propel (Symfony)
- Yii Active Record
- Django’s ORM

Older version of Doctrine ORM did follow Active Record pattern and an entity was created and saved this way:
```
<?php
$user = new User();
$user->name = "john";
$user->password = "doe";
$user->save();
echo "The user with id $user->id has been saved.";

```

In Ruby on Rails it could be like this: 
```
u = User.create(name: "john", password: "doe")
```

Here is another exaple using [Eloquent ORM](https://laravel.com/docs/5.0/eloquent):

Define entity like so:
```
class User extends Model {}
```
and that is basically it. You can fire `User::all()` in order to get all users.  
The entity does not have fields mapping becase they *are* alredy defined in the database.

So the major benefits of AR are:
- simplicity
- easy to start with

Disadvantages are:
- strong binding between database and application - entities contain domain behaviour apart from the data itself
- can become messy in big projects

# Data Mapper

From wikipedia:
> A Data Mapper is a Data Access Layer that performs bidirectional transfer of data between a persistent data store (often a relational database) and an in-memory data representation (the domain layer). The goal of the pattern is to keep the in-memory representation and the persistent data store independent of each other and the data mapper itself.

That is a long definition and it definitely says something but I need a bit more succint and clear definition, otherwise my brain wont remember it. So I like this by Martin Fowler:
> The Data Mapper is a layer of software that separates the in-memory objects from the database. Its responsibility is to transfer data between the two and also to isolate them from each other. 

For instance here an example of Doctine2 Entity:

```
<?php
// src/Entity/Product.php
namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * @ORM\Entity(repositoryClass="App\Repository\ProductRepository")
 */
class Product
{
    /**
     * @ORM\Id
     * @ORM\GeneratedValue
     * @ORM\Column(type="integer")
     */
    private $id;

    /**
     * @ORM\Column(type="string", length=255)
     */
    private $name;

    /**
     * @ORM\Column(type="integer")
     */
    private $price;

    public function getId()
    {
        return $this->id;
    }

    // ... getter and setter methods
}
```
Note how it lacks CRUD and domain methods, also mapping definition is done via annotaions.

Examples of Data Mapper:
- Java Hibernate
- Doctrine2
- SQLAlchemy in Python
- EntityFramework for Microsoft .NET
- Golang Prisma
- Ecto Elixir

PHP example with Doctrine2. See, how CRUD et all operations are done with EntityManager and not with Entity itself?
```

$user = new User();
$user->setName("john");
$user->setPassword("doe");
$entityManager->persist($user);
$entityManager->flush();
echo "The user with id " . $user->getId() . "has been saved.";

```

Benefits of Data Mapper:
- clear separation of domain logic and database
- a lot of flexibility. That is arguable of course, because with enough experience AR allows a lot of flexibility too, imo

Disadvantages:
- you have to learn how to work with it
- may not be easy to set up and start with

# Brief conclusion: 
When Active Record tries to make the gap between application and database as thin and seamless as possible, Data Mapper strives to abstract your domain away as much as possible.

Resources used:   
[Active record versus Data Mapper](https://www.thoughtfulcode.com/orm-active-record-vs-data-mapper/)   
[stackoverfow_1](https://stackoverflow.com/questions/4667906/the-advantages-and-disadvantages-of-using-orm)   
[Doctrine wiki page in russian](https://ru.wikipedia.org/wiki/Doctrine)   
[Martin Fowler Active Record](https://martinfowler.com/eaaCatalog/activeRecord.html)   
[Martin Fowler Data Mapper](https://martinfowler.com/eaaCatalog/dataMapper.html)    
[wiki page for DataMapper](https://en.wikipedia.org/wiki/Data_mapper_pattern)   
[entity example with Symfony and Doctrine](https://symfony.com/doc/current/doctrine.html#creating-an-entity-class)  
[active record antipattern](https://www.mehdi-khalili.com/orm-anti-patterns-part-1-active-record)
[ar-vs-data_mapper](https://medium.com/oceanize-geeks/the-active-record-and-data-mappers-of-orm-pattern-eefb8262b7bb)   
