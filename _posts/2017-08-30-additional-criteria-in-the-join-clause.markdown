---
layout: post
date:   2017-09-04
title: "Discovery of an advanced JOIN clause in MySQL"
---

_A little disclaimer: this is just a short self-initialized-probably-never-released postmortem note._

Today at work I was silly enough not to ask help from my colleagues, I've decided to deal with the problem myself and came up with a shitty solution.   
During code review horrible hackery was revaled and I was taugh to live a simple life.

Lets consider the following - there are two tables:

    SELECT * FROM docs

    | id | rev |                                           content |
    |----|-----|---------------------------------------------------|
    |  1 |   1 |                                 The earth is flat |
    |  2 |   1 | One hundred angels can dance on the head of a pin |

    SELECT * FROM docvalues

    | id | doc_id | property_id |  value |
    |----|--------|-------------|--------|
    |  1 |      1 |          10 |  First |
    |  2 |      1 |          10 | Second |
    |  3 |      1 |           8 |  Third |
    |  4 |      2 |          10 | Fourth |
    |  5 |      2 |           9 |  Fifth |
    |  6 |      2 |          10 |  Sixth |


And what we need is to select all docs with docvalues where `property_id` is 9, thus we intend to get NULL result for those who does not have corresponding record in the docvalues. Right?   

So the first mumbling query is the trivial one:

    SELECT docs.id, property_id, value FROM docs
        LEFT JOIN docvalues ON docvalues.doc_id = docs.id
        WHERE docvalues.property_id = 9;

    | id | property_id | value |
    |----|-------------|-------|
    |  2 |           9 | Fifth |

And it does not give us that NULL value for the document with id = 1!   
You see, in this case what we would actually need is to have that `property_id` written for the document with id = 1 and NULL value for the `value` field.

So there is actually a neat solution and it looks like this:

    SELECT docs.id, property_id, value FROM docs
        LEFT JOIN docvalues 
            ON docvalues.doc_id = docs.id 
            AND docvalues.property_id = 9;

    | id | property_id |  value |
    |----|-------------|--------|
    |  2 |           9 |  Fifth |
    |  1 |      (null) | (null) |

Now we got what we wanted initially, just thanks to this amazing JOIN clause!  

**Further reading:**   
[MySql 5.7 JOIN man](https://dev.mysql.com/doc/refman/5.7/en/join.html)   
