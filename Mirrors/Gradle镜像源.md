### 1. gradle dist 镜像源

gradle/wrapper/gradle-wrapper.properties
```properties
# 镜像源网站 http://mirrors.cloud.tencent.com/gradle
# distributionUrl=https\://services.gradle.org/distributions/gradle-<versions>.zip
# 改成
distributionUrl=https\://mirrors.cloud.tencent.com/gradle/gradle-<versions>.zip
```

### 2. 配置maven镜像源
* 全局配置

~/.gradle/init.gradle
```gradle
allprojects {
    repositories {
        def ALIYUN_REPOSITORY_URL = 'https://maven.aliyun.com/repository/public'
        def ALIYUN_JCENTER_URL = 'https://maven.aliyun.com/repository/central'
        def ALIYUN_PLUGIN_URL = 'https://maven.aliyun.com/repository/gradle-plugin'
        def ALIYUN_SNAPSHOTS_URL = 'https://maven.aliyun.com/repository/apache-snapshots'
        all {
            ArtifactRepository repo ->
                if (repo instanceof MavenArtifactRepository) {
                    def url = repo.url.toString()
                    if (url.startsWith('https://repo1.maven.org/maven2/')) {
                        project.logger.lifecycle "Repository ${repo.url} replaced by $ALIYUN_REPOSITORY_URL."
                        remove repo
                    }
                    if (url.startsWith('https://repo.maven.apache.org/maven2')) {
                        project.logger.lifecycle "Repository ${repo.url} replaced by $ALIYUN_REPOSITORY_URL."
                        remove repo
                    }
                    if (url.startsWith('https://jcenter.bintray.com/')) {
                        project.logger.lifecycle "Repository ${repo.url} replaced by $ALIYUN_JCENTER_URL."
                        remove repo
                    }
                    if (url.startsWith('https://plugins.gradle.org/m2')) {
                        project.logger.lifecycle "Repository ${repo.url} replaced by $ALIYUN_PLUGIN_URL."
                        remove repo
                    }
                    if (url.startsWith('https://repository.apache.org/snapshots')) {
                        project.logger.lifecycle "Repository ${repo.url} replaced by $ALIYUN_SNAPSHOTS_URL."
                        remove repo
                    }
                }
        }
        maven { url ALIYUN_REPOSITORY_URL }
        maven { url ALIYUN_JCENTER_URL }
        maven { url ALIYUN_PLUGIN_URL }
        maven { url ALIYUN_SNAPSHOTS_URL }
    }
}
```
* 项目内配置

settings.gradle
```gradle
pluginManagement {
    repositories {
        println "aliyun repositories"
        maven { url 'https://mirrors.cloud.tencent.com/maven' }
        maven { url 'https://mirrors.cloud.tencent.com/maven2' }
        maven { url 'https://maven.aliyun.com/repository/google' }
        maven { url 'https://maven.aliyun.com/repository/central' }
        maven { url 'https://maven.aliyun.com/repository/public' }
        maven { url 'https://maven.aliyun.com/repository/gradle-plugin' }
        maven { url 'https://maven.aliyun.com/repository/apache-snapshots' }
    }
}

dependencyResolutionManagement {
    repositories {
        println "aliyun allprojects ${project.name}"
        repositories {
            maven { url 'https://mirrors.cloud.tencent.com/maven' }
            maven { url 'https://mirrors.cloud.tencent.com/maven2' }
            maven { url 'https://maven.aliyun.com/repository/google' }
            maven { url 'https://maven.aliyun.com/repository/central' }
            maven { url 'https://maven.aliyun.com/repository/public' }
            maven { url 'https://maven.aliyun.com/repository/gradle-plugin' }
            maven { url 'https://maven.aliyun.com/repository/apache-snapshots' }
        }
    }
}
```

settings.gradle.kts
```kts
    ...
    maven { setUrl("https://mirrors.cloud.tencent.com/maven") }
    maven { setUrl("https://mirrors.cloud.tencent.com/maven2") }
    maven { setUrl("https://jitpack.io") }
    maven { setUrl("https://maven.aliyun.com/repository/releases") }
    maven { setUrl("https://maven.aliyun.com/repository/google") }
    maven { setUrl("https://maven.aliyun.com/repository/central") }
    maven { setUrl("https://maven.aliyun.com/repository/gradle-plugin") }
    maven { setUrl("https://maven.aliyun.com/repository/public") }
    ...
```