# Provider block
provider "null" {}

# Grafana
resource "null_resource" "grafana" {
  provisioner "local-exec" {
    command = "docker run -d --name=grafana -p 3000:3000 grafana/grafana"
  }
}

# Prometheus
resource "null_resource" "prometheus" {
  provisioner "local-exec" {
    command = "docker run -d --name=prometheus -p 9090:9090 prom/prometheus"
  }
}

# ELK Stack (Elasticsearch, Logstash, Kibana)
resource "null_resource" "elk" {
  provisioner "local-exec" {
    command = "docker run -d --name=elasticsearch -p 9200:9200 -p 9300:9300 -e \"discovery.type=single-node\" docker.elastic.co/elasticsearch/elasticsearch:7.15.2 && \
               docker run -d --name=kibana --link elasticsearch:elasticsearch -p 5601:5601 docker.elastic.co/kibana/kibana:7.15.2 && \
               docker run -d --name=logstash --link elasticsearch:elasticsearch -p 5000:5000 docker.elastic.co/logstash/logstash:7.15.2"
  }
}

# AppDynamics
resource "null_resource" "appdynamics" {
  provisioner "local-exec" {
    command = "docker run -d --name=appdynamics appdynamics"
  }
}
