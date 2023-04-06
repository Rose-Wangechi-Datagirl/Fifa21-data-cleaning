--Cleaning Fifa21 data

Select *
from [Data Cleaning]..Sheet1$

--Updating the Longname for consistency and neatness
ALTER TABLE [Data Cleaning]..Fifa21
ADD Player_full_name VARCHAR(100)

UPDATE [Data Cleaning]..Fifa21
SET Player_full_name = SUBSTRING(playerUrl, 33, LEN(LongName)+2)

	--remove special characters from full name and use the new column to populate long name
UPDATE [Data Cleaning]..Fifa21
SET LongName = REPLACE(UPPER(
					CASE WHEN CHARINDEX('/', Player_full_name) > 0
						THEN SUBSTRING(Player_full_name, 1, CHARINDEX('/', Player_full_name)-1)
						ELSE Player_full_name
						END
						), '-', ' ')

											   
--updating the Contract column by creating new columns and populating them
	--updating contract column dates in tect with 'on loan'
UPDATE [Data Cleaning]..Fifa21
SET Contract= 'On loan'
WHERE Contract like '%On Loan%'

--create column Contract_start_year and Contract_end_year
ALTER TABLE [Data Cleaning]..Fifa21
ADD Contract_start_year VARCHAR(20)
	,Contract_end_year Varchar(20)

--populate the columns
UPDATE [Data Cleaning]..Fifa21
SET Contract_start_year = CASE
						WHEN Contract like '%loan%' THEN 'On loan'
						WHEN Contract  like '%Free%' THEN 'Free'
						ELSE CAST(YEAR(CAST(LEFT(Contract, 4) + '-01-01' AS DATE)) AS
						VARCHAR(20))
						END,
	Contract_end_year = CASE
					WHEN Contract like '%loan%' THEN 'On loan'
					WHEN Contract like '%Free%' THEN 'Free'
					ELSE CAST(YEAR(CAST(RIGHT(Contract, 4) + '-01-01' AS DATE)) AS
					VARCHAR(20))
					END
WHERE Contract like '%-%' OR Contract like '%loan' OR Contract like '%Free'

--create column contract_status

ALTER TABLE [Data Cleaning]..Fifa21
ADD Contract_status VARCHAR(20)	

--populate the column from the contract column
UPDATE [Data Cleaning]..Fifa21
SET Contract_status = CASE
					WHEN Contract like '%-%' THEN 'Active Contact'
					WHEN Contract like '%loan%' THEN 'On Loan'
					WHEN Contract like '%Free%' THEN 'Free'
					ELSE NULL
					END


--populating the Contract_end_year from Loan Date End for the loan players

UPDATE [Data Cleaning]..Fifa21
SET Contract_end_year = CASE
					WHEN Contract like '%on loan%' AND [Loan Date End] IS NOT NULL
					THEN CONVERT(NVARCHAR, [Loan Date End], 23)
					ELSE Contract_end_year
					END
WHERE Contract like '%on loan%'

--cleaning up the club colum to remove unwanted chracters
Select REPLACE( REPLACE( Club, '.', ' '), '1', ' ')
from [Data Cleaning]..Fifa21

UPDATE [Data Cleaning]..Fifa21
SET Club = REPLACE( REPLACE( Club, '.', ' '), '1', ' ')

--standardising the Height to cm

Select *
from [Data Cleaning]..Fifa21
where Height not like '%cm'

--alter column data

ALTER TABLE Fifa21 
ALTER COLUMN Height
NVARCHAR (50)

--changing the heigt to cm

UPDATE [Data Cleaning]..Fifa21
SET Height = (LEFT(Height, CHARINDEX('''', Height) - 1) * 30.48) + 
(RIGHT(LEFT(Height, LEN(Height) - CHARINDEX('''', REVERSE(Height))) 
, CHARINDEX('''', REVERSE(Height)) - 1) * 2.54) 
WHERE Height NOT LIKE '%cm'

--dropping the cm in height column
Select Height
from [Data Cleaning]..Fifa21
--where Height like '%cm'

Select 
	Replace(Height,'cm', ' ')
from [Data Cleaning]..Fifa21

UPDATE [Data Cleaning]..Fifa21
SET Height = Replace(Height,'cm', ' ')

--Removing decimals to make it consistent

Update [Data Cleaning]..Fifa21 
SET Height = ROUND(Height, 0)


Select *
from [Data Cleaning]..Fifa21
--where ID = 189280

--Standardise the Weight to Kg


Select *
from [Data Cleaning]..Fifa21
Where Weight not like '%kg'

ALTER TABLE  [Data Cleaning]..Fifa21
ALTER COLUMN Weight
NVARCHAR (50)

UPDATE [Data Cleaning]..Fifa21 
SET Weight = CAST((LEFT(Weight,LEN(Weight)-3)) AS DECIMAL(10,2)) * 0.45359237
where Weight like '%lbs'

UPDATE [Data Cleaning]..Fifa21
SET Weight = Replace(Weight,'kg', ' ')

Update [Data Cleaning]..Fifa21 
SET Weight = ROUND(Weight, 0)


--Standardising the Value
Select *
from [Data Cleaning]..Fifa21
Where Value like '%K'
 
UPDATE [Data Cleaning]..Fifa21
SET Value = Replace(Value,'€', ' ')

UPDATE [Data Cleaning]..Fifa21 
SET Value = (LEFT(Value,LEN(Value)-1)) *1000
Where Value like '%K'


Select *
from [Data Cleaning]..Fifa21
Where Value like '%M'
 

UPDATE [Data Cleaning]..Fifa21
SET value = CAST((LEFT(Value, LEN(Value)-1)) AS DECIMAL(10,2)) * 1000000 
WHERE Value like '%M'

ALTER TABLE [Data Cleaning]..Fifa21
ALTER COLUMN value DECIMAL(18, 0) NOT NULL

--Standardising the Wage column

Select *
from [Data Cleaning]..Fifa21
Where Wage like '%K'

UPDATE [Data Cleaning]..Fifa21
SET Wage = Replace(Wage,'€', ' ')

UPDATE [Data Cleaning]..Fifa21
SET Wage =(LEFT(Wage, LEN(Wage)-1)) * 1000
WHERE Wage like '%K'

--Cleaning the release clause
Select *
from [Data Cleaning]..Fifa21
Where [Release Clause] like '%M'

UPDATE [Data Cleaning]..Fifa21
SET [Release Clause] = Replace([Release Clause],'€', ' ')

UPDATE [Data Cleaning]..Fifa21
SET [Release Clause]= CASE
			WHEN [Release Clause] like '%K' THEN (LEFT( [Release Clause], LEN( [Release Clause])-1)) * 1000
			WHEN [Release Clause] like '%M' THEN CAST((LEFT( [Release Clause], LEN( [Release Clause])-1))
				AS DECIMAL(10,2)) * 1000000
			ELSE [Release Clause]
			END

ALTER TABLE [Data Cleaning]..Fifa21
ALTER COLUMN [Release Clause] DECIMAL(18, 0) NOT NULL

--Removing the special characters ★ from the W/F, SM and IR columns

UPDATE [Data Cleaning]..Fifa21
SET [W/F] = Replace([W/F], N'★', N' ')
WHERE CHARINDEX (N'★', [W/F]) > 0


Select *
from [Data Cleaning]..Fifa21
--Where [W/F] like '%★'

UPDATE [Data Cleaning]..Fifa21
SET SM = Replace(SM, N'★', N' ')
WHERE CHARINDEX (N'★', SM) > 0

UPDATE [Data Cleaning]..Fifa21
SET IR = Replace(IR, N'★', N' ')
WHERE CHARINDEX (N'★', IR) > 0

--standardising the Hits Column

Select Hits
from [Data Cleaning]..Fifa21
WHERE Hits like '%00'

Select Hits =CAST((LEFT(Hits, LEN(Hits)-1)) AS DECIMAL(10,2)) * 1000
from [Data Cleaning]..Fifa21
WHERE Hits like '%K'

UPDATE [Data Cleaning]..Fifa21
SET Hits = CAST((LEFT(Hits, LEN(Hits)-1)) AS DECIMAL(10,2)) * 1000
WHERE Hits like '%K'

UPDATE [Data Cleaning]..Fifa21
SET Hits = ROUND(Hits,0)

--checking duplicates

Select ID, COUNT(*) AS num_duplicates
From [Data Cleaning]..Fifa21
GROUP BY ID
HAVING COUNT(*) > 1

--Dropping columns, Modifying column names

--Dropping columns

Select *
from [Data Cleaning]..Fifa21

ALTER TABLE [Data Cleaning]..Fifa21
ADD Height_CM FLOAT

UPDATE [Data Cleaning]..Fifa21
SET Height_CM = Height

ALTER TABLE [Data Cleaning]..Fifa21
DROP COLUMN Height

ALTER TABLE [Data Cleaning]..Fifa21
ADD Weight_Kg FLOAT

UPDATE [Data Cleaning]..Fifa21
SET Weight_Kg =Weight

ALTER TABLE [Data Cleaning]..Fifa21
DROP COLUMN Weight

ALTER TABLE [Data Cleaning]..Fifa21
ADD [Value_€] MONEY

UPDATE [Data Cleaning]..Fifa21
SET [Value_€] =Value

ALTER TABLE [Data Cleaning]..Fifa21
DROP COLUMN Value

ALTER TABLE [Data Cleaning]..Fifa21
ADD [Wage_€] MONEY

UPDATE [Data Cleaning]..Fifa21
SET [Wage_€] =Wage

ALTER TABLE [Data Cleaning]..Fifa21
DROP COLUMN Wage

ALTER TABLE [Data Cleaning]..Fifa21
ADD [ReleaseClause_€] MONEY

UPDATE [Data Cleaning]..Fifa21
SET [ReleaseClause_€] = [Release Clause]

ALTER TABLE [Data Cleaning]..Fifa21
DROP COLUMN [Release Clause]

ALTER TABLE [Data Cleaning]..Fifa21
ADD [W_F(Weaker_foot_ability)] INT

UPDATE [Data Cleaning]..Fifa21
SET [W_F(Weaker_foot_ability)] = [W/F]

ALTER TABLE [Data Cleaning]..Fifa21
DROP COLUMN [W/F]

ALTER TABLE [Data Cleaning]..Fifa21
ADD [SM(Skill_Moves_ability)] INT

UPDATE [Data Cleaning]..Fifa21
SET [SM(Skill_Moves_ability)] = SM

ALTER TABLE [Data Cleaning]..Fifa21
DROP COLUMN SM

ALTER TABLE [Data Cleaning]..Fifa21
ADD [IR(injury_resistance] INT

UPDATE [Data Cleaning]..Fifa21
SET [IR(injury_resistance] = IR

ALTER TABLE [Data Cleaning]..Fifa21
DROP COLUMN IR

ALTER TABLE [Data Cleaning]..Fifa21
DROP COLUMN Name, [photoUrl],[playerUrl], [Loan Date End], Contract, Positions
			, Player_full_name

ALTER TABLE [Data Cleaning]..Fifa21
DROP COLUMN Height_in_cm


Select *
From [Data Cleaning]..Fifa21