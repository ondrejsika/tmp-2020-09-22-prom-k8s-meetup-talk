# ondrejsika-k8s-prom

## Setup

Clone repo

```
git clone git@github.com:ondrejsika/ondrejsika-k8s-prom.git
cd ondrejsika-k8s-prom
```

Setup helm, longhorn, consul, ingress

```
make helm
make longhorn
make consul
make ingress
```

Create CRDs

```
make crd
```

Install Prometheus

```
make prom
```
