# Source https://github.com/travisjeffery/terraform-provider-kafka/blob/master/README.md
# Provider source: https://registry.terraform.io/providers/Mongey/kafka/latest
terraform {
  required_providers {
    kafka = {
      source = "Mongey/kafka"
    }
  }
}

# ACL = Contrôle d'accès en Kafka
# Controle les opéaration sur un topic, consumer, cluster.
# First grant ourself admin permissions, then add ACL for topic.
resource "kafka_acl" "test" {
  resource_name       = "syslog" # Topic name
  resource_type       = "Topic" # Type of resource
  acl_principal       = "User:Alice" # User is used in sasl else if not use sasl should create user.
  acl_host            = "*"
  acl_operation       = "Write"
  acl_permission_type = "Deny"

  depends_on = []
}


provider "kafka" {
  bootstrap_servers = ["localhost:9092"]
  tls_enabled       = false
  skip_tls_verify  = true
}

resource "kafka_topic" "syslog" {
  name               = "syslog"
  replication_factor = 1
  partitions         = 4

  config = {
    "segment.ms"   = "4000"
    "retention.ms" = "86400000"
  }
}

# Configurer le débit afin de controller la consomation et la production des donnée pour un client.
# Empêche un client d’utiliser trop de bande passante, améliorant la stabilité et l'équilibre du cluster Kafka.
# Pour empêcher un client (d'utiliser trop de bande de passante) de consommer ou de produire des données à un débit supérieur à celui spécifié.
# Garantir une répartition équitable des ressources Kafka entre plusieurs clients

# Entity_name: c'est l'ID du client kafka. Celui-la il est configurer pendant la configuration du consumer/producer props.put("client.id", "client1");
# Entity_type: c'est le type de l'entité. Il peut être client-id ou user-principal. Pour les clients SASL/SSL, utilisez user-principal.
# Sinon kafka génére un ID client automatiquement.
# Sinon on peut le trouver dans les logs de kafka. Sinon dans une interface de monitoring comme AKHQ, Conduktor.
resource "kafka_quota" "quota1" {
  entity_name = "client1"
  entity_type = "client-id" # change client-id to user-principal for SASL/SSL
  config = {
    "consumer_byte_rate" = "4000000" # Limite de consommation (4 Mo/s)
    "producer_byte_rate" = "3500000" # Limite de production (3,5 Mo/s)
  }
}