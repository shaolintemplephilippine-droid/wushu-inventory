-- 武术服库存管理系统的共享数据表
-- 所有已登录用户都可以读写（共享库存）

-- 入库记录
CREATE TABLE IF NOT EXISTS stock_in (
  id BIGSERIAL PRIMARY KEY,
  type TEXT NOT NULL,
  size TEXT NOT NULL,
  date DATE NOT NULL,
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  operator TEXT NOT NULL,
  note TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 出库 / 领取记录
CREATE TABLE IF NOT EXISTS stock_out (
  id BIGSERIAL PRIMARY KEY,
  student TEXT NOT NULL,
  type TEXT NOT NULL,
  size TEXT NOT NULL,
  date DATE NOT NULL,
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  paid BOOLEAN DEFAULT false,
  payment_method TEXT,
  operator TEXT NOT NULL,
  note TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 实际盘点数量
CREATE TABLE IF NOT EXISTS actual_counts (
  type TEXT NOT NULL,
  size TEXT NOT NULL,
  qty INTEGER NOT NULL CHECK (qty >= 0),
  date DATE NOT NULL,
  operator TEXT NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (type, size)
);

-- 启用 RLS
ALTER TABLE stock_in ENABLE ROW LEVEL SECURITY;
ALTER TABLE stock_out ENABLE ROW LEVEL SECURITY;
ALTER TABLE actual_counts ENABLE ROW LEVEL SECURITY;

-- 已认证用户可全权限访问共享库存
CREATE POLICY "authenticated_full_access_stock_in"
  ON stock_in FOR ALL TO authenticated
  USING (true) WITH CHECK (true);

CREATE POLICY "authenticated_full_access_stock_out"
  ON stock_out FOR ALL TO authenticated
  USING (true) WITH CHECK (true);

CREATE POLICY "authenticated_full_access_actual_counts"
  ON actual_counts FOR ALL TO authenticated
  USING (true) WITH CHECK (true);

-- service_role 也需要表级权限（Edge Function 用）
GRANT SELECT, INSERT, UPDATE, DELETE ON stock_in TO service_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON stock_out TO service_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON actual_counts TO service_role;

-- 给 authenticated 用户表级权限
GRANT SELECT, INSERT, UPDATE, DELETE ON stock_in TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON stock_out TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON actual_counts TO authenticated;

-- 序列权限
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO authenticated;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO service_role;
