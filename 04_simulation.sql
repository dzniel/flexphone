use FlexPhone

begin tran

  -- Scenario : Staff ST002 completed a transaction with Vendor VE001
  -- Date     : 2021-12-26
  insert into Purchase values
  ('PH016','ST002','VE001','2021-12-26')

  -- Staff ST002 bought 10 Samsung Galaxy Z Fold4 & 5 VIVO V25 from the Vendor 
  insert into PurchaseDetail values
  ('PH016','PO001',10),
	('PH016','PO002',5)

rollback
-- or
commit tran

begin tran

  -- Scenario : Customer CU003 bought some phones from Staff ST002
  -- Date     : 2021-12-28
  insert into Sales values
  ('SH016','ST002','CU003', '2021-12-28')

  -- Customer CU003 bought a Samsung Galaxy Z Fold4 & a Vivo V25
  insert into SalesDetail values
  ('SH016','PO001',1),
	('SH016','PO002',1)

rollback
-- or
commit tran
