# SQL-Nashville-Housing-Data-Quality-Assessment
The Nashville Housing project is about cleaning a real estate dataset for Nashville market by standardizing data formats, removing duplicates, and improving data completeness.
1. About Project
- The dataset contained information about property sales, rentals, and other real estate transactions in Nashville Housing market.
- Data source: https://www.kaggle.com/datasets/tmthyjames/nashville-housing-data
- Technologies used: MS SQL Server Management

2. Project Planning & Aim Grid:
- Main purpose:
  - Applying data cleaning and normalizing techniques, make the dataset became more consistent, complete, and usable for further analysis.
- Stakeholders:
  - Real estate professionals
  - Investors
  - Anyyone interested
- Success Criteria:
  - The dataset will be more standardized, consistent and usable for further analysis.
  - Users, managers, investors can analyze quality and reliability dataset to identify trends, patterns, and insights about the Nashville Housing real estate market.
- Setup process:
  - Step 1: Collect data from above source
  - Step 2: Import data to SSMS to perform cleaning techniques
  - Step 3: Export cleaned data to .xlsx file
  
3. Problem statement:
- Standardize Date format
- Populate Property Address data
- Breaking out PropertyAddress, OwnerAddress into individual columns (Address, City)
- Add Individual columns (Address, City), (Address, City, State) to the table
- Change values 'Y' and 'N' to 'Yes' and 'No' in SoldAsVacant column
- Checking for duplicated rows
- Remove Duplicates
- Remove Unused columns (if required)



4. Finished products
- SQL (MS SSMS) queries (uploaded file)
- Cleaned dataset in .xlsx file (uploaded file)


