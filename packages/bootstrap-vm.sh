#createrepo is not present by default. Install it.
yum install createrepo

# disable yum cache
sh disable-yum-cache.sh

# disable other repos
sh disable-online-repo.sh

cp /packages/local.repo /etc/yum.repos.d/
createrepo --update /packages/localrepo
touch /etc/yum.repos.d/local.repo

yum install puppet git
# git clone https://github.com/Bhamni/bahmni-environment.git