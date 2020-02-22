ДЗ с **: В вашем образе нормально работают VirtualBox Shared Folders<br><br>
1. Переходим в папку задачи 01-02<br>
2. Устанавливаем плагин vagrant для автоматического поднятия VirtualBox Guest Additions на гостевой системе<br>
	$ vagrant plugin install vagrant-vbguest<br>
3. Отключаем стандартный каталог обмена по rsync в Vagrantfile и записываем свой.<br>
	config.vm.synced_folder ".", "/vagrant", disabled: true<br>
	config.vm.synced_folder ".", "/home/vagrant/synced"<br>
4. Запускаем виртуальную машину<br>
	vagrant up<br>
5. Конектимся к виртуальной машине по ssh и проверяем работу shared folders. Для этого создаем файлы в виртуальной машине в папке обмена и проверяем их появление на своей машине.
