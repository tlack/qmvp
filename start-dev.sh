. ./config.sh
echo starting $APPNAME on $DEVHOST:$DEVPORT
q $APPNAME -l -p $DEVHOST:$DEVPORT 2>&1 | tee -a /tmp/q-$APPNAME-dev.log

