FROM ubuntu

# Java

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y  software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean

RUN apt-get install -y -f git wget unzip 
RUN mkdir /var/data
RUN mkdir /var/data/agg

RUN wget https://dl.bintray.com/sbt/native-packages/sbt/0.13.11/sbt-0.13.11.zip
RUN unzip sbt-0.13.11
RUN mv sbt /opt/sbt
ENV PATH $PATH:/opt/sbt/bin

RUN wget http://d3kbcqa49mib13.cloudfront.net/spark-1.5.0-bin-hadoop2.6.tgz
RUN tar -xzvf spark-1.5.0-bin-hadoop2.6.tgz
RUN mv spark-1.5.0-bin-hadoop2.6 /opt/spark
ENV PATH $PATH:/opt/spark/bin

RUN git clone https://github.com/jpzk/example-cpuusage-spark.git
WORKDIR example-cpuusage-spark
RUN sbt assembly
RUN echo "* */1  * * *   root    /opt/spark/bin/spark-submit --deploy-mode client --master local --class Main /example-cpuusage-spark/target/scala-2.10/cpuapi-spark.jar" > /etc/crontab

RUN crontab /etc/crontab
RUN crontab -l
WORKDIR /
RUN git clone https://github.com/jpzk/example-cpuusage-api.git
WORKDIR /example-cpuusage-api
RUN sbt assembly
RUN mv /example-cpuusage-api/target/scala-2.10/cpuapi-api.jar .

EXPOSE 9990
EXPOSE 8888

WORKDIR /

