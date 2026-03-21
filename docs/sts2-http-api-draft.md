# STS2 HTTP API Draft

## Goal

Define the smallest stable HTTP API for the STS2 bridge.
The API is intentionally simple so it can later be wrapped into MCP without redesigning core actions.

Base URL example:

```text
http://127.0.0.1:8765
```

---

## 1. Health

### `GET /health`

#### Response
```json
{
  "ok": true,
  "mod": "Sts2AgentBridge",
  "version": "0.1.0"
}
```

---

## 2. State

### `GET /state`

Returns current structured game state.

#### Response
See `docs/sts2-state-schema.md`.

---

## 3. Available Actions

### `GET /actions`

Returns context-aware available actions.

#### Response
```json
{
  "screen_type": "COMBAT",
  "actions": [
    {"action": "play_card", "enabled": true},
    {"action": "end_turn", "enabled": true},
    {"action": "proceed", "enabled": false}
  ]
}
```

---

## 4. Play Card

### `POST /action/play_card`

#### Request
```json
{
  "card_index": 1,
  "target_index": 1
}
```

#### Fields
- `card_index`: required, 1-based hand index
- `target_index`: optional, 1-based monster index

#### Response
```json
{
  "ok": true,
  "message": "Card played",
  "state_changed": true
}
```

#### Error Example
```json
{
  "ok": false,
  "error": "Card not playable"
}
```

---

## 5. End Turn

### `POST /action/end_turn`

#### Request
```json
{}
```

#### Response
```json
{
  "ok": true,
  "message": "Turn ended",
  "state_changed": true
}
```

---

## 6. Choose

### `POST /action/choose`

Used for reward screens, events, map choices, etc.

#### Request
```json
{
  "choice_index": 1
}
```

#### Response
```json
{
  "ok": true,
  "message": "Choice selected",
  "state_changed": true
}
```

---

## 7. Proceed

### `POST /action/proceed`

#### Request
```json
{}
```

#### Response
```json
{
  "ok": true,
  "message": "Proceeded",
  "state_changed": true
}
```

---

## 8. Cancel

### `POST /action/cancel`

#### Request
```json
{}
```

#### Response
```json
{
  "ok": true,
  "message": "Cancelled",
  "state_changed": true
}
```

---

## 9. Batch Actions (Phase 2)

### `POST /action/execute`

Not required for day-one prototype, but should be added early.

#### Request
```json
{
  "actions": [
    {"action": "play_card", "card_index": 1, "target_index": 1},
    {"action": "end_turn"}
  ]
}
```

#### Response
```json
{
  "ok": true,
  "executed": 2,
  "message": "Executed 2 actions"
}
```

#### Error Example
```json
{
  "ok": false,
  "executed": 1,
  "failed_at": 2,
  "error": "Action not available"
}
```

---

## Thread-Safety Model

- `GET /health`, `GET /state`, `GET /actions` are read-only.
- `POST /action/*` must enqueue state-changing work for main-thread execution.
- Only one state-changing action should execute at a time in the prototype.

---

## Response Rules

- Every response must include `ok`.
- On failure, include `error`.
- On success, include `message` where useful.
- Prefer explicit errors over silent no-ops.

---

## Recommended First External Test

Order of operations:
1. `GET /health`
2. `GET /state`
3. choose first playable card
4. `POST /action/play_card`
5. `GET /state`
6. `POST /action/end_turn`

If this works, the bridge is viable.
