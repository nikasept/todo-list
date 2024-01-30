
-- Create a new table called 'Blogs' in schema 'dbo' with
-- Drop the table if it already exists
/*
IF OBJECT_ID('dbo.Blogs', 'U') IS NOT NULL
DROP TABLE dbo.Blogs
GO
*/
-- Create the table in the specified schema
CREATE TABLE Blogs
(
  BlogsId INT NOT NULL PRIMARY KEY, -- primary key column
  Header VARCHAR(50) NOT NULL,
  Body VARCHAR(1024) NOT NULL
  -- specify more columns here
);
