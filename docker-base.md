### Create the Droplet

Following https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-18-04:

* Create a Droplet with monitoring enabled, and with SSH access (all keys).

### Create the user

    adduser deployer
    usermod -aG sudo deployer

* Use the password from LastPass (under 'DigitalOcean jbrunton.com deployer).

### Configure SSH

    su - deployer
    sudo cp -r /root/.ssh ~/.ssh
    sudo chown -R deployer .ssh/

* At this point you can sign out as `root` and sign in as `deployer`.

TODO: I think I use a different SSH key for the github deployer. Need to add that.

### Install and configure docker

Following https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04:

    sudo apt update

    sudo apt install apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
    
    sudo apt update

    apt-cache policy docker-ce
    sudo apt install docker-ce

Check docker status:

    sudo systemctl status docker

Run docker without sudo:

    sudo usermod -aG docker ${USER}
    su - ${USER}

Per [this issue](https://github.com/docker/compose/issues/6678), install haveged:

    sudo apt-get install haveged

### Install docker-compose

Following the Linux steps here from https://docs.docker.com/compose/install/:

    sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

Check installation:

    docker-compose --version

### Prometheus node exporter

Following https://www.digitalocean.com/community/tutorials/how-to-install-prometheus-on-ubuntu-16-04:

    sudo useradd --no-create-home --shell /bin/false node_exporter
    
    curl -LO https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz
    tar xvf node_exporter-0.18.1.linux-amd64.tar.gz
    
    sudo cp node_exporter-0.18.1.linux-amd64/node_exporter  /usr/local/bin
    
    rm -rf node_exporter-0.18.1.linux-amd64.tar.gz node_exporter-0.18.1.linux-amd64

Configure:

    sudo nano /etc/systemd/system/node_exporter.service

Add the following:

    [Unit]
    Description=Node Exporter
    Wants=network-online.target
    After=network-online.target

    [Service]
    User=node_exporter
    Group=node_exporter
    Type=simple
    ExecStart=/usr/local/bin/node_exporter

    [Install]
    WantedBy=multi-user.target

Run the service:

    sudo systemctl daemon-reload
    sudo systemctl start node_exporter
    sudo systemctl enable node_exporter
    sudo systemctl status node_exporter
