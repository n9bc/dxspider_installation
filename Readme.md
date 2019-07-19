With this script you can install and configure in the few minutes the DxSpider Cluster

Installation Steps

1. Download script.

    wget https://gitlab.com/glaukos/dxspider_installation_script/-/archive/master/dxspider_installation_script-master.tar.gz
    
2. Must be run as root user.

3. Uncompress & change permissions

    tar xvfz dxspider_installation_script-master.tar.gz
    
    cd dxspider_installation_script-master/
    
    chmod +x install_dxspider.sh

4. Run script and follow the messages.

    ./install_dxspider.sh

Script has been tested on the following Operating Systems (Linux Distributions)

1. CentOS 7
2. Raspbian 8 (Jessie)
3. Raspbian 9 (stretch)
4. Debian GNU/Linux 9 (stretch)