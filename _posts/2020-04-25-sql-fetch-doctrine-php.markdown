---
layout: post
date: 2020-04-25
comments: true
title: "join-fetched queries in doctrine for lost dummies"
---

# what is JOIN FETCH exactly?

So it was not clear from the start and search engine results might confuse you even further. Here it goes — 
JOIN FETCH is not an SQL feature and it does not relate to FETCH keyword in [t-sql](https://docs.microsoft.com/en-us/sql/t-sql/language-elements/fetch-transact-sql?view=sql-server-ver15) or any other sql dialect that uses it.

Note: hydration is the process of turning fetched rows from the database into object/entities. Embarrased to admit that
I did not knew exactly what it is.

Down below I'm going to show some examples and outputs based on a very simple database structure that includes two tables — Customer and Product. Customer can have many Products so it is one-to-many relation.

# what is fetch-join in doctrine?
Here is a [link](https://www.doctrine-project.org/projects/doctrine-orm/en/2.7/reference/dql-doctrine-query-language.html#joins) to documentation. 
It boils down to the following — there are two types of JOIN in Doctrine:
- **Regular Joins**: Used to limit the results and/or compute aggregate values.
- **Fetch Joins**: In addition to the uses of regular joins it is also _fetches related entities_ and include them in the hydrated result of a query.

In [Hibernate](https://docs.jboss.org/hibernate/core/3.3/reference/en/html/queryhql.html#queryhql-joins) a
specific keyword "fetch" might be used in HQL(Hibernate Query Language) or fetch "mode" might be used in metadata of the
Entity. Doctrine does something similar.

For example lets just select all customers and see what we get with this query:

```
$query = $em->createQuery('select c from App\Entity\Customer c');
dump($query->getResult());
```

Result:

```
array:2 [▼
  0 => App\Entity\Customer {#579 ▼
    -id: 1
    -name: "Petr"
    -products: Doctrine\ORM\PersistentCollection {#687 ▼
      -snapshot: []
      -owner: App\Entity\Customer {#579}
      -association: array:15 [ …15]
      -em: Doctrine\ORM\EntityManager {#546 …11}
      -backRefFieldName: "customer"
      -typeClass: Doctrine\ORM\Mapping\ClassMetadata {#654 …}
      -isDirty: false
      #collection: Doctrine\Common\Collections\ArrayCollection {#689 ▼
        -elements: []
      }
      #initialized: false
    }
  }
  1 => App\Entity\Customer {#690 ▼
    -id: 2
    -name: "Ion"
    -products: Doctrine\ORM\PersistentCollection {#691 ▼
      -snapshot: []
      -owner: App\Entity\Customer {#690}
      -association: array:15 [ …15]
      -em: Doctrine\ORM\EntityManager {#546 …11}
      -backRefFieldName: "customer"
      -typeClass: Doctrine\ORM\Mapping\ClassMetadata {#654 …}
      -isDirty: false
      #collection: Doctrine\Common\Collections\ArrayCollection {#692 ▼
        -elements: []
      }
      #initialized: false
    }
  }
]
```
As you can see related records are not really there but we have proxy instead.  

Fetch join might be done:
- **implicitly** by including relation in SQL select statement
- **explicitly** by adding fetch strategy to the relation annotation, see example below.


### Implicit fetch-join
Implicit fetch-join is done simply by mentioning required relation in SELECT statement like this:
```
$query = $em->createQuery('select c, p from App\Entity\Customer c JOIN c.products p');
dump($query->getResult());
```
Pay attention that we do JOIN not with "entity" for example 'App\Entity\Product', but with Customer's property — _products_ that is a relation.  

The result is loaded collections:
```
array:2 [▼
  0 => App\Entity\Customer {#579 ▼
    -id: 3
    -name: "Petr"
    -products: Doctrine\ORM\PersistentCollection {#687 ▼
      -snapshot: array:1 [ …1]
      -owner: App\Entity\Customer {#579}
      -association: array:15 [ …15]
      -em: Doctrine\ORM\EntityManager {#546 …11}
      -backRefFieldName: "customer"
      -typeClass: Doctrine\ORM\Mapping\ClassMetadata {#654 …}
      -isDirty: false
      #collection: Doctrine\Common\Collections\ArrayCollection {#689 ▼
        -elements: array:1 [▼
          0 => App\Entity\Product {#722 ▼
            -id: 4
            -title: "Shampoo"
            -sku: "7f9s"
            -customer: App\Entity\Customer {#579}
          }
        ]
      }
      #initialized: true
    }
  }
  1 => App\Entity\Customer {#690 ▼
    -id: 4
    -name: "Ion"
    -products: Doctrine\ORM\PersistentCollection {#691 ▼
      -snapshot: array:2 [ …2]
      -owner: App\Entity\Customer {#690}
      -association: array:15 [ …15]
      -em: Doctrine\ORM\EntityManager {#546 …11}
      -backRefFieldName: "customer"
      -typeClass: Doctrine\ORM\Mapping\ClassMetadata {#654 …}
      -isDirty: false
      #collection: Doctrine\Common\Collections\ArrayCollection {#692 ▼
        -elements: array:2 [▼
          0 => App\Entity\Product {#723 ▼
            -id: 5
            -title: "Pizza"
            -sku: "fg75"
            -customer: App\Entity\Customer {#690}
          }
          1 => App\Entity\Product {#724 ▼
            -id: 6
            -title: "Lemon"
            -sku: "9nm1"
            -customer: App\Entity\Customer {#690}
          }
        ]
      }
      #initialized: true
    }
  }
]
```

### Explicit fetch-join

Lets execute explicit fetch-join using optional annotation reference called "fetch". It defaults to LAZY and can also be EXTRA_LAZY or EAGER.
In my case I did add EAGER to get all related records like this:

```
/**
 * @ORM\OneToMany(targetEntity="App\Entity\Product", mappedBy="customer", fetch="EAGER")
 */
private $products;
```

Don't forget to make sure your metadata cache is warmed up and execute this query:

```
$query = $em->createQuery('select c from App\Entity\Customer c');
dump($query->getResult());
```

Result will be the same as in previous example.

Here is mini [tutorial](https://doctrine2.readthedocs.io/en/latest/tutorials/extra-lazy-associations.html) on EXTRA_LAZY fetch mode if you want to find more.  

