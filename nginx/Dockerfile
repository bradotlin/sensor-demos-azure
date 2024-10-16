FROM nginx:1.20.0
ARG TARGETPLATFORM

RUN apt-get update && apt-get install -y cron curl less netcat procps sudo unzip wget


WORKDIR /root

RUN curl https://secure.eicar.org/eicar.com -o eicarfile 
RUN chmod +x eicarfile

COPY sensor-demos-azure/nginx/files/scripts/40-execute-cron.sh /docker-entrypoint.d/
RUN chmod +x /docker-entrypoint.d/*

COPY sensor-demos-azure/nginx/files/scripts/make_*.sh .
RUN chmod +x *.sh

COPY sensor-demos-azure/nginx/files/cron/ /etc/cron.d/
RUN chmod 644 /etc/cron.d/*
RUN crontab /etc/cron.d/havok


COPY sensor-demos-azure/nginx/files/nginx/conf /etc/sensor-demos-azure/nginx/conf.d/
COPY sensor-demos-azure/nginx/files/www/ /www/html

COPY sensor-demos-azure/nginx/files/wallet/config.json .
COPY sensor-demos-azure/nginx/files/mongodb/mongo_secret.txt .
COPY sensor-demos-azure/nginx/files/userdata/UserData.txt .

COPY sensor-demos-azure/nginx/files/secrets/fake-hr.admin.dem .azure/accessToken.json

EXPOSE 8080
