FROM centos/systemd

RUN yum install -y https://repo.saltstack.com/yum/redhat/salt-repo-latest.el7.noarch.rpm 
RUN yum update -y
RUN yum install -y salt-minion

RUN systemctl enable salt-minion

CMD ["/usr/sbin/init"]
