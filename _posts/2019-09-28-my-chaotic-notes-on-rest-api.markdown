---
layout: post
date:   2019-09-28
comments: true
title: "My chaotic notes on REST API"
---

REST is paradigm or architectural style that defines your API.   

- One of the most important and yet simple REST consept is resouce/endpoint, I really like resource term so I'm going to use it here. In REST paradigm URL is a resource, e.g. — http://example.org/test/foo.

- You should strive not to use verbs in URL. The only verbs you need are HTTP verbs — GET, HEAD, POST, PUT, PATCH, OPTIONS, TRACE.

- Subresource in REST looks like this — `/posts/{id}/author`. With GET verb it means — fetch me an author of this particular book. It makes no sense to continue a subresouce with additional nesting. If you have situation like this TRY to move that to separate endpoint. Although the correct answer is always — "it depends" : )    
If you are developing something vast and complex e.g. [github api](https://developer.github.com/v3/) than you can/should use longer URLs to fit in all the domain logic.

- Plan and build API documentaion first. Write your API documentaion with [OpenAPI3](https://github.com/OAI/OpenAPI-Specification) and use tools like [Prism](https://stoplight.io/open-source/prism/) to create mock API and give it to the client. This way you can get an early feedback, see the full picture before actual development started.

- If something goes wrong you should use [HTTP status codes](https://httpstatuses.com) and custom error codes and messages e.g. [twitter error codes](https://developer.twitter.com/en/docs/basics/response-codes). You need to use custom error code because HTTP statuses can not cover all your needs — you have to be more specific about happened errors instead of just sending 500 status with message "Oopps... something went wront".  
Error codes can be used to take specific measures and act accordingly, for instance if you got smth. like "Your JWT token expired" you can do a login and retry an action.

- Test your API! You can do this with BDD using [Behat](https://behat.org/en/latest/quick_start.html) or use `WebTestCase` class provided by [Symfony](https://symfony.com/doc/current/testing.html#functional-tests).

- Versioning could be done with prefixing, e.g. `/api/v1`, `/api/v2` and etc. or version number could be sent in Content-Type HTTP header, like [github](https://developer.github.com/v3/media/#request-specific-version) does it 

- For proper authentication use [OAuth2](https://oauth.net/code/php/) or [JWT](https://jwt.io). OAuth2 seems to be the best choice as a more "solid" authentication solution. Make sure to read "What Happens If Your JWT Is Stolen?" in the resources section.

- Make sure to check your HTTP headers. Set all security headers and throw away unnecessary once, check security list under Resources section.

- HATEOAS makes REST api RESTFUL. HATEOAS means you should use `Content-Type` header and speak in a language your client requires, be it JSON or XML or plain text for some reason. HATEOAS also means that you should provide related data in the form of links in the response. That related data coulb be use in a form "find me all the frends of that user partner". These links can help your API to work with your API more efficiently.

Misc:   

- UUID is a must, do not use auto-incrementing ids

- Store Timezones, not offsets. Use [IANA](https://www.iana.org/time-zones)

- Obvious, but... SSL is mandatory for all communication.



Resources:   
[Build APIs You Wont Hate by Phil Sturgeon](https://leanpub.com/build-apis-you-wont-hate/)  
[Build APIs You Wont Hate: Second Edition](https://leanpub.com/build-apis-you-wont-hate-2/)  
[What the hell is REST, Anyway?](https://programmingisterrible.com/post/181841346708/what-the-hell-is-rest-anyway)
[REST API Tutorial](https://restfulapi.net/)  
[What Happens If Your JWT Is Stolen?](https://developer.okta.com/blog/2018/06/20/what-happens-if-your-jwt-is-stolen)   
[API-Security-Checklist](https://github.com/shieldfy/API-Security-Checklist)    
[JSONAPI](https://jsonapi.org)   
[GitHub API](https://developer.github.com/v3/)   
