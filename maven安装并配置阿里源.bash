# 安装maven必须要有java环境
# 官网：http://maven.apache.org/download.cgi
wget https://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
tar zxf apache-maven-3.6.3-bin.tar.gz -C /usr/local/
cd /usr/local/apache-maven-3.6.3/bin
echo PATH=$PATH:$PWD >> /etc/profile
source /etc/profile
mvn -v

# ----------------------------修改阿里源
vim /usr/local/apache-maven-3.6.3/conf/settings.xml
# 添加内容
# 本地缓存目录
<localRepository>/usr/local/apache-maven-3.6.3/repo</localRepository>
# <localRepository>E:\Work\Test\Java\repository</localRepository>
# --------------------maven 配置指南
# 打开 maven 配置文件(windows下，maven安装目录/conf/settings.xml)，
# 在<mirrors></mirrors>标签中，添加 mirror 子节点:
<mirror>
  <id>aliyunmaven</id>
  <mirrorOf>*</mirrorOf>
  <name>阿里云公共仓库</name>
  <url>https://maven.aliyun.com/repository/public</url>
</mirror>
# 如果想使用其它代理仓库，可在<repositories></repositories>节点中,加入对应的仓库地址。
# spring 代理仓为例：失败
<repository>
  <id>spring</id>
  <url>https://maven.aliyun.com/repository/spring</url>
  <releases>
    <enabled>true</enabled>
  </releases>
  <snapshots>
    <enabled>true</enabled>
  </snapshots>
</repository>
# 在pom.xml文件<denpendencies></denpendencies>节点中,加入要引用的文件信息：
<dependency>
  <groupId>[GROUP_ID]</groupId>
  <artifactId>[ARTIFACT_ID]</artifactId>
  <version>[VERSION]</version>
</dependency>
# 拉取：
mvn install

# 阿里
https://maven.aliyun.com/mvn/guide
