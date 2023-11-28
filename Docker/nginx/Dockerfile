FROM nginx:stable-alpine
RUN sed 's/#error_page\s\{1,\}404\s\{1,\}\/404.html;/error_page 404 \/index.html;/g' -i /etc/nginx/conf.d/default.conf && \
  rm -rf /usr/share/nginx/html
COPY . /usr/share/nginx/html