/*

Cleaning Data in SQL Queries

*/


SELECT * 
FROM PortfolioProject..NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select *
From PortfolioProject..NashvilleHousing


Alter Table NashvilleHousing
Add SaleDateUpdated date

Update NashvilleHousing
Set SaleDateUpdated = CONVERT(Date, SaleDate)







-------------------------------------------------------------------------------------------------------------------------

--Populate Property Address Data

Select *
From PortfolioProject..NashvilleHousing
--Where PropertyAddress is NULL
Order By 2,4


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL( a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null


Update a
Set PropertyAddress =  ISNULL( a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null




SELECT * 
FROM PortfolioProject..NashvilleHousing




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


--Using LEFT and RIGHT Functions

Select PropertyAddress, 
Left(PropertyAddress, Charindex(',',PropertyAddress)-1) as Address1,
Right(PropertyAddress, LEN(PropertyAddress)- Charindex(',',PropertyAddress)) as Address2
From PortfolioProject..NashvilleHousing



-- Using SUBSTRING


Select PropertyAddress,
SUBSTRING(PropertyAddress,1,Charindex(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,Charindex(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address
From PortfolioProject..NashvilleHousing


Alter Table NashvilleHousing
Add PropertySplitAddress nvarchar(255)

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1,Charindex(',',PropertyAddress)-1) 


Alter Table NashvilleHousing
Add PropertySplitCity nvarchar(255)

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress,Charindex(',',PropertyAddress)+1, LEN(PropertyAddress))



--Owner Address

Select OwnerAddress
From PortfolioProject..NashvilleHousing
Where OwnerAddress is NOT NULL



Select PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From PortfolioProject..NashvilleHousing
--Where OwnerAddress is NOT NULL


Alter Table NashvilleHousing
Add OwnerSplitAddress nvarchar(255)

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter Table NashvilleHousing
Add OwnerSplitCity nvarchar(255)

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)


Alter Table NashvilleHousing
Add OwnerSplitState nvarchar(255)

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)




SELECT * 
FROM PortfolioProject..NashvilleHousing








--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field



Select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group By SoldAsVacant
Order By 2





Select SoldAsVacant,
CASE
	WHEN SoldAsVacant = 'y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END
From PortfolioProject..NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE
			WHEN SoldAsVacant = 'y' THEN 'Yes'
			WHEN SoldAsVacant = 'N' THEN 'No'
			ELSE SoldAsVacant
		   END



SELECT * 
FROM PortfolioProject..NashvilleHousing





-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

With RowNumCTE AS
(
Select *, ROW_NUMBER() 
OVER (Partition By ParcelID,
		   PropertyAddress,
		   SaleDate,
		   SalePrice,
		   LandValue,
		   LegalReference
		   Order By
		       UniqueID
		   ) row_num

From PortfolioProject..NashvilleHousing
--Order By ParcelID
)
Select *
From RowNumCTE
Where row_num >1



SELECT * 
FROM PortfolioProject..NashvilleHousing





---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select * 
From PortfolioProject..NashvilleHousing


Alter Table PortfolioProject..NashvilleHousing
Drop Column OwnerAddress, SaleDate, PropertyAddress, TaxDistrict















-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------



















