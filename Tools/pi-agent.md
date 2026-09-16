# Pi Agent 安装与配置

## 1. 装 pi 本体

需要 Node.js。用 npm 全局安装：

```bash
npm install -g --ignore-scripts @earendil-works/pi-coding-agent
pi --version
```

配置目录：`~/.pi/agent/`。卸载不影响该目录。

## 2. 装 pi 扩展

按需安装，装完重启 pi，会自动写入 settings.json 的 `packages`：

```bash
pi install npm:pi-mcp-adapter
pi install npm:pi-vision-proxy               # 可选：图片/音视频描述
pi install npm:@juicesharp/rpiv-ask-user-question   # 可选：结构化追问
```

## 3. 配置 API（models.json）

配置 provider 与模型在 `~/.pi/agent/models.json`。`api` 字段指定 API 协议，**没有 auto/自动探测选项**，必须手动选一个。支持以下取值：

| `api` 取值 | 协议 | 说明 |
|-----------|------|------|
| `openai-completions` | OpenAI Chat Completions | 兼容性最好（多数本地/中转服务用这个） |
| `openai-responses` | OpenAI Responses API | OpenAI 新接口 |
| `anthropic-messages` | Anthropic Messages API | Anthropic 原生协议 |
| `google-generative-ai` | Google Generative AI | Google Gemini |

示例：

```json
{
  "providers": {
    "<provider名>": {
      "baseUrl": "https://<API地址>",
      "api": "<API协议>",
      "apiKey": "$MY_API_KEY",
      "models": [
        {
          "id": "<模型id>",
          "reasoning": true,
          "contextWindow": 200000,
          "maxTokens": 32768,
          "input": ["text", "image"]
        }
      ]
    }
  }
}
```

- `api` 没有自动探测，需按你的服务实际支持的协议手动选择。选错会导致请求格式不匹配（报错/无响应），优先试 `openai-completions`（兼容性最好）。
- `baseUrl` 填实际的 API 基础地址，可以是官方 API、自建服务或其他服务，不一定是代理；是否需要 `/v1` 等路径按 API 服务要求填写。
- `apiKey` 换成自己的密钥，并用环境变量 `$MY_API_KEY` 引用，不写明文。
- 也可用官方 provider：先执行 `export ANTHROPIC_API_KEY=...`，再启动 `pi`；或启动 pi 后在交互界面输入 `/login`。
- 改完进 `/model` 即重新加载。

## 4. 配置其他（settings / MCP）

### 4.1 settings.json

默认模型、主题等在 `~/.pi/agent/settings.json`：

```json
{
  "defaultProvider": "<provider名>",
  "defaultModel": "<模型id>",
  "defaultThinkingLevel": "medium",
  "theme": "dark"
}
```

其他常用字段：`compaction.enabled`（上下文自动压缩）、`httpProxy`（HTTP 代理）、`packages`（已装扩展，无需手改）。

### 4.2 MCP

服务器配置放在 `mcpServers` 对象，每个服务器写连接方式：

```json
{
  "mcpServers": {
    "<服务器名>": {
      "url": "http://localhost:<端口>/<路径>"
    }
  }
}
```

**走 stream 还是 sse？不需要你指定**（配置里也没有这个字段）。对 HTTP `url` 服务，固定先尝试 **Streamable HTTP（stream）**，连接失败自动退回 **SSE**。你只需决定服务器是远程还是本地：

- 远程 HTTP(S) 服务 → 写 `url`；内部传输自动探测降级。
- 本地 MCP 程序 → 用 `command` + `args`（stdio）。

两者二选一（互斥）。需要鉴权时加 `headers`（含 Bearer）或 `auth`（`"bearer"` / `"oauth"`）；`lifecycle` 默认 `"lazy"`（用到才连接）。

```json
{
  "mcpServers": {
    "<服务器名>": {
      "url": "http://localhost:<端口>/<路径>",
      "headers": { "Authorization": "Bearer ${MCP_TOKEN}" },
      "lifecycle": "lazy"
    }
  }
}
```

pi（经 pi-mcp-adapter）按以下顺序读取，后面的配置会覆盖前面的配置：

| 顺序 | 位置 |
|------|------|
| 1 | `~/.config/mcp/mcp.json`（全局，推荐） |
| 2 | `~/.agents/mcp.json` |
| 3 | `~/.agents/mcp/mcp.json` |
| 4 | `~/.pi/agent/mcp.json` |
| 5 | `.mcp.json`（项目根） |
| 6 | `.pi/mcp.json`（项目级，最高优先级） |

按需填自己的服务器名、地址；运行时也可用 `/mcp` 管理。

## 启动

```bash
cd /path/to/project
pi                    # 交互模式
pi -c                 # 续上次会话
pi -p "简述仓库"       # 一次性提问
```

> 改 `settings.json` / MCP 配置后重启或 `/reload`。密钥放环境变量、地址用占位符，不要提交任何真实 Key。