USE projects
GO

BEGIN TRANSACTION
BEGIN TRY
  IF OBJECT_ID('todo.Atoms', 'U') IS NOT NULL 
  BEGIN
    drop table todo.Atoms
  END
  COMMIT
END TRY
BEGIN CATCH
  PRINT 'does not exist'
  ROLLBACK
END CATCH



