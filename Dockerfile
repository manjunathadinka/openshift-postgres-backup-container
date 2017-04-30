FROM centos:centos7

MAINTAINER Tyrell Perera <tyrell.perera@gmail.com>

# Install Python and dependencies
RUN python --version
RUN yum -y install python-devel

# Install pip
RUN curl -O https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py
RUN pip --version

# Install AWS CLI
RUN pip install awscli --upgrade
RUN aws --version

# Install pg_dump v9.5
RUN rpm -Uvh https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-3.noarch.rpm
RUN yum -y install postgresql95

# Install dev cron
RUN yum -y install mercurial && yum clean all
RUN pip install -e hg+https://bitbucket.org/dbenamy/devcron#egg=devcron

# Copy scripts and crontab
ADD backups-cron /etc/cron.d/backups-cron
ADD backups.sh /backups.sh

CMD ["devcron.py", "/etc/cron.d/backups-cron"]
