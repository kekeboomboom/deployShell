# deployShell

本项目提供docker项目的离线部署脚本案例。

## shellDeploy.sh

1. 判断是否安装docker，如果没有安装则安装docker，使用docker离线安装包进行安装（docker-install 文件夹）。如果安装了则检查版本，如果版本老则退出程序。

2. 镜像加载（docker save备份镜像，docker load加载备份的镜像）
3. 容器启动

## mysql.tar, yourApplication.tar,minio.tar

mysql.tar, yourApplication.tar, minio.tar 是备份的镜像文件，可以通过docker load -i mysql.tar 和 docker load -i yourApplication.tar 加载镜像。
docker save -o yourApplication.tar yourApplication:1.0.0 保存镜像到文件中。

## docker-install

docker-install directory is docker offline install package. And docker version is 24.0.2.

[docker doc install from a package](https://docs.docker.com/engine/install/ubuntu/#install-from-a-package)



## minioDeploy.sh

项目中用到了MinIO，并且部署的时候需要对MinIO做一些初始化的配置。比如create access key and secret key, create bucket, webhook event。在shellDeploy.sh初次启动MinIO时引入此脚本，即可完成初始化。

## docker-compose.yml

根据情况自行修改吧
