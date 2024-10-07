# create initial config
talosctl gen secrets -o secrets.yaml
talosctl gen config --with-secrets secrets.yaml mortis https://192.168.2.250:6443

# add control planes to config / set config default
talosctl --talosconfig=./talosconfig config endpoint 192.168.2.70 192.168.2.75 192.168.2.82
talosctl config merge ./talosconfig

# set up nodes
talosctl apply-config --insecure -n 192.168.2.70 --file nodes/cluster-1.yml
talosctl apply-config --insecure -n 192.168.2.75 --file nodes/cluster-2.yml
talosctl apply-config --insecure -n 192.168.2.83 --file nodes/cluster-3.yml
talosctl apply-config --insecure -n 192.168.2.33 --file nodes/cluster-4.yml
talosctl apply-config --insecure -n 192.168.2.85 --file nodes/cluster-5.yml
talosctl apply-config --insecure -n 192.168.2.63 --file nodes/cluster-6.yml
talosctl apply-config --insecure -n 192.168.2.29 --file nodes/cluster-7.yml
talosctl apply-config --insecure -n 192.168.2.82 --file nodes/cluster-8.yml

talosctl apply-config --insecure -n 192.168.2.57 --file nodes/storage-1.yml
talosctl apply-config --insecure -n 192.168.2.38 --file nodes/storage-1.yml
# 4c4c4544-0052-4310-8042-b4c04f4a4232

# update nodes
talosctl apply-config -n 192.168.2.70 --file nodes/cluster-1.yml
talosctl apply-config -n 192.168.2.75 --file nodes/cluster-2.yml
talosctl apply-config -n 192.168.2.83 --file nodes/cluster-3.yml
talosctl apply-config -n 192.168.2.33 --file nodes/cluster-4.yml
talosctl apply-config -n 192.168.2.85 --file nodes/cluster-5.yml
talosctl apply-config -n 192.168.2.63 --file nodes/cluster-6.yml
talosctl apply-config -n 192.168.2.29 --file nodes/cluster-7.yml
talosctl apply-config -n 192.168.2.82 --file nodes/cluster-8.yml

talosctl apply-config -n 192.168.2.38 --file nodes/storage-1.yml

# upgrade
## no gpu
talosctl upgrade --image factory.talos.dev/installer/613e1592b2da41ae5e265e8789429f22e121aab91cb4deb6bc3c0b6262961245:v1.7.7 --preserve -n cluster-8

## gpu
talosctl upgrade --image factory.talos.dev/installer/daa836c9267d89003d0314e32d120d49d5c7573f825958e8de13cca6b559b93f:v1.7.7 --preserve -n cluster-3

## gpu+zfs
talosctl upgrade --image factory.talos.dev/installer/c0714b30cf4fadeb71f019b1e8c9b0c191052dc49c16a9e3c91c9c643c2fc3e3:v1.8.0 --preserve -n storage-1


# Core Setup

## kubernetes bootstrap
talosctl bootstrap --nodes 192.168.2.70
kubectl apply -f https://raw.githubusercontent.com/alex1989hu/kubelet-serving-cert-approver/main/deploy/standalone-install.yaml
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
