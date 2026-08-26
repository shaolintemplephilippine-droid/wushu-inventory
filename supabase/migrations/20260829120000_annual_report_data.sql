-- Annual/monthly income & expense report: shared cloud data store.
-- Single-row JSONB table: public report page (index.html) reads it anonymously,
-- the editor (edit.html) requires a logged-in account to write.

CREATE TABLE IF NOT EXISTS annual_report_data (
  id INT PRIMARY KEY,
  data JSONB NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE annual_report_data ENABLE ROW LEVEL SECURITY;

-- Public report page can read without login
DROP POLICY IF EXISTS "annual_report_public_read" ON annual_report_data;
CREATE POLICY "annual_report_public_read" ON annual_report_data
  FOR SELECT TO anon, authenticated USING (true);

-- Only logged-in users can modify the report data
DROP POLICY IF EXISTS "annual_report_authenticated_insert" ON annual_report_data;
CREATE POLICY "annual_report_authenticated_insert" ON annual_report_data
  FOR INSERT TO authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "annual_report_authenticated_update" ON annual_report_data;
CREATE POLICY "annual_report_authenticated_update" ON annual_report_data
  FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "annual_report_authenticated_delete" ON annual_report_data;
CREATE POLICY "annual_report_authenticated_delete" ON annual_report_data
  FOR DELETE TO authenticated USING (true);

GRANT SELECT ON annual_report_data TO anon, authenticated;
GRANT INSERT, UPDATE, DELETE ON annual_report_data TO authenticated;

-- Seed with the report data currently embedded in the page
INSERT INTO annual_report_data (id, data, updated_at)
VALUES (1, '{"year":2026,"updatedAt":1787485893220,"expenseCats":["水费","电费","网费","团体工资","房租","保姆工资","保安工资"],"incomeCats":["功德箱","武术学费"],"months":[{"label":"1月","expenses":{"水费":15409.11,"电费":29069.61,"网费":1899,"团体工资":330000,"房租":250000,"保姆工资":14500,"保安工资":33000},"income":{"功德箱":46230,"武术学费":348500}},{"label":"2月","expenses":{"水费":17646,"电费":25976,"网费":1899,"团体工资":330000,"房租":250000,"保姆工资":15000,"保安工资":32000},"income":{"功德箱":40000,"武术学费":53000}},{"label":"3月","expenses":{"水费":0,"电费":31541.76,"网费":1899,"团体工资":330000,"房租":250000,"保姆工资":15000,"保安工资":30000},"income":{"功德箱":72300,"武术学费":152000}},{"label":"4月","expenses":{"水费":6000,"电费":42742,"网费":1899,"团体工资":400000,"房租":250000,"保姆工资":15000,"保安工资":33000},"income":{"功德箱":65820,"武术学费":183500}},{"label":"5月","expenses":{"水费":8000,"电费":60493,"网费":1899,"团体工资":400000,"房租":250000,"保姆工资":10500,"保安工资":33393.33},"income":{"功德箱":61400,"武术学费":314800}},{"label":"6月","expenses":{"水费":6000,"电费":57798.26,"网费":1899,"团体工资":400000,"房租":250000,"保姆工资":15000,"保安工资":33000},"income":{"功德箱":58200,"武术学费":348525}},{"label":"7月","expenses":{"水费":0,"电费":0,"网费":0,"团体工资":0,"房租":0,"保姆工资":0,"保安工资":0},"income":{"功德箱":0,"武术学费":0}}]}'::jsonb, to_timestamp(1787485893220 / 1000.0))
ON CONFLICT (id) DO NOTHING;
