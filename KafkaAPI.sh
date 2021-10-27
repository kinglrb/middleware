# -----------------------------------------KafkaAPI实战
1）启动zk和kafka集群，打开一个消费者
$bin/kafka-console-consumer.sh  --zookeeper Hmaster:2181 --topic firstTopic

2）导入pom依赖
<dependencies>
	<! --https://mvnrepository.com/artifact/org.apache.kafka/kafka-clients -->
	<dependency>
		<groupId>org.apache.kafka</groupId>
		<artifactId>kafka-clients</artifactId>
		<version>1.0.0</version>
	</dependency>
	
	<! --https://mvnrepository.com/artifact/org.apache.kafka/kafka -->
	<dependency>
		<groupId>org.apache.kafka</groupId>
		<artifactId>kafka_2.11</artifactId>
		<version>1.0.0</version>
	</dependency>
</dependencies>

# ---------------------------------Kafka生产者JavaAPI
# ---------创建生产者(过时的API)
package  com.king.kafka;
import java.util.Properties;
import kafka.javaapi.producer.Producer;
import kafka.producer.KeyedMessage;
import kafka.producer.ProducerConfig;
public class  OldProducer{
	@SuppressWarnings("deprecation")
	public static void main(String []args){
		Propertiesproperties=new Properties();
		properties.put("metadata.broker.list","Hmaster:9092");
		properties.put("request.required.acks","1");
		properties.put("serializer.class","kafka.serializer. String Encoder");
		Producer<Integer,String>producer=new Producer<Integer,String>(new ProducerConfig(properties));
		KeyedMessage<Integer,String>message=new KeyedMessage<Integer,String>("first","helloworld");
		producer.send(message);
	}
}

# ---------------创建生产者（新API）
package  com.king.kafka;
import java.util.Properties;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerRecord;
public class   new Producer{
	public static void main(String []args){
		Propertiesprops=new Properties();
		#//Kafka服务端的主机名和端口号
		props.put("bootstrap.servers","Hslave1:9092");
		#//等待所有副本节点的应答
		props.put("acks","all");
		#//消息发送最大尝试次数
		props.put("retries",0);
		#//一批消息处理大小
		props.put("batch.size",16384);
		#//请求延时
		props.put("linger.ms",1);
		#//发送缓存区内存大小

		props.put("buffer.memory",33554432);
		#//key序列化
		props.put("key.serializer","org.apache.kafka.common.serialization. String Serializer");
		#//value序列化
		props.put("value.serializer","org.apache.kafka.common.serialization. String Serializer");
		Producer<String,String>producer=new KafkaProducer<>(props);
		for(inti=0;i<50;i++){
			producer.send(new ProducerRecord<String,String>("first",Integer.to String (i),"helloworld-"+i));
		}
		producer.close();
	}
}

# ---------------------创建生产者带回调函数（新API）
package  com.king.kafka;
import java.util.Properties;
import org.apache.kafka.clients.producer.Callback;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.clients.producer.RecordMetadata;
public class  CallBackProducer{
	public static void main(String []args){
		Propertiesprops=new Properties();
		#//Kafka服务端的主机名和端口号
		props.put("bootstrap.servers","Hslave1:9092");
		#//等待所有副本节点的应答
		props.put("acks","all");
		#//消息发送最大尝试次数
		props.put("retries",0);
		#//一批消息处理大小
		props.put("batch.size",16384);
		#//增加服务端请求延时
		props.put("linger.ms",1);
		#//发送缓存区内存大小
		props.put("buffer.memory",33554432);
		#//key序列化
		props.put("key.serializer",
		"org.apache.kafka.common.serialization. String Serializer");
		#//value序列化
		props.put("value.serializer","org.apache.kafka.common.serialization. String Serializer");
		KafkaProducer<String,String>kafkaProducer=new KafkaProducer<>(props);
		for(inti=0;i<50;i++){
			kafkaProducer.send(new ProducerRecord<String,String>("first","hello"+i), new Callback(){
				@Override
				public void onCompletion(RecordMetadata metadata,Exception
				exception){
					if(metadata!=null){
						System.err.println(metadata.partition()+" ---"+metadata.offset());
					}
				}
			});
		}
		kafkaProducer.close();
	}
}

4.2.4自定义分区生产者
0）需求：将所有数据，存储到topic的第0号分区上
# 1）定义一个类，实现Partitioner接口，重写partition方法（过时API）
# package  com.king.kafka;
# import java.util.Map;
# import kafka.producer.Partitioner;
# public class  CustomPartitioner implements Partitioner{
	# public CustomPartitioner(){
		# super();
	# }
	# @Override
	# public int partition(Object key,int numPartitions){
		# //控制分区
		 # return 0;
	# }
# }

2）自定义分区（新API）
package  com.king.kafka;
import java.util.Map;
import org.apache.kafka.clients.producer.Partitioner;
import org.apache.kafka.common.Cluster;
public class  CustomPartitioner implements Partitioner{
	@Override
	public void configure(Map<String,?>configs){
	}
	@Override
	public int partition(String topic,Object key,byte[] keyBytes,Object value,byte[] valueBytes,Cluster cluster){
		#//控制分区
		 return 0;
	}
	@Override
	public void close(){
	}
}

3）在代码中调用
package  com.king.kafka;

import java.util.Properties;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerRecord;
public class  PartitionerProducer{
	public static void main(String []args){
		Propertiesprops=new Properties();
		#//Kafka服务端的主机名和端口号
		props.put("bootstrap.servers","Hslave1:9092");
		#//等待所有副本节点的应答
		props.put("acks","all");
		#//消息发送最大尝试次数
		props.put("retries",0);
		#//一批消息处理大小
		props.put("batch.size",16384);
		#//增加服务端请求延时
		props.put("linger.ms",1);
		#//发送缓存区内存大小
		props.put("buffer.memory",33554432);
		#//key序列化
		props.put("key.serializer","org.apache.kafka.common.serialization. String Serializer");
		#//value序列化
		props.put("value.serializer","org.apache.kafka.common.serialization. String Serializer");
		#//自定义分区
		props.put("partitioner.class","com.king.kafka.CustomPartitioner");
		Producer<String,String>producer=new KafkaProducer<>(props);
		producer.send(new ProducerRecord<String,String>("first","1","atguigu"));
		producer.close();
	}
}

4）测试
（1）在Hmaster上监控kafka/logs/first主题3个分区log日志变化情况
tail -f 00000000000000000000.log
# 数据存储到指定分区
