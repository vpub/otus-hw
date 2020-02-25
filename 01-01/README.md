ДЗ со *: Ядро собрано из исходников<br><br>
1. Переходим в папку задачи 01-01<br>
2. Устанавливаем плагин vagrant для автоматического поднятия VirtualBox Guest Additions на гостевой системе<br>
	$ vagrant plugin install vagrant-vbguest<br>
3. Запускаем виртуальную машину<br>
	$ vagrant up<br>
4. Конектимся к виртуальной машине по ssh, проверяем версию ядра и запускаем скрипт компиляции и обновления ядра из исходников из shared folders:<br>
	$ vagrant ssh<br>
	$ uname -a<br>
	$ sudo bash /home/vagrant/synced/kernel-manual-update.sh<br>
5. Перезапускаем виртуальную машину<br>
	$ vagrant reload<br>
6. Конектимся к виртуальной машине по ssh и проверяем версию ядра:<br>
	$ vagrant ssh<br>
	$ uname -a<br>