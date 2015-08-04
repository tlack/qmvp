qmvp
====

Q Minimum Viable Product is a barebones boiler plate Q webserver that includes
templating, serving from html/, index files, and logging. If you are playing
around with a Q-based web site/service idea, this is a great place to start.

All of this is implemented in about 40 lines of code, with zero dependencies
other than Q itself. By contrast, this README is already twice that size.

This is mostly an extract from the code used to run http://q4a.co/

Config
------
Set APPNAME and port details in config.sh

Keep this file bare minimum and don't use shell expressions - it is loaded by Q
as well.

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


