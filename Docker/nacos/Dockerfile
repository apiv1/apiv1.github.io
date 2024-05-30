FROM openjdk:8-jre-slim
ENV TZ=PRC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ADD nacos /nacos
ENTRYPOINT [ "sh", "-c", "/usr/local/openjdk-8/bin/java -Xms512m -Xmx512m -Xmn256m -Dnacos.standalone=true -Dnacos.member.list= -Djava.ext.dirs=/usr/local/openjdk-8/jre/lib/ext:/usr/local/openjdk-8/lib/ext -Xloggc:/nacos/logs/nacos_gc.log -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCTimeStamps -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=100M -Dloader.path=/nacos/plugins/health,/nacos/plugins/cmdb -Dnacos.home=/nacos -jar /nacos/target/nacos-server.jar --spring.config.additional-location=file:/nacos/conf/ --logging.config=/nacos/conf/nacos-logback.xml --server.max-http-header-size=524288" ]