
-- =============================================
-- Author:		Lars Jensen
-- Create date: 2017-08-03
-- Description:	Sets opened by for any table, record and user
-- =============================================
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'csp_clear_openedby' AND UPPER(type) = 'P')
   DROP PROCEDURE [csp_clear_openedby]
GO

CREATE PROCEDURE [dbo].[csp_clear_openedby]
	AS
BEGIN
    
    SELECT * 
    INTO #temp
    FROM (
	   SELECT * FROM openedby
	   WHERE timestamp > CAST(GETDATE() AS DATE)
    ) as temp

    TRUNCATE TABLE openedby
    
    INSERT INTO openedby (status, createduser, createdtime, updateduser, timestamp, rowguid, tablename, idrecord, iduser)
    SELECT status, createduser, createdtime, updateduser, timestamp, rowguid, tablename, idrecord, iduser FROM #temp

    DROP TABLE #temp
END
