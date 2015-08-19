qmvp
====

Q Minimum Viable Product is a barebones boiler plate Q webserver that includes
templating, serving from html/, index files, and logging. If you are playing
around with a Q-based web site/service idea, this is a great place to start.

All of this is implemented in about 40 lines of code, with zero dependencies
other than Q itself. By contrast, this README is already twice that size.

This is mostly an extract from the code used to run http://q4a.co/

What is Q?
----------

Q is an insanely powerful programming language developed by 
(Kx Systems)[http://kx.com].

Configuration & Use
-------------------

Think of a name for your app. Be sure to make the name tacky or stupid.

Rename example.q to APPNAME.q.

Set APPNAME and host/port bind details in config.sh. Keep this file bare
minimum and don't use shell expressions - it is loaded by Q as well.

example.q/APPNAME.q
-------------------
This file is ordered such that definitions of globals comes first, then
low level functions, then mid-level functions that manipulate data,
and then the high level stuff that calls everything else, such as the
.z.ph (HTTP GET) handler. It's written this way so that you can start
from the top and read down, with full understanding of everything as you
go. 

This isn't a framework. Feel free to remove anything you don't need from
APPNAME.q. Hack at will.

A note on -l (logging mode)
---------------------------

I like using -l because I know I can be sloppy about my data and it will persist
to the next session. -l is the default in the start scripts provided here.

You should be aware of the way it works because it has a 
few odd caveats:

* For updates to be logged, they must be sent to the currently running server
  as so: ```0(upsert;`Table;row)```. Updates done at the console won't be logged.
* As you do work interactively, be sure to flush your changes to disk with \l.
	You can set this to occur automatically every 60 seconds with
	```minutely:{system"l"}```
* The log file is the name of your start script with .q replaced by .log. Keep
  this in mind as you change your script name.

I hope to write a more thorough version of this logging guide soon.

Templates
---------
.html files (served from .h.HOME) are interpreted and expressions within {{ and
}} are evaluated as Q. 

Timers
------
Define minutely[], hourly[], and daily[] - these are called automatically from our
.z.ts handler, which dispatches every 60 seconds.

Backups
-------
Backups of the entire environment are taken with daily[] and saved in
/tmp/APPNAME[WD].qdb. WD is the week day number, from 0 to 6. By using this as
part of the filename, we'll never overflow the disk, and you keep seven days of
backups too.

"Analytics"
-----------
A log of hits is stored in HITS. isbot=1b if the user agent (available as UA)
matches "*[Bb]ot*".  This is available to the running script as ISBOT as well.

About proxying
--------------
I tend to proxy my stuff through Nginx for safety and perceived static file serving
performance. An example config file can be found in nginx.conf.

Performance
-----------
"Seems OK?"

I haven't had the need to try improving the performance of this software. It
seems pretty quick to me.

start-prod.sh
-------------
Start the server (APPNAME.q) in production mode:
- binds to 127.0.0.1:8888 (edit config.sh to change)
- logging is on (-l)
- output tee'd to /tmp/q-APPNAME.log
- reporting client-side exceptions is off (-e 0)
- if you are running this on a public IP and port 80, uncomment the first line
	of server.q so that .z.po is disabled and remote clients can't connect and wreak
	havoc

start-dev.sh
------------
Start the server (APPNAME.q) in development mode:
- binds to 127.0.0.1:8889 (edit config.sh to change)
- logging is on (-l)
- output tee'd to /tmp/q-APPNAME-dev.log
- reporting client-side exceptions is ON (-e 1). This will halt your REPL on
	error, good for debugging.

Starting at system boot
-----------------------

This seems to work in `/etc/rc.local`:

```
cd /home/APPNAME/app; 
nohup sh start-prod.sh 2>&1&
echo $! > /var/run/q-APPNAME-prod.pid
```


