--Cleaning Fifa21 data

Select *
from [Data Cleaning]..Fifa21

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
Where Weight like '%lbs'

UPDATE [Data Cleaning]..Fifa21 
SET Weight = 
CASE WHEN Weight like '%lbs' 
THEN TRY_CONVERT (DECIMAl(10,2),(LEFT(Weight,LEN(Weight)-3)) * 0.45359237)
ELSE Weight
END



--Standardising the Value
Select *
from [Data Cleaning]..Sheet1$
Where Value like '%K'
 
UPDATE [Data Cleaning]..Sheet1$
SET Value = Replace(Value,'€', ' ')

UPDATE [Data Cleaning]..Sheet1$ 
SET Value = (LEFT(Value,LEN(Value)-1)) *1000
Where Value like '%K'


Select *
from [Data Cleaning]..Sheet1$
Where Value like '%M'
 

UPDATE [Data Cleaning]..Sheet1$
SET value = CAST((LEFT(Value, LEN(Value)-1)) AS DECIMAL(10,2)) * 1000000 
WHERE Value like '%M'

ALTER TABLE [Data Cleaning]..Sheet1$
ALTER COLUMN value DECIMAL(18, 0) NOT NULL

--Standardising the Wage column

Select *
from [Data Cleaning]..Sheet1$
Where Wage like '%K'

UPDATE [Data Cleaning]..Sheet1$
SET Wage = Replace(Wage,'€', ' ')

UPDATE [Data Cleaning]..Sheet1$
SET Wage =(LEFT(Wage, LEN(Wage)-1)) * 1000
WHERE Wage like '%K'


--Modifying column names

EXEC sp_rename '[Data Cleaning]..Sheet1$.Weight', 'Weight_kg', 'COLUMN'

EXEC sp_rename '[Data Cleaning]..Sheet1$.Height', 'Height_cm', 'COLUMN'

EXEC sp_rename '[Data Cleaning]..Sheet1$.Value', 'Market Value_€ ', 'COLUMN'

EXEC sp_rename '[Data Cleaning]..Sheet1$.Wage', 'Wage_€ ', 'COLUMN'


--Dropping columns

Select *
from [Data Cleaning]..Sheet1$

ALTER TABLE [Data Cleaning]..Sheet1$ 
DROP COLUMN Name, Photo Url, PlayerUrl, Attacking, Crossing, Finishing
, Heading Accuracy, Short Passing, Dribbling, Curve, Long Passing, Movement, Acceleration
,