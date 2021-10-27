cat zoo.cfg 
	#心跳，ms毫秒
	tickTime=2000
	# 初始通信时限，10个心跳，启动时，leader和follower通信容忍时间
	initLimit=10
	# 同步通信时限，5个心跳，正常运行时，leader和follower通信容忍时间
	syncLimit=5
	dataDir=/usr/local/zookeeper/data
	dataLogDir=/usr/local/zookeeper/log
	clientPort=2181
    #server.1服务器编号  IP  2888：follow服务器与leader服务器交换信息的端口，传递数据副本  
	# 3888：选择时，服务器间相互通信的端口，传递选举信息.如leader挂了，由此重新选择
	server.1=Hmaster:2888:3888
	server.2=Hslave1:2888:3888
	server.3=Hslave2:2888:3888
	4lw.commands.whitelist=*

cd /usr/local/zookeeper
bin/zkServer.sh start
bin/zkCli.sh
quit
bin/zkServer.sh stop
# bin/zkEnv.sh
# bin/zkServer-initialize.sh
# bin/zkSnapShotToolkit.sh
# bin/zkTxnLogToolkit.sh
