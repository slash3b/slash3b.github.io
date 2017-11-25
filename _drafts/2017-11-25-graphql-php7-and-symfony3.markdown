---
layout: post
date:   2017-10-08
comments: true
title: "GraphQL, PHP7+ and Symfony3"
---
todo: write disclaimer

First, for those who are like me do not have a computer science degree, lets find out what graph is. 
In plain english graph is a structure which consists of nodes interconnected between each other, like this:   

<img align="right" style="margin-left: 20px;" src="/assets/images/6n-graf.svg"> 

In wikipedia we may find the following explanation:
> In mathematics, and more specifically in graph theory, a graph is a structure amounting to a set of objects in which some pairs of the objects are in some sense "related".  
The objects correspond to mathematical abstractions called vertices and each of the related pairs of vertices is called an edge.   

Graphs are used to represent many real life objects "cases" such as network connections, relations between different object/peoples and etc.

## GraphQL
In a nut shell graphQL is a query language that serves as a replacement for REST api. Instead of using typical HTTP verbs such as POST, PUT, GET, TRACE, PATCH, DELETE and others we use this query language that is quite expressive and allows ask to query only the data we need. Instead of many different endpoint we have only one that receives all requests. Thanks to this language single query can access multiple resources at once, thus making GraphQL faster and more efficient.


So the recommended package is [webonyx/graphql-php](https://github.com/webonyx/graphql-php).
I started with the simples example from the packaged and slightly adapted it:

{% highlight PHP %}
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
         * @Route("/graphql")
         * @param Request $request
         *
         * @return JsonResponse string
         */
        public function graphql(Request $request): JsonResponse
        {
            $queryType = new ObjectType(
                [
                    'name'        => 'Query',
                    'description' => 'This is basic description of the Schema.',
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

            $schema = new Schema(
                [
                    'query' =>  $queryType,
                ]
            );

            $rawQuery = $request->getContent();
            $query    = json_decode($rawQuery);

            try {
                if (!$query) {
                    throw new \LogicException('Sorry, empty request.');
                }
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
{% endhighlight %}


Basically I'd outline here 3 main steps:
- create object type for the `echo` field
- register schema
- process request

And when you send request with curl you will get silly but perfectly valid response:  

{% highlight bash %}
    ~ $ curl http://localhost:8080/graphql -d '{"query":"query{ echo(message: \"Hello GraphQL\") }" }'
    {"data":{"echo":"Hello GraphQL"}}
{% endhighlight %}

I do have a small pet project, I wont even link it here it is so unimportant, but that is the way to try GraphQL!
Lets go through more difficult example:




I thought I can get by without ready-made solution [owerblog/graphql-bundle](https://packagist.org/packages/overblog/graphql-bundle)









GraphQL itself has a plethora of info to study

### Resources:  
attp://webonyx.github.io/graphql-php

