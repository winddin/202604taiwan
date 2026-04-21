-- ============================================================
-- Taiwan Trip 2026 — Supabase Schema
-- Schema: 202604taiwan
-- Run this in Supabase SQL Editor
-- ============================================================

-- 1. Create schema
CREATE SCHEMA IF NOT EXISTS "202604taiwan";

-- ============================================================
-- 2. SESSIONS
-- One row per device (identified by a random device_id stored
-- in the browser's localStorage). All other tables reference
-- this via session_id (UUID).
-- ============================================================
CREATE TABLE "202604taiwan".sessions (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  device_id   TEXT        UNIQUE NOT NULL,
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  last_active TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 3. CHECKLIST_PROGRESS
-- Pre-trip preparation checklist items.
-- item_key: numeric string matching data-cl attributes in HTML
--   e.g. "0", "1", "2" ... "32"
-- ============================================================
CREATE TABLE "202604taiwan".checklist_progress (
  session_id  UUID        NOT NULL REFERENCES "202604taiwan".sessions(id) ON DELETE CASCADE,
  item_key    TEXT        NOT NULL,
  checked     BOOLEAN     NOT NULL DEFAULT FALSE,
  checked_at  TIMESTAMPTZ,
  PRIMARY KEY (session_id, item_key)
);

-- ============================================================
-- 4. DAYCHECKLIST_PROGRESS
-- Per-day preparation checklists (e.g. N4 day prep).
-- item_key: matches data-dc attributes in HTML
--   e.g. "d4_1", "d4_2" ... "d4_10"
-- ============================================================
CREATE TABLE "202604taiwan".daychecklist_progress (
  session_id  UUID        NOT NULL REFERENCES "202604taiwan".sessions(id) ON DELETE CASCADE,
  item_key    TEXT        NOT NULL,
  checked     BOOLEAN     NOT NULL DEFAULT FALSE,
  checked_at  TIMESTAMPTZ,
  PRIMARY KEY (session_id, item_key)
);

-- ============================================================
-- 5. MUSTDO_PROGRESS
-- Taiwan must-do / bucket list items.
-- item_key: matches data-md attributes in HTML
--   e.g. "f1"-"f15" (food), "e1"-"e12" (experience),
--        "s1"-"s5" (shopping), "c1"-"c8" (culture)
-- ============================================================
CREATE TABLE "202604taiwan".mustdo_progress (
  session_id  UUID        NOT NULL REFERENCES "202604taiwan".sessions(id) ON DELETE CASCADE,
  item_key    TEXT        NOT NULL,
  checked     BOOLEAN     NOT NULL DEFAULT FALSE,
  checked_at  TIMESTAMPTZ,
  PRIMARY KEY (session_id, item_key)
);

-- ============================================================
-- 6. ROW LEVEL SECURITY
-- Enable RLS on all tables. Policy: anon users can read and
-- write their own rows (matched via session_id from sessions).
-- Since we use anon key only, we allow all operations.
-- For production with auth, tighten these policies.
-- ============================================================
ALTER TABLE "202604taiwan".sessions             ENABLE ROW LEVEL SECURITY;
ALTER TABLE "202604taiwan".checklist_progress   ENABLE ROW LEVEL SECURITY;
ALTER TABLE "202604taiwan".daychecklist_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE "202604taiwan".mustdo_progress      ENABLE ROW LEVEL SECURITY;

-- Allow anon access (static site, no auth)
CREATE POLICY "anon_all" ON "202604taiwan".sessions
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "anon_all" ON "202604taiwan".checklist_progress
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "anon_all" ON "202604taiwan".daychecklist_progress
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "anon_all" ON "202604taiwan".mustdo_progress
  FOR ALL USING (true) WITH CHECK (true);

-- ============================================================
-- 7. INDEXES (for query performance)
-- ============================================================
CREATE INDEX ON "202604taiwan".checklist_progress    (session_id);
CREATE INDEX ON "202604taiwan".daychecklist_progress (session_id);
CREATE INDEX ON "202604taiwan".mustdo_progress       (session_id);
CREATE INDEX ON "202604taiwan".sessions              (device_id);

-- ============================================================
-- DONE. Verify with:
-- SELECT table_name FROM information_schema.tables
-- WHERE table_schema = '202604taiwan';
-- ============================================================
