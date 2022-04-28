### 允许plain http登录cockpit

/etc/cockpit/cockpit.conf
```toml
[WebService]
Origins = https://${DOMAIN_NAME} http://${DOMAIN_NAME}  http://127.0.0.1:9090
ProtocolHeader = X-Forwarded-Proto
AllowUnencrypted = true
```