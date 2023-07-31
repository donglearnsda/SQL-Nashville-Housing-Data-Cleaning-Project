/*

Cleaning Data in SQL Queries

*/

SELECT * FROM dbo.[Nashville Housing]
ORDER BY [UniqueID ]


/* Checking DATA TYPE OF COLUMNS IN the TABLE */
SELECT * FROM INFORMATION_SCHEMA.COLUMNS


/* PERFORM CLEANING TECHNIQUES */

/* STANDARDIZE DATE FORMAT: from DATETIME to DATE
ColumnName: SaleDate to SaleDateConverted */

ALTER TABLE dbo.[Nashville Housing]
ADD SaleDateConverted DATE	-- create column SaleDateConverted

UPDATE dbo.[Nashville Housing]
SET SaleDateConverted = CONVERT(DATE, SaleDate)	-- convert the data type and transfer result to new column

SELECT
	SaleDate,
	SaleDateConverted
FROM dbo.[Nashville Housing]	-- compare old vs new columns


/* POPULATE PROPERTY ADDRESS DATA */

SELECT PropertyAddress FROM dbo.[Nashville Housing]
WHERE PropertyAddress IS NULL	-- many null values in this column

SELECT * FROM dbo.[Nashville Housing]
ORDER BY ParcelID	-- there are many duplicated values in columns 'ParcelID' and 'PropertyAddress'

-- we have one column 'PropertyAddress' with all NULL vales and one with values
SELECT
	a.ParcelID,
	b.ParcelID,
	a.PropertyAddress,
	b.PropertyAddress
FROM dbo.[Nashville Housing] a
JOIN dbo.[Nashville Housing] b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL	

-- We're going to copy data from second PropertyAddress column to the first one
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM dbo.[Nashville Housing] a
JOIN dbo.[Nashville Housing] b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


/* BREAKING OUT PropertyAddress INTO INDIVIDUAL COLUMNS (CITY, ADDRESS) */
SELECT PropertyAddress FROM dbo.[Nashville Housing]

SELECT
	-- The value for 'Address' column will be taken before the comma
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS PropertySplitAddress,
	-- The value for 'City' column will be taken after the comma
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS PropertySplitCity
FROM dbo.[Nashville Housing]

-- Create columns 'PropertySplitAddress' and 'PropertySplitCity'
ALTER TABLE dbo.[Nashville Housing]
ADD PropertySplitAddress NVARCHAR(50), PropertySplitCity NVARCHAR(50)

-- Update value for columns 'PropertySplitAddress' and 'PropertySplitCity'
UPDATE dbo.[Nashville Housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1),
	PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

SELECT * FROM dbo.[Nashville Housing]



/* BREAKING OUT OwnerAddress INTO INDIVIDUAL COLUMNS (STATE, CITY, ADDRESS) */

SELECT * FROM dbo.[Nashville Housing]

SELECT
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS OwnerSplitAddress,
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS OwnerSplitCity,
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS OwnerSplitState
FROM dbo.[Nashville Housing]

-- Create columns 'OwnerSplitAddress', 'OwnerSplitCity', 'OwnerSplitState'
ALTER TABLE dbo.[Nashville Housing]
ADD	OwnerSplitAddress NVARCHAR(50),
	OwnerSplitCity NVARCHAR(50),
	OwnerSplitState NVARCHAR(50)

-- Update value for 3 columns
UPDATE dbo.[Nashville Housing]
SET	OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
	OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
	OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT * FROM dbo.[Nashville Housing]



/* STANDARDIZE COLUMN SoldAsVacant: Change value 'Yes' and 'No' to 'Y' and 'N' */

-- Count the distinct value of column SoldAsVacant
SELECT 
	DISTINCT(SoldAsVacant),
	COUNT(SoldAsVacant)
FROM dbo.[Nashville Housing]
GROUP BY SoldAsVacant
ORDER BY 2;

-- Use CASE Expression
SELECT
	SoldAsVacant,
	CASE
		WHEN SoldAsVacant = 'Yes' THEN 'Y'
		WHEN SoldAsVacant = 'No' THEN 'N'
		ELSE SoldAsVacant
	END
FROM dbo.[Nashville Housing]

-- Update result for the column SoldAsVacant
UPDATE dbo.[Nashville Housing]
SET	SoldAsVacant = 
	CASE
		WHEN SoldAsVacant = 'Yes' THEN 'Y'
		WHEN SoldAsVacant = 'No' THEN 'N'
		ELSE SoldAsVacant
	END

SELECT SoldAsVacant FROM dbo.[Nashville Housing]



/* CHECK AND REMOVE DUPLICATED VALUES */

WITH RowNumCTE AS (
SELECT
	*,
	ROW_NUMBER() OVER (
	PARTITION BY
				ParcelID,
				PropertyAddress,
				SaleDate,
				SalePrice,
				LegalReference
	ORDER BY [UniqueID]) AS row_num
FROM dbo.[Nashville Housing]
)

DELETE  
FROM RowNumCTE
WHERE RowNumCTE.row_num > 1 -- Then double checking for duplicated values
-- ORDER BY RowNumCTE.PropertyAddress




/* REMOVE UNUSED COLUMNS (NOT ENCOURAGE) */

--ALTER TABLE PortfolioProject_NashvilleHousing.dbo.NashvilleHousing
--DROP COLUMN
--	PropertyAddress,
--	SaleDate,
--	OwnerAddress;

SELECT *
FROM dbo.[Nashville Housing]

