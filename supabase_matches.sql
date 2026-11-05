-- DIIR MATCH — جدول البحث عن خصم / فريق (Supabase PostgreSQL)
-- نفّذ هذا الملف في SQL Editor داخل مشروع Supabase.

CREATE TABLE IF NOT EXISTS open_matches (
  id TEXT PRIMARY KEY,
  field_id TEXT,
  field_name TEXT,
  creator_id BIGINT,
  creator_name TEXT,
  creator_phone TEXT,
  match_date DATE,
  match_time TEXT,
  kind TEXT DEFAULT 'opponent',
  note TEXT,
  status TEXT DEFAULT 'open',
  created_at BIGINT,
  booking_id TEXT,
  expires_at BIGINT,
  auto_cancel BOOLEAN DEFAULT FALSE,
  matched_by BIGINT
);

CREATE INDEX IF NOT EXISTS idx_open_matches_status_date
  ON open_matches (status, match_date);

CREATE INDEX IF NOT EXISTS idx_open_matches_booking
  ON open_matches (booking_id);

ALTER TABLE open_matches ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS open_matches_read ON open_matches;
CREATE POLICY open_matches_read ON open_matches
  FOR SELECT USING (true);

DROP POLICY IF EXISTS open_matches_write ON open_matches;
CREATE POLICY open_matches_write ON open_matches
  FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS open_matches_update ON open_matches;
CREATE POLICY open_matches_update ON open_matches
  FOR UPDATE USING (true);
