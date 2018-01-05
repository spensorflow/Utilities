/* Alter commands */

-- Drop column
Alter table table_name
  DROP COLUMN field_name;

  
-- Add primary key  (NEED TO FIX)
Alter table table_name
Add constraint primary key (var_name);


-- Rename column
ALTER TABLE table_name
 RENAME COLUMN old_name to new_name;

  
-- Rename table 
ALTER TABLE table_name
RENAME TO new_table_name;
