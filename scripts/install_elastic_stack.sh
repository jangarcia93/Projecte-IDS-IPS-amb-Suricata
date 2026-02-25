#!/bin/bash

echo "Installing dependencies..."
sudo apt install apt-transport-https wget curl -y

echo "Adding Elastic GPG key..."
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elastic.gpg

echo "Adding Elastic repository..."
echo "deb [signed-by=/usr/share/keyrings/elastic.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list

echo "Updating repositories..."
sudo apt update

echo "Installing Elasticsearch..."
sudo apt install elasticsearch -y

echo "Configuring Elasticsearch for local lab..."
sudo sed -i 's/#network.host:.*/network.host: localhost/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#http.port:.*/http.port: 9200/' /etc/elasticsearch/elasticsearch.yml

echo "Setting heap memory to 512MB..."
echo "-Xms512m" | sudo tee /etc/elasticsearch/jvm.options.d/heap.options
echo "-Xmx512m" | sudo tee -a /etc/elasticsearch/jvm.options.d/heap.options

sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch

echo "Installing Kibana..."
sudo apt install kibana -y

sudo sed -i 's/#server.host:.*/server.host: "0.0.0.0"/' /etc/kibana/kibana.yml

sudo systemctl enable kibana
sudo systemctl start kibana

echo "Installing Filebeat..."
sudo apt install filebeat -y

echo "Enabling Suricata module in Filebeat..."
sudo filebeat modules enable suricata

sudo systemctl enable filebeat
sudo systemctl start filebeat

echo "Elastic Stack installation completed."