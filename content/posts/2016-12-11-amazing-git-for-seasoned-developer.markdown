---
layout: post
date:   2018-06-13
comments: true
title: Amazing GIT for seasoned developer.
---

At first, like so many others I didn't use git to full extent, the tool belt of `git add, git commit, git push, git pull` 
allowed me to survive through the day. At some point I realized that I need to enforce my GIT knowledge.

In short GIT has an insanely rich eco system of different tools designed to do only one thing but do it very good.
This is not a post but rather a set of things I would like to remember about GIT.

Do you know that there is a way to trace function or a piece of code?
In order to see code snippet evolution you have to use this command, specifying start line(2) and end line(20):
{% highlight bash %}
git log -L  2,20:src/AdminBundle/Controller/AccountController.php
{% endhighlight %}

If you want to trace fuction history you may use:
{% highlight bash %}
git log -L  :funcname:src/AdminBundle/Controller/AccountController.php
{% endhighlight %}
In my case this worked for class definition but not for methods within, the thing is that GIT doesn't know a thing about function declaration in the given language. GIT has a set of predefined regular expressions for some languages so we can fix this issue with this one-liner in your repo - `echo '*.php diff=php' >> .gitattributes`. Thus GIT will know PHP better, given line affects git diff command and diff output will be more correct.

There is also a slightly different approach to this - you can use so called "pickaxe" filter `-S`
{% highlight bash %}
git log -S function_name
{% endhighlight %}
It will show commits that contain addition or removal of the given function name. With this filter you can trace back all "evolution" of the function. Note that in case function has some generic name you may end up with ambiguous data.  

Another interesting command will display all commit names grouped and counted by contributors:
{% highlight bash %}
git shortlog --no-merges
{% endhighlight %}

Instead of writing n'th time about difference between HEAD~ and HEAD^, I will paste here [this](http://) awesome answer from stackoverflow with some additions:
{% highlight bash %}
HEAD^    : means the parent of HEAD
HEAD^^   : 2 commits older than HEAD
HEAD^2   : the second parent of HEAD, if HEAD was a merge, otherwise illegal

HEAD~    : the parent of HEAD
HEAD~~   : 2 commits older than HEAD
HEAD~6   : 6 commits older than HEAD

HEAD~3^2 : 3 commits older than HEAD and then grab the second parent of merge commit

HEAD@{2} : refers to the 3rd listing in the overview of git reflog
{% endhighlight %}
More info may be found in the [documentation](https://git-scm.com/book/en/v2/Git-Tools-Revision-Selection)

Imagine that for some reason you have to merge the same piece of code over and over again. In this case GIT can simplify your life a bit, you  should turn on `git rerere` which stands for reuse recorded resolution. Basically it would record khow you did merge and next time will do that for you.

You can always create an alias for some 'missing' commands like this:
`git config --global alias.unstage 'reset HEAD --'`
By the way, recent version of oh-my-zsh http://ohmyz.sh/ has 123 git aliases. 
For instance, here are some aliases for git log command, so please use oh-my-zsh, they are awesome!
{% highlight bash %}

gke='\gitk --all $(git log -g --pretty=%h)'
glg='git log --stat'
glgg='git log --graph'

{% endhighlight %}

There is also an interesting possibility to pack the whole repo into the binary file like this:
`git bundle create repo.bundle HEAD master`
and then clone it again with `git clone repo.bundle repo`

Missing the keys all the time? Autocorrect you typo with delay of 2sec with `git config --global help.autocorrect 20`

To tell git what files are binary you have to edit .gitattributes file and add e.g. `*.pbxproj binary`

With GIT hooks you can establish whatever policy you can dream of, just do remember that git hooks files can not be distributed on project clone, you have to store them in the repository in some folder and then copy to the .git folder with some makefile or anythig else.

I was always curious what are those signs that appear in the files in case of a conflict `<<<<<<<<`, `=========`, and `>>>>>>>>`. These are the conflict markers, and the code between `<<<<<<<<` and `=========` is what you have right now. The other half ending in `>>>>>>>>` is what came to you from the server or another branch.

`git branch --merged` shows all the branches that were merged, you can use `--no-merged` as well.

Lets turn to more adavanced stuff.
In short all commands in git can be divided in two groups:
 - the ones you use every day, e.g. `git add`, `git commit` and etc. are called 'porcelain'
 - other low-level commands like `git cat-file`, `git commit-tree` and etc. are called 'plumbing' commands

Lets have a look at some of plumbing commands.
First command is `hash-object`:
with `echo 'test content' | git hash-object -w --stdin` you'll get hash sum of the content you passed to the hash-object command. So the hash sum is d670460b4b4aece5915caf5c68d12f560a9fe3e4, first two letters are the name of subdirectory and the least files are the name of created file - .git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4.

By doing `git cat-file -p <blob>` you can get every recoded state of the file.

With `git cat-file -p master^{tree}` we get the tree which is pointed to by the latest commit. Git tree is essentially the snapshot which contains references to all blobs and sub-trees.
Basically all the magic goes through these commands - `git update-index` adds the files to the staging area and `git write-tree` creates the tree.

At last we should create commit object which contains all meta-information on commit.
`echo 'first commit' | git commit-tree <SHA-1 of the tree-object>` will do the trick.

One of the most intriguing topics - data recovery is almost always possible.
Suppose you did `git hard --reset <SHA-1>` for a few commits, and you want it back. 
The easiest way is to use `git reflog` to get the list of your recent actions or `git log -g` which gives you the more ample info.
Once you get lost commit SHA you can checkout it or create some 'recovery-branch' and that is it!

There is another powerfull command `git fsck --full` which checks git database for intergrity.

Do you have something to add ? Please comment below.

Links:

[git caret and tilde different](http://www.paulboxley.com/blog/2011/06/git-caret-and-tilde)
