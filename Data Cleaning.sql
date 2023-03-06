SELECT *
FROM NashVilleHousing

--Change of SaleDate

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM NashVilleHousing

update NashVilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashVilleHousing
Add SaleDateConverted Date;

update NashVilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

---------------------------------------------------------------------------

--Populate Property Address data

SELECT * 
FROM NashVilleHousing
--WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashVilleHousing a
JOIN NashVilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null

update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashVilleHousing a
JOIN NashVilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null

--DOUBLE CHECKING
SELECT * 
FROM NashVilleHousing
WHERE PropertyAddress is null
ORDER BY ParcelID
---------------------------------------------------------------------

--Breaking out the Address into Individual Columns (Address, city, state)

SELECT PropertyAddress
FROM NashVilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as Address
FROM NashVilleHousing

--Get rid of that comma
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
FROM NashVilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress +1), LEN(PropertyAddress)) as Address
FROM NashVilleHousing

--ANOTHER WAY OF DOING THIS SAME THING (by using PARSENAME, PARSENAME ONLY LOOKS FOR '.' NOT ',')

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM NashVilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
FROM NashVilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM NashVilleHousing

--UPDATE THE TABLE
ALTER TABLE NashVilleHousing
Add OwnerSplitAddress Nvarchar(255)

update NashVilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

ALTER TABLE NashVilleHousing
Add OwnerSplitCity Nvarchar(255)

update NashVilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE NashVilleHousing
Add OwnerSplitState Nvarchar(255)

update NashVilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

-----------------------------------------------------------------------------------------
--Change Y and N to Yes and No in "Sold as Vacant" field

SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM NashVilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
 FROM NashVilleHousing

 update NashVilleHousing
 SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
FROM NashVilleHousing
----------------------------------------------------------------------------------
--Remove Duplicate

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	 PARTITION BY	ParcelID,
					PropertyAddress,
					SalePrice,
					LegalReference
					ORDER BY
					UniqueID
					) row_num
FROM NashVilleHousing
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress


WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	 PARTITION BY	ParcelID,
					PropertyAddress,
					SalePrice,
					LegalReference
					ORDER BY
					UniqueID
					) row_num
FROM NashVilleHousing
)
DELETE
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress
---------------------------------------------------------------------------------

--Delete unused column

Select *
FROM NashVilleHousing

LTER TABLE NashVilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE NashVilleHousing
DROP COLUMN SaleDate
