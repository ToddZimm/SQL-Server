-- Returns all user accounts in a domain
-- Query broken out by letter to avoid max records limit

IF OBJECT_ID('tempdb..#Users') IS NOT NULL
  DROP TABLE #Computer
  
CREATE TABLE #Users (
  UserId nvarchar(300),
  FirstName nvarchar(200),
  LastName nvarchar(200),
  FullName nvarchar(600),
  Email nvarchar(200),
  Department nvarchar(200),
  userAccountControl int
)

DECLARE @Alpha TABLE (
  idAlpha INT identity(1, 1) PRIMARY KEY CLUSTERED,
  letter CHAR(1)
)
  
DECLARE @First CHAR(1) = '',
  @Last CHAR(1) = '',
  @LastSecondLetter CHAR(1) = '',
  @cmdTxt VARCHAR(4000) = '',
  @cmdTxtTop VARCHAR(4000) = '',
  @cntrFirst INT = 0,
  @cntrLast INT = 0,
  @cntrLastSecondLetter INT = 0,
  @maxIdAlpha INT = NULL

INSERT INTO @Alpha (letter)
VALUES 
  ('A'),
  ('B'),
  ('C'),
  ('D'),
  ('E'),
  ('F'),
  ('G'),
  ('H'),
  ('I'),
  ('J'),
  ('K'),
  ('L'),
  ('M'),
  ('N'),
  ('O'),
  ('P'),
  ('Q'),
  ('R'),
  ('S'),
  ('T'),
  ('U'),
  ('V'),
  ('W'),
  ('X'),
  ('Y'),
  ('Z')

SELECT @maxIdAlpha = MAX(idAlpha)
FROM @Alpha

-- ********************** Preparation **********************
SET @cmdTxtTop += (
    'Insert Into #Users (userID, LastName, FirstName, FullName, userAccountControl, Email, Department) ' + 
	'Select top 901 cast(sAMAccountName as nvarchar(300)) as userID, cast(sn AS nvarchar(200)) as LastName, cast(givenName AS nvarchar(200)) as FirstName, cast(DisplayName as nvarchar(600)) as FullName, cast(userAccountControl as int) as userAccountControl, cast(mail as nvarchar(200)) as Email, cast(department AS nvarchar(200)) AS department ' + 
	'From OPENQUERY (ADSI, ''Select sn, GivenName, sAMAccountName, DisplayName, mail, userAccountControl, telephoneNumber, manager, department From ''''LDAP://DC=<<domain>>,DC=<<tld>>'''' Where objectCategory=''''person'''' And objectClass = ''''user'''' '
    )
SET @cmdTxt = ('Truncate Table #Users '  )

EXEC (@cmdTxt)

-- ********************** Last Name Outer Loop **********************
WHILE (@cntrLast < @maxIdAlpha)
BEGIN
  SET @cntrLastSecondLetter = 0
  SET @cntrLast += 1

  SELECT @Last = a.letter
  FROM @Alpha AS a
  WHERE a.idAlpha = @cntrLast

  -- ********************** Last Name Second Letter Outer Loop **********************
  WHILE (@cntrLastSecondLetter < @maxIdAlpha)
  BEGIN
    SET @cntrFirst = 0
    SET @cntrLastSecondLetter += 1

    SELECT @LastSecondLetter = a.letter
    FROM @Alpha AS a
    WHERE a.idAlpha = @cntrLastSecondLetter

    -- ********************** First Name Inner Loop **********************
    WHILE (@cntrFirst < @maxIdAlpha)
    BEGIN
      SET @cntrFirst += 1
      SET @cmdTxt = ''

      SELECT @First = a.letter
      FROM @Alpha AS a
      WHERE a.idAlpha = @cntrFirst

      SET @cmdTxt = (@cmdTxtTop +  'And GivenName = ''''' + @First + '*'''' ' +  'And sn = ''''' + @Last + @LastSecondLetter + '*'''' '  + ''' ) ' )
      PRINT @cmdTxt
      EXEC (@cmdTxt)
    END -- First Name
  END -- Last Name Second Letter  
END -- Last Name First Letter


SELECT *,
CASE WHEN (userAccountControl & 2) <> 0 THEN 0 ELSE 1 END AS Active
FROM #Users

--drop table #Users