# Housing-Portfolio-Project

# Data Cleaning By SQL

```sql
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
```

 - The first query retrieves all the columns and rows from the "NashvilleHousing" table within the "PortfolioProject" database. 
This query can be useful to review the overall data and familiarize oneself with the columns and values in the dataset.
 - The second query standardizes the date format of the "SaleDate" column in the "NashvilleHousing" table. 
 This is important because having a standardized format can simplify analysis and enable time-based queries to be executed efficiently.
 - The third query updates the "SaleDate" column to the newly standardized format. 
 This ensures that all dates in the column are consistent and can be properly analyzed.
 - The fourth query adds a new column called "SaleDateConverted" to the "NashvilleHousing" table with a date data type. 
 This column will hold the standardized date format, allowing for more accurate and efficient analysis.
 - Finally, the fifth query populates the "SaleDateConverted" column with the standardized 
 date format by converting the existing "SaleDate" values using the "Convert" function. 
 
 
 Overall, these queries can be used to standardize date formats in the dataset, ensuring consistency and enabling efficient analysis.

----------------------------------------------------------------------------------
 
```sql
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
```

 - The first query retrieves all the rows and columns from the "NashvilleHousing" table in the "PortfolioProject" database 
 where the "PropertyAddress" column is null. This can be useful to identify incomplete data and ensure that all records have complete address information.
 - The second query uses a self-join to compare records with the same ParcelID but different UniqueID values. 
 It then selects the ParcelID and PropertyAddress columns from both records and populates a new column called 
 "ISNULL(a.PropertyAddress, b.PropertyAddress)" with the non-null value of the PropertyAddress column. 
 This can be useful for populating missing PropertyAddress values using data from other records with the same ParcelID.
 - The third query updates the "PropertyAddress" column for records where the PropertyAddress is null and uses the ISNULL function 
 to populate the missing value with data from other records with the same ParcelID. This ensures that all records have complete address information 
 and can be properly analyzed.
 
 
Overall, these queries can be useful for identifying and correcting incomplete or missing address data in the dataset, 
ensuring completeness and accuracy in the analysis.

----------------------------------------------------------------------------------

```sql
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
```

These SQL queries are used to split the address column in the NashvilleHousing table of the PortfolioProject database into separate columns 
for address, city, and state. 
 - The first set of queries use the SUBSTRING and CHARINDEX functions to extract the address and city information 
from the PropertyAddress column, then update the table with the new columns. 
 - The second set of queries use the PARSENAME and REPLACE functions 
to split the OwnerAddress column into separate columns for address, city, and state.

The reason for splitting the address column into separate columns is to make the data more usable and organized for analysis. 
This allows for easier filtering and sorting by address, city, and state. Additionally, splitting the OwnerAddress column allows 
for analysis of owner information at a more granular level.

----------------------------------------------------------------------------------

```sql
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
```
 - The first query provides a count of unique values in the "SoldAsVacant" field of the NashvilleHousing table to understand the distribution of the values.
 - The second query changes the values of 'Y' and 'N' in the "SoldAsVacant" field to 'Yes' and 'No', respectively, 
 and leaves all other values unchanged using a CASE statement.
 - The third query updates the NashvilleHousing table with the updated values in the "SoldAsVacant" field.
 
The reason to use this for a project is to standardize the data in the "SoldAsVacant" field and make it more meaningful for analysis. 
This would help in making more accurate decisions based on the data.

----------------------------------------------------------------------------------

```sql
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
```
 - This query uses a common table expression (CTE) with the ROW_NUMBER() function to assign a unique row number to each row in the table, 
based on a specified partition and order. The partition is determined by the values in the columns ParcelId, PropertyAddress, SalePrice, SaleDate, 
and LegalReference. The order is based on the UniqueID column.
 - The DELETE statement then removes any rows where the row number is greater than 1, effectively deleting all duplicate rows from the table.
 
Removing duplicates is an important step in data cleaning and analysis to ensure that each observation in the dataset is unique and accurate. 
By removing duplicates, we can eliminate any potential errors or inconsistencies in the data that could affect the analysis and insights gained from it.

----------------------------------------------------------------------------------

```sql
--DELETE Unused Columns

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COlumn OwnerAddress, TaxDistrict, PropertyAddress
```
This query is used to delete unused columns from the table NashvilleHousing in the PortfolioProject database. 
 - The SELECT * statement is used to view all the columns in the table before the alteration is made. 
 - The ALTER TABLE statement is used to modify the structure of the table by dropping the columns OwnerAddress, TaxDistrict, and PropertyAddress. 
 
These columns were identified as unused and can be safely deleted from the table without impacting the data analysis.
Removing unused columns can help to reduce the storage size of the table and improve query performance by reducing the amount of data that needs to be scanned during query execution. Additionally, it can simplify the data schema, making it easier to understand and work with.
