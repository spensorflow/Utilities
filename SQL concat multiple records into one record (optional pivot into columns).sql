 -- Gather all records per group
 If Object_ID('TempDB.dbo.#Group') is not null begin drop table #Group end;
 Select distinct
	[Group ID],
	[Value Name]
into #Group
from [table name]

-- Select * from #Group


-- Concatenate all records into 1 column with comma-separated values per group
If Object_ID('TempDB.dbo.#Value_Concat') is not null begin drop table #Value_Concat end;
Select distinct
	[Group ID],
	[Value Names] = Stuff((Select ', ' + [Value Name])
		from #Prov l2
		where g2.[Group ID] = g.[Group ID]
		for XML Path('')),1,1,'')
into #Value_Concat
from #Group g
group by g.[Group ID], g.[Value Name]
Order by 1

-- Select * from #Value_Concat

/* Optional */

-- Pivot top 5 values into 5 separate columns 
If Object_ID('TempDB.dbo.#Value_Final') is not null begin drop table #Value_Final end;

; with Split_Value ([Group ID],xmlname)
	AS
-- Define the CTE query.
	(
      SELECT [Group ID],
      CONVERT(XML,'<Names><name>'  
      + REPLACE([Value Names],',', '</name><name>') + '</name></Names>') AS xmlname
      FROM #Value_Concat
	)
-- Define the outer query referencing the CTE name.
 SELECT [Group ID],     
 xmlname.value('/Names[1]/name[1]','varchar(100)') AS Value1,    
 xmlname.value('/Names[1]/name[2]','varchar(100)') AS Value2,
 xmlname.value('/Names[1]/name[3]','varchar(100)') AS Value3,
 xmlname.value('/Names[1]/name[4]','varchar(100)') AS Value4,
 xmlname.value('/Names[1]/name[5]','varchar(100)') AS Value5
 into #Value_Final
 FROM Split_Value
 
 -- Select * from #Value_Final
