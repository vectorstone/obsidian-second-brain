# Vault Schema Reference

## Recommended Folder Structure

```
Your Vault/
├── _CLAUDE.md                  ← Claude's operating manual for this vault
├── Home.md                     ← Dashboard with dataview queries
│
├── Daily/                      ← Daily notes (one per day)
├── Dev Logs/                   ← Technical work logs
├── Tasks/                      ← Standalone task notes
├── Projects/                   ← Project notes
├── People/                     ← One note per person
├── Boards/                     ← Kanban boards (Personal, Work, etc.)
│
├── Knowledge/                  ← Reference material, things learned
├── Learning/                   ← Books, courses, content consumed
├── Ideas/                      ← Idea captures
├── Content/                    ← Content calendar, drafts (LinkedIn, X, etc.)
│   ├── LinkedIn/
│   └── X/
│
├── Goals/                      ← Annual and life goals
├── Health/                     ← Health tracking
├── Finances/                   ← Monthly finance notes, subscriptions
│   └── Spending/
│
├── Jobs/                       ← Employment / contract roles
├── Businesses/                 ← Companies you own (founder)
├── Mentions/                   ← Times you've been mentioned or recognized
├── Reviews/                    ← Weekly / monthly reviews
├── Life Chapters/              ← Major life periods
│
├── Templates/                  ← Note templates (Templater plugin)
├── Faith/                      ← Personal spiritual notes (optional)
├── Partner/ (or Family/)       ← Personal relationship notes (optional)
│
└── _trash/                     ← Soft-deleted notes
```

---

## Frontmatter Schemas

### Daily Note
```yaml
---
date: 2026-03-24
tags:
  - daily
mood: 4          # 1-5 scale
energy: 3        # 1-5 scale
---
```

### Project Note
```yaml
---
date: 2026-03-24
tags:
  - project
status: active   # active | planning | completed | archived | on-hold
job: "[[Acme Corp]]"   # or Personal, [[Company Name]]
---
```

### Task Note
```yaml
---
date: 2026-03-24
tags:
  - task
status: in-progress   # in-progress | done | waiting | cancelled
project: "[[Project Name]]"
job: "[[Company]]"    # or Personal
requested_by: "[[Person Name]]"
due: 2026-03-28
---
```

### Person Note
```yaml
---
date: 2026-03-24
tags:
  - person
role: "Senior Engineer"
company: "[[Acme Corp]]"
relationship_strength: 3   # 1-5 scale
last_interaction: 2026-03-24
follow_up_date:
contact_email:
location:
---
```

### Dev Log
```yaml
---
date: 2026-03-24
tags:
  - devlog
project: "[[Project Name]]"
job: "[[Company]]"
---
```

### Deal (side business pattern, adapt as needed)
```yaml
---
date: 2026-03-24
tags:
  - deal
status: negotiating   # prospect | negotiating | confirmed | completed | lost
business: "Acme Tours"
pax: 20
revenue_best: 400
revenue_worst: 300
probability: 70
event_date: 2026-05-15
contact: "[[Person Name]]"
---
```

### Kanban Board
```yaml
---
kanban-plugin: board
---
```

### Finance Monthly
```yaml
---
date: 2026-03-01
tags:
  - monthly
  - finance
month: "2026-03"
---
```

### Goal
```yaml
---
date: 2026-01-01
tags:
  - goal
category: "career"   # career | health | financial | personal | relationship
status: active       # active | completed | paused | abandoned
progress: 35         # 0-100 integer
target_date: 2026-12-31
---
```

### Mention / Recognition
```yaml
---
date: 2026-03-24
tags:
  - mention
source: "Slack"    # Slack | Email | Meeting | LinkedIn | etc.
from: "[[Person Name]]"
context: "[[Project Name]]"
---
```

### Content Post
```yaml
---
date: 2026-03-24
tags:
  - content
platform: "LinkedIn"   # LinkedIn | X | Both
status: draft          # draft | scheduled | published
published_date:
---
```

---

## Naming Conventions

| Type | Pattern | Example |
|---|---|---|
| Daily note | `YYYY-MM-DD.md` | `2026-03-24.md` |
| Dev log | `YYYY-MM-DD — Description.md` | `2026-03-24 — API Gateway Debug.md` |
| Deal | `Contact - Description Month Year.md` | `Acme Corp - City Tour May 2026.md` |
| Task | Descriptive title | `Project Name — Feature.md` |
| Person | Full name | `Jane Smith.md` |
| Project | Proper name | `My Project Name.md` |
| Archive prefix | `_archived_` | `_archived_Old Project.md` |

---

## Dataview Query Patterns

### All active projects
```dataview
TABLE status, job FROM "Projects"
WHERE contains(tags, "project") AND status = "active"
SORT file.name ASC
```

### Recent daily notes
```dataview
TABLE date, mood, energy FROM "Daily"
SORT date DESC
LIMIT 7
```

### Active deals pipeline
```dataview
TABLE business, status, pax, revenue_best, probability
FROM "Side Biz/Deals"
WHERE status != "lost" AND status != "completed"
SORT probability DESC
```

### Tasks linked to a project (put inside project note)
```dataview
TABLE status, due FROM "Tasks"
WHERE contains(file.outlinks, this.file.link)
SORT date DESC
```

### Daily notes mentioning a person (put inside person note)
```dataview
LIST FROM "Daily"
WHERE contains(file.outlinks, this.file.link)
SORT date DESC
LIMIT 10
```
