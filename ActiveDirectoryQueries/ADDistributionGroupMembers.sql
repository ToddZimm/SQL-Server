-- Returns all members of a distribution group

SELECT *
  ,CASE WHEN (userAccountControl & 2) <> 0 THEN 1 ELSE 0 END AS Disabled
FROM OPENQUERY(ADSI, 'SELECT CN, sAMAccountname, DisplayName, telephoneNumber, mail, department, title, employeeID, employeeNumber, userAccountControl, givenName, sn, middlename, generationQualifier, facsimileTelephoneNumber, pager
FROM ''LDAP://DC=<<domain>>,DC=<<tld>>'' 
WHERE objectCategory=''person'' 
   AND objectClass=''user''  
   AND memberOf=''CN=<<group name>>,OU=Distribution Groups,DC=<<domain>>,DC=org''
')
ORDER BY cn
