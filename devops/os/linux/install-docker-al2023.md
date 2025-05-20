# Install Docker on Amazon Linux 2023

```bash
sudo dnf update -y
# Install dnf plugin
sudo dnf -y install dnf-plugins-core
# Add CentOS repository
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
# Adjust release server version in the path as it will not match with Amazon Linux 2023
sudo sed -i 's/$releasever/9/g' /etc/yum.repos.d/docker-ce.repo
# Install as usual
sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Enable the docker service
sudo systemctl enable --now docker
```
