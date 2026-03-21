# STS2 State Schema Draft

## Purpose

This document defines the first structured state payload for the STS2 agent bridge.
The goal is not full coverage on day one. The goal is a stable, minimal schema that is sufficient for:
- reading combat state
- selecting playable actions
- ending turns
- handling simple choice screens

---

## Top-Level Shape

```json
{
  "ok": true,
  "timestamp": "2026-03-21T22:50:00+08:00",
  "screen_type": "COMBAT",
  "room_phase": "COMBAT",
  "in_combat": true,
  "can_proceed": false,
  "can_cancel": false,
  "can_end_turn": true,
  "player": {},
  "hand": [],
  "monsters": [],
  "choices": []
}
```

---

## Common Fields

- `ok`: bool
- `timestamp`: ISO datetime string
- `screen_type`: current screen type, e.g. `COMBAT`, `CARD_REWARD`, `MAP`, `EVENT`, `SHOP`, `REST`, `BOSS_REWARD`
- `room_phase`: coarse room phase
- `in_combat`: bool
- `can_proceed`: bool
- `can_cancel`: bool
- `can_end_turn`: bool

---

## Player

```json
{
  "hp": 63,
  "max_hp": 80,
  "block": 0,
  "energy": 3,
  "gold": 99,
  "class": "IRONCLAD",
  "stance": null,
  "powers": [
    {
      "id": "Strength",
      "name": "Strength",
      "amount": 2
    }
  ]
}
```

### Required in prototype
- `hp`
- `max_hp`
- `block`
- `energy`

### Optional early fields
- `gold`
- `class`
- `stance`
- `powers`

---

## Hand

```json
[
  {
    "index": 1,
    "id": "Strike",
    "name": "Strike",
    "cost": 1,
    "upgraded": false,
    "is_playable": true,
    "requires_target": true,
    "ethereal": false,
    "exhaust": false,
    "type": "ATTACK",
    "rarity": "BASIC"
  }
]
```

### Required in prototype
- `index`
- `id`
- `name`
- `cost`
- `is_playable`
- `requires_target`

### Optional later fields
- `upgraded`
- `ethereal`
- `exhaust`
- `type`
- `rarity`
- `description`

---

## Monsters

```json
[
  {
    "index": 1,
    "id": "JawWorm",
    "name": "Jaw Worm",
    "hp": 42,
    "max_hp": 42,
    "block": 0,
    "intent": "ATTACK",
    "intent_value": 11,
    "is_dead": false,
    "powers": []
  }
]
```

### Required in prototype
- `index`
- `name`
- `hp`
- `block`
- `intent`
- `is_dead`

### Optional later fields
- `id`
- `max_hp`
- `intent_value`
- `powers`

---

## Choices

Used for non-combat decision screens.

```json
[
  {
    "index": 1,
    "type": "card_reward",
    "label": "Pommel Strike"
  },
  {
    "index": 2,
    "type": "skip",
    "label": "Skip"
  }
]
```

### Required in prototype
- `index`
- `label`

### Optional later fields
- `type`
- `payload`

---

## Extended Sections for Later Phases

These should not block the prototype but should be planned for:

### Deck State
- `draw_pile`
- `discard_pile`
- `exhaust_pile`

### Inventory
- `relics`
- `potions`

### Map State
- current node
- reachable nodes
- node metadata

### Rewards / Shop / Event State
- structured choices with ids and categories

---

## Stability Rules

- Keep field names stable once introduced.
- Prefer explicit booleans over inferred meaning.
- Prefer compact state for fast polling.
- Add optional fields instead of changing meanings.
- If a field is unknown, return `null` instead of omitting it where possible.

---

## Prototype Minimum Contract

The bridge is considered usable when `/state` always returns:
- common top-level fields
- player hp / max_hp / block / energy
- hand with playable metadata
- monsters with targetable metadata in combat
- choices on choice screens

That is enough to let an external agent:
- play a card
- target an enemy
- end turn
- choose a reward
- proceed to next screen
