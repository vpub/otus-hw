Почта: SMTP, IMAP, POP3

Домашнее задание
Установка почтового сервера
Цель: В результате выполнения ДЗ студент установит почтовый сервер.
1. Установить в виртуалке postfix+dovecot для приёма почты на виртуальный домен любым обсужденным на семинаре способом
2. Отправить почту телнетом с хоста на виртуалку
3. Принять почту на хост почтовым клиентом

Результат
1. Полученное письмо со всеми заголовками
2. Конфиги postfix и dovecot

Всё это сложить в git, ссылку прислать в "чат с преподавателем"

======[Результат-начало]======
1. Полученное письмо с заголовками: message01.png, message02.png

2. Конфиги postfix в папке postfix. Конфиги dovecot в папке dovecot.
======[Результат-окончание]======


======[Ход работы]======
1. Запускаем виртуальную машину (файл Vagrantfile)
2. Подключаем репозиторий epel
3. Обновляем систему
4. Устанавливаем postfix
5. Правим в конфиге (/etc/postfix/main.cf):
myhostname = virtual.domain.tld
mydomain = domain.tld
inet_interfaces = all
inet_protocols = all
mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain
home_mailbox = Maildir/
6. Запускаем (enable/start) postfix
7. Создаем (useradd/passwd) тестового пользователя
8. Устанавливаем dovecot
9. Правим в конфиге (/etc/dovecot/dovecot.conf):
protocols = imap pop3 lmtp
10. Правим в конфиге (/etc/dovecot/conf.d/10-mail.conf):
mail_location = maildir:~/Maildir
11. Правим в конфиге (/etc/dovecot/conf.d/10-auth.conf):
disable_plaintext_auth = yes
auth_mechanisms = plain login
12. Правим в конфиге (/etc/dovecot/conf.d/10-master.conf):
service dict {
  unix_listener dict {
    user = postfix
    group = postfix
  }
}
13. Запускаем (enable/start) dovecot
14. Устанавливаем squirrelmail
15. Настраиваем конфиг через скрипт (/usr/share/squirrelmail/config/conf.pl).
- Domain : domain.tld
- Sendmail or SMTP : SMTP 
16. Создаем виртуальный хост Squirrelmail в Apache (/etc/httpd/conf/httpd.conf):
Alias /webmail /usr/share/squirrelmail
<Directory /usr/share/squirrelmail>
 Options Indexes FollowSymLinks 
 RewriteEngine On
 AllowOverride All
 DirectoryIndex index.php
 Order allow,deny
 Allow from all
</Directory>
17. Создаем разрешения в Selinux: 
setsebool -P httpd_can_network_connect=1
18. Запускаем (enable/start) Apache
19. Отправляем письмо с хоста через telnet:

$ telnet 192.168.10.5 25
Trying 192.168.10.5...
Connected to 192.168.10.5.
Escape character is '^]'.
220 virtual.domain.tld ESMTP Postfix
EHLO virtual.domain.tld
250-virtual.domain.tld
250-PIPELINING
250-SIZE 10240000
250-VRFY
250-ETRN
250-ENHANCEDSTATUSCODES
250-8BITMIME
250 DSN
mail from: <test@test.com>
250 2.1.0 Ok
rcpt to: <test@domain.tld>
250 2.1.5 Ok
data
354 End data with <CR><LF>.<CR><LF>
From: test <test@test.com>
To: test <test@domain.tld>
Subject: test
Content-Type: text/plain

test test tetst
.
250 2.0.0 Ok: queued as 95D6D649E7
quit
221 2.0.0 Bye
Connection closed by foreign host.
20. Подключаемся с хоста к вебинтерфейсу почты тестовым пользователем созданным ранее и проверяем полученную почту:
http://192.168.10.5/webmail/