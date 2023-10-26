# HashiCorp Consul

Deploying and configuring a [Consul Enterprise](https://www.hashicorp.com/products/consul) cluster on an existing Kubernetes cluster.

Consul has many integrations with Kubernetes. You can deploy Consul to Kubernetes using the Helm chart or Consul K8s CLI.  As part of the GitOps workflow we are deploying Consul via HELM.

## Service Discovery
Service sync to enable Kubernetes and non-Kubernetes services to communicate: Consul can sync Kubernetes services with its own service registry. This service sync allows Kubernetes services to use Kubernetes' native service discovery capabilities to discover and connect to external services registered in Consul, and for external services to use Consul service discovery to discover and connect to Kubernetes services.

### Authentication and Annotations
When using Helm, the init container handles the auth for you but I guess you have to have the annotations in there during initial deploy

### DNS

The RPT EKS cluster is using CoreDNS instead of KubeDNS so need to update the coredns ConfigMap in the kube-system namespace to include a forward definition for consul that points to the cluster IP of the Consul DNS service.  This is documented here:

https://developer.hashicorp.com/consul/docs/k8s/dns#coredns-configuration

## Consul Service Mesh
Consul can automatically inject the Consul Service Mesh sidecar into pods so that they can accept and establish encrypted and authorized network connections with mutual TLS. And because Consul Service Mesh can run anywhere, pods and external services can communicate with each other over a fully encrypted connection.

## Enterprise License

You need to create K8s secret to enable the Consul Enterprise License

```
kubectl create secret generic consul-license \
    --from-literal=license='license file contents here' \
    -n consul
```
