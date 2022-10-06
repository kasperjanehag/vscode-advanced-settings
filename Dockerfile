FROM cimg/python:3.7
USER root

# Install system dependencies #################################################

RUN apt-get update
RUN apt-get install -y \
    build-essential \
    zlib1g-dev \
    libffi-dev \
    libpq-dev \
    software-properties-common \
    ca-certificates \
    gnupg2 \
    openjdk-8-jdk \
    scala \
    curl \
    autoconf \
    automake \
    libtool \
    git \
    curl \
    rsync \
    lsof \
    jq \
    pandoc \
    zip \
    unzip \
    tree \
    wait-for-it \
    wget \
    vim

RUN apt-get clean
RUN update-ca-certificates --fresh

# Install spark ###############################################################

ENV AWS_JAVA_SDK_VERSION="1.8.9"
ENV HADOOP_AWS_VERSION="3.2.2"
ENV HADOOP_VERSION="3.2"
ENV SCALA_VERSION="2.12"
ENV SPARK_EXCEL_VERSION="0.12.2"
ENV SPARK_VERSION="3.2.2"
ENV SPARK_VERSION_NO_PATCH="3.2"
ENV SPARK_HOME="/opt/spark"

WORKDIR /tmp
RUN curl -LO https://downloads.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
RUN tar xvf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
RUN mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /opt/spark

RUN wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk/${AWS_JAVA_SDK_VERSION}/aws-java-sdk-${AWS_JAVA_SDK_VERSION}.jar \
-qO ${SPARK_HOME}/jars/aws-java-sdk-bundle-${AWS_JAVA_SDK_VERSION}.jar

RUN wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_AWS_VERSION}/hadoop-aws-${HADOOP_AWS_VERSION}.jar \
-qO ${SPARK_HOME}/jars/hadoop-aws-${HADOOP_AWS_VERSION}.jar

RUN wget https://repo1.maven.org/maven2/com/crealytics/spark-excel_${SCALA_VERSION}/${SPARK_EXCEL_VERSION}/spark-excel_${SCALA_VERSION}-${SPARK_EXCEL_VERSION}.jar \
-qO ${SPARK_HOME}/jars/spark-excel_${SCALA_VERSION}-${SPARK_EXCEL_VERSION}.jar

WORKDIR /home/circleci/project

# Install python requirements #################################################

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .