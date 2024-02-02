USE projects
GO
 

BEGIN TRANSACTION
BEGIN TRY
  -- Insert rows into table 'todo.Atoms' table
  INSERT INTO todo.Atoms
  ( -- columns to insert data into
    title, [description], createDate
  )
  VALUES
  ( -- first row: values for the columns in the list above
    'go', 'gogogo', GETDATE()
  )
END TRY
BEGIN CATCH
  ROLLBACK TRANSACTION
END CATCH

COMMIT TRANSACTION