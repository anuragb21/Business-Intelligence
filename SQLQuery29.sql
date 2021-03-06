Select DP.dimProductKey, DP.ProductID, DP.ProductTypeID, DP.ProfitMarginPerc,
SD.SalesQuantity, SD.SalesAmount, SD.ProductID, SH.SalesHeaderID, SD.SalesDetailID,
SH.StoreID, SH.ResellerID, SH.Date,
case when DS.dimStoreKey is null then -1 else DS.dimStoreKey end,
case when DR.dimResellerKey is null then -1 else DR.dimResellerKey end,
DC.dimChannelKey,
DD.DimDateID
from dbo.DimProduct DP
inner join dbo.Staging_SalesDetail SD
on DP.ProductID = SD.ProductID
inner join dbo.Staging_SalesHeader SH
on SH.SalesHeaderID = SD.SalesHeaderID
left join dbo.DimStore DS
on DS.StoreID = SH.StoreID
left join dbo.DimReseller DR
on cast(DR.ResellerID As nvarchar(255)) = CAST(SH.ResellerID AS nvarchar(255))
left join dbo.DimChannel DC
on DC.ChannelID = SH.ChannelID
left join dbo.DimDate DD
on DD.FullDate = SH.Date




Select case when DS.dimStoreKey is null then -1 else DS.dimStoreKey end,
case when DR.dimResellerKey is null then -1 else DR.dimResellerKey end,
DC.dimChannelKey,
DD.DimDateID
from dbo.DimProduct DP
inner join dbo.Staging_SalesDetail SD
on DP.ProductID = SD.ProductID
inner join dbo.Staging_SalesHeader SH
on SH.SalesHeaderID = SD.SalesHeaderID
left join dbo.DimStore DS
on DS.StoreID = SH.StoreID
left join dbo.DimReseller DR
on cast(DR.ResellerID As nvarchar(255)) = CAST(SH.ResellerID AS nvarchar(255))
left join dbo.DimChannel DC
on DC.ChannelID = SH.ChannelID
left join dbo.DimDate DD
on DD.FullDate = SH.Date



select * from factSalesTarget
alter table dbo.factSalesTarget
drop column SalesTargetAmount
Insert into dbo.factSalesTarget
(
	[dimStoreKey]
      ,[dimResellerKey]
      ,[dimChannelKey]
      ,[dimTargetDateKey]
)
Select 
case when DS.dimStoreKey is null then -1 else DS.dimStoreKey end as dimStoreKey,
case when DR.dimResellerKey is null then -1 else DR.dimResellerKey end as dimResellerKey,
case when DC.dimChannelKey is null then -1 else DC.dimChannelKey end as dimChannelKey,
DD.dimDateID
from dbo.Staging_Target ST
left join dbo.DimStore DS
on 'Store Number ' + cast((DS.StoreNumber) as nvarchar(50)) = ST.Target
left join dbo.DimReseller DR
on DR.ResellerName = ST.Target
left join dbo.DimChannel DC
on DC.ChannelName = ST.Target
inner join dbo.DimDate DD
on ST.Year = DD.CalendarYear where DD.DayNumberOfMonth = 1