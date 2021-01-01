
#https://fisco-bcos-documentation.readthedocs.io/zh_CN/latest/docs/installation.html

echo "----------------fisco-bcos-----------------------------"
sudo apt install -y openssl curl

cd ~ && mkdir -p fisco && cd fisco
## 下载脚本
curl -#LO https://github.com/FISCO-BCOS/FISCO-BCOS/releases/download/v2.7.1/build_chain.sh && chmod u+x build_chain.sh
#命令执行成功会输出All completed。如果执行出错，请检查nodes/build.log文件中的错误信息。
bash build_chain.sh -l 127.0.0.1:4 -p 30300,20200,8545

#启动所有节点
cd ~/fisco && bash nodes/127.0.0.1/start_all.sh
#检查进程是否启动,如果进程数不为4，则进程没有启动（一般是端口被占用导致的）
#ps -ef | grep -v grep | grep fisco-bcos

#配置及使用控制台
# sudo apt install -y default-jdk
sudo apt-get install openjdk-8-jdk -y
#Retry...
if [[ $? != 0 ]]; then
    # sudo apt install -y default-jdk
    sudo apt-get install openjdk-8-jdk -y
fi
cd ~/fisco && curl -#LO https://github.com/FISCO-BCOS/console/releases/download/v2.7.1/download_console.sh && bash download_console.sh

# 最新版本控制台使用如下命令拷贝配置文件
cp -n console/conf/config-example.toml console/conf/config.toml
cp -r nodes/127.0.0.1/sdk/* console/conf/
#启动并使用控制台
# cd ~/fisco/console && bash start.sh
cd ~/fisco/console && echo "exit" | bash start.sh

echo "cd ~/fisco && bash nodes/127.0.0.1/start_all.sh" >> ~/.bashrc
. ~/.bashrc