错误:
```
com.android.manifmerger.ManifestMerger2$MergeFailureException: Error parsing
```

解决
```xml
<!--1. 添加xmlns-->
<manifest
  ...
  xmlns:tools="http://schemas.android.com/tools"
  ...
  >
  <!--2. tools:node-->
  <application
    tools:node="replace"
...
```