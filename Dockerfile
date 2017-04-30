FROM centos:centos7

MAINTAINER Tyrell Perera <tyrell.perera@gmail.com>

RUN python --version
RUN yum -y install python-devel

RUN curl -O https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py
RUN pip --version

RUN pip install awscli --upgrade
RUN aws --version

RUN rpm -Uvh https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-3.noarch.rpm
RUN yum -y install postgresql95

ADD backups-cron /etc/cron.d/backups-cron
ADD backups.sh /backups.sh

CMD ["/backups.sh"]
