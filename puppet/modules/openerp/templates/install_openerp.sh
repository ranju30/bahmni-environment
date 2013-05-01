su - postgres -c "createuser  --superuser openerp"
cd $1
wget http://gdata-python-client.googlecode.com/files/gdata-2.0.17.zip
unzip gdata-2.0.17.zip
rm -rf gdata-2.0.17.zip
cd gdata*
python setup.py install
cd /usr/local
adduser openerp
DIR="/var/run/openerp /var/log/openerp"
for NAME in $DIR
do
if [ ! -d $NAME ]; then
   mkdir $NAME
   chown openerp.openerp $NAME
fi
done
rm -rf openerp*

wget http://nightly.openerp.com/7.0/nightly/src/openerp-7.0-20130301-002301.tar.gz
tar -zxvf openerp-7.0-latest.tar.gz  --transform 's!^[^/]\+\($\|/\)!openerp\1!'
cd openerp
python setup.py install
rm -rf /usr/local/bin/openerp-server
cp openerp-server /usr/local/bin
cp install/openerp-server.init /etc/init.d/openerp
cp install/openerp-server.conf /etc
chown openerp:openerp /etc/openerp-server.conf
chmod u+x /etc/init.d/openerp
chkconfig openerp on
service openerp start