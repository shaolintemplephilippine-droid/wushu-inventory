-- 财务报表支持：为入库/出库记录添加金额字段
-- stock_in.amount  = 购买金额（支出，php）
-- stock_out.amount = 收款金额（php，未收款时为应收金额）
ALTER TABLE stock_in ADD COLUMN IF NOT EXISTS amount NUMERIC NOT NULL DEFAULT 0;
ALTER TABLE stock_out ADD COLUMN IF NOT EXISTS amount NUMERIC NOT NULL DEFAULT 0;

COMMENT ON COLUMN stock_in.amount IS '购买金额（支出，php）';
COMMENT ON COLUMN stock_out.amount IS '收款金额（php）';