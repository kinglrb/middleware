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
create /xiyouji "baigujing"
	Created /xiyouji
create /xiyouji/huaguoshan "sunwukong"
	Created /xiyouji/huaguoshan
# 2.6 获取节点的值
get /xiyouji
	baigujing
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

get /xiyouji/huaguosha
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
create -e /xiyouji/tianting "erlangshen"
	Created /xiyouji/tianting
# 当前客户端可看到
ls /xiyouji 
	[huaguoshan, tianting]
# 退出客户端
quit
# 重启
/opt/module/zookeeper-3.4.10/bin/zkCli.sh
# 再次查看根目录,短暂节点已删除
ls /xiyouji 
	[huaguoshan]
2.8 创建带序号的节点
# 创建普通节点
create /xiyouji/tianbing "tianbing6"
	Created /xiyouji/tianbing6
# 创建带序号的节点
create -s /xiyouji/tianbing/tianbing1 "xiaotianquan"
	Created /xiyouji/tianbing/tianbing10000000000
create -s /xiyouji/tianbing/tianbing2 "xiaotianquan"
	Created /xiyouji/tianbing/tianbing20000000001
create -s /xiyouji/tianbing/tianbing3 "xiaotianquan"
	Created /xiyouji/tianbing/tianbing30000000002
# 原来没有序号节点，序号从0开始,依次递增
# 如果原节点下已有2个节点，则再排序时,从2开始，以此类推

2.9 修改节点值
set /xiyouji/tianbing "tuotatianwang"
2.10 节点值变化监听
# node1 主机 上注册监听 /xiyouji节点数据变化
get /xiyouji  watch
# node2 主机 修改 /xiyouji节点的值
set /xiyouji "didi"
# node1 主机 收到数据变化的监听
	WATCHER::
	WatchedEvent state:SyncConnected type:NodeDataChanged path:/xiyouji
2.11 节点的子节点变化监听（路径变化）
# node1 主机 上注册监听 /huaguoshan 节点的子节点变化
ls /xiyouji  watch
# node2 主机 创建 /huaguoshan 的子节点
create /xiyouji/wujiguan "wujiguan"
	Created /sanguo/wujiguan
# node1 主机 收到子节点变化的监听
	WATCHER::
	WatchedEvent state:SyncConnected type:NodeChildrenChanged path:/xiyouji
# 2.12 删除节点
delete /xiyouji/wujiguan
# 2.13 递归删除节点
rmr /xiyouji/huaguoshan
# 2.14 查看节点状态
stat /xiyouji
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