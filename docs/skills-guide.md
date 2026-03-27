# OpenClaw 技能配置指南

## 已安装技能汇总

共安装 **21 个技能**，以下是需要配置的关键技能：

### 🔥 常用技能

| 技能 | 功能 | 需要配置 |
|------|------|----------|
| **weather** | 天气查询 | ✅ curl (已安装) |
| **searxng** | 隐私搜索 | ⚙️ SEARXNG_URL 环境变量 |
| **github** | GitHub 操作 | ⚙️ gh CLI 已认证 |
| **notion** | Notion 笔记 | ⚙️ NOTION_API_KEY |
| **obsidian** | Obsidian 知识库 | ⚙️ obsidian-cli |
| **discord** | Discord 消息 | ⚙️ channels.discord.token |
| **slack** | Slack 消息 | ⚙️ channels.slack |
| **spotify-player** | Spotify 控制 | ⚙️ spogo/spotify_player |
| **nano-pdf** | PDF 编辑 | ⚙️ nano-pdf CLI |
| **summarize** | 文本摘要 | ⚙️ summarize.sh |
| **openai-image-gen** | AI 绘图 | ⚙️ OPENAI_API_KEY |
| **gemini** | Gemini CLI | ⚙️ GEMINI_API_KEY |
| **qqbot-cron** | QQ 定时提醒 | ⭐ 已安装 |
| **qqbot-media** | QQ 媒体发送 | ⭐ 已安装 |
| **agent-browser** | 浏览器自动化 | ⚙️ browser 工具 |
| **proactive-agent** | 主动 Agent | ⭐ 已安装 |
| **self-improvement** | 自我改进 | ⭐ 已安装 |
| **skill-vetter** | 技能安全检查 | ⭐ 已安装 |
| **find-skills** | 技能发现 | ⭐ 已安装 |

### 配置文件位置

`~/.openclaw/openclaw.json`

### 配置示例

```json5
{
  "skills": {
    "entries": {
      "notion": {
        "enabled": true,
        "apiKey": { "source": "env", "provider": "default", "id": "NOTION_API_KEY" }
      },
      "github": { "enabled": true },
      "weather": { "enabled": true },
      "discord": { "enabled": true },
      "slack": { "enabled": true },
      "spotify-player": { "enabled": true },
      "summarize": { "enabled": true },
      "openai-image-gen": {
        "enabled": true,
        "apiKey": { "source": "env", "provider": "default", "id": "OPENAI_API_KEY" }
      },
      "gemini": {
        "enabled": true,
        "apiKey": { "source": "env", "provider": "default", "id": "GEMINI_API_KEY" }
      },
      "searxng": {
        "enabled": true,
        "env": { "SEARXNG_URL": "http://localhost:8080" }
      }
    }
  }
}
```

## 安装更多技能

从 GitHub 安装:
```bash
git clone https://github.com/openclaw/openclaw.git /tmp/oc
cp -r /tmp/oc/skills/<skill-name> ~/.openclaw/workspace/skills/
```

或者使用 ClawHub:
```bash
clawhub install <skill-slug>
```

---

最后更新: 2026-03-15
