FROM local/c7-systemd

# update system, install salt-master and set hostname to 'salt'
RUN yum install -y https://repo.saltstack.com/yum/redhat/salt-repo-latest.el7.noarch.rpm 
RUN yum update -y
RUN yum install -y salt-master

# auto accept all minions
RUN sed -i 's/#auto_accept: False/auto_accept: True/' /etc/salt/master

# start salt-master service
RUN systemctl enable salt-master

# expose ports
EXPOSE 4505 4506

CMD ["/usr/sbin/init"]
