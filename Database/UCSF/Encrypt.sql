-- Declaration section
DECLARE  @NormalPassword     varchar (255),
               @EncryptedPassword  varchar(255)

-- Assign a clear password
SELECT @NormalPassword = 'sswug'

/*
Encrypt the clear password and assign it to a variable. 
Note that each time you run this script it gives you a different hexadecimal value.
*/

SELECT  @EncryptedPassword = HASHBYTES('SHA1 ',@NormalPassword) 

-- For the purpose of understanding display the clear and encrypted password. 
Select @NormalPassword, @EncryptedPassword

-- Compare the normal and encrypted string and see whether it is matching
SELECT HASHBYTES('SHA1 ','sswug') , @EncryptedPassword