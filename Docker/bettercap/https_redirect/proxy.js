var config = {
    logFilePath: "http_req_resp_log.json",  // 日志路径,留空就不输出。
    bodyMaxLength: 200  // Body最大保留长度 (字节)
};

function logToFile(data) {
    if (!config.logFilePath) return;
    appendFile(config.logFilePath, JSON.stringify(data) + "\n");
}

function onLoad() {
    log_info("\n=== 加载成功 ===\n" +
        "Body 最大保留长度: " + config.bodyMaxLength + " 字节\n" +
        "日志路径: " + config.logFilePath + "\n" +
        "WebSocket连接: 自动放行（请求和响应）");
}

// 截断字符串到指定长度
function truncateBody(body) {
    if (!body) return body;
    if (body.length <= config.bodyMaxLength) return body;
    return body.substring(0, config.bodyMaxLength) + "...";
}

// 检测WebSocket升级请求
function isWebSocketUpgrade(req) {
    if (!req.Headers) return false;

    // 检查Upgrade头是否为websocket，且Connection头包含upgrade
    var headers = req.Headers.toString().toLowerCase();
    return headers.indexOf("upgrade: websocket") !== -1 &&
           headers.indexOf("connection:") !== -1 &&
           headers.indexOf("upgrade") !== -1;
}

// 检测WebSocket握手响应
function isWebSocketHandshakeResponse(res) {
    if (!res.Headers) return false;

    // 检查状态码是否为101 Switching Protocols
    return res.Status === 101;
}

// 格式化headers为可读字符串
function formatHeaders(headers) {
    if (!headers) return "无";
    return headers.toString();
}

// 生成请求信息的字符串
function formatRequestInfo(client_ip, method, hostname, path, rawBody, headers) {
    var body = truncateBody(rawBody);
    var bodyLength = body ? body.length : 0;
    var bodyPart = bodyLength > 0 ? body : "无";
    var result = "📅 时间: " + new Date().toISOString() + "\n" +
        "🌐 客户端IP: " + client_ip + "\n" +
        "🏠 主机: " + hostname + "\n" +
        "\n--- 请求信息 ---\n" +
        "📡 方法: " + method + "\n" +
        "📂 路径: " + path + "\n" +
        "📋 请求头:\n" + formatHeaders(headers) + "\n" +
        "📊 请求体长度: " + bodyLength + " 字节\n" +
        "📦 请求体（部分）:\n" + bodyPart + "\n"
        ;
    return result;
}

// 生成响应信息的字符串（只包含响应部分）
function formatResponseInfo(status, resHeaders, rawBody) {
    var body = truncateBody(rawBody);
    var bodyLen = body ? body.length : 0;
    var bodyPart = bodyLen > 0 ? body : "无";
    var result = "\n--- 响应信息 ---\n" +
        "📊 状态码: " + status + "\n" +
        "📋 响应头:\n" + formatHeaders(resHeaders) + "\n" +
        "📊 响应体长度: " + bodyLen + " 字节\n" +
        "📦 响应体（部分）:\n" + bodyPart + "\n";
    return result;
}

// 处理HTTP/HTTPS请求
function onRequest(req, res) {
    var hostname = req.Hostname;
    // ⚠️ 注意：如果在这里修改res（如设置res.Status/res.Body），请求将不会真正转发到目标服务器，
    // 代理会直接返回你设置的res内容作为响应。这可用于拦截、阻断或伪造响应。
    _ = res; // 避免未使用res警告

    // 检测WebSocket连接并直接放行
    if (isWebSocketUpgrade(req)) {
        log_info("🔄 WebSocket请求放行: " + hostname + req.Path);
        return req; // 直接返回请求，跳过后续处理
    }

    // 读取body
    req.ReadBody();

    // 文件输出完整req对象
    var fileData = {
        timestamp: new Date().toISOString(),
        type: "request",
        request: req
    };
    logToFile(fileData);

    // 日志输出简化信息
    var client_ip = req.Client.IP;
    var method = req.Method;
    var path = req.Path;

    var requestInfo = "\n========== REQUEST ==========\n" +
        formatRequestInfo(client_ip, method, hostname, path, req.Body, req.Headers) +
        "================================================\n";

    log_info(requestInfo);

    return req;
}

// 处理HTTP/HTTPS响应
function onResponse(req, res) {
    var hostname = req.Hostname;

    // 检测WebSocket握手响应并放行
    if (isWebSocketHandshakeResponse(res)) {
        log_info("🔄 WebSocket响应放行: " + hostname + req.Path);
        return res; // 直接返回响应
    }

    res.ReadBody();

    // 文件输出完整req和res对象
    var fileData = {
        timestamp: new Date().toISOString(),
        type: "response",
        request: req,
        response: res
    };
    logToFile(fileData);

    // 日志输出简化信息
    var client_ip = req.Client.IP;
    var method = req.Method;
    var path = req.Path;
    var status = res.Status;

    var responseInfo = "\n========== RESPONSE ==========\n" +
        formatRequestInfo(client_ip, method, hostname, path, req.Body, req.Headers) +
        formatResponseInfo(status, res.Headers, res.Body) +
        "================================================\n";

    log_info(responseInfo);
    return res;
}