---
layout: post
date:   2019-05-12
comments: true
title: "How to send request to UNIX socket"
---

This is one of those notes to myself, so I can remmber it better or find it later more easy.

I was recently strugging with permission problem for the unix socket, the mistake was quite silly - I did not turn permission bit on for the folder with socket file. And before I found the solution I tried to debug socket and I found that you can curl socket with 
```
curl --unix-socket /full/path/to/the/socket/socket.sock host_name
```

In my case the socket file was created by gunicorn and host name did not have any meaning, dunno why, you could put there blah and it worked just fine. So curl should return you the proper respons. But I was wondern how one could send request to the socket manually and I found this handy snippet


<script src="https://gist.github.com/nuxlli/7553996.js"></script>


Probably it works like this on Mac but it did not work for me on Ubuntu, in the comments section I found that you have to put extra `\r\n` sequence in the request. The whole `\r\n\r\n` sequence signify end of your request.   

So the final command for me is   

```
echo -e "GET / HTTP/1.0\r\n\r\n" | nc -U /var/www/patria/flask/pirata.sock
```

Pay attention to the `-e` argument it interprets all the escape characters in the string.

