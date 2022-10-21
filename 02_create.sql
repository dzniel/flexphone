create database FlexPhone
use FlexPhone

create table Staff (
  staff_id char(5),
  staff_name varchar(50) not null,
  staff_email varchar(50) not null,
  staff_dob date not null,
  staff_gender varchar(10) not null,
  staff_phone varchar(20) not null,
  staff_address varchar(50) not null,
  staff_salary int not null

  constraint PK_Staff
    primary key(staff_id),

  constraint CHECK_staff_id
    check(staff_id like 'ST[0-9][0-9][0-9]'),
  constraint CHECK_staff_email
    check(staff_email like '%@bluejack.com' or staff_email like '%@sunib.edu'),
  constraint CHECK_staff_dob
    check(year(staff_dob) >= 1960),
  constraint CHECK_staff_gender
    check(staff_gender in ('Male', 'Female'))
)

create table Vendor (
  vendor_id char(5),
  vendor_name varchar(50) not null,
  vendor_email varchar(50) not null, 
  vendor_phone varchar(20) not null,
  vendor_address varchar(50) not null,

  constraint PK_Vendor
    primary key(vendor_id),

  constraint CHECK_vendor_id
    check(vendor_id like 'VE[0-9][0-9][0-9]'),
  constraint CHECK_vendor_email
    check(vendor_email like '%@bluejack.com' or vendor_email like '%@sunib.edu')
)

create table Customer (
  customer_id char(5),
  customer_name varchar(50) not null,
  customer_email varchar(50) not null,
  customer_dob date not null,
  customer_gender varchar(10) not null,
  customer_phone varchar(20) not null,
  customer_address varchar(50) not null,

  constraint PK_Customer
    primary key(customer_id),
  
  constraint CHECK_customer_id
    check(customer_id like 'CU[0-9][0-9][0-9]'),
  constraint CHECK_customer_name
    check(len(customer_name) >= 3),
  constraint CHECK_customer_email
    check(customer_email like '%@bluejack.com' or customer_email like '%@sunib.edu'),
  constraint CHECK_customer_gender
    check(customer_gender in ('Male', 'Female'))
)

create table PhoneBrand (
  brand_id char(5),
  brand_name varchar(50) not null,

  constraint PK_PhoneBrand
    primary key(brand_id),

  constraint CHECK_brand_id
    check(brand_id like 'PB[0-9][0-9][0-9]')
)

create table Phone (
  phone_id char(5),
  brand_id char(5) not null,
  phone_name varchar(50) not null,
  phone_price int not null,

  constraint PK_Phone
    primary key(phone_id),
  constraint FK_Phone
    foreign key(brand_id)
    references PhoneBrand(brand_id)
    on update cascade
    on delete cascade,
  
  constraint CHECK_phone_id
    check(phone_id like 'PO[0-9][0-9][0-9]'),
  constraint CHECK_Phone_brand_id
    check(brand_id like 'PB[0-9][0-9][0-9]'),
  constraint CHECK_phone_price
    check(phone_price between 100000 and 40000000)
)

create table Sales (
  sales_id char(5),
  staff_id char(5) not null,
  customer_id char(5) not null,
  sales_date date not null,

  constraint PK_Sales
    primary key(sales_id),
  constraint FK_Sales_staff_id
    foreign key(staff_id)
    references Staff(staff_id)
    on update cascade
    on delete cascade,
  constraint FK_Sales_customer_id
    foreign key(customer_id)
    references Customer(customer_id)
    on update cascade 
    on delete cascade,

  constraint CHECK_sales_id
    check(sales_id like 'SH[0-9][0-9][0-9]'),
  constraint CHECK_Sales_staff_id
    check(staff_id like 'ST[0-9][0-9][0-9]'),
  constraint CHECK_Sales_customer_id
    check(customer_id like 'CU[0-9][0-9][0-9]')
)

create table SalesDetail (
  sales_id char(5),
  phone_id char(5),
  quantity int not null,

  constraint CK_SalesDetail
    primary key(sales_id, phone_id),
  constraint FK_SalesDetail_sales_id
    foreign key(sales_id)
    references Sales(sales_id)
    on update cascade
    on delete cascade,
  constraint FK_SalesDetail_phone_id
    foreign key(phone_id)
    references Phone(phone_id)
    on update cascade
    on delete cascade,

  constraint CHECK_SalesDetail_sales_id
    check(sales_id like 'SH[0-9][0-9][0-9]'),
  constraint CHECK_SalesDetail_phone_id
    check(phone_id like 'PO[0-9][0-9][0-9]')
)

create table Purchase (
  purchase_id char(5),
  staff_id char(5) not null,
  vendor_id char(5) not null,
  purchase_date date not null,

  constraint PK_Purchase
    primary key(purchase_id),
  constraint FK_Purchase_staff_id
    foreign key(staff_id)
    references Staff(staff_id)
    on update cascade
    on delete cascade,
  constraint FK_Purchase_vendor_id
    foreign key(vendor_id)
    references Vendor(vendor_id)
    on update cascade
    on delete cascade,

  constraint CHECK_purchase_id
    check(purchase_id like 'PH[0-9][0-9][0-9]'),
  constraint CHECK_Purchase_staff_id
    check(staff_id like 'ST[0-9][0-9][0-9]'),
  constraint CHECK_Purchase_vendor_id
    check(vendor_id like 'VE[0-9][0-9][0-9]')
)

create table PurchaseDetail (
  purchase_id char(5),
  phone_id char(5),
  quantity int not null,

  constraint CK_PurchaseDetail
    primary key(purchase_id, phone_id),
  constraint FK_PurchaseDetail_purchase_id
    foreign key(purchase_id)
    references Purchase(purchase_id)
    on update cascade
    on delete cascade,
  constraint FK_PurchaseDetail_phone_id
    foreign key(phone_id)
    references Phone(phone_id)
    on update cascade
    on delete cascade,

  constraint CHECK_PurchaseDetail_purchase_id
    check(purchase_id like 'PH[0-9][0-9][0-9]'),
  constraint CHECK_PurchaseDetail_phone_id
    check(phone_id like 'PO[0-9][0-9][0-9]')
)