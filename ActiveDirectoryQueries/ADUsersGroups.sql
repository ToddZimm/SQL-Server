-- Returns the list of groups that where the user is a member.

-- Find user's CN
SELECT (
		SELECT *
		FROM OPENQUERY(ADSI, ' 
SELECT 
distinguishedName
From 
  ''LDAP://DC=<<domain>>,DC=<<tld>>'' 
  Where objectCategory=''person'' 
  And objectClass = ''user'' 
  And sAMAccountname = ''<<user id>>''  
  ')
)

-- Find user's groups
SELECT *
FROM openquery(ADSI, 'SELECT cn, distinguishedName, sAMAccountName
FROM ''LDAP://DC=<<domain>>,DC=<<tld>>'' 
WHERE objectCategory = ''group''
AND member = ''CN=<<users CN>>''')
ORDER BY 1
