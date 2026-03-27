# 海外服务器访问配置指南

## 场景
- 服务器: 海外
- 用户: 国内
- 需要访问部署在海外的 OpenClaw 服务

---

## 方案对比

| 方案 | 难度 | 速度 | 安全性 | 推荐场景 |
|------|------|------|--------|----------|
| 开放端口 | ⭐ | 最快 | 低 | 有独立公网 IP |
| Tailscale | ⭐⭐ | 快 | 高 | 长期使用 |
| Cloudflare Tunnel | ⭐⭐ | 中 | 高 | 临时/演示 |
| frp | ⭐⭐ | 中 | 中 | 需要中转服务器 |

---

## 方案 1: 开放端口（最简单）

### 检查防火墙
```bash
sudo ufw status
```

### 开放端口
```bash
# 开放单个端口
sudo ufw allow 8765/tcp

# 开放 OpenClaw 默认端口
sudo ufw allow 18789/tcp

# 重新加载防火墙
sudo ufw reload
```

### 使用
```
http://服务器IP:8765
```

---

## 方案 2: Tailscale（推荐）

### 服务器端
```bash
# 安装
curl -fsSL https://tailscale.com/install.sh | sh

# 启动（需要登录）
tailscale up

# 查看分配的 IP
tailscale ip -4
```

### 本地端（国内）
1. 下载安装 Tailscale: https://tailscale.com/download
2. 登录同一账号
3. 通过 Tailscale 分配的 IP 访问服务器服务

### 访问示例
```
http://100.x.x.x:8765
```

---

## 方案 3: Cloudflare Tunnel

### 安装
```bash
curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o cloudflared
chmod +x cloudflared
```

### 启动 Tunnel
```bash
# 本地服务
./cloudflared tunnel --url http://localhost:8765

# 或创建持久 tunnel
./cloudflared tunnel create openclaw
./cloudflared tunnel route dns openclaw your-subdomain.example.com
./cloudflared tunnel ingress rule --hostname your-subdomain.example.com --service http://localhost:8765
./cloudflared tunnel start openclaw
```

---

## 方案 4: frp 内网穿透

需要一台有公网 IP 的中转服务器。

### 服务端配置 (frps)
```bash
# frps.toml
[common]
bind_port = 7000

# 启动
./frps -c frps.toml
```

### 客户端配置 (frpc)
```bash
# frpc.toml
[common]
server_addr = your-frp-server.com
server_port = 7000

[web]
type = tcp
local_port = 8765
remote_port = 18789

# 启动
./frpc -c frpc.toml
```

---

## 常见端口

| 服务 | 端口 |
|------|------|
| OpenClaw Gateway 默认 | 18789 |
| Control UI | 18789 |
| 本示例 HTTP 服务 | 8765 |

---

最后更新: 2026-03-15
