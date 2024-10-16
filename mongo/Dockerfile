FROM mongo:5.0.0
ARG TARGETPLATFORM

RUN apt-get update && apt-get -y install cron curl less unzip vim

# AWS CLI installation commands
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
    curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip; fi
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
    curl https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip -o awscliv2.zip; fi

# AWS CLI installation
RUN	unzip awscliv2.zip && ./aws/install
RUN rm awscliv2.zip && rm -R /aws

WORKDIR /root

# Copy cron script 
COPY files/scripts/docker-entrypoint-cron.sh .

# Copy and run cron jobs
COPY files/cron/ /etc/cron.d/
RUN chmod 644 /etc/cron.d/*
RUN crontab /etc/cron.d/havok

# Copy the make_cdr script
COPY files/scripts/make_*.sh .

# Make copied scripts executable
RUN chmod +x *.sh

ENTRYPOINT [ "/root/docker-entrypoint-cron.sh" ]
CMD [ "mongod" ]
