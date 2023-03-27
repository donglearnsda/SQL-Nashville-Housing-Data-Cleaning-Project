/*

Cleaning Data in SQL Queries

*/


SELECT *
FROM PortfolioProject_NashvilleHousing.dbo.NashvilleHousing
ORDER BY ParcelID asc;


-------------------------------------------------------------


-- Standardize Date format

SELECT 
	SaleDate,
	SaleDateConverted
FROM PortfolioProject_NashvilleHousing.dbo.NashvilleHousing;


ALTER TABLE dbo.NashvilleHousing
ADD SaleDateConverted DATE;


UPDATE PortfolioProject_NashvilleHousing.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(DATE,SaleDate);


SELECT 
	SaleDateConverted
FROM PortfolioProject_NashvilleHousing.dbo.NashvilleHousing;


-------------------------------------------------------------

-- Populate Property Address data

SELECT 
	PropertyAddress	
FROM PortfolioProject_NashvilleHousing.dbo.NashvilleHousing;

SELECT 
	a.ParcelID,
	a.PropertyAddress,
	b.ParcelID,
	b.PropertyAddress,
	ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject_NashvilleHousing.dbo.NashvilleHousing a
JOIN PortfolioProject_NashvilleHousing.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject_NashvilleHousing.dbo.NashvilleHousing a
JOIN PortfolioProject_NashvilleHousing.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;


-------------------------------------------------------------

-- Breaking out PropertyAddress into individual columns (Address, City)

SELECT
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS PropertySplitAddress,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS PropertySplitCity
FROM PortfolioProject_NashvilleHousing.dbo.NashvilleHousing;

-- Add Individual columns (Address, City) to the table

ALTER TABLE PortfolioProject_NashvilleHousing.dbo.NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE PortfolioProject_NashvilleHousing.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1);

ALTER TABLE PortfolioProject_NashvilleHousing.dbo.NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE PortfolioProject_NashvilleHousing.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));

-- Breaking out OwnerAddress into individual columns (Address, City, State)

SELECT
	PARSENAME(REPLACE(OwnerAddress,',','.'),3) AS OwnerSplitAddress,
	PARSENAME(REPLACE(OwnerAddress,',','.'),2) AS OwnerSplitCity,
	PARSENAME(REPLACE(OwnerAddress,',','.'),1) AS OwnerSplitState
FROM PortfolioProject_NashvilleHousing.dbo.NashvilleHousing;

-- Add Individual columns (Address, City, State) to the table

ALTER TABLE PortfolioProject_NashvilleHousing.dbo.NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE PortfolioProject_NashvilleHousing.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3);

ALTER TABLE PortfolioProject_NashvilleHousing.dbo.NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

UPDATE PortfolioProject_NashvilleHousing.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2);

ALTER TABLE PortfolioProject_NashvilleHousing.dbo.NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

UPDATE PortfolioProject_NashvilleHousing.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1);

SELECT
	OwnerSplitAddress,
	OwnerSplitCity,
	OwnerSplitState
FROM PortfolioProject_NashvilleHousing.dbo.NashvilleHousing;

-------------------------------------------------------------

-- Change values 'Y' and 'N' to 'Yes' and 'No' in SoldAsVacant column

SELECT 
	DISTINCT(SoldAsVacant),
	COUNT(SoldAsVacant)
FROM PortfolioProject_NashvilleHousing.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT
	SoldAsVacant,
	CASE 
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
	END
FROM PortfolioProject_NashvilleHousing.dbo.NashvilleHousing;

UPDATE PortfolioProject_NashvilleHousing.dbo.NashvilleHousing
SET SoldAsVacant = CASE 
						WHEN SoldAsVacant = 'Y' THEN 'Yes'
						WHEN SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
					END
;


-------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS (
SELECT
	*,
	ROW_NUMBER() OVER (
	PARTITION BY
				ParcelID,
				PropertyAddress,
				SalePrice,
				LegalReference
	ORDER BY [UniqueID ]) AS row_num
FROM PortfolioProject_NashvilleHousing.dbo.NashvilleHousing
)

DELETE
FROM RowNumCTE
WHERE row_num > 1;

-- Checking for duplicated rows

WITH RowNumCTE AS (
SELECT
	*,
	ROW_NUMBER() OVER (
	PARTITION BY
				ParcelID,
				PropertyAddress,
				SalePrice,
				LegalReference
	ORDER BY [UniqueID ]) AS row_num
FROM PortfolioProject_NashvilleHousing.dbo.NashvilleHousing
)

SELECT *
FROM RowNumCTE
WHERE row_num > 1;


-------------------------------------------------------------

-- !!!Remove Unused columns!!!

	--ALTER TABLE PortfolioProject_NashvilleHousing.dbo.NashvilleHousing
	--DROP COLUMN
	--			PropertyAddress,
	--			SaleDate,
	--			OwnerAddress;

	SELECT *
	FROM PortfolioProject_NashvilleHousing.dbo.NashvilleHousing






