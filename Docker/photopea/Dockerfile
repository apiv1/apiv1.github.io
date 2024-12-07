FROM python:3.10.2-alpine AS downloader
COPY . /app
WORKDIR /app
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    pip install -r requirements.txt && \
    python3 ./Updater.py

FROM nginx:stable-alpine
RUN rm -rf /usr/share/nginx/html
COPY --from=downloader /app/www.photopea.com /usr/share/nginx/html