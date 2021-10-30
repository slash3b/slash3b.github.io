---
layout: post
date:   2018-05-20
comments: true
title: 'How to sign your commit with GPG'
---

First step - creating the key itself.

Note that I'm using Fedora and for some rason I have to use `gpg2` though `gpg` is available also for some reason.  
Generate your key:  

`gpg2 --full-gen-key`  
First two questions - choose default answers, but for key expiration date it is up to you,  
I chose '0 = key does not expire' option.  

To view fingerprint for the newly created key use:  
`gpg2 --fingerprint <your@email.com>`  

You have to save your GPG public key on GitHub [here](https://github.com/settings/gpg/new), in order to do that you should export your public key first. It is fairly easy to do with `gpg2 --export --armor <your@email.com>`  

Next step - let git on your local machine know that you want to sign your commits. To do that you have to sign your commit with a secret key you have just generated. 
This command lists all keys for which you have both private and public keys `gpg2 --list-secret-keys --keyid-format LONG`  

```
gpg2 --list-secret-keys --keyid-format LONG
/Users/hubot/.gnupg/secring.gpg
------------------------------------
sec   4096R/i3AA5C34371567BD2 2016-03-10 [expires: 2017-03-10]
uid                          Hubot 
ssb   4096R/42B317FD4BA89E7A 2016-03-10
```

The id you need is in the 'sec' line, right after bits lenght - **i3AA5C34371567BD2**  

Run this command `git config --global user.signingkey i3AA5C34371567BD2` which tells git about your key.  Next time you want to sign your commit just run `git commit -S -m your commit message`.  

By default git does not show signed commits, so you have to run `git log --show-signature` in order to see commits with signature.   

When you do your first commit, Gnome allows you to store passphrase in password manager so next time you do not have to type it again!

### Resources:  
https://fedoraproject.org/wiki/Creating_GPG_Keys#


