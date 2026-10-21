# Building palladio 

## Preparation
1. Copy java 21 to the _bhost_ machine
2. Login to the _bhost_ machine
3. Extract the java JDK to /mnt/ide/java as jdk-21.0.5+11
#4. IAdapt _/mnt/ide/palladio_dev/env.fish_ to point to the Java 21 JDK
4. Update palladio_dev
```
cd /mnt/ide/palladio_dev
git config --global --add safe.directory /mnt/ide/palladio_dev
sudo chgrp -R simexpeaoptimize .
sudo chmod -R g+w .
git pull
```
5. execute setup script
```
cd
/local/repository/setup-build-development.sh
```

## Build Palladio
1. login to the _bhost_ machine
```
cd ~/develop/palladio/simexp-ea/Palladio-Analyzer-SimExp
source /mnt/ide/palladio_dev/env.fish
mvn clean verify
```

## Deploy container
1. Build image
```
cd ~/develop/kubernetes/Simexp-Kubernetes-Worker
./image_build.sh
./image_push.sh --host node-0
```



