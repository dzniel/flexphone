use FlexPhone

-- View Staff
select * from Staff
-- View Vendor
select * from Vendor
-- View Customer
select * from Customer
-- View PhoneBrand
select * from PhoneBrand
-- View Phone
select * from Phone
-- View Sales
select * from Sales
-- View SalesDetail
select * from SalesDetail
-- View Purchase
select * from Purchase
-- View PurchaseDetail
select * from PurchaseDetail

-- 1
select 
  'Customer' + right(c.customer_id, patindex('%[1-9][0A-Z]%', reverse(c.customer_id))) as [ID],
  c.customer_name,
  c.customer_gender,
  sum(p.phone_price * sd.quantity) as [Total Amount of Spending]
from Customer c
join Sales s on s.customer_id = c.customer_id
join SalesDetail sd on sd.sales_id = s.sales_id
join Phone p on p.phone_id = sd.phone_id
group by c.customer_id, c.customer_name, c.customer_gender

-- 2
select 
  st.staff_id as [Staff ID],
  left(st.staff_name, charindex(' ', st.staff_name)) as [Name],
  count(sa.sales_id) as [Customer Count]
from Staff st
join Sales sa on sa.staff_id = st.staff_id
join Customer c on c.customer_id = sa.customer_id 
where st.staff_name like '% %'
group by st.staff_id, st.staff_name

-- 3
select 
  'Customer' + right(c.customer_id, 1) as [Customer ID],
  c.customer_name as [Customer Name],
  pb.brand_name as [Phone Brand],
  sum(p.phone_price * sd.quantity) as [Total Spending]
from Customer c 
join Sales s on s.customer_id = c.customer_id
join SalesDetail sd on sd.sales_id = s.sales_id
join Phone p on p.phone_id = sd.phone_id 
join PhoneBrand pb on pb.brand_id = p.brand_id
where c.customer_name like '% %' and c.customer_id in (
  select s.customer_id
  from Sales s
  join SalesDetail sd on sd.sales_id = s.sales_id
  group by s.customer_id
  having count(sd.sales_id) > 3
)
group by c.customer_id, c.customer_name, pb.brand_name
order by c.customer_id

-- 4
select 
  st.staff_id as [Staff ID],
  stuff(st.staff_email, charindex('@', st.staff_email) + 1, len(st.staff_email) - charindex('@', st.staff_email), 'Ymail.com') as [Email],
  pb.brand_name as [Phone Brand],
  sum(p.phone_price * sd.quantity) as [Total Selling]
from Staff st
join Sales sa on sa.staff_id = st.staff_id
join SalesDetail sd on sd.sales_id = sa.sales_id
join Phone p on p.phone_id = sd.phone_id
join PhoneBrand pb on pb.brand_id = p.brand_id
where st.staff_id in (
  select s.staff_id
  from Sales s
  join SalesDetail sd on sd.sales_id = s.sales_id
  group by s.staff_id
  having count(distinct sd.phone_id) > 2
)
group by st.staff_id, st.staff_email, pb.brand_name
order by st.staff_id

-- 5
select 
  s.staff_email as [Staff Email],
  s.staff_gender as [Staff Gender],
  convert(varchar, s.staff_dob, 106) as [Date Of Birth],
  concat('Rp.', s.staff_salary, ',00.') as [Salary]
from Staff s
join (
  select avg(staff_salary) as [average_salary]
  from Staff
) as asl on s.staff_salary > asl.average_salary
where datediff(year, year(getdate()), s.staff_dob) >= 30

-- 6
select 
  s.staff_id,
  s.staff_name, 
  replace(s.staff_phone, '+62', '08') as [StaffPhone],
  ps.purchase_sum as [Total Selling]
from Staff s
join (
  select 
    s.staff_id,
    sum(p.phone_price * sd.quantity) as [purchase_sum]
  from Sales s
  join SalesDetail sd on sd.sales_id = s.sales_id 
  join Phone p on p.phone_id = sd.phone_id
  group by s.staff_id
) as ps on ps.staff_id = s.staff_id
where ps.purchase_sum between 10000000 and 100000000

-- 7
select 
  'Staff No' + right(s.staff_id, patindex('%[1-9][0A-Z]%', reverse(s.staff_id))) as [Staff No],
  s.staff_name,
  stuff(s.staff_email, charindex('@', s.staff_email) + 1, len(s.staff_email) - charindex('@', s.staff_email), 'gmail.com') as [Email],
  convert(varchar, s.staff_dob, 103) as [Date Of Birth],
  cc.customer_count as [Customer Count]
from Staff s
join (
  select 
    s.staff_id, 
    count(distinct s.customer_id) as [customer_count]
  from Sales s
  group by s.staff_id
) as cc on cc.staff_id = s.staff_id
where cc.customer_count = (
  select max(cc.customer_count) as [max_customer_count]
  from (
    select 
      s.staff_id, 
      count(distinct s.customer_id) as [customer_count]
    from Sales s
    group by s.staff_id
  ) as cc
)

-- 8
