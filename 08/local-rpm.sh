#!/bin/bash

# Устанавливаем необходимые пакеты
yum install -y \
  redhat-lsb-core \
  wget \
  rpmdevtoools \
  rpm-build \
  createrepo \
  yum-utils \
  lynx \
  gcc

# Скачиваем нужную src версию nginx
wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.16.1-1.el7.ngx.src.rpm
rpm -i nginx-1.16.1-1.el7.ngx.src.rpm

# Устанавливаем зависимости, необходимые nginx
yum-builddep /root/rpmbuild/SPECS/nginx.spec -y

# Скачиваем и распаковываем нужную версию openssl
wget https://www.openssl.org/source/openssl-1.1.1f.tar.gz
tar -xvf openssl-1.1.1f.tar.gz --directory /usr/lib

# Добавляем зависимость от скачанной версии openssl в конфигурацию nginx
sed '/--with-debug/ a --with-openssl=\/usr\/lib\/openssl-1.1.1f' /root/rpmbuild/SPECS/nginx.spec.tmp
mv /root/rpmbuild/SPECS/nginx.spec.tmp /root/rpmbuild/SPECS/nginx.spec

# Собираем новый пакет nginx с openssl зависимостью
rpmbuild --bb /root/rpmbuild/SPECS/nginx.spec

# Устанавливаем пакет
yum install -y /root/rpmbuild/RPMS/x86_64/nginx-1.16.1-1.el7.ngx.x86_64.rpm

systemctl enable nginx
systemctl start nginx

# create rpm repo
mkdir /usr/share/nginx/html/localrepo
cp /root/rpmbuild/RPMS/x86_64/nginx-1.16.1-1.el7.ngx.x86_64.rpm /usr/share/nginx/html/localrepo/
createrepo /usr/share/nginx/html/localrepo/

sed '/index  index.html index.htm;/ a autoindex on;' /etc/nginx/conf.d/default.conf > /etc/nginx/conf.d/default.conf.tmp
yes | mv /etc/nginx/conf.d/default.conf.tmp /etc/nginx/conf.d/default.conf
nginx -t
nginx -s reload

# add rpm repo to available list
cat > /etc/yum.repos.d/localrepo.repo <<EOF
[localrepo]
name=localrepo-repo
baseurl=http://localhost/localrepo
gpgcheck=0
enabled=1
EOF