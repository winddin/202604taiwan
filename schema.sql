-- ============================================================
-- Taiwan Trip 2026 — Supabase Schema v2
-- Schema: 202604taiwan
-- Run full script from scratch (idempotent)
-- ============================================================

CREATE SCHEMA IF NOT EXISTS "202604taiwan";

-- SESSIONS
CREATE TABLE IF NOT EXISTS "202604taiwan".sessions (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  device_id   TEXT        UNIQUE NOT NULL,
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  last_active TIMESTAMPTZ DEFAULT NOW()
);

-- CHECKLIST_PROGRESS (pre-trip prep, item_key: "0"-"33")
CREATE TABLE IF NOT EXISTS "202604taiwan".checklist_progress (
  session_id  UUID        NOT NULL REFERENCES "202604taiwan".sessions(id) ON DELETE CASCADE,
  item_key    TEXT        NOT NULL,
  checked     BOOLEAN     NOT NULL DEFAULT FALSE,
  checked_at  TIMESTAMPTZ,
  PRIMARY KEY (session_id, item_key)
);

-- MUSTDO_PROGRESS (bucket list, item_key: "f1"-"f15", "e1"-"e12", "s1"-"s5", "c1"-"c8")
CREATE TABLE IF NOT EXISTS "202604taiwan".mustdo_progress (
  session_id  UUID        NOT NULL REFERENCES "202604taiwan".sessions(id) ON DELETE CASCADE,
  item_key    TEXT        NOT NULL,
  checked     BOOLEAN     NOT NULL DEFAULT FALSE,
  checked_at  TIMESTAMPTZ,
  PRIMARY KEY (session_id, item_key)
);

-- DAY_TASKS (editable per-day checklist)
-- day_key: "day1"-"day8" | id: client-generated string
CREATE TABLE IF NOT EXISTS "202604taiwan".day_tasks (
  id          TEXT        NOT NULL,
  session_id  UUID        NOT NULL REFERENCES "202604taiwan".sessions(id) ON DELETE CASCADE,
  day_key     TEXT        NOT NULL,
  task_text   TEXT        NOT NULL,
  checked     BOOLEAN     NOT NULL DEFAULT FALSE,
  sort_order  INTEGER     NOT NULL DEFAULT 0,
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (session_id, id)
);

-- BOOKING_LINKS (per-day booking URLs)
-- link_type: "flight" | "hotel" | "transport" | "ticket" | "tour" | "permit" | "other"
CREATE TABLE IF NOT EXISTS "202604taiwan".booking_links (
  id          TEXT        NOT NULL,
  session_id  UUID        NOT NULL REFERENCES "202604taiwan".sessions(id) ON DELETE CASCADE,
  day_key     TEXT        NOT NULL,
  link_type   TEXT        NOT NULL DEFAULT 'other',
  label       TEXT        NOT NULL,
  url         TEXT        NOT NULL DEFAULT '',
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (session_id, id)
);

-- RLS
ALTER TABLE "202604taiwan".sessions              ENABLE ROW LEVEL SECURITY;
ALTER TABLE "202604taiwan".checklist_progress    ENABLE ROW LEVEL SECURITY;
ALTER TABLE "202604taiwan".mustdo_progress       ENABLE ROW LEVEL SECURITY;
ALTER TABLE "202604taiwan".day_tasks             ENABLE ROW LEVEL SECURITY;
ALTER TABLE "202604taiwan".booking_links         ENABLE ROW LEVEL SECURITY;

DO $$ BEGIN
  DROP POLICY IF EXISTS "anon_all" ON "202604taiwan".sessions;
  DROP POLICY IF EXISTS "anon_all" ON "202604taiwan".checklist_progress;
  DROP POLICY IF EXISTS "anon_all" ON "202604taiwan".mustdo_progress;
  DROP POLICY IF EXISTS "anon_all" ON "202604taiwan".day_tasks;
  DROP POLICY IF EXISTS "anon_all" ON "202604taiwan".booking_links;
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

CREATE POLICY "anon_all" ON "202604taiwan".sessions              FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "anon_all" ON "202604taiwan".checklist_progress    FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "anon_all" ON "202604taiwan".mustdo_progress       FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "anon_all" ON "202604taiwan".day_tasks             FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "anon_all" ON "202604taiwan".booking_links         FOR ALL USING (true) WITH CHECK (true);

-- INDEXES
CREATE INDEX IF NOT EXISTS idx_sessions_device       ON "202604taiwan".sessions (device_id);
CREATE INDEX IF NOT EXISTS idx_cl_session            ON "202604taiwan".checklist_progress (session_id);
CREATE INDEX IF NOT EXISTS idx_md_session            ON "202604taiwan".mustdo_progress (session_id);
CREATE INDEX IF NOT EXISTS idx_tasks_session_day     ON "202604taiwan".day_tasks (session_id, day_key);
CREATE INDEX IF NOT EXISTS idx_bookings_session_day  ON "202604taiwan".booking_links (session_id, day_key);

-- VERIFY:
-- SELECT table_name FROM information_schema.tables
-- WHERE table_schema = '202604taiwan' ORDER BY table_name;
-- Expected: booking_links, checklist_progress, day_tasks, mustdo_progress, sessions
