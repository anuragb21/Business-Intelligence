drop table DimLocation
CREATE TABLE dimLocation
(
dimLocationKey int IDENTITY (1,1) PRIMARY KEY,
Address nvarchar (255),
City nvarchar (255),
PostalCode nvarchar (255),
StateProvince nvarchar (255) ,
Country nvarchar (255) ,
/*PRIMARY KEY (dimLocationKey) identity (1,1),*/
);

drop table dbo.DimStore
CREATE TABLE [dbo].[DimStore](
	[dimStoreKey] [int] identity (1,1) not NULL,
	[dimLocationKey] [int] not NULL,
	[StoreName] [nvarchar](255) NULL,
	[StoreNumber] int NULL,
	[StoreManager] [nvarchar](255) NULL,
	PRIMARY KEY (dimStoreKey),
	constraint FK_Dim_DimStore_DimLocationKey FOREIGN KEY (dimLocationKey) References dimLocation,
) ON [PRIMARY]


drop table DimReseller
Truncate table
alter table dbo.DimReseller drop constraint FK_Dim_DimReseller_DimLocationKey
CREATE TABLE [dbo].[DimReseller](
	[dimResellerKey] [int] identity (1,1) not NULL,
	[dimLocationKey] int not NULL,
	ResellerID [nvarchar] (255) NULL,
	ResellerName [nvarchar](255) NULL,
	ContactName [nvarchar](255) NULL,
	PhoneNumber nvarchar (255) NULL,
	Email [nvarchar](255) NULL,
	PRIMARY KEY (dimResellerKey),
	Constraint FK_Dim_DimReseller_DimLocationKey Foreign key (dimLocationKey) references dimLocation,
) ON [PRIMARY]

INSERT INTO dbo.DimReseller
(
dimLocationKey,
ResellerID,
ResellerName,
ContactName,
PhoneNumber,
Email
)
SELECT 
DL.dimLocationKey,
SR.ResellerID,
SR.ResellerName,
SR.Contact,
SR.PhoneNumber,
SR.EmailAddress
FROM Staging_Reseller SR
INNER JOIN DimLocation DL
ON SR.Address = DL.Address



drop table DimCustomer
alter table DimCustomer drop constraint FK_Dim_DimCustomer_DimLocationKey
CREATE TABLE [dbo].[DimCustomer](
	[dimCustomerKey] [int] IDENTITY (1,1) not NULL,
	[dimLocationKey] int not NULL,
	CustomerID [nvarchar] (255) NULL,
	CustomerFullName [nvarchar](255) NULL,
	CustomerFirstName [nvarchar](255) NULL,
	CustomerLastName [nvarchar](255) NULL,
	CustomerGender [nvarchar](255) NULL,
	PRIMARY KEY (dimCustomerKey),
	constraint FK_Dim_DimCustomer_DimLocationKey Foreign key (dimLocationKey) references dimLocation,
) ON [PRIMARY]

INSERT INTO dbo.DimCustomer
(
dimLocationKey,
CustomerID,
CustomerFullName,
CustomerFirstName,
CustomerLastName,
CustomerGender
)
SELECT
DL.dimLocationKey,
SC.CustomerID,
SC.FirstName + SC.LastName,
SC.FirstName,
SC.LastName,
SC.Gender
FROM Staging_Customer SC
INNER JOIN DimLocation DL
ON SC.Address = DL.Address

drop table DimChannel
CREATE TABLE [dbo].[DimChannel](
	[dimChannelKey] [int] IDENTITY (1,1) not NULL,
	ChannelID nvarchar(255) null,
	ChannelName [nvarchar](255) NULL,
	ChannelCategory [nvarchar](255) NULL,
	ChannelCategoryID nvarchar (255) null,
	PRIMARY KEY (dimChannelKey),
) ON [PRIMARY]

INSERT INTO dbo.DimChannel
(
ChannelID,
ChannelName,
ChannelCategory,
ChannelCategoryID
)
SELECT SC.ChannelID, SC.Channel, SCC.ChannelCategory, SCC.ChannelCategoryID
FROM Staging_Channel SC
INNER JOIN Staging_ChannelCategory SCC
ON SC.ChannelCategoryID = SCC.ChannelCategoryID


drop table factSalesTarget
CREATE TABLE [dbo].[factSalesTarget](
	factSalesTargetKey identity (100,1) int not null,
	dimStoreKey int not null,
	dimResellerKey int not null,
	dimChannelKey int not null,
	dimTargetDateKey int not null,
	SalesTargetAmount int not null,
	PRIMARY KEY (factSalesTargetKey),
	Foreign key (dimStoreKey) references dimStore,
	Foreign key (dimResellerKey) references dimReseller,
	Foreign key (dimChannelKey) references dimChannel,
	Foreign key (dimTargetDateKey) references dimDate (dimDateID)
	)

drop table factSalesActual
	CREATE TABLE [dbo].[factSalesActual](
	factSalesActualKey int not null,
	dimProductKey int not null,
	dimStoreKey int not null,
	dimResellerKey int not null,
	dimChannelKey int not null,
	dimSaleDateKey int not null,
	SaleAmount int,
	SaleQuantity int,
	SalePrice int,
	SaleCost int,
	SaleProfit int,
	PRIMARY KEY (factSalesActualKey),
	Foreign key (dimProductKey) references DimProduct,
	Foreign key (dimStoreKey) references dimStore,
	Foreign key (dimResellerKey) references dimReseller,
	Foreign key (dimChannelKey) references dimChannel,
	Foreign key (dimSaleDateKey) references dimDate (dimDateID)
	)


	CREATE TABLE [dbo.Staging_Customer] (
    [CustomerID] uniqueidentifier,
    [SubSegmentID] int,
    [FirstName] nvarchar(255),
    [LastName] nvarchar(255),
    [Gender] nvarchar(1),
    [EmailAddress] nvarchar(255),
    [Address] nvarchar(255),
    [City] nvarchar(255),
    [StateProvince] nvarchar(255),
    [Country] nvarchar(255),
    [PostalCode] nvarchar(255),
    [PhoneNumber] nvarchar(20),
    [CreatedDate] datetime,
    [CreatedBy] nvarchar(255),
    [ModifiedDate] datetime,
    [ModifiedBy] nvarchar(255)
)

