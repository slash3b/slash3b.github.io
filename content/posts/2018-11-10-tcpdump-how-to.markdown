---
layout: post
date:   2018-11-10
comments: true
title: "tcpdump tiny cheat sheet"
---

tcpdump is such an amazing tool, even knowing just basic parameters you can do a lot.

- show list of available interfaces
```
    sudo tcpdump -D
```

- show packets with X argument. Use A in case you want to see only textual info and skip binary in hex
```
    sudo tcpdump -X
```

- track only specific port
```
    sudo tcpdump 'port 8888'
```

- do not resolve host names, lets you see IP addresses
```
    sudo tcpdump -nn
```

With all those arguments combined you can track connection to the program opened on local machine on port 8888 and see the following:

```
sudo tcpdump -i lo -nnA 'port 8000'

1  23:53:22.733261 IP 127.0.0.1.40968 > 127.0.0.1.8000: Flags [S], seq 3663077212, win 43690, options [mss 65495,sackOK,TS val 1062127408 ecr 0,nop,wscale 7], length 0
2      0x0000:  4500 003c 8b44 4000 4006 b175 7f00 0001  E..<.D@.@..u....
3      0x0010:  7f00 0001 a008 1f40 da56 1f5c 0000 0000  .......@.V.\....
4      0x0020:  a002 aaaa fe30 0000 0204 ffd7 0402 080a  .....0..........
5      0x0030:  3f4e c730 0000 0000 0103 0307            ?N.0........
6 23:53:22.733288 IP 127.0.0.1.8000 > 127.0.0.1.40968: Flags [S.], seq 2164662000, ack 3663077213, win 43690, options [mss 65495,sackOK,TS val 1062127408 ecr 1062127408,nop,wscale 7], length 0
7      0x0000:  4500 003c 0000 4000 4006 3cba 7f00 0001  E..<..@.@.<.....
8      0x0010:  7f00 0001 1f40 a008 8106 1ef0 da56 1f5d  .....@.......V.]
9      0x0020:  a012 aaaa fe30 0000 0204 ffd7 0402 080a  .....0..........
10     0x0030:  3f4e c730 3f4e c730 0103 0307            ?N.0?N.0....
11 23:53:22.733309 IP 127.0.0.1.40968 > 127.0.0.1.8000: Flags [.], ack 1, win 342, options [nop,nop,TS val 1062127408 ecr 1062127408], length 0
12     0x0000:  4500 0034 8b45 4000 4006 b17c 7f00 0001  E..4.E@.@..|....
13     0x0010:  7f00 0001 a008 1f40 da56 1f5d 8106 1ef1  .......@.V.]....
14     0x0020:  8010 0156 fe28 0000 0101 080a 3f4e c730  ...V.(......?N.0
15     0x0030:  3f4e c730                                ?N.0
16 23:53:22.733375 IP 127.0.0.1.40968 > 127.0.0.1.8000: Flags [P.], seq 1:79, ack 1, win 342, options [nop,nop,TS val 1062127408 ecr 1062127408], length 78
17     0x0000:  4500 0082 8b46 4000 4006 b12d 7f00 0001  E....F@.@..-....
18     0x0010:  7f00 0001 a008 1f40 da56 1f5d 8106 1ef1  .......@.V.]....
19     0x0020:  8018 0156 fe76 0000 0101 080a 3f4e c730  ...V.v......?N.0
20     0x0030:  3f4e c730 4745 5420 2f20 4854 5450 2f31  ?N.0GET./.HTTP/1
21     0x0040:  2e31 0d0a 486f 7374 3a20 3132 372e 302e  .1..Host:.127.0.
22     0x0050:  302e 313a 3830 3030 0d0a 5573 6572 2d41  0.1:8000..User-A
23     0x0060:  6765 6e74 3a20 6375 726c 2f37 2e35 392e  gent:.curl/7.59.
24     0x0070:  300d 0a41 6363 6570 743a 202a 2f2a 0d0a  0..Accept:.*/*..
25     0x0080:  0d0a                                     ..
26 23:53:22.733387 IP 127.0.0.1.8000 > 127.0.0.1.40968: Flags [.], ack 79, win 342, options [nop,nop,TS val 1062127408 ecr 1062127408], length 0
27     0x0000:  4500 0034 8ae9 4000 4006 b1d8 7f00 0001  E..4..@.@.......
28     0x0010:  7f00 0001 1f40 a008 8106 1ef1 da56 1fab  .....@.......V..
29     0x0020:  8010 0156 fe28 0000 0101 080a 3f4e c730  ...V.(......?N.0
30     0x0030:  3f4e c730                                ?N.0
31 23:53:22.733970 IP 127.0.0.1.8000 > 127.0.0.1.40968: Flags [P.], seq 1:166, ack 79, win 342, options [nop,nop,TS val 1062127408 ecr 1062127408], length 165
32     0x0000:  4500 00d9 8aea 4000 4006 b132 7f00 0001  E.....@.@..2....
33     0x0010:  7f00 0001 1f40 a008 8106 1ef1 da56 1fab  .....@.......V..
34     0x0020:  8018 0156 fecd 0000 0101 080a 3f4e c730  ...V........?N.0
35     0x0030:  3f4e c730 4854 5450 2f31 2e31 2032 3030  ?N.0HTTP/1.1.200
36     0x0040:  204f 4b0d 0a48 6f73 743a 2031 3237 2e30  .OK..Host:.127.0
37     0x0050:  2e30 2e31 3a38 3030 300d 0a44 6174 653a  .0.1:8000..Date:
38     0x0060:  2046 7269 2c20 3039 204e 6f76 2032 3031  .Fri,.09.Nov.201
39     0x0070:  3820 3231 3a35 333a 3232 202b 3030 3030  8.21:53:22.+0000
40     0x0080:  0d0a 436f 6e6e 6563 7469 6f6e 3a20 636c  ..Connection:.cl
41     0x0090:  6f73 650d 0a58 2d50 6f77 6572 6564 2d42  ose..X-Powered-B
42     0x00a0:  793a 2050 4850 2f37 2e32 2e31 310d 0a43  y:.PHP/7.2.11..C
43     0x00b0:  6f6e 7465 6e74 2d74 7970 653a 2074 6578  ontent-type:.tex
44     0x00c0:  742f 6874 6d6c 3b20 6368 6172 7365 743d  t/html;.charset=
45     0x00d0:  5554 462d 380d 0a0d 0a                   UTF-8....
46 23:53:22.734001 IP 127.0.0.1.40968 > 127.0.0.1.8000: Flags [.], ack 166, win 350, options [nop,nop,TS val 1062127408 ecr 1062127408], length 0
47     0x0000:  4500 0034 8b47 4000 4006 b17a 7f00 0001  E..4.G@.@..z....
48     0x0010:  7f00 0001 a008 1f40 da56 1fab 8106 1f96  .......@.V......
49     0x0020:  8010 015e fe28 0000 0101 080a 3f4e c730  ...^.(......?N.0
50     0x0030:  3f4e c730                                ?N.0
51 23:53:22.734035 IP 127.0.0.1.8000 > 127.0.0.1.40968: Flags [P.], seq 166:171, ack 79, win 342, options [nop,nop,TS val 1062127408 ecr 1062127408], length 5
52     0x0000:  4500 0039 8aeb 4000 4006 b1d1 7f00 0001  E..9..@.@.......
53     0x0010:  7f00 0001 1f40 a008 8106 1f96 da56 1fab  .....@.......V..
54     0x0020:  8018 0156 fe2d 0000 0101 080a 3f4e c730  ...V.-......?N.0
55     0x0030:  3f4e c730 7465 7374 21                   ?N.0test!
56 23:53:22.734049 IP 127.0.0.1.40968 > 127.0.0.1.8000: Flags [.], ack 171, win 350, options [nop,nop,TS val 1062127408 ecr 1062127408], length 0
57     0x0000:  4500 0034 8b48 4000 4006 b179 7f00 0001  E..4.H@.@..y....
58     0x0010:  7f00 0001 a008 1f40 da56 1fab 8106 1f9b  .......@.V......
59     0x0020:  8010 015e fe28 0000 0101 080a 3f4e c730  ...^.(......?N.0
60     0x0030:  3f4e c730                                ?N.0
61 23:53:22.734262 IP 127.0.0.1.8000 > 127.0.0.1.40968: Flags [F.], seq 171, ack 79, win 342, options [nop,nop,TS val 1062127409 ecr 1062127408], length 0
62     0x0000:  4500 0034 8aec 4000 4006 b1d5 7f00 0001  E..4..@.@.......
63     0x0010:  7f00 0001 1f40 a008 8106 1f9b da56 1fab  .....@.......V..
64     0x0020:  8011 0156 fe28 0000 0101 080a 3f4e c731  ...V.(......?N.1
65     0x0030:  3f4e c730                                ?N.0
66 23:53:22.734332 IP 127.0.0.1.40968 > 127.0.0.1.8000: Flags [F.], seq 79, ack 172, win 350, options [nop,nop,TS val 1062127409 ecr 1062127409], length 0
67     0x0000:  4500 0034 8b49 4000 4006 b178 7f00 0001  E..4.I@.@..x....
68     0x0010:  7f00 0001 a008 1f40 da56 1fab 8106 1f9c  .......@.V......
69     0x0020:  8011 015e fe28 0000 0101 080a 3f4e c731  ...^.(......?N.1
70     0x0030:  3f4e c731                                ?N.1
71 23:53:22.734362 IP 127.0.0.1.8000 > 127.0.0.1.40968: Flags [.], ack 80, win 342, options [nop,nop,TS val 1062127409 ecr 1062127409], length 0
72     0x0000:  4500 0034 8aed 4000 4006 b1d4 7f00 0001  E..4..@.@.......
73     0x0010:  7f00 0001 1f40 a008 8106 1f9c da56 1fac  .....@.......V..
74     0x0020:  8010 0156 fe28 0000 0101 080a 3f4e c731  ...V.(......?N.1
75     0x0030:  3f4e c731                                ?N.1
76 

```

Basically it shows you how TCP connection established and then on 26-th line we send request. And server answers with 'test!' on 55-th line. 

Enjoy, experiment with tcpdump!
