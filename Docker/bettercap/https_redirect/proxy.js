function onLoad() {
    log_info("=== 脚本加载成功 ===");
}

// 处理HTTP/HTTPS请求
function onRequest(req, res) {
    var client_ip = req.Client.IP;
    var method = req.Method;
    var hostname = req.Hostname;
    var path = req.Path;

    // 先读取request body
    req.ReadBody();

    var requestInfo = "\n[PROXY REQUEST]\n" +
                      "Client IP: " + client_ip + "\n" +
                      "Method: " + method + "\n" +
                      "Host: " + hostname + "\n" +
                      "Path: " + path + "\n" +
                      "Query: " + req.Query + "\n" +
                      "=== Request Headers ===\n" +
                      req.Headers;

    if (req.Body && req.Body.length > 0) {
        var bodyPreview = req.Body.length > 100 ? req.Body.substring(0, 100) + "..." : req.Body;
        requestInfo += "\n=== Request Body (" + req.Body.length + " bytes) ===\n" + bodyPreview;
    }

    log_info(requestInfo);

    return req;
}

// 处理HTTP/HTTPS响应
function onResponse(req, res) {
    var client_ip = req.Client.IP;
    var hostname = req.Hostname;
    var status = res.Status;

    // 先读取response body
    res.ReadBody();

    var responseInfo = "\n[PROXY RESPONSE]\n" +
                       "Client IP: " + client_ip + "\n" +
                       "Status: " + status + "\n" +
                       "Host: " + hostname + "\n" +
                       "Content-Type: " + res.ContentType + "\n" +
                       "=== Response Headers ===\n" +
                       res.Headers;

    if (res.Body && res.Body.length > 0) {
        var bodyPreview = res.Body.length > 100 ? res.Body.substring(0, 100) + "..." : res.Body;
        responseInfo += "\n=== Response Body (" + res.Body.length + " bytes) ===\n" + bodyPreview;
    }

    log_info(responseInfo);

    return res;
}