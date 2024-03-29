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

### 提取音频
```shell
ffmpeg -i sample.mp4 -q:a 0 -map a sample.mp3 # 提取完整音频#
ffmpeg -i sample.mp4 -ss 00:03:05 -t 00:00:45.0 -q:a 0 -map a sample.mp3 # 提取指定时间段的音频
ffmpeg -i input-video.avi -vn -acodec copy output-audio.aac # 只提取音频流而不进行重新编码
```

### concat
```shell
ffmpeg -i concat:"1.mp3|2.mp3|3.mp3|4.mp3|5.mp3|6.mp3" -c copy output.mp3
```