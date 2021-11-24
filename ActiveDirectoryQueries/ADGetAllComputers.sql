-- Returns all computer accounts in a domin
-- Query broken down by first three letters of computer name to avoid max records limit.

IF OBJECT_ID('tempdb..#Computer') IS NOT NULL
  DROP TABLE #Computer

CREATE TABLE #Computer (
  cn nvarchar(300),
  distinguishedName nvarchar(500),
  dNSHostName nvarchar(300),
  operatingSystem nvarchar(300)
)

DECLARE @Alpha TABLE (
  idAlpha INT identity(1, 1) PRIMARY KEY CLUSTERED,
  letter CHAR(1)
)

DECLARE @FirstChar CHAR(1) = '',
  @SecondChar CHAR(1) = '',
  @ThirdChar CHAR(1) = '',
  @cmdTxt VARCHAR(4000) = '',
  @cmdTxtTop VARCHAR(4000) = '',
  @cntrFirstChar INT = 0,
  @cntrSecondChar INT = 0,
  @cntrThirdChar INT = 0,
  @maxIdAlpha INT = NULL

INSERT INTO @Alpha (letter)
VALUES ('A'),
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
  ('Z'),
  ('0'),
  ('1'),
  ('2'),
  ('3'),
  ('4'),
  ('5'),
  ('6'),
  ('7'),
  ('8'),
  ('9'),
  ('-')

SELECT @maxIdAlpha = MAX(idAlpha)
FROM @Alpha

-- ********************** Preparation **********************
SET @cmdTxtTop += (
    'Insert Into #Computer (cn, distinguishedName, dNSHostName, operatingSystem) ' + 
	'Select top 901 cast(cn as nvarchar(300)), cast(distinguishedName AS nvarchar(500)), cast(dNSHostName as nvarchar(300)), cast(operatingSystem as nvarchar(300)) ' + 
	'From OPENQUERY (ADSI, ''Select cn, distinguishedName, dNSHostName, operatingSystem From ''''LDAP://DC=<<domain>>,DC=<<tld>>'''' Where objectCategory=''''computer'''' And objectClass = ''''computer'''' '
    )
SET @cmdTxt = ('Truncate Table #Computer '  )

EXEC (@cmdTxt)

-- ********************** Second Char Loop **********************
WHILE (@cntrThirdChar < @maxIdAlpha)
BEGIN
  SET @cntrSecondChar = 0
  SET @cntrThirdChar += 1

  SELECT @ThirdChar = a.letter
  FROM @Alpha AS a
  WHERE a.idAlpha = @cntrThirdChar

  -- ********************** Third Char Loop **********************
  WHILE (@cntrSecondChar < @maxIdAlpha)
  BEGIN
    SET @cntrFirstChar = 0
    SET @cntrSecondChar += 1

    SELECT @SecondChar = a.letter
    FROM @Alpha AS a
    WHERE a.idAlpha = @cntrSecondChar

    -- ********************** First Char Loop **********************
    WHILE (@cntrFirstChar < @maxIdAlpha)
    BEGIN
      SET @cntrFirstChar += 1
      SET @cmdTxt = ''

      SELECT @FirstChar = a.letter
      FROM @Alpha AS a
      WHERE a.idAlpha = @cntrFirstChar

      SET @cmdTxt = (@cmdTxtTop +  'And cn = ''''*' + @ThirdChar + @SecondChar + @FirstChar + ''''' ' +  ''' ) ' )
      PRINT @cmdTxt
      EXEC (@cmdTxt)
    END 
  END 
END 


SELECT DISTINCT *
FROM #Computer

-- DROP TABLE #Computer