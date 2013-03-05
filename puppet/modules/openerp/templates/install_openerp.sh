#!/bin/sh
# Modified script from Carlos E. Fonseca Zorrilla
yum -vy install wget unzip
rpm -ivh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
rpm -ivh http://yum.pgrpms.org/9.2/redhat/rhel-6-i386/pgdg-centos92-9.2-6.noarch.rpm

yum -vy install python-psycopg2 python-lxml PyXML python-setuptools libxslt-python pytz
yum -vy install python-matplotlib python-babel python-mako python-dateutil python-psycopg2
yum -vy install pychart pydot python-reportlab python-devel python-imaging python-vobject
yum -vy install hippo-canvas-python mx python-gdata python-ldap python-openid
yum -vy install python-werkzeug python-vatnumber pygtk2 glade3 pydot python-dateutil
yum -vy install python-matplotlib pygtk2 glade3 pydot python-dateutil python-matplotlib
yum -vy install python python-devel python-psutil python-docutils make
yum -vy install automake gcc gcc-c++ kernel-devel byacc flashplugin-nonfree poppler-utils pywebdav
yum -vy install postgresql92-libs postgresql92-server postgresql92

easy_install http://cheeseshop.python.org/packages/source/p/pyparsing/pyparsing-1.5.5.tar.gz

service postgresql-9.2 initdb
chkconfig postgresql-9.2 on
service postgresql-9.2 start
su - postgres -c "createuser  --superuser openerp"
cd /tmp
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
wget http://nightly.openerp.com/7.0/nightly/src/openerp-7.0-latest.tar.gz
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
service  openerp start