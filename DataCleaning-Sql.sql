
------Cleaning Data in Sql Queries

Select*
from NashvilleHousingData

--Sandardize Date Format

Select SaledateConverted
from NashvilleHousingData

--Steps

update NashvilleHousingData
set SaleDate = Convert(Date, SaleDate)

Alter table NashvilleHousingData
add SaleDateConverted date

update NashvilleHousingData
set SaleDateConverted = Convert(Date, SaleDate)


--Populate Property Address Data

select *
from [Portfolio Project]..nashvillehousingdata
where Propertyaddress is null

--Steps

select a.parcelID, a.propertyaddress, b.parcelID, b.propertyaddress, isnull(a.propertyaddress, b.propertyaddress)
from [Portfolio Project]..nashvillehousingdata as A
join [Portfolio Project]..nashvillehousingdata as B
on a.parcelID = B.parcelID AND 
   a.UniqueID <> b.uniqueid
where a.propertyaddress is null

 update A
 set PropertyAddress = isnull(a.propertyaddress, b.propertyaddress)
 from [Portfolio Project]..nashvillehousingdata as A
join [Portfolio Project]..nashvillehousingdata as B
on a.parcelID = B.parcelID AND 
   a.UniqueID <> b.uniqueid
 where a.propertyaddress is null


 --Breaking out Property/Owner Address into Individual Columns (Address, City, State)

 Select propertyaddress, SUBSTRING(propertyaddress, 1,  CHARINDEX(',', propertyaddress)-1) as Property_Address, 
 substring(PropertyAddress, CHARINDEX(',', propertyaddress)+1, len(propertyaddress)) as Property_City
 from [Portfolio Project]..nashvillehousingdata
 order by 1

 --Property_Address

 alter table [Portfolio Project]..nashvillehousingdata
 add Property_Address nvarchar(255)

 update [Portfolio Project]..nashvillehousingdata
 set Property_Address = SUBSTRING(propertyaddress, 1,  CHARINDEX(',', propertyaddress)-1)

 --Property_City

 alter table [Portfolio Project]..nashvillehousingdata
 add Property_City nvarchar(255)

 update [Portfolio Project]..nashvillehousingdata
 set Property_City = substring(PropertyAddress, CHARINDEX(',', propertyaddress)+1, len(propertyaddress))

 Select *
 from [Portfolio Project]..nashvillehousingdata

 --OwnerAddress

 Select owneraddress
 from [Portfolio Project]..nashvillehousingdata
 where OwnerAddress is not null

Select owneraddress,
parsename(replace(owneraddress, ',','.'),3) Address,
parsename(replace(owneraddress, ',','.'),2) City,
parsename(replace(owneraddress, ',','.'),1) State
from [Portfolio Project]..nashvillehousingdata
where OwnerAddress is not null

--Owner_Add

alter table [Portfolio Project]..nashvillehousingdata
 add Owner_Add nvarchar(255)

 update [Portfolio Project]..nashvillehousingdata
 set  Owner_Add = parsename(replace(owneraddress, ',','.'),3)

 --Owner_City

 alter table [Portfolio Project]..nashvillehousingdata
 add Owner_City nvarchar(255)

 update [Portfolio Project]..nashvillehousingdata
 set  Owner_City = parsename(replace(owneraddress, ',','.'),2)

 --Owner_State

 alter table [Portfolio Project]..nashvillehousingdata
 add Owner_State nvarchar(255)

 update [Portfolio Project]..nashvillehousingdata
 set  Owner_State = parsename(replace(owneraddress, ',','.'),1)

 Select *
 from [Portfolio Project]..nashvillehousingdata


 --Change Y & N to Yes and No in "Sold as Vacante" field

 select distinct(SoldAsVacant)
 from [Portfolio Project]..nashvillehousingdata
 order by 1

 select SoldAsVacant,
 case
 when SoldAsVacant = 'N' then 'No' 
 when SoldAsVacant = 'Y' then 'Yes'
 else SoldAsVacant
 end 
 from [Portfolio Project]..nashvillehousingdata

 update [Portfolio Project]..nashvillehousingdata
 set SoldAsVacant = case
 when SoldAsVacant = 'N' then 'No' 
 when SoldAsVacant = 'Y' then 'Yes'
 else SoldAsVacant
 end 
 from [Portfolio Project]..nashvillehousingdata

 
 --Remove Duplicates

 Select *, 
 ROW_NUMBER() over (partition by Parcelid,
 Propertyaddress, 
 saleprice, 
 Legalreference order by UniqueId) Row_Num
 from [Portfolio Project]..nashvillehousingdata

 with Row_NumCTE AS(
 Select *, 
 ROW_NUMBER() over (partition by Parcelid,
 Propertyaddress, 
 saleprice, 
 Legalreference order by UniqueId) Row_Num
 from [Portfolio Project]..nashvillehousingdata
 )
Delete 
from Row_NumCTE
where Row_Num = 2


--Delete Unused Columns

Select *
from [Portfolio Project]..nashvillehousingdata

Alter table [Portfolio Project]..nashvillehousingdata
drop column saledate, taxdistrict, saledateconverted5
