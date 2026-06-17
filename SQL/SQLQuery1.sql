USE EcommerceDWH;
GO

-- Drop all Foreign Keys
DECLARE @sql NVARCHAR(MAX) = ''
SELECT @sql += 'ALTER TABLE ' + QUOTENAME(OBJECT_NAME(parent_object_id)) + 
               ' DROP CONSTRAINT ' + QUOTENAME(name) + ';'
FROM sys.foreign_keys
EXEC sp_executesql @sql

-- Drop all User Tables
SET @sql = ''
SELECT @sql += 'DROP TABLE ' + QUOTENAME(name) + ';'
FROM sysobjects WHERE xtype = 'U'
EXEC sp_executesql @sql

PRINT 'Database cleaned.'

select * from order_reviews