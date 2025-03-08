Xray **全自动加密+免证书+开箱即用** 的完整配置方案，已包含密钥生成步骤

---

### 密钥生成（服务器执行）
```bash
# 生成 x25519 密钥对
xray x25519 > xray_key.txt && cat xray_key.txt
# 生成 shortId（取前4位）
echo "shortId: $(openssl rand -hex 4 | cut -c1-4)"
```
输出示例：
```
私钥：YOUR_PRIVATE_KEY（如 2CFA_4pTrQFjGXXX...）
公钥：YOUR_PUBLIC_KEY（如 qANj_8tQ6yXXX...）
shortId: 89a3
```

---

### 服务器配置（需替换内容）
```json
{
  "log": { "loglevel": "warning" },
  "inbounds": [{
    "port": 443,
    "protocol": "vless",
    "settings": {
      "clients": [{
        "id": "30e9abcd-1234-5678-90ab-cdef01234567",
        "flow": "xtls-rprx-vision"
      }],
      "decryption": "none"
    },
    "streamSettings": {
      "network": "tcp",
      "security": "reality",
      "realitySettings": {
        "show": false,
        "dest": "www.amazon.com:443",
        "serverNames": ["www.amazon.com"],
        "privateKey": "0LkWqmVPkSsfkeChwOmgMXM7ZJ12-V2_qUjCEWfCcG4",
        "shortIds": ["89a3"]
      }
    }
  }],
  "outbounds": [{"protocol": "freedom"}]
}
```

---

### 客户端配置（Xray专用）
```json
{
  "log": { "loglevel": "info" },
  "inbounds": [{
    "port": 10808, // 本地监听端口
    "protocol": "socks",
    "settings": {
      "auth": "noauth",
      "udp": true
    }
  }],
  "outbounds": [{
    "protocol": "vless",
    "settings": {
      "vnext": [{
        "address": "你的服务器IP", // ← 只改这里
        "port": 443,
        "users": [{
          "id": "30e9abcd-1234-5678-90ab-cdef01234567", // 同服务器UUID
          "flow": "xtls-rprx-vision",
          "encryption": "none"
        }]
      }]
    },
    "streamSettings": {
      "network": "tcp",
      "security": "reality",
      "realitySettings": {
        "serverName": "www.amazon.com",
        "publicKey": "YOUR_PUBLIC_KEY", // ← 替换生成的公钥
        "shortId": "89a3", // ← 替换生成的shortId
        "fingerprint": "chrome" // 指纹伪装
      }
    }
  }]
}
```

---

### 配置替换三部曲
1. **服务器端替换**：
   - `privateKey` → 用生成的 **私钥**
   - `shortIds` → 用生成的 shortId（如 89a3）

2. **客户端替换**：
   - `address` → 服务器IP或域名
   - `publicKey` → 用生成的 **公钥**
   - `shortId` → 与服务器一致

3. **UUID修改**（可选）：
   ```bash
   xray uuid  # 生成新UUID后需同步修改服务端和客户端
   ```

---

### 连接测试命令
```bash
# 查看Xray客户端日志
journalctl -u xray-client --since "5分钟前" -f

# 测试网络连通性
curl --socks5 127.0.0.1:10808 https://ip.sb
```

---

### ⚠️ 常见问题处理
1. **`invalid privateKey` 错误**：
   - 检查私钥是否包含特殊字符（需完整复制）
   - 确认服务端使用**私钥**，客户端使用**公钥**

2. **`shortId mismatch` 错误**：
   - 检查服务器 `shortIds` 数组和客户端 `shortId` 是否完全一致
   - 建议 shortId 长度用4字符（如 89a3）

3. **连接超时**：
   ```bash
   sudo lsof -i:443  # 检查端口是否监听
   ping 服务器IP      # 检查网络可达性
   ```