-- Drop child tables first, then parent tables
DROP TABLE IF EXISTS Portfolio_Investment;
DROP TABLE IF EXISTS Portfolio;

DROP TABLE IF EXISTS Investment;

DROP TABLE IF EXISTS Financial_Product;
DROP TABLE IF EXISTS Risk_Profile;
DROP TABLE IF EXISTS Financial_Product_Type;

DROP TABLE IF EXISTS [Transaction];
DROP TABLE IF EXISTS Transaction_Type;

DROP TABLE IF EXISTS Account;
DROP TABLE IF EXISTS Account_Type;

DROP TABLE IF EXISTS Client;
DROP TABLE IF EXISTS Client_Type;
