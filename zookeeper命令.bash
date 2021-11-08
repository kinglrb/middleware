# zookeeper客户端命令行操作
1 基本语法
命令         	    功能描述
help	            #显示所有操作命令
ls path [watch]	    #查看当前znode中包含的内容
ls2 path [watch]	#查看当前节点数据(能看到更新次数等数据)
create	            #普通创建，-s含有序列，-e临时(重启或超时消失)
get path [watch]	#获得节点的值
set	                #设置节点的具体值
stat	            #查看节点状态
delete	            #删除节点
rmr	                #递归删除节点

2 基础操作
# 2.1 启动客户端
/opt/zookeeper-3.4.10/bin/zkCli.sh
# 2.2 显示所有操作命令
help
# 2.3 查看当前 znode 包含内容
ls /
# 2.4 查看当前节点详细数据
ls2 /
	[zookeeper]
	cZxid = 0x0
	ctime = Thu Jan 01 08:00:00 CST 1970
	mZxid = 0x0
	mtime = Thu Jan 01 08:00:00 CST 1970
	pZxid = 0x0
	cversion = -1
	dataVersion = 0
	aclVersion = 0
	ephemeralOwner = 0x0
	dataLength = 0
	numChildren = 1
# 2.5 创建节点
create /king "xyj"
	Created /king
create /king/huaguoshan "sunwukong"
	Created /king/huaguoshan
# 2.6 获取节点的值
get /king
	xyj
	cZxid = 0x100000003
	ctime = Wed Mar 20 19:15:22 CST 2021
	mZxid = 0x100000003
	mtime = Wed Aug 20 19:15:22 CST 2021
	pZxid = 0x100000004
	cversion = 1
	dataVersion = 0
	aclVersion = 0
	ephemeralOwner = 0x0
	dataLength = 7
	numChildren = 1

get /king/huaguosha
	sunwukong
	cZxid = 0x100000004
	ctime = Wed Mar 20 19:15:23 CST 2021
	mZxid = 0x100000004
	mtime = Wed Mar 20 19:15:23 CST 2021
	pZxid = 0x100000004
	cversion = 0
	dataVersion = 0
	aclVersion = 0
	ephemeralOwner = 0x0
	dataLength = 6
	numChildren = 0
# 2.7 创建短暂节点
create -e /king/tianting "erlangshen"
	Created /king/tianting
# 当前客户端可看到
ls /king 
	[huaguoshan, tianting]
# 退出客户端
quit
# 重启
/opt/module/zookeeper-3.4.10/bin/zkCli.sh
# 再次查看根目录,短暂节点已删除
ls /king 
	[huaguoshan]
2.8 创建带序号的节点
# 创建普通节点
create /king/tianbing "tianbing6"
	Created /king/tianbing6
# 创建带序号的节点
create -s /king/tianbing/tianbing1 "xiaotianquan"
	Created /king/tianbing/tianbing10000000000
create -s /king/tianbing/tianbing2 "xiaotianquan"
	Created /king/tianbing/tianbing20000000001
create -s /king/tianbing/tianbing3 "xiaotianquan"
	Created /king/tianbing/tianbing30000000002
# 原来没有序号节点，序号从0开始,依次递增
# 如果原节点下已有2个节点，则再排序时,从2开始，以此类推

2.9 修改节点值
set /king/tianbing "tuotatianwang"
2.10 节点值变化监听
# node1 主机 上注册监听 /king节点数据变化
get /king  watch
# node2 主机 修改 /king节点的值
set /king "didi"
# node1 主机 收到数据变化的监听
	WATCHER::
	WatchedEvent state:SyncConnected type:NodeDataChanged path:/king
2.11 节点的子节点变化监听（路径变化）
# node1 主机 上注册监听 /huaguoshan 节点的子节点变化
ls /king  watch
# node2 主机 创建 /huaguoshan 的子节点
create /king/test "test"
	Created /sanguo/test
# node1 主机 收到子节点变化的监听
	WATCHER::
	WatchedEvent state:SyncConnected type:NodeChildrenChanged path:/king
# 2.12 删除节点
delete /king/test
# 2.13 递归删除节点
rmr /king/huaguoshan
# 2.14 查看节点状态
stat /king
	cZxid = 0x100000003
	ctime = Wed Mar 20 20:03:23 CST 2021
	mZxid = 0x100000011
	mtime = Wed Mar 20 20:21:23 CST 2021
	pZxid = 0x100000014
	cversion = 9
	dataVersion = 1
	aclVersion = 0
	ephemeralOwner = 0x0
	dataLength = 4
	numChildren = 1
