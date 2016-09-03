Для вирішення даної задачі використав такі інструменти:
- Система віртуалізації - Virtualbox
- Система деплою віртуальних машин - Vagrant
- Операційна система для віртуальних машин - Centos6
- Система управління конфігураціями - Puppet
- Веб сервер - Tomcat
- База даних - MySQL
- Система моніторингу - Nagios Core

Проце деплою описаний у Vagrantfile:
https://github.com/rkosyk/puppet/blob/master/vagrant/Vagrantfile 
Vagrant деплоїть в циклі чотири віртуалки: puppet, webserver1, database1, nagios, конфігурація яких описана в масиві "nodes"

Після деплою кожної машини, Vagrant запускає на ній скрипт початкової ініціалізації bootstrap.sh: 
https://github.com/rkosyk/puppet/blob/master/vagrant/bootstrap.sh
який встановлює на кожну машину puppet agent, і на машину з назвою "puppet" - puppet server.
Підготовлений конфіг для puppet server і всі маніфести для віртуальних машин скрипт тяне з github з цього ж репозиторію:
https://github.com/rkosyk/puppet.git

Всі подальші дії по налаштуванню та інсталяці софта виконує puppet. В залежності від імені хоста (або початкових символів в імені) до нього застосовується відповідний puppet-маніфест: 
https://github.com/rkosyk/puppet/tree/master/manifests/nodes 
Вхідною точкою для цих маніфестів служить site.pp 
https://github.com/rkosyk/puppet/blob/master/manifests/site.pp 

Оскільки не вказано якихось додаткових умов, для webserver1 здійснюється тільки інсталяція tomcat, для database1 ставиться MySQL і створюється юзер "roman".
Для сервера моніторингу nagios встановлюється nagios core і підсовується йому вже підготовлений конфіг в папку /etc/nagios для моніторнига чотирьох нод puppet, webserver1, database1, nagios, на яких зконфігурований моніторинг трьох сервісів - CPU Load, RAM Usage, HDD Usage.

Процес розгортання цих чотирьох машин повністю автоматизований, запускається командою "vagrant up"

Рутовий пароль на машини "vagrant", кредли для нагіос: http://10.0.0.40/nagios, login: nagiosadmin, passwd: Asdfgh1
