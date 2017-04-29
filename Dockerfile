FROM centos:centos7

MAINTAINER Tyrell Perera <tyrell.perera@gmail.com>

RUN python --version
RUN yum -y install python-devel

RUN curl -O https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py --user
RUN export PATH=~/.local/bin:$PATH
RUN ~/.local/bin/pip --version

RUN ~/.local/bin/pip install awscli --upgrade --user

RUN yum -y install postgresql

ADD backups-cron /etc/cron.d/backups-cron
RUN touch /var/log/cron.log
ADD backups.sh /backups.sh
ADD start.sh /start.sh

CMD ["/start.sh"]
