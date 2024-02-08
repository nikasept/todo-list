USE projects;

BEGIN TRANSACTION;

BEGIN TRY
    IF OBJECT_ID('dbo.Atoms', 'U') IS NULL
    BEGIN
        CREATE TABLE dbo.Atoms (
            Id varchar(255) NOT NULL PRIMARY KEY,
            Header varchar(255) NOT NULL,
            Body varchar(255) NOT NULL,
            [Date] datetime,
            Completed bit NOT NULL
        );
    END
    COMMIT;
END TRY
BEGIN CATCH
    PRINT 'Something went wrong';
    IF @@TRANCOUNT > 0 ROLLBACK;
END CATCH;
