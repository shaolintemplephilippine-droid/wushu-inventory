-- 期初库存表
-- 用于记录每批盘点后留下的上批剩余库存
-- 应余 = 期初库存 + 入库量 - 出库量
CREATE TABLE IF NOT EXISTS opening_stock (
  type TEXT NOT NULL,
  size TEXT NOT NULL,
  qty INTEGER NOT NULL CHECK (qty >= 0),
  date DATE NOT NULL,
  operator TEXT NOT NULL,
  note TEXT,
  updated_at TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (type, size)
);

-- 启用 RLS
ALTER TABLE opening_stock ENABLE ROW LEVEL SECURITY;

-- 已认证用户可全权限访问共享库存
CREATE POLICY "authenticated_full_access_opening_stock"
  ON opening_stock FOR ALL TO authenticated
  USING (true) WITH CHECK (true);

-- service_role 与 authenticated 权限
GRANT SELECT, INSERT, UPDATE, DELETE ON opening_stock TO service_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON opening_stock TO authenticated;
