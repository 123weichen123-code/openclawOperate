---
name: chandra
version: "0.2.0"
description: "SOTA级OCR模型，将图片和PDF转换为结构化HTML/Markdown/JSON，支持90+语言、复杂表格、手写内容和数学公式识别。"
argument-hint: 'chandra document.pdf ./output, chandra --help'
allowed-tools: Bash, Read
homepage: https://github.com/datalab-to/chandra
author: datalab-to
license: Apache-2.0
user-invocable: true
metadata:
  openclaw:
    emoji: "📄"
    requires:
      bins:
        - python3
    files:
      - ".venv/bin/chandra"
      - ".venv/bin/chandra_vllm"
      - ".venv/bin/chandra_app"
    tags:
      - ocr
      - pdf
      - document
      - table-extraction
      - handwriting
      - multilingual
---

# Chandra OCR - 文档智能处理技能

SOTA级OCR模型，支持将图片和PDF转换为结构化输出，完整保留布局信息。

## 核心能力

- **90+ 语言支持** - 覆盖主流语言
- **复杂表格识别** - 精确还原表格结构
- **手写内容识别** - 支持手写文字和数学公式
- **数学公式识别** - 包括手写数学公式
- **图表提取** - 提取图片和图表并添加说明
- **布局保留** - 完整保留文档结构

## 使用方式

### 基础使用

```bash
# 激活虚拟环境
source ~/.openclaw/workspace/skills/chandra/.venv/bin/activate

# 处理单个PDF
chandra input.pdf ./output

# 处理整个目录
chandra ./documents ./output
```

### 启动vLLM服务器（推荐）

```bash
# 启动本地服务
chandra_vllm

# 使用vLLM后端处理
chandra input.pdf ./output --method vllm
```

### 交互式应用

```bash
chandra_app
```

## CLI 参数

- `--method [hf|vllm]` - 推理方式（默认: vllm）
- `--page-range TEXT` - PDF页面范围（如 "1-5,7,9-12"）
- `--max-output-tokens INTEGER` - 每页最大token数
- `--include-images/--no-images` - 是否提取图片（默认: 是）
- `--include-headers-footers/--no-headers-footers` - 是否包含页眉页脚（默认: 否）

## 输出结构

每个处理的文件会创建一个子目录，包含：

- `.md` - Markdown 输出
- `.html` - HTML 输出
- `_metadata.json` - 元数据（页面信息、token数等）
- 提取的图片直接保存在输出目录

## 使用场景

- 文档数字化处理
- PDF内容提取与分析
- 复杂表格数据抽取
- 手写文档识别
- 多语言文档处理
- RAG预处理（为知识库准备数据）

## 性能参考

在 NVIDIA H100 上约 1.44 页/秒（基准测试），实际使用约 2 页/秒。

## 安全注意事项

- 本地处理，数据不上传云端
- 模型权重使用 OpenRAIL-M 许可证（免费用于研究、个人使用和年融资/收入低于 200 万美元的初创公司）
