. ./config.sh
echo starting $APPNAME on $PRODPORT
q $APPNAME -l -p $PRODPORT 2>&1 | tee -a /tmp/q-$APPNAME.log

