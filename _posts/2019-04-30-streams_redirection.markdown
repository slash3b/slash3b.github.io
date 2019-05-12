---
layout: post
date:   2019-04-30
comments: true
title: "Stream redirection tl;dr"
---

I love terminal, it is so simple and so reliable. When I'm in doubt, when I'm not sure the GUI I'm working with gives me correct representation I always turn to the terminal as an ultimate source of truth.  

Every process has *at least* three communication channels a.k.a. streams attached to it:
- STDIN. Standard input with file descriptor 0
- STDOUT. Standard output with file decriptor 1
- STDERR. Standard error with file descriptor 2

Usually when we work with streams we use file descriptor numbers. 

> Note: if you want to learn more or something is not clear, definetely check post by @thewizardlus,   
link in the Resources section.

Redirect STDOUT to some file:  
{% highlight bash %}
    cat /proc/sys/kernel/hostname 1> /tmp/test
{%endhighlight%}

More complex example with piping and STDOUT redirection:  
{% highlight bash %}mysql -uuser -ppass db_name | bzip > 1.sql.bz2{%endhighlight%}


Redirect STDERR to some file, note - wrong filename:  
{% highlight bash %}
    cat /proc/sys/kernel/hostname_ 2> /tmp/test
{%endhighlight%}


Redirect STDOUT and STDERR to the file with **&>** shortcut:   
{% highlight bash %}
    cat smth /proc/sys/kernel/hostname &> /tmp/test
{%endhighlight%}


Another way to redirect STDOUT to STDERR is to use **2>&1** in the end of line like this:   
{% highlight bash %}
    cat smth /proc/sys/kernel/hostname > /tmp/test 2>&1
{%endhighlight%}

... here your shell will first analyze what is going on and only then command will be launched. So shell does this analysys from left to right and first it sees redirection to the file, then it sees STDERR to STROUT redirection and does that, only then the whole line is "launched".  


Direct STDOUT to STDIN of another program:   
{% highlight bash %}
sed -n "${RANDOM}p" < /usr/share/dict/words
{% endhighlight %}
Pay attention that here we used **<** sign for redirection from file to the stream editor.  

















<hr>


Resources:  
[UNIX and Linux System Administration Handbook](https://www.amazon.com/gp/product/B075MK6LZ7) chapter 7: Scripting and shell

Excellent post about streams by Lucas F. Costa [@thewizardlucas](https://twitter.com/thewizardlucas) - 
[Your terminal is not a terminal: An Introduction to Streams](https://lucasfcosta.com/2019/04/07/streams-introduction.html)  

[pipes versus redirects](https://superuser.com/questions/277324/pipes-vs-redirects)
