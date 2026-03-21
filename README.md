# openclawOperate

一个围绕 OpenClaw 搭建的个人运维与成长仓库。

这个仓库不只是放代码，也用来沉淀：
- 日常操作面板
- 定时任务与自动化策略
- 飞书文档归档
- skill 安装与能力扩展
- 成长日志与经验记录
- GitHub 自动同步

## 目前包含的核心能力

### 1. 状态面板
- `status-dashboard.html`
- `dashboard-server.py`

用于展示 OpenClaw 的运行状态，包括：
- 当前模型
- cron 任务状态
- 最近动作
- 模型切换历史
- 任务结果与飞书文档链接

### 2. 飞书文档归档
当前已经为多个定时任务建立了对应的飞书归档文档，用于追加保存日报、周报和执行结果。

覆盖方向包括：
- 游戏每日更新
- OpenClaw 每日更新
- 今日头条
- 股票市场日报
- GitHub Trending 日报
- 游戏周报
- 状态面板飞书版
- skill 候选清单

### 3. 成长日志体系
- `CHANGELOG.md`
- `growth-log/TEMPLATE.md`
- `growth-log/YYYY-MM-DD.md`
- `docs/growth-log-rules.md`

用于持续记录：
- 技能安装
- cron 修改
- 文档归档
- 模型切换
- 修复经验
- 后续计划

### 4. 自动记录脚本
`scripts/` 目录下已经封装了一批带日志能力的常见操作脚本：

- `scripts/daily-sync.sh`
  - 每日自动提交并推送到 GitHub

- `scripts/growth-log-event.sh`
  - 将事件即时追加到当天的 growth log

- `scripts/logged-skill-install.sh`
  - 安装 skill 并自动记日志

- `scripts/logged-cron-add.sh`
  - 新增 cron 并自动记日志

- `scripts/logged-cron-edit.sh`
  - 修改 cron 并自动记日志

- `scripts/logged-model-switch.sh`
  - 记录模型切换事件并自动记日志

## 当前工作流

### 定时任务管理
仓库目前已经围绕 OpenClaw 配置了一批定时任务，用于：
- 游戏资讯收集
- OpenClaw 动态追踪
- 股票市场信息整理
- GitHub Trending 追踪
- skill 候选清单更新
- 每日 GitHub 自动同步

### 自动同步 GitHub
本仓库已经绑定到：
- `git@github.com:123weichen123-code/openclawOperate.git`

并且配置了：
- git 用户名：`mercury`
- git 邮箱：`123weichen123@gmail.com`

每日会执行自动同步，把有价值的改动和成长日志推送到远端。

## skill 能力地图
当前已安装并投入使用的 skill 包括：

- `openclaw-control-center`
  - 控制中心、状态面板、可视化总览

- `proactive-self-improving-agent`
  - 问题复盘、自我改进、经验沉淀

- `openclaw-backup`
  - 配置备份与恢复

- `openclaw-self-healing`
  - 故障自愈与自动恢复

- `feishu-doc`
  - 飞书文档归档与结构化写入

- `browser-automation`
  - 网页浏览、页面交互、抓取 fallback

- `devops-automation`
  - 运维、服务检查、流程自动化

- `openclaw-audit-watchdog`
  - 安全巡检、配置审计、风险检查

## 推荐查看的文件

- `README.md`
  - 项目总览
- `CHANGELOG.md`
  - 变更历史
- `growth-log/`
  - 每日成长日志
- `docs/growth-log-rules.md`
  - 记录规则
- `status-dashboard.html`
  - 状态面板页面
- `scripts/`
  - 自动化脚本集合

## 后续方向

下一步适合继续完善的方向：
- 把状态面板从半静态继续升级为全动态
- 让模型、cron、文档状态全部走稳定接口
- 继续沉淀 skill 能力地图和候选清单
- 让更多常见操作天然带成长日志记录

## 仓库定位

这个仓库的定位不是“代码示例仓库”，而是一个正在持续生长的 OpenClaw 个人操作中台。

它记录的不只是结果，也记录：
- 为什么这么做
- 做完之后学到了什么
- 下次如何更稳地自动完成
