FROM centos/systemd

RUN yum install -y https://repo.saltstack.com/yum/redhat/salt-repo-latest.el7.noarch.rpm 
RUN yum update -y
RUN yum install -y salt-master git

RUN sed -i 's/#auto_accept: False/auto_accept: True/' /etc/salt/master
RUN systemctl enable salt-master
RUN chown -R user /etc/salt /var/cache/salt /var/log/salt /var/run/salt

CMD ["/usr/sbin/init"]
