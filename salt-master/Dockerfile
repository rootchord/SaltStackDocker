FROM centos/systemd

RUN yum install -y https://repo.saltstack.com/yum/redhat/salt-repo-latest.el7.noarch.rpm 
RUN yum update -y
RUN yum install -y salt-master git

RUN sed -i 's/#auto_accept: False/auto_accept: True/' /etc/salt/master
RUN systemctl enable salt-master

RUN yum –y install openssh-server openssh-clients

RUN systemctl start sshd

RUN systemctl enable sshd

RUN systemctl status sshd

CMD ["/usr/sbin/init"]

EXPOSE 4505 4506 22
