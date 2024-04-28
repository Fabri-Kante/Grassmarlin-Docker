FROM openjdk:8u342-jdk-slim

RUN apt-get update -y
RUN apt-get install -y wget libpcap-dev openjfx  xdg-utils procps \
        libcanberra-gtk-module libcanberra-gtk3-module
RUN echo "wireshark-common wireshark-common/install-setuid boolean true" | debconf-set-selections && \
        DEBIAN_FRONTEND=noninteractive apt-get install -y wireshark

WORKDIR /root

RUN wget -P /app https://github.com/nsacyber/GRASSMARLIN/releases/download/v3.2.1/grassmarlin_3.2.1.ubuntu1604-1_amd64.deb
RUN dpkg -i /app/grassmarlin_3.2.1.ubuntu1604-1_amd64.deb
RUN apt-get update && apt-get install -y openssh-server xauth
RUN mkdir /var/run/sshd
RUN echo 'X11UseLocalhost no' >> /etc/ssh/sshd_config
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'root:1234' | chpasswd
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh
RUN touch /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys
ENV CLASSPATH=/usr/share/openfx/lib:${CLASSPATH}


# COPY ./GrassMarlin3.3/ /usr/share/GrassMarlin3.3/

# Puerto por defecto que GRASSMARLIN utiliza
#EXPOSE 8080
EXPOSE 22
#RUN which grassmarlin

# Comando para ejecutar la aplicación
#CMD CMD ["/usr/bin/grassmarlin"] 
CMD tail -f /dev/null
CMD ["/usr/sbin/sshd", "-D"]
