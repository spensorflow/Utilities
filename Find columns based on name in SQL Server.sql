USE [db name] --Database to Search 
Select distinct
	--*
	'[db name]' as DB,
	TableName = o.name , 
	ColumnName = c.name 
from sysobjects o 
	inner join syscolumns c 
	on o.id = c.id 
where o.name like '[string/pattern]' --Column you're searching for	
ORDER BY    TableName
 --           ,ColumnName;
