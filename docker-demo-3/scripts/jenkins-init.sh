#!/bin/bash

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# volume setup
vgchange -ay

DEVICE_FS=`blkid -o value -s TYPE ${DEVICE}`
if [ "`echo -n $DEVICE_FS`" == "" ] ; then 
  # wait for the device to be attached
  DEVICENAME=`echo "${DEVICE}" | awk -F '/' '{print $3}'`
  DEVICEEXISTS=''
  while [[ -z $DEVICEEXISTS ]]; do
    echo "checking $DEVICENAME"
    DEVICEEXISTS=`lsblk |grep "$DEVICENAME" |wc -l`
    if [[ $DEVICEEXISTS != "1" ]]; then
      sleep 15
    fi
  done
  pvcreate ${DEVICE}
  vgcreate data ${DEVICE}
  lvcreate --name volume1 -l 100%FREE data
  mkfs.ext4 /dev/data/volume1
fi

echo "fstab and mount volume"
mkdir -p /var/lib/jenkins
echo '/dev/data/volume1 /var/lib/jenkins ext4 defaults 0 0' >> /etc/fstab
mount /var/lib/jenkins

echo "install default-jre (needed for ubuntu 18.04)"
apt-get install -y default-jre

echo "install jenkins and docker"
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
echo "deb http://pkg.jenkins.io/debian-stable binary/" >> /etc/apt/sources.list

apt-get update
apt-get install -y jenkins=${JENKINS_VERSION} unzip docker.io

echo "enable docker and add perms"
usermod -G docker jenkins
systemctl enable docker
echo "restart jenkins and docker"
service docker start
service jenkins restart

echo "install pip"

wget -q https://bootstrap.pypa.io/get-pip.py
python get-pip.py
python3 get-pip.py
rm -f get-pip.py

echo  "install awscli"
pip install awscli

echo "install terraform"
TERRAFORM_VERSION="0.12.29"
wget -q https://releases.hashicorp.com/terraform/$${TERRAFORM_VERSION}/terraform_$${TERRAFORM_VERSION}_linux_amd64.zip \
&& unzip -o terraform_$${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin \
&& rm terraform_$${TERRAFORM_VERSION}_linux_amd64.zip

echo "clean up"
apt-get clean
rm -rf terraform_$${TERRAFORM_VERSION}_linux_amd64.zip
