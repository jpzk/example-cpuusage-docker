# README

Requirements: Linux host with git and docker

The solution is based on two components running in the same Ubuntu 14.04 container (can be distributed with small effort) ([Webservice in Finatra](https://github.com/jpzk/example-cpuusage-api) and a [Spark driver](https://github.com/jpzk/example-cpuusage-spark) which is running in client mode. The driver aggregates the previous hour, and writes the results into the file system (for a distributed approach of Spark, the CSV files need to be written to HDFS). The following setup works on a [DigitalOcean](http://www.digitalocean.com) instance: 8GB, 4CPU, 80GB, 5TB. 

## Installation

<pre>
  git clone https://github.com/jpzk/example-cpuusage-docker
  cd example-cpuusage-docker

  docker build -t cpuusage .
  docker run -i --name cpuusagec -p 80:8888 -p 81:9990 -t cpuusage "/bin/bash"
</pre>

The API endpoint is served on container port 8888 and on the host system it is 80.
The API endpoint is served on container port 9990 and on the host system it is 81.

## Under the hood

The API endpoint service writes CSV files to /var/data/. The hourly cron job executing (can also use an external Spark cluster, if the CSV data is stored in HDFS by the api): /opt/spark/bin/spark-submit --master local --deploy-mode client --class Main /example-cpuusage-spark/target/scala-2.10/cpuapi-spark.jar. The spark driver program writes the JSON output to /var/data/agg.

## Usage

Now we only need to start the finatra service by

<pre>
java -jar /example-cpuusage-api/cpuapi-api.jar &
</pre>

Use the client in example-cpuusage-api/client/generator.py to send requests to API which runs on port 80.

## Twitter Finatra Web admin

![admin](http://i.imgur.com/2LmNVss.png)

