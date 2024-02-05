FROM alpine:3.18

LABEL maintainer="Luis Miguel Vicente Fuentes"
ARG DOCKER_TAG=59.0

# Salesforce Ant migration tool
ENV SF_ANT_VERSION=$DOCKER_TAG

# Apache Ant
ENV ANT_VERSION 1.10.14
ENV ANT_HOME /opt/ant

RUN  apk update \
  && apk upgrade \
  && apk add ca-certificates \
  && update-ca-certificates \
  && apk add --update coreutils && rm -rf /var/cache/apk/*   \
  && apk add --update openjdk11 tzdata curl unzip bash \
  && apk add --no-cache nss \
  && rm -rf /var/cache/apk/*

WORKDIR /tmp
# Apache Ant installation
RUN wget https://dlcdn.apache.org/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz \
    && mkdir ant-${ANT_VERSION} \
    && tar -zxvf apache-ant-${ANT_VERSION}-bin.tar.gz \
    && mv apache-ant-${ANT_VERSION} ${ANT_HOME} \
    && rm apache-ant-${ANT_VERSION}-bin.tar.gz \
    && rm -rf ant-${ANT_VERSION} \
    && rm -rf ${ANT_HOME}/manual \
    && unset ANT_VERSION
ENV PATH ${PATH}:${ANT_HOME}/bin

# Salesforce Ant migration tool installation
RUN mkdir salesforce-ant-${SF_ANT_VERSION} \
    && wget https://gs0.salesforce.com/dwnld/SfdcAnt/salesforce_ant_${SF_ANT_VERSION}.zip \
    && unzip -d salesforce-ant-${SF_ANT_VERSION} salesforce_ant_${SF_ANT_VERSION}.zip \
    && mv salesforce-ant-${SF_ANT_VERSION}/ant-salesforce.jar ${ANT_HOME}/lib \
    && rm salesforce_ant_${SF_ANT_VERSION}.zip \
    && rm -rf salesforce-ant-${SF_ANT_VERSION} \
    && unset SF_ANT_VERSION

WORKDIR /salesforce
