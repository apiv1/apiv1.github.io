# admin:admin

docker run  --name x-ui --restart always -d --net host -v x-ui_data:/etc/x-ui/ -v x-ui_home:/root enwaiax/x-ui:latest