### 给视频添加音频
```shell
ffmpeg -i ${VIDEO_FILE}  -i ${AUDIO_FILE}  -filter_complex '[1:a]aloop=loop=-1:size=2e+09[out];[out][0:a]amix' -ss 0 -t 184 -y out.mp4
```

### 剪切音频
```shell
ffmpeg -i input.mp3 -ss hh:mm:ss -t hh:mm:ss -acodec copy output.mp3
```

### 转wav
```shell
ffmpeg -i $item.mp3 -acodec pcm_s16le -ar 8000 -ac 1 $item.wav
```

### 剪切加转wav
```shell
ffmpeg -i input.mp3 -ss hh:mm:ss -t hh:mm:ss -acodec pcm_s16le -ar 8000 -ac 1 output.wav
```