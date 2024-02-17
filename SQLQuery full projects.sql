select * from master.dbo.Sheet1$;
select SaleDate, convert(Date, SaleDate) as Date
from dbo.Sheet1$

update dbo.Sheet1$
set SaleDate=convert(Date, SaleDate)


alter table dbo.Sheet1$
add SaleDateConverted Date
update dbo.Sheet1$
set SaleDateConverted=convert(Date, SaleDate)

select * from dbo.Sheet1$
alter table dbo.Sheet1$ drop column SaleDate

-----

select *from dbo.Sheet1$
--where PropertyAddress is nulloredr
order by ParcelID
---
select *from dbo.Sheet1$
where PropertyAddress is null


select a.ParcelID, a.PropertyAddress, b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress) d
from dbo.Sheet1$ a
join dbo.Sheet1$ b
    on b.ParcelID=a.ParcelID
	and b.UniqueID<> a.UniqueID
	

update a
set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
from dbo.Sheet1$ a
join dbo.Sheet1$ b
    on b.ParcelID=a.ParcelID
	and b.UniqueID<> a.UniqueID
where a.PropertyAddress is null

select PropertyAddress from dbo.Sheet1$

select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Adrecess1,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1 ,LEN(PropertyAddress))
as Adrecess from dbo.Sheet1$

alter table dbo.Sheet1$
add PropertySplitAddresses nvarchar(250)

alter table dbo.Sheet1$
add PropertySplitCity nvarchar(250)


update dbo.Sheet1$
set PropertySplitAddresses=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 
--
update dbo.Sheet1$
set PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1 ,LEN(PropertyAddress)) 
--

select * from dbo.Sheet1$

alter table dbo.Sheet1$
drop column  PropertyAddress


select OwnerAddress from dbo.Sheet1$

select 
PARSENAME(replace(OwnerAddress,',','.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
from dbo.Sheet1$

alter table dbo.Sheet1$
add OwnerSplitCity nvarchar(250)
alter table dbo.Sheet1$
add OwnerSplitAddress nvarchar(250)
alter table dbo.Sheet1$
add OwnerSplitState nvarchar(250)

update dbo.Sheet1$
set OwnerSplitCity =PARSENAME(replace(OwnerAddress,',','.'),3)

update dbo.Sheet1$
set OwnerSplitAddress =PARSENAME(replace(OwnerAddress,',','.'),2)
update dbo.Sheet1$
set OwnerSplitState =PARSENAME(replace(OwnerAddress,',','.'),1)
 

 alter table dbo.Sheet1$
 drop column OwnerAddress


select SoldAsVacant,
 case when SoldAsVacant='N' then 'NO'
      when SoldAsVacant='Y' then 'YES'
	  else SoldAsVacant
	  end
  
from dbo.Sheet1$

update dbo.Sheet1$
set SoldAsVacant=
case when SoldAsVacant='N' then 'NO'
      when SoldAsVacant='Y' then 'YES'
	  else SoldAsVacant
	  end


--remove duplicated

with cte as (
select * ,
ROW_NUMBER() OVER(partition by OwnerName,
LegalReference,SalePrice,LandValue order by UniqueID)as rn
from dbo.Sheet1$ 

)
select * from cte
WHERE rn=1

