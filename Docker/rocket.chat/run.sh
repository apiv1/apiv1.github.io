docker rm -f rocketchat-db rocketchat
docker run -v $PWD/data/db:/data/db --name rocketchat-db -d mongo --replSet rs0 --oplogSize 128
docker exec -ti rocketchat-db mongosh --eval "printjson(rs.initiate())"
docker run --name rocketchat -p 8000:3000 --link db --env ROOT_URL=http://0.0.0.0 --env MONGO_OPLOG_URL=mongodb://db:27017/local -d rocket.chat
