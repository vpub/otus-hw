# 1. Запретить всем пользователям, кроме группы admin логин в выходные (суббота и воскресенье), без учета праздников

# Добавляем пользователей и группы, задаем пароли, разрешаем заходить через ssh по паролю, рестартим сервис
useradd admin
usermod -aG admin admin
useradd test
echo "admin:admin" | chpasswd
echo "test:test" | chpasswd
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

# Устанавливаем epel репозиторий и из него pam_script
yum update -y
yum install epel-release -y
yum install pam_script -y

# Добавляем запись о необходимости проверки из скрипта при аутентификации по ssh
echo "auth  required  pam_script.so" >> /etc/pam.d/sshd

# Копируем скрипт проверки и делаем его исполняемым. Скрипт проверяет состоит ли пользователь в группе admin и какой сегодня день недели. Скрипт запрещает всем пользователям, кроме пользователей группы admin заходить по ssh в выходные (суббота и воскресенье), без учета праздников.
cp /vagrant/pam_script_ssh_auth.sh /etc/
chmod +x /etc/pam_script_ssh_auth.sh

# * дать конкретному пользователю права работать с докером и возможность рестартить докер сервис

# Устанавливаем docker
yum update -y
curl -fsSL https://get.docker.com/ | sh
systemctl start docker

# Добавляем пользователя dockerUser, назначаем ему группу docker и устанавилаем пароль
useradd dockerUser
usermod -aG docker dockerUser
echo "dockerUser:dockeruser" | chpasswd

# Копируем правило PolicyKit
cp /vagrant/01-systemd-docker-dockerUser.rules /etc/polkit-1/rules.d/