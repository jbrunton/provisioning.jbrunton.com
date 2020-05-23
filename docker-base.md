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
    sudo chown -r deployer .ssh/

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

### Install docker-compose

Following the Linux steps here from https://docs.docker.com/compose/install/:

    sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

Check installation:

    docker-compose --version
