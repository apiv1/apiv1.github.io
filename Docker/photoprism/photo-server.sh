docker run -d \
  --name photoprism \
  --security-opt seccomp=unconfined \
  --security-opt apparmor=unconfined \
  -p 2342:2342 \
  -e PHOTOPRISM_UPLOAD_NSFW="true" \
  -e PHOTOPRISM_ADMIN_PASSWORD="admin123" \
  -v type=tmpfs,/photoprism/storage \
  -v $PWD:/photoprism/originals:ro \
  photoprism/photoprism