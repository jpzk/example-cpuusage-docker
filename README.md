# README

Requirements:Linux host with git and docker

The solution is based on two components running on the same machine (can be distributed with small effort). The following works on a DigitalOcean instance: 8GB, 4CPU 80GB 5TB.

https://github.com/jpzk/example-cpuusage-docker
https://github.com/jpzk/example-cpuusage-api
https://github.com/jpzk/example-cpuusage-spark

* For the API endpoint Finatra is used.
* For aggregating the raw data hourly Spark is employed.

## Installation

git clone https://github.com/jpzk/example-cpuusage-docker
cd example-cpuusage-docker

docker build -t cpuusage .
docker run -i --name cpuusagec -p 80:8888 -p 81:9990 -t cpuusage "/bin/bash"

The API endpoint is served on container port 8888 and on the host system it is 80.
The API endpoint is served on container port 9990 and on the host system it is 81.

INFO: The API endpoint service writes CSV files to /var/data/. The hourly cron job executing (can also use an external Spark cluster, if the CSV data is stored in HDFS by the api): /opt/spark/bin/spark-submit --master local --deploy-mode client --class Main /example-cpuusage-spark/target/scala-2.10/cpuapi-spark.jar. The spark driver program writes the JSON output to /var/data/agg.

## Usage

Now we only need to start the finatra service by
java -jar /example-cpuusage-api/cpuapi-api.jar &

Use the client in example-cpuusage-api/client/generator.py to send requests to API which runs on port 80.


