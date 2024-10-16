FROM nginx:1.20.0
ARG TARGETPLATFORM

RUN apt-get update && apt-get install -y cron curl less netcat procps sudo unzip wget
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
    curl https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb -o session-manager-plugin.deb; \
    curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip; fi
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
    curl https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_arm64/session-manager-plugin.deb -o session-manager-plugin.deb; \
    curl https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip -o awscliv2.zip; fi

RUN dpkg -i session-manager-plugin.deb
# AWS CLI installation
RUN	unzip awscliv2.zip && ./aws/install
RUN rm awscliv2.zip && rm -R /aws && rm session-manager-plugin.deb

WORKDIR /root

RUN curl https://secure.eicar.org/eicar.com -o eicarfile 
RUN chmod +x eicarfile

COPY sensor-demos-azure/sensor-demos-azure/nginx/files/scripts/40-execute-cron.sh /docker-entrypoint.d/
RUN chmod +x /docker-entrypoint.d/*

COPY sensor-demos-azure/nginx/files/scripts/make_*.sh .
RUN chmod +x *.sh

COPY sensor-demos-azure/nginx/files/cron/ /etc/cron.d/
RUN chmod 644 /etc/cron.d/*
RUN crontab /etc/cron.d/havok

RUN rm -R /usr/share/sensor-demos-azure/nginx/html/*
RUN rm /etc/sensor-demos-azure/nginx/conf.d/default.conf

COPY sensor-demos-azure/nginx/files/sensor-demos-azure/nginx/conf /etc/sensor-demos-azure/nginx/conf.d/
COPY sensor-demos-azure/nginx/files/www/ /www/html

COPY sensor-demos-azure/nginx/files/wallet/config.json .
COPY sensor-demos-azure/nginx/files/mongodb/mongo_secret.txt .
COPY sensor-demos-azure/nginx/files/userdata/UserData.txt .

COPY sensor-demos-azure/nginx/files/secrets/fake-hr.admin.dem .azure/accessToken.json

EXPOSE 8080
