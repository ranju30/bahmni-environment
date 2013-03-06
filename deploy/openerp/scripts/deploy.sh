rm -rf /tmp/openerp-modules
git clone https://github.com/Bhamni/openerp-modules.git /tmp
OPENERP_ROOT=`cat $1.properties | grep openerp_deploy_root | cut -f2 -d"="`
cp -r /tmp/openerp-modules/* $OPENERP_ROOT