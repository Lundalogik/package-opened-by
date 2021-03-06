SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'csp_clear_openedby' AND UPPER(type) = 'P')
   DROP PROCEDURE [csp_clear_openedby]
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'csp_addon_openedby_clear_openedby' AND UPPER(type) = 'P')
   DROP PROCEDURE [csp_addon_openedby_clear_openedby]
GO
-- =============================================
-- Author:		Lars Jensen
-- Create date: 2017-08-03
-- Description:	Clears opened by records older than one day
-- =============================================
CREATE PROCEDURE [dbo].[csp_addon_openedby_clear_openedby]
	AS
BEGIN
    
    SELECT * 
    INTO #temp
    FROM (
	   SELECT * FROM openedby
	   WHERE timestamp > CAST(GETDATE() AS DATE)
    ) as temp

    TRUNCATE TABLE openedby
    
    INSERT INTO openedby (status, createduser, createdtime, updateduser, timestamp, rowguid, tablename, recordid, iduser)
    SELECT status, createduser, createdtime, updateduser, timestamp, rowguid, tablename, recordid, iduser FROM #temp

    DROP TABLE #temp
END
