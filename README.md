## Inspecting and Wrangling the Fifa 21 Data using SQL

<center>
    <img src="https://cdn.spaziogames.it/storage/wp/old-images/2020/06/fifa-21logo.jpg?width=898">
</center>

## Description
Welcome to the FIFa 21 Data cleaning excess. the raw data for this project was very dity ad required extensive cleaning.
Data Cleaning is one of the core stages for any data enthusisast before the data can be used for analysis or even creating an ML model.
It ensures that the insights o models generated are accurate and not influenced by any inconsistencies, errors or dirtiness tied to the data. The data used in this project was sourced from 
[Kaggle](https://www.kaggle.com/datasets/yagunnersya/fifa-21-messy-raw-dataset-for-cleaning-exploring) It contains the details of football players alongside their performance, updated up till 2021. After aalysing the data carefully, I found there were several issues with it.

## Issues Identified
- Null Values
- Inconsistent values
- Incoorect data types
- Deplicate values
- Spellings and value errors
- Irrerevant data

## steps taken during data cleaning
- Update the Height and Weight column for consistencies
- Update the Contract column delimiter, create new columns for contract status, Contract Start and End Year, and populate them with data from the Contract column for categorization and status purposes. As a result, we will have columns such as Contract Status, which will include those with active contracts, on loan players, and free agents, as well as Contract Start and End Year.
- Adding a new column for loan status (not on loan, on loan, and free) rather than loan end date, while populating the Contract end year column with dates written in text at loan end date for loan players so we know which year loan contracts expire.
- Cleaning Columns written as € and M, K and changing there column names to describe them properly.
- Removing the ‘★’ and other unwanted characters from the columns that have them.
- Use player names at the player url column to update the long name. Check if there are duplicates, change column names accordingly for consistency and neatness.
- Ensure all columns are put in the right data type format and drop all irrelevant columns.

## Conclusion
Cleaning the FIFA 21 data was a bit challenging. Despite the challenges encountered, the messy dataset was transformed into a state that renders it ready for use in analysis and any other future uses



