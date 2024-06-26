* 引入外部jar包文件夹
pom.xml

```xml
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.8.1</version>
                <configuration>
                    <source>1.8</source>
                    <target>1.8</target>
                    <encoding>UTF-8</encoding>
                    <compilerArguments>
                        <extdirs>${project.basedir}/libs</extdirs>
                    </compilerArguments>
                </configuration>
            </plugin>
```

* maven指定本地仓库和镜像仓库参考

~/.m2/settings.xml

```xml
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
  <localRepository>C:\local_respository</localRepository>
  <mirrors>
    <mirror>
      <id>tencent</id>
      <url>https://mirrors.cloud.tencent.com/maven</url>
      <mirrorOf>*</mirrorOf>
    </mirror>
  </mirrors>
</settings>
```

* maven 打包跳过test构建运行
```shell
mvn package '-Dmaven.test.skip=true'
```