FROM stackbrew/ubuntu:saucy
MAINTAINER b@heyomayeah.com

# ensure we are up to date
RUN apt-get update

# install runit
RUN apt-get install -y runit

# install openssh-server
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

# setup runit for sshd
ADD etc/sv/sshd/ /etc/sv/sshd/
RUN chown -R root:root /etc/sv/sshd
RUN mkdir /etc/sv/sshd/log/main
RUN chown syslog /etc/sv/sshd/log/main
RUN ln -s /etc/sv/sshd /etc/service/

# workaround pam issue related to SElinux in saucy
RUN sed -i -e 's/session    required     pam_loginuid\.so/#session    required     pam_loginuid\.so/' /etc/pam.d/sshd

# set a rly dumb default root password
RUN echo "root:passwerd" | chpasswd

CMD ["/usr/sbin/runsvdir-start"]
