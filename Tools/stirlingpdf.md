# 处理PDF的网站

[官网](https://www.stirlingpdf.com/)
[源码](https://github.com/Stirling-Tools/Stirling-PDF)

Docker安装
```shell
docker run -d \
  --name stirling-pdf \
  -p 8080:8080 \
  -v "./StirlingPDF/trainingData:/usr/share/tessdata" \
  -v "./StirlingPDF/extraConfigs:/configs" \
  -v "./StirlingPDF/customFiles:/customFiles/" \
  -v "./StirlingPDF/logs:/logs/" \
  -v "./StirlingPDF/pipeline:/pipeline/" \
  -e DOCKER_ENABLE_SECURITY=false \
  -e INSTALL_BOOK_AND_ADVANCED_HTML_OPS=false \
  -e LANGS=en_GB \
  frooodle/s-pdf:latest
```
