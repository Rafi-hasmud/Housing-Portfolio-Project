
SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing;

--Standardize DATE format--
SELECT SaleDateConverted, CONVERT (Date, SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing;


Update NashvilleHousing
Set SaleDate = Convert(date, SaleDate);

ALTER TABLE NashvilleHousing
ADD SaleDateConverted date;

UPDATE NashvilleHousing
SET SaleDateConverted = Convert(date,Saledate);



 --Populate Property Address Data

SELECT *
From PortfolioProject.dbo.NashvilleHousing
WHERE PropertyAddress IS NULL
ORDER BY ParcelID


SELECT a.[UniqueID ], b.[UniqueID ], a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
ON a.ParcelID=b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
ON a.ParcelID=b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL



--Breaking Out Address into individual Columns (Adress, City, State)


SELECT PropertyAddress
From PortfolioProject.dbo.NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertySplitAddress varchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertSplitCity varchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertSplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing


SELECT OwnerAddress
FROM PortfolioProject.dbo.NashvilleHousing


SELECT 
Parsename(Replace(OwnerAddress, ',', '.'), 3),
Parsename(Replace(OwnerAddress, ',', '.'), 2),
Parsename(Replace(OwnerAddress, ',', '.'), 1)
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OwnerSplitAddress varchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress = Parsename(Replace(OwnerAddress, ',', '.'), 3)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OwnerSplitCity varchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitCity = Parsename(Replace(OwnerAddress, ',', '.'), 2)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OwnerSplitState varchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitState = Parsename(Replace(OwnerAddress, ',', '.'), 1)

Select *
FROM PortfolioProject.dbo.NashvilleHousing



--Change Y and N to YES and NO in "Sold as Vacant" Field

Select DISTINCT SoldAsVacant, COUNT (SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
     ELSE SoldAsVacant 
	 END
FROM PortfolioProject.dbo.NashvilleHousing


UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
     ELSE SoldAsVacant 
	 END



--REMOVE duplicates 

WITH RowNumCTE AS (
Select *,
     ROW_Number() Over(
	 Partition By ParcelId,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  Order By
				          UniqueID) row_num
FROM PortfolioProject.dbo.NashvilleHousing
--Order By ParcelID
)
DELETE FROM RowNumCTE
WHERE row_num > 1
--Order By PropertyAddress



--DELETE Unused Columns

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COlumn OwnerAddress, TaxDistrict, PropertyAddress
