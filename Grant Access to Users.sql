/* Grant access to user to specified table */

-- All Privileges - Grant all privileges to the user
-- Delete - Grant permission to delete rows from table
-- Insert - Grant permission to insert rows into table
-- References - Grant permission to create a foreign key reference to the specified table
-- Select - Grant permission to perform Select Statements on table
-- Trigger - Grant permission to create a trigger on table
-- Update - Grant permission to use update statement on table


/* Grant select privileges to specific table */
Grant select on schema.table_name to user_name;


/* Revoke test */
 Revoke select on table_name from user_name;


/* Create role (user group) */
Create role role_name;
Grant select on table;
Grant role_name to user_name1,user_name2,...;
