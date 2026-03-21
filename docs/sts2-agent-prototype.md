# STS2 Agent 原型方案：最小状态读取 + 最小动作执行

## 目标

这份文档只解决一件事：
**先把《杀戮尖塔2》接上，让外部 agent 能读到最小状态，并执行最小动作。**

不是先追求强度，也不是先追求完整 bot，而是先打通闭环：
- 读状态
- 发动作
- 收反馈

如果这个闭环能打通，后面再叠规则引擎、MCP、OpenClaw 接入都顺理成章。

---

## 从 `STS2FirstMod` 确认到的事实

`jiegec/STS2FirstMod` 已经证明：

- STS2 可以通过 mod 扩展
- 工程形态是：
  - `Godot.NET.Sdk 4.5.1`
  - `net9.0`
  - 引用游戏里的 `sts2.dll`
- 核心 mod 入口可以通过：
  - `using MegaCrit.Sts2.Core.Modding;`
  - `[ModInitializer("ModLoaded")]`
- 打包形态是：
  - `dll + pck`
- 目标目录是游戏的 `mods/<ModName>/`

也就是说，**最低限度的 STS2 agent mod 工程可以直接从这个最小例子出发。**

---

## 原型阶段不要做的事

为了避免一开始就把项目做复杂，原型阶段先不要做：

- 不要先做完整 MCP server
- 不要先做完整 battle simulator
- 不要先做全局策略系统
- 不要先做商店/地图/奖励/事件全覆盖
- 不要先做截图识别

原型阶段只做：
- 最小状态读取
- 最小动作执行
- 本地控制接口

---

## Phase A：最小可运行 STS2 Agent Mod

## 目录建议

建议先在仓库里规划一个未来目录，例如：

```text
sts2-agent/
  mod/
    Sts2AgentBridge.csproj
    Sts2AgentBridge.cs
    mod_manifest.json
    build.sh
  docs/
    api-draft.md
    state-schema.md
```

原型阶段只要先有 `mod/` 就够了。

---

## 最小 mod 入口

可以从 `STS2FirstMod` 的结构开始，先把 `FirstMod` 改成类似 `Sts2AgentBridge`。

### 最小入口职责
- mod 成功加载
- 输出一条日志，证明桥接启动成功
- 启动一个本地 bridge（推荐先用本地 HTTP）

### 为什么推荐 HTTP 而不是一开始就 MCP
- 更容易调试
- 更适合快速验证状态与动作
- 等接口稳定后再包成 MCP

---

## Phase B：最小状态读取

原型阶段最少只需要暴露这几项：

### 游戏基础状态
- `screen_type`
- `in_combat`
- `can_proceed`
- `can_end_turn`

### 玩家基础状态
- `hp`
- `max_hp`
- `block`
- `energy`

### 手牌
每张牌至少暴露：
- `id`
- `name`
- `cost`
- `is_playable`
- `requires_target`

### 怪物
每个怪物至少暴露：
- `index`
- `name`
- `hp`
- `block`
- `intent`
- `is_dead`

### 当前选择（如有）
- `choice_list`
- `screen_type`

---

## 建议的最小状态接口

### `GET /health`
返回：
```json
{
  "ok": true,
  "mod": "Sts2AgentBridge"
}
```

### `GET /state`
返回：
```json
{
  "screen_type": "COMBAT",
  "in_combat": true,
  "player": {
    "hp": 63,
    "max_hp": 80,
    "block": 0,
    "energy": 3
  },
  "hand": [
    {
      "index": 1,
      "id": "Strike",
      "name": "Strike",
      "cost": 1,
      "is_playable": true,
      "requires_target": true
    }
  ],
  "monsters": [
    {
      "index": 1,
      "name": "Jaw Worm",
      "hp": 42,
      "block": 0,
      "intent": "ATTACK",
      "is_dead": false
    }
  ],
  "choices": []
}
```

### 这一步的成功标准
- 外部程序稳定拿到 JSON
- JSON 足够让一个简单 agent 判断“能不能打牌、能不能结束回合”

---

## Phase C：最小动作执行

原型阶段最少实现这 4 个动作：

### 1. `POST /action/play_card`
参数：
```json
{
  "card_index": 1,
  "target_index": 1
}
```

### 2. `POST /action/end_turn`
参数：空

### 3. `POST /action/choose`
参数：
```json
{
  "choice_index": 1
}
```

### 4. `POST /action/proceed`
参数：空

---

## 动作执行原则

这里最重要的不是接口，而是**线程安全**：

- 游戏状态读取可以尽量同步完成
- 游戏动作执行不要直接乱调用
- 所有会改游戏状态的操作，最好进一个队列
- 再在游戏主线程安全执行

这点可以直接参考 `MCPTheSpire` 的思路：
- 读操作即时返回
- 写操作排队执行

---

## 原型阶段的最小闭环

当下面这个流程能跑通时，说明原型成功：

1. 启动 STS2
2. mod 成功加载
3. 外部请求 `GET /state`
4. 返回当前手牌、能量、敌人信息
5. 外部请求 `POST /action/play_card`
6. 游戏内成功打出一张牌
7. 外部请求 `POST /action/end_turn`
8. 游戏顺利进入下一阶段

如果这个闭环跑通，就说明：
- STS2 可被 agent 控制
- 后续做战斗策略不是空谈

---

## 推荐的外部调试脚本

建议同时写一个极小 Python 调试脚本，例如：

```python
import requests

base = "http://127.0.0.1:8765"
state = requests.get(f"{base}/state").json()
print(state)

playable = [c for c in state["hand"] if c["is_playable"]]
if playable:
    card = playable[0]
    payload = {"card_index": card["index"]}
    if card["requires_target"] and state["monsters"]:
        payload["target_index"] = state["monsters"][0]["index"]
    print(requests.post(f"{base}/action/play_card", json=payload).json())
else:
    print(requests.post(f"{base}/action/end_turn", json={}).json())
```

这个脚本不是最终 agent，但非常适合验证桥接层有没有通。

---

## 原型阶段的关键风险

## 1. STS2 内部对象结构不好找
### 应对
- 先只拿最小字段
- 用日志打印确认对象路径
- 先做战斗 screen，再扩展其他 screen

## 2. 动作执行可能需要严格主线程
### 应对
- 先实现简单队列
- 每次只执行一个动作
- 动作执行完再允许下一次请求

## 3. 屏幕切换会导致状态结构变化
### 应对
- `screen_type` 必须是第一层字段
- 不同 screen 的数据结构允许不同
- 原型阶段宁可简单，不要追求统一过度抽象

## 4. STS2 更新可能改 API
### 应对
- mod bridge 层保持薄
- 决策逻辑全部放到外部进程

---

## 原型完成后的下一步

当最小读写闭环完成后，再按这个顺序推进：

### 下一步 1：状态结构补全
- relics
- draw pile
- discard pile
- potions
- buffs / debuffs
- map nodes
- rewards

### 下一步 2：批量动作
增加：
- `POST /action/execute`
- 一次传多步动作

### 下一步 3：MCP 化
把 HTTP bridge 包装成：
- `get_game_state`
- `execute_actions`
- `get_available_actions`
- `get_card_info`

### 下一步 4：规则战斗 AI
先做一个最小版本：
- 优先可打牌
- 优先能击杀
- 否则优先防御
- 否则结束回合

---

## 推荐实现顺序（最务实版）

### Day 1
- 建 mod 工程
- 成功加载
- 启动 `/health`

### Day 2
- 做 `/state`
- 返回最小战斗状态

### Day 3
- 做 `/action/play_card`
- 做 `/action/end_turn`

### Day 4
- 写 Python 外部调试脚本
- 打通一场简单战斗的最小循环

### Day 5+
- 扩展 `choose` / `proceed`
- 增加奖励和地图支持
- 准备接 OpenClaw / MCP

---

## 结论

如果你现在要真正开始做 STS2 agent，最优先的不是“做 AI 多聪明”，而是：

**先让 STS2 能稳定地把最小状态暴露出来，并接收最小动作。**

这一步一旦跑通：
- 规则引擎能接
- OpenClaw 能接
- MCP 能接
- 战斗策略、路线规划、构筑优化都能在后面逐步叠加

所以我对当前阶段的建议非常明确：

### 现在最该做的原型目标
- `GET /state`
- `POST /action/play_card`
- `POST /action/end_turn`
- `POST /action/choose`
- `POST /action/proceed`

只要这套最小闭环完成，STS2 自主游玩项目就正式从“研究判断”进入“可开发状态”。
