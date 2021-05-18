docker run -v $PWD/data/db:/data/db --name db -d mongo:4.0 --smallfiles --replSet rs0 --oplogSize 128
docker exec -ti db mongo --eval "printjson(rs.initiate())"
docker run --name rocketchat -p 80:3000 --link db --env ROOT_URL=http://0.0.0.0 --env MONGO_OPLOG_URL=mongodb://db:27017/local -d rocket.chat
