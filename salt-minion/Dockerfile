FROM local/c7-systemd

# update system, install salt-minion and set hostname to 'salt'
RUN yum install -y https://repo.saltstack.com/yum/redhat/salt-repo-latest.el7.noarch.rpm 
RUN yum update -y
RUN yum install -y salt-minion

# start salt-minion service
RUN systemctl enable salt-minion

# expose ports
#EXPOSE 4505 4506

CMD ["/usr/sbin/init"]
