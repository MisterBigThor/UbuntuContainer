FROM ubuntu:focal

RUN apt-get update && apt-get install apt-utils -y --force-yes
RUN apt-get upgrade -y --force-yes

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -yq --no-install-recommends

RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata

RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y locales locales-all
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen

#=====Configure MPI=====
RUN apt-get install openmpi-bin -y
# Set ports with mca configurations
WORKDIR /home/pharmacelera/.openmpi
COPY  mca-params.conf .

RUN apt-get install sudo net-tools

#=====Configure users=====
# Create user bic ...
RUN useradd -ms /bin/bash bic

# ... and add user to sudoers, default password -> password
RUN usermod -aG sudo bic
RUN yes password | passwd bic

#=====Configure ssh===== 
# Install ssh server
RUN apt-get install --fix-missing
RUN apt-get install -y openssh-server

# Copy and set configuration files:
COPY ssh_configuration/sshd_config /etc/ssh/
WORKDIR /home/bic/.ssh

COPY ssh_configuration/id_1.pub . 
COPY ssh_configuration/id_1 .
COPY ssh_configuration/config .
COPY ssh_configuration/authorized_keys .

RUN chmod 700 /home/bic/.ssh
RUN chmod 600 authorized_keys
RUN chown -R bic:bic /home/bic/.ssh

EXPOSE 22
EXPOSE 2222

#=====User apps=====
RUN apt-get install nano

#=====Up script=====
WORKDIR /
COPY init.sh .
RUN chmod 777 init.sh

CMD ./init.sh && bash