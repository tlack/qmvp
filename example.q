/.z.po:{}                                                  /uncomment if on public IP port 80
value 0N! ssr[";\n" sv read0 `:config.sh;"=";":"];
/load local config settings (\e 1 \c 10 999 etc)
\l config-local.q

if[not `HITS in tables[];0 (set;`HITS;0N!([]u:();ip:();at:();isbot:()))]      
PATHINFO:"";                                               /current page source file
QS:"";                                                     /current request query string
TITLE:"";                                                  /set by page being requested
UA:"";
ISBOT:0b;

r:{system"l ",APPNAME,".q"}                                /helper func: reload script (for interactive dev)
backup:{(fn:`$":",BKDIR,"/",APPNAME,string[.z.D mod 7],".qdb") set get `.;fn}
loghit:{0(insert;`HITS;(`$x;.z.a;.z.p;ISBOT))}

minutely:{}; hourly:{}; daily:backup;                      /set these for timers
.z.ts:{minutely[]; if[0=(`minute$.z.t) mod 60;hourly[]]; if[0=`hh$.z.T;daily[]]}
\t 60000

read:{0N!(`read;x);"c"$@[read1;`$.h.HOME,"/",x;""]}        /read file contents from html/ - errors return ""
source:{tmpl ssr[read x;"\n";" "]};                        /read a file and interp contents as template

tmpl:{[t] 
	indices:0,/ flip 0 2+t ss/:("{{";"}}");                  /indexes of template tags in string
	/evaluate each tag using @[] protected evaluation and the 'value' function:
	evaltag:{$["{"=x[0];$[11h~type res:@[value;0N!expr:2_-2_x;{"error: ",string[x]}];res;string res];x]};
	(raze/) evaltag @/:indices _ t}

serve:{
	/interp body first; header/footer needs values from it. only log hit on non-404
	body:tmpl[$[count c:read[x];[loghit[x]; c];read["404.html"]]]; 	
	.h.hy[`html; source["header.html"], body, source["footer.html"]]}

.z.ph:{0N!(`zph;x);                                        /our HTTP server handler
	`PATHINFO`QS set' 2#"?"vs x[0],"?"; QS::.h.uh QS;        /parse req URL and urldecode query string
	UA::x[1]`$"User-agent"; ISBOT::UA like"*[Bb]ot*";
	if[""~PATHINFO;PATHINFO::"index/"];                      /empty uri? use index/ 
	if["/"~last PATHINFO;PATHINFO::(-1 _ PATHINFO),".html"]; /ends with slash? use [name].md
	serve[PATHINFO]}


