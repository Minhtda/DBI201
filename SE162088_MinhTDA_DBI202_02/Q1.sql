CREATE TABLE Roles(
RoleID int PRIMARY KEY,
name nvarchar(100)
)
CREATE TABLE Users(
Username varchar(30) PRIMARY KEY,
Password nvarchar(20),
Email nvarchar(200),
RoleID int FOREIGN KEY REFERENCES Roles(RoleID)
)
CREATE TABLE Permissions(
permissionID int PRIMARY KEY,
name nvarchar(50) 
)
CREATE TABLE hasPermission(
permissionID int FOREIGN KEY REFERENCES Permissions(permissionID),
RoleID int FOREIGN KEY REFERENCES Roles(RoleID)
)