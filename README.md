# Projecte IDS/IPS amb Suricata + Elastic Stack

## Descripció del Projecte

Aquest projecte consisteix en la implementació d’un sistema de detecció d’intrusions (IDS) utilitzant Suricata, integrat amb Elastic Stack (Elasticsearch + Kibana + Filebeat) per a la visualització i anàlisi d’esdeveniments de seguretat en temps real.

L’objectiu és simular un entorn real on es detectin atacs de xarxa, s’analitzin els logs generats i es visualitzin mitjançant un sistema SIEM.

---

## Objectius

- Implementar un IDS funcional amb Suricata
- Definir regles personalitzades de detecció
- Simular atacs reals (Nmap)
- Integrar els logs amb Elasticsearch
- Visualitzar alertes amb Kibana
- Analitzar esdeveniments de seguretat en temps real

---

## Arquitectura del Laboratori

### Màquines virtuals

| Sistema         | Funció                                | IP               |
|----------------|----------------------------------------|------------------|
| Kali Linux     | Atacant                               | 192.168.100.20   |
| Ubuntu Server  | IDS (Suricata + Elastic Stack)        | 192.168.100.10   |

### Xarxa

- Xarxa interna VirtualBox
- Rang: 192.168.100.0/24

---

## Instal·lació de Suricata

### Instal·lació

```bash
sudo apt update
sudo apt install suricata -y
```

### Verificació

```bash
suricata --version
```

### Execució manual

```bash
sudo suricata -c /etc/suricata/suricata.yaml -i enp0s3
```

---

## Configuració de Regles

### Instal·lació regles ET Open

```bash
sudo suricata-update
```

### Regla personalitzada creada

Fitxer: `/var/lib/suricata/rules/local.rules`

```bash
alert tcp any any -> $HOME_NET any (flags:S; msg:"SCAN TCP SYN detectat"; sid:1000001; rev:1;)
```

Aquesta regla detecta escaneigs SYN (utilitzats per Nmap).

---

## Simulació d’Atacs

### Escaneig complet amb Nmap

```bash
nmap -sS -T4 -p- 192.168.100.10
```

Resultat:
- Generació d’alertes SID 1000001
- Detectat correctament per Suricata

---

## Integració amb Elastic Stack

### Components instal·lats

- Elasticsearch
- Kibana
- Filebeat (mòdul Suricata)

---

## Configuració Elasticsearch

Configuració bàsica a `/etc/elasticsearch/elasticsearch.yml`:

```bash
network.host: localhost
http.port: 9200
```

Limitació manual de memòria heap:

Fitxer `/etc/elasticsearch/jvm.options.d/heap.options`:

```bash
-Xms512m
-Xmx512m
```

---

## Configuració Kibana

Fitxer `/etc/kibana/kibana.yml`:

```bash
server.port: 5601
server.host: "0.0.0.0"

elasticsearch.hosts: ["https://localhost:9200"]
elasticsearch.username: "kibana_system"
elasticsearch.password: "********"
elasticsearch.ssl.verificationMode: none
```

Accés via navegador:

```
http://localhost:5601
```

Usuari d'accés:
- elastic

---

## Configuració Filebeat

Activació mòdul Suricata:

```bash
sudo filebeat modules enable suricata
```

Configuració del mòdul:

Fitxer `/etc/filebeat/modules.d/suricata.yml`:

```bash
- module: suricata
  eve:
    enabled: true
    var.paths: ["/var/log/suricata/eve.json"]
```

Sortida cap a Elasticsearch:

Fitxer `/etc/filebeat/filebeat.yml`:

```bash
output.elasticsearch:
  hosts: ["https://localhost:9200"]
  username: "elastic"
  password: "********"
  ssl.verification_mode: none
```

---

## Visualització a Kibana

A Discover:

Filtre per alertes:

```bash
event.kind: alert
```

Filtre per regla personalitzada:

```bash
rule.id: 1000001
```

Resultat visualitzat:
- rule.name: SCAN TCP SYN detectat
- IP atacant
- Ports escanejats
- Timestamp dels atacs

---

## Estat Actual del Projecte

- IDS funcional amb Suricata  
- Regles ET Open carregades  
- Regla personalitzada implementada  
- Simulació d’atacs Nmap  
- Logs enviats a Elasticsearch  
- Visualització en Kibana  
- Alertes detectades correctament  

---

## Properes Millores

- Implementar detecció de força bruta SSH
- Crear més regles personalitzades
- Implementar mode IPS (bloqueig)
- Crear dashboard personalitzat a Kibana
- Desenvolupar pla de resposta a incidents

---

## Conclusions Parcials

El sistema IDS implementat detecta correctament escaneigs de ports mitjançant regles personalitzades.  
La integració amb Elastic Stack permet una anàlisi visual i estructurada dels esdeveniments de seguretat, aportant una visió clara del comportament de l’atacant.

Aquest entorn simula una arquitectura bàsica de SOC en laboratori.

---

## Tecnologies Utilitzades

- Suricata
- Elasticsearch
- Kibana
- Filebeat
- Kali Linux
- Ubuntu Server
- VirtualBox

---

## Autor

Projecte desenvolupat com a pràctica d’ASIX2 – Implementació d’un Sistema IDS/IPS.
