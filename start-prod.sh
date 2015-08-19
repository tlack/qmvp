. ./config.sh
echo starting $APPNAME on $PRODHOST:$PRODPORT
q $APPNAME -l -p $PRODHOST:$PRODPORT 2>&1 | tee -a /tmp/q-$APPNAME.log

