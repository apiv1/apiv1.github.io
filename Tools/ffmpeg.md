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

### 音频截取转视频
将一段音频片段转为视频格式，并配上黑色背景。
- `-f lavfi -i color=c=black:s=1920x1080:r=25`: 生成一段1920x1080分辨率、25帧率的黑色纯色视频作为背景。
- `-ss 00:03:05 -t 00:00:45.0 -i "in.m4s"`: 从音频文件"in.m4s"的03:05秒处截取45秒。
- `-map 0:v -map 1:a:0`: 选用第一个输入的全部视频轨道和第二个输入的音频轨道。
- `-c:v mpeg4 -q:v 3 -preset ultrafast -tune stillimage -pix_fmt yuv420p`: 设置视频编码器为mpeg4，画质和编码选项优化为静态图像。
- `-c:a copy`: 音频不重新编码，直接复制。
- `-shortest`: 使输出文件时长与最短流对齐（避免纯黑持续时间超出现有音频）。
- `-movflags +faststart`: 让视频可流式播放。

```shell
ffmpeg -f lavfi -i color=c=black:s=1920x1080:r=25 -ss 00:03:05 -t 00:00:45.0 -i "in.m4s" -map 0:v -map 1:a:0 -c:v mpeg4 -q:v 3 -preset ultrafast -tune stillimage -pix_fmt yuv420p -c:a copy -shortest -movflags +faststart "out.mp4"
```

### concat
```shell
ffmpeg -i concat:"1.mp3|2.mp3|3.mp3|4.mp3|5.mp3|6.mp3" -c copy output.mp3
```