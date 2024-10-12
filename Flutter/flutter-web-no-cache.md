# Flutter web 设置不缓存页面

index.html
```html
<head>
...
    <meta http-equiv="cache-control" content="no-cache" />
    <meta http-equiv="expires" content="0" />
    <meta http-equiv="pragma" content="no-cache" />
...
</head>
```

[参考](https://stackoverflow.com/questions/72363997/force-cache-refresh-on-flutter-v3-0-1-web/74124477#74124477)