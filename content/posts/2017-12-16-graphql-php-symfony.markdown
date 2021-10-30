---
layout: post
date:   2017-12-16
comments: true
title: 'wip: GraphQL and Symfony'
draft: true

---

_Disclaimer: this post is my own understanding of graphQL and how it may be implemented with Symfony. I'm quite sure this is not a "best practice" guide and this post may contain erros, so please remember this. I do not encourage anybody to build API the way it is described here. I would be really glad if you would leave your opinion in the comments below. Thanks for reading!_

<br>
First, for those who are like me do not have a computer science degree, lets find out what graph is. 
In plain english graph is a structure which consists of nodes interconnected between each other, like this:   

<img align="right" style="margin-left: 20px;" src="/assets/images/6n-graf.svg"> 

In wikipedia we may find the following explanation:
> In mathematics, and more specifically in graph theory, a graph is a structure amounting to a set of objects in which some pairs of the objects are in some sense "related".  
The objects correspond to mathematical abstractions called vertices and each of the related pairs of vertices is called an edge.   

Graphs are used to represent many real life objects "cases" such as network connections, relations between different object/peoples and etc.

## What is GraphQL and why is it called that way ?
> GraphQL is a query language for APIs and a runtime for fulfilling those queries with your existing data.    

> GraphQL is a query language that traverses your data graph to produce a query result tree.   

GraphQL is a declarative query language that allows us to query for the data we need, it also tends to be a replacement for REST api. Thanks to this language single query can access multiple resources at once, thus making GraphQL faster and more efficient.    

<img height="70%" width="70%" align="left" style="margin-right: 20px;" src="/assets/images/simplified_restful_request_model.svg"> 
Here is a simple REST request model, whenever we need to fetch/modify data we need to query appropriate endpoint, which may lead us, if it is the 3-rd level of REST,   
to another endpoint/resource and etc. Each time we need data we do yet another request which is not really efficient.    
<br><br>
<br><br>
Graph QL on the other hand is able to fetch all the necessary data at once and __only the data we need__, collecting everything we reqeuested for and outputting it in one response.
<img src="/assets/images/simplified_graphql_request_response_model.svg"> 

GraphQL uses type system to describe underluing data we can work with and ensure helpful error reporting. As the client specify what data needed we do not have to stick with version mangement for GraphQL endpoint, in other words GraphQL endpoints are versionless. You can add new fields without worrying - existing clients will still receive data.   

So finally it looks something like this(gif stolen from the [graphql.org](http://graphql.org/)):
<img src="/assets/images/t01c93357a8f0c51329.gif"> 

<br><br>
## "Hello GraphQL" example with Symfony
Lets start!  
We are going to use Symfony the GraphQL recommended PHP package - [webonyx/graphql-php](https://github.com/webonyx/graphql-php).

In order to implement the very simple "Hello GraphQL" example I have to start with creating a simple controller 
keep an eye on inline comments!
```
   <?php

    namespace AppBundle\Controller;

    use GraphQL\GraphQL;
    use GraphQL\Type\Definition\ObjectType;
    use GraphQL\Type\Definition\Type;
    use GraphQL\Type\Schema;
    use Symfony\Bundle\FrameworkBundle\Controller\Controller;
    use Symfony\Component\HttpFoundation\JsonResponse;
    use Symfony\Component\HttpFoundation\Request;
    use Symfony\Component\Routing\Annotation\Route;

    /**
     * Class ApiController
     *
     * @package AppBundle\Controller
     */
    class ApiController extends Controller
    {

        /**
         * @Route("/graphql") // so here is the endpoint name
         * @param Request $request
         *
         * @return JsonResponse string
         */
        public function graphql(Request $request): JsonResponse
        {
            // define Type
            $queryType = new ObjectType(
                [
                    'name'        => 'Query',
                    'description' => 'Some description',
                    'fields'      => [
                        'echo' => [
                            'type'    => Type::string(),
                            'args'    => [
                                'message' => Type::nonNull(Type::string()),
                            ],
                            'resolve' => function ($prefix, $args) {
                                return $args['message'];
                            },
                        ],
                    ],
                ]
            );
            // register schema
            $schema = new Schema(
                [
                    // 'query' will be root element in the query body,
                    // like this "query { request body ... }"
                    'query' =>  $queryType,
                ]
            );

            // take json request
            $rawQuery = $request->getContent();
            $query    = json_decode($rawQuery);

            try {
                if (!$query) {
                    throw new \LogicException('Sorry, empty request.');
                }
                // query execution
                $result    = GraphQL::executeQuery($schema, $query->query);
                $output    = $result->toArray();
            } catch (\Exception $e) {
                $output = [
                    'errors' => [
                        [
                            'message' => $e->getMessage(),
                        ],
                    ],
                ];
            }


            return new JsonResponse($output, 200);
        }

    }     
```


Basically I'd outline here 3 main steps:
- create hierarchy of types you need 
- register schema
- process request

And when you send request with curl you will get silly but perfectly valid response:  

```
    ~ $ curl http://localhost:8080/graphql -d '{"query":
             "query{ echo(message: \"Hello GraphQL\") }" }'

    {"data":{"echo":"Hello GraphQL"}}
```

### Cons:
<div class="reddit-embed" data-embed-media="www.redditmedia.com" data-embed-parent="false" data-embed-live="false" data-embed-uuid="d9ca904a-9fe4-4528-a251-192208fd9a73" data-embed-created="2017-12-02T08:25:27.545Z"><a href="https://www.reddit.com/r/reactjs/comments/4h2rm6/graphql_overhyped/d2n5r9j/">Comment</a> from discussion <a href="https://www.reddit.com/r/reactjs/comments/4h2rm6/graphql_overhyped/">GraphQL Overhyped?</a>.</div><script async src="https://www.redditstatic.com/comment-embed.js"></scripit>

<div class="reddit-embed" data-embed-media="www.redditmedia.com" data-embed-parent="false" data-embed-live="false" data-embed-uuid="6332761d-64d0-4c5a-8f67-f59bba177ba0" data-embed-created="2017-12-02T09:09:07.994Z"><a href="https://www.reddit.com/r/reactjs/comments/4h2rm6/graphql_overhyped/d2n8a54/">Comment</a> from discussion <a href="https://www.reddit.com/r/reactjs/comments/4h2rm6/graphql_overhyped/">GraphQL Overhyped?</a>.</div><script async src="https://www.redditstatic.com/comment-embed.js"></script>

GraphQL itself has a plethora of info to study

### Resources:  
http://webonyx.github.io/graphql-php
https://dev-blog.apollodata.com/the-concepts-of-graphql-bc68bd819be3
https://symfony.fi/entry/adding-a-graphql-api-to-your-symfony-flex-app


