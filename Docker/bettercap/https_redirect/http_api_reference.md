# Bettercap HTTP API 参考文档

## 📋 HTTP API 概述

Bettercap为JavaScript脚本提供了两种HTTP请求API：

1. **`http` 对象** - 高级API，功能丰富，支持多种请求类型
2. **`httpRequest` 函数** - 简单API，基础的HTTP请求功能

> **📋 文档说明**: 本文档基于 `js/http.go` 源码分析，确保所有API描述准确无误。

## 🔍 http 对象详解

### **源码基础**
```go
type httpPackage struct {}

type httpResponse struct {
    Error    error
    Response *http.Response
    Raw      []byte
    Body     string
    JSON     interface{}
}
```

### **可用方法**

| 方法名 | 参数 | 返回值 | 描述 | 源码位置 |
|--------|------|--------|------|----------|
| `Request(method, uri, headers, form, json)` | `string, string, object, object, string` | `httpResponse` | 通用HTTP请求 | `Request()` |
| `Get(url, headers)` | `string, object` | `httpResponse` | GET请求 | `Get()` |
| `PostForm(url, headers, form)` | `string, object, object` | `httpResponse` | POST表单请求 | `PostForm()` |
| `PostJSON(url, headers, json)` | `string, object, string` | `httpResponse` | POST JSON请求 | `PostJSON()` |
| `Encode(str)` | `string` | `string` | URL编码 | `Encode()` |

### **httpResponse 返回对象字段**

| 字段名 | 类型 | 描述 | 示例 |
|--------|------|------|------|
| `Error` | `error` | 请求错误（如果有） | `null` 或错误对象 |
| `Response` | `http.Response` | 原始HTTP响应对象 | 包含状态码、头部等 |
| `Raw` | `[]byte` | 原始响应体字节数组 | 二进制数据 |
| `Body` | `string` | 响应体字符串 | `"{"status": "ok"}"` |
| `JSON` | `interface{}` | 解析后的JSON对象 | 自动解析JSON响应 |

## 🔍 httpRequest 函数详解

### **源码基础**
```go
func httpRequest(call otto.FunctionCall) otto.Value {
    // 实现HTTP请求并返回包含body字段的对象
}
```

### **函数签名**
```javascript
httpRequest(method, url[, data][, headers])
```

### **参数说明**

| 参数 | 类型 | 必需 | 描述 | 示例 |
|------|------|------|------|-------|
| `method` | `string` | ✅ | HTTP方法 | `"GET"`, `"POST"`, `"PUT"` |
| `url` | `string` | ✅ | 请求URL | `"http://api.example.com/data"` |
| `data` | `string` | ❌ | 请求体数据 | `"key1=value1&key2=value2"` |
| `headers` | `object` | ❌ | 请求头部 | `{"Content-Type": "application/json"}` |

### **返回值**
返回一个包含 `body` 字段的对象：
```javascript
{
    body: "响应内容字符串"
}
```

## 📝 详细使用示例

### **http 对象示例**

#### **1. GET 请求**
```javascript
// 基本GET请求
var response = http.Get("http://httpbin.org/get", {});

// 检查响应
if (response.Error) {
    log_error("请求失败: " + response.Error);
} else {
    log_info("状态码: " + response.Response.StatusCode);
    log_info("响应体: " + response.Body);
}
```

#### **2. POST JSON 请求**
```javascript
var jsonData = JSON.stringify({
    username: "admin",
    password: "secret"
});

var response = http.PostJSON("http://api.example.com/login",
    {"User-Agent": "Bettercap-Script"},
    jsonData
);

if (response.Error) {
    log_error("POST请求失败: " + response.Error);
} else {
    log_info("登录响应: " + response.Body);
    // 如果响应是JSON，会自动解析到response.JSON中
}
```

#### **3. POST 表单请求**
```javascript
var formData = {
    username: "admin",
    password: "secret",
    remember: "true"
};

var response = http.PostForm("http://example.com/login",
    {"Referer": "http://example.com/"},
    formData
);

if (response.Response.StatusCode === 200) {
    log_info("登录成功!");
} else {
    log_warn("登录失败，状态码: " + response.Response.StatusCode);
}
```

#### **4. 通用请求方法**
```javascript
// PUT请求更新数据
var response = http.Request("PUT", "http://api.example.com/user/123",
    {"Authorization": "Bearer token123"},
    null, // 没有表单数据
    '{"name": "John", "email": "john@example.com"}'
);

if (response.Error) {
    log_error("更新失败: " + response.Error);
} else {
    log_info("用户更新成功");
}
```

#### **5. URL编码**
```javascript
var encoded = http.Encode("hello world & special chars");
// 结果: "hello%20world%20%26%20special%20chars"

var url = "http://example.com/search?q=" + encoded;
var response = http.Get(url, {});
```

### **httpRequest 函数示例**

#### **1. 简单GET请求**
```javascript
var response = httpRequest("GET", "http://httpbin.org/get");
log_info("响应: " + response.body);
```

#### **2. POST请求带数据**
```javascript
var postData = "username=admin&password=secret";
var response = httpRequest("POST", "http://example.com/login", postData);
log_info("登录结果: " + response.body);
```

#### **3. 带自定义头部的请求**
```javascript
var headers = {
    "User-Agent": "Bettercap-Script/1.0",
    "Content-Type": "application/x-www-form-urlencoded",
    "Authorization": "Basic dXNlcjpwYXNz"
};

var response = httpRequest("POST", "http://api.example.com/data",
    "key1=value1&key2=value2", headers);

log_info("API响应: " + response.body);
```

#### **4. JSON数据请求**
```javascript
var jsonData = '{"action": "update", "data": {"id": 123, "status": "active"}}';
var headers = {"Content-Type": "application/json"};

var response = httpRequest("PUT", "http://api.example.com/item/123",
    jsonData, headers);

if (response.body.indexOf("success") >= 0) {
    log_info("更新成功");
} else {
    log_warn("更新可能失败");
}
```

## 🔄 API对比

| 特性 | http 对象 | httpRequest 函数 |
|------|-----------|------------------|
| **复杂度** | 高（功能丰富） | 低（简单直接） |
| **返回值** | 结构化对象（Error, Response, Body等） | 简单对象（只有body字段） |
| **错误处理** | 内置Error字段 | 通过返回值判断 |
| **头部支持** | 完整支持 | 支持 |
| **请求类型** | 多种便捷方法 | 仅基础方法 |
| **响应解析** | 自动JSON解析 | 纯文本 |
| **使用场景** | 复杂HTTP操作 | 简单数据获取 |

## ⚠️ 注意事项

### **错误处理**
```javascript
// http对象错误处理
var response = http.Get("http://invalid.url", {});
if (response.Error) {
    log_error("网络错误: " + response.Error);
    return;
}

// httpRequest错误处理
try {
    var response = httpRequest("GET", "http://invalid.url");
    if (!response || !response.body) {
        log_error("请求失败或无响应");
        return;
    }
} catch (e) {
    log_error("异常: " + e);
}
```

### **性能考虑**
- **连接复用**: 两个API都使用Go的`http.DefaultClient`，自动复用连接
- **超时设置**: 使用默认超时，如需自定义需要创建新的Client
- **并发安全**: 可以安全地在多个goroutine中使用

### **数据格式**
- **JSON请求**: 使用`http.PostJSON()`或手动设置Content-Type
- **表单请求**: 使用`http.PostForm()`自动处理URL编码
- **二进制数据**: 可以通过Raw字段访问原始字节数据

### **安全提醒**
```javascript
// 避免在日志中输出敏感信息
var response = http.PostJSON("http://api.com/auth", {}, jsonData);
// 不要记录response.Body（可能包含token）
log_info("认证请求完成，状态码: " + response.Response.StatusCode);
```

## 🎯 实际应用场景

### **API监控脚本**
```javascript
function checkAPI() {
    var response = http.Get("http://api.example.com/health", {});
    if (response.Error || response.Response.StatusCode !== 200) {
        log_warn("API健康检查失败");
        return false;
    }

    var health = JSON.parse(response.Body);
    log_info("API状态: " + health.status);
    return true;
}
```

### **数据同步脚本**
```javascript
function syncData() {
    // 获取数据
    var getResponse = http.Get("http://source.api/data", {});
    if (getResponse.Error) return;

    var data = JSON.parse(getResponse.Body);

    // 发送到目标API
    var postResponse = http.PostJSON("http://target.api/sync",
        {"Authorization": "Bearer " + token},
        JSON.stringify(data)
    );

    if (postResponse.Response.StatusCode === 200) {
        log_info("数据同步成功");
    } else {
        log_error("同步失败: " + postResponse.Body);
    }
}
```

### **网页内容抓取**
```javascript
function scrapePage(url) {
    var response = http.Get(url, {
        "User-Agent": "Mozilla/5.0 (Bettercap Bot)"
    });

    if (response.Error) {
        log_error("抓取失败: " + url);
        return null;
    }

    // 检查是否为HTML
    if (response.Body.indexOf("<html") >= 0) {
        log_info("成功抓取页面: " + url);
        return response.Body;
    } else {
        log_warn("页面内容异常: " + url);
        return null;
    }
}
```

## 📚 源码文件参考

本文档基于以下Bettercap源码文件：

- **`js/http.go`** - HTTP API实现
- **`js/init.go`** - JavaScript环境注册

所有API和示例都经过源码验证，确保准确无误！

这个HTTP API参考文档为你提供了在Bettercap JavaScript脚本中进行HTTP请求的完整指南！🌐📡
