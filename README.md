# 🇹🇼 202604taiwan — Taiwan Trip Planner 2026

Interactive trip planner for 8-day Taiwan trip (25/04–02/05/2026).  
Built as a single-file HTML app with Supabase for persistent storage.

## ✈️ Trip Overview

| # | Date | City | Highlights |
|---|------|------|------------|
| N1 | 25/04 Sat | Taipei | Arrival · Ximending |
| N2 | 26/04 Sun | Taipei | 101 · Yongkang · Elephant Mt · Raohe |
| N3 | 27/04 Mon | New Taipei | Yehliu · Jiufen · Shifen · Ningxia |
| N4 | 28/04 Tue | Hualien | TRA East Coast ✅ · Taroko · Motorbike |
| N5 | 29/04 Wed | Hualien | Qixingtan · Shakadang · Tiaoshi Coast |
| N6 | 30/04 Thu | Taichung | Miyahara · Rainbow Village · Gaomei · Fengjia |
| N7 | 01/05 Fri | Taipei | HSR back · Beitou/Tamsui · Shilin |
| N8 | 02/05 Sat | — | Departure CI-783 13:45 |

## 🗂️ Repo Structure

```
202604taiwan/
├── index.html              # Main app (single file, all-in-one)
├── supabase/
│   └── schema.sql          # Supabase DB schema to run once
├── vercel.json             # Vercel static deployment config
├── .gitignore
└── README.md
```

## 🛠️ Setup

### 1. Supabase (Database)

1. Go to [supabase.com](https://supabase.com) → your project
2. Open **SQL Editor**
3. Paste and run `supabase/schema.sql`
4. Verify: `SELECT table_name FROM information_schema.tables WHERE table_schema = '202604taiwan';`

The app is pre-configured with:
- **Project URL**: `https://wvabjrxyymhpdpvuswfr.supabase.co`
- **Schema**: `202604taiwan`
- **Tables**: `sessions`, `checklist_progress`, `daychecklist_progress`, `mustdo_progress`

### 2. Deploy to Vercel

```bash
# Install Vercel CLI
npm i -g vercel

# Clone repo
git clone https://github.com/YOUR_USERNAME/202604taiwan
cd 202604taiwan

# Deploy
vercel --prod
```

Or connect repo directly at [vercel.com](https://vercel.com) → Import Git Repository.

### 3. Local Development

Just open `index.html` in a browser. Supabase sync works from any origin.

```bash
# Optional: serve locally
npx serve .
# or
python3 -m http.server 8080
```

## 🗄️ Database Schema

```
sessions              — One row per device (device_id in localStorage)
  id          UUID PK
  device_id   TEXT UNIQUE
  created_at  TIMESTAMPTZ
  last_active TIMESTAMPTZ

checklist_progress    — Pre-trip preparation items
daychecklist_progress — Per-day prep items (e.g. N4 day checklist)
mustdo_progress       — Taiwan must-do bucket list (42 items)
  session_id  UUID FK → sessions.id
  item_key    TEXT    (matches data-cl/data-dc/data-md in HTML)
  checked     BOOLEAN
  checked_at  TIMESTAMPTZ
```

## 📱 Features

- **Interactive map** (Leaflet/OpenStreetMap) — per-day routes, clickable rank badges
- **Day-by-day itinerary** — 8 tabs with timeline, photo spots, food recommendations
- **Photo Spots** — expand/collapse per location with Google Maps links
- **Food Recommendations** — expand/collapse per day with Google Maps links
- **Pre-trip Checklist** — synced to Supabase
- **Day Checklist** — N4-specific prep (motorbike, permit, etc.)
- **Must-Do List** — 42 items across Food / Experience / Shopping / Culture
- **Hotel recommendations** — Budget / Mid-range / Airbnb per city
- **Budget tracker** — per-day spending breakdown
- **Top 20 ranking** — sortable table, click to zoom map
- **Bilingual** — Vietnamese + English + 漢字 for all locations
- **Supabase sync** — progress persists across devices via device fingerprint
- **localStorage fallback** — works offline if Supabase unavailable

## 🔑 Credentials

> **Do not commit real API keys to public repos.**  
> The current keys are in `index.html` — move them to environment variables for production.

For a public repo, replace the keys in `index.html`:
```js
const SUPA_URL = process.env.SUPABASE_URL || 'YOUR_URL';
const SUPA_KEY = process.env.SUPABASE_KEY || 'YOUR_KEY';
```
Then set them in Vercel dashboard → Settings → Environment Variables.

## ✈️ Key Booking References

| Route | Train | Booking Code | Date |
|-------|-------|-------------|------|
| Taipei → Hualien | Tze-Chiang 472 | `6684500` | 28/04 08:40 |
| Car 12, Seat 32/34/36 | 3 adults | 1,749 TWD paid | — |

## 👥 Passengers

- Gia Bao — FMGKXZ
- Hoài Thanh + Quỳnh Hương — DW9ZY2

---

*Built with HTML/CSS/JS + Leaflet + Supabase*
