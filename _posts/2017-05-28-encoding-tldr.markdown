---
layout: post
date:   2017-05-28
comments: true
title: "Encoging tl;dr"
---
Well, this is my own version of TLDR for an amazing post by [David C. Zentgraf](https://twitter.com/deceze). As a self-starter I always struggle to find a good source of information which would give me ample view on the subject and the post writtend by David revealed the whole world of encoding to me.

******

Every text is just a sequence of bytes. Period.
There are 128 symbols defined in ASCII table and out of 8 bits ASCII uses only 7.

Encoding is a process of converting one representation to another.

Unicode is a REALLY big table with 1 114 112 code points, but it is not encoding by itself, it is the standard.

UTF-16 and UTF-8 are variable-length encodings. It means that if character may be represented with 1 byte, then 1 byte only will be used, if character needs 3 bytes, then suprise suprise, 3 bytes will be used.

If your text is garbled there is only one reason for this - you are using wrong encoding!

In order to use encoding correctly, simply use one encoding everywhere for inrepretation.

If you need to work with different encodings use Unicode as the middle-man, converting from given encoding to Unicode and then from Unicode to anothe encoding. Correct me if I'm wrong, but roughly it is like working with different timezones - we always rely on UTC as a pivot. Actually there is a tool _iconv_ which perfectly handles encoding conversions.

UTF-8 is binary compatible with ASCII, in other words UTF-8 maps 1:1 to ASCII.

Speaking of PHP, every string is just a byte sequence, so PHP does not care/know where the character's byte sequence starts or ends. For instance `strlen('abc')` will return 3, and `strlen('абв')` will return 6. So in order to work with strings properly _mbstring_ extension and all appropriate _mb_*_ functions should be used.

The whole issue of PHP's (non-)support for Unicode is that it just doesn't care. (c) David

PHP source code should be UTF-8 encoded, or lets say that whatever encoding you are using it should be 128 characters compatible with ASCII. For instance, internally, JavaScript source code is treated as a sequence of UTF-16 code units, [ref](http://speakingjs.com/es5/ch24.html).





