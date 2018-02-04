CREATE DATABASE F21603S1_MovieOnline
GO
USE F21603S1_MovieOnline
GO

CREATE TABLE Genre
(
	genreId INT PRIMARY KEY IDENTITY(1,1),
	genreName VARCHAR(20) NOT NULL,
	genre_order INT NOT NULL
)
GO

CREATE TABLE Country
(
	countryId INT PRIMARY KEY IDENTITY(1,1),
	countryName VARCHAR(20) NOT NULL,
	country_order INT NOT NULL
)
GO

CREATE TABLE Movies
(
	movieId INT PRIMARY KEY IDENTITY(1,1),
	title NVARCHAR(100) NOT NULL,
	realTitle NVARCHAR(100) NOT NULL,
	titleTag NVARCHAR(200),
	releaseDay DATE NOT NULL,
	countryId INT FOREIGN KEY (countryId) REFERENCES dbo.Country(countryId) ON DELETE CASCADE,
	imdb FLOAT CHECK (imdb BETWEEN 0 AND 10),
	actors NVARCHAR(200) NOT NULL,
	actor_ascii VARCHAR(200) NOT NULL,
	director NVARCHAR(50) NOT NULL,
	director_ascii VARCHAR(50) NOT NULL,
	[description] NVARCHAR(MAX),
	[type] BIT, --phim le:0 phim bo:1
	duration VARCHAR(20) NOT NULL,
	[views] INT DEFAULT 0,
	uploadDay DATE DEFAULT GETDATE(), 
	trailer VARCHAR(100) NOT NULL,
	[status] BIT DEFAULT(1),
	quantity VARCHAR(10) CHECK (quantity ='HD' OR quantity ='FullHD' OR quantity='SD'),
	ageLimit BIT DEFAULT(0),
	vipOnly BIT DEFAULT(0)
)
GO

CREATE TABLE Movies_Genre
(
	MovieID INT FOREIGN KEY(MovieID) REFERENCES dbo.Movies(movieId),
	GenreID INT FOREIGN KEY(GenreID) REFERENCES dbo.Genre(genreId)
)
go

CREATE TABLE Role
(
	roleId INT PRIMARY KEY IDENTITY(1,1),
	name VARCHAR(30) NOT NULL,
	color VARCHAR(7) NOT NULL
)
go

CREATE TABLE Accounts
(
	accountId INT PRIMARY KEY IDENTITY(1,1),
	userName VARCHAR(20) NOT NULL,
	[password] VARCHAR(100) NOT NULL,
	phoneNumber VARCHAR(15),
	[role] INT FOREIGN KEY([role]) REFERENCES dbo.Role(roleId),
	gender BIT , --1:nam,0:nu
	[image] VARCHAR(50) DEFAULT 'blank_avatar.png', 
	email VARCHAR(50) NOT NULL,
	registerDay DATE DEFAULT GETDATE(),
	isVip BIT,
	dayVipEnd DATE,
	banned BIT,
	reasonBan NVARCHAR(MAX)
)
GO

CREATE TABLE TypeVip(
	typeVipId INT PRIMARY KEY IDENTITY(1,1),
	name VARCHAR(20) NOT NULL, -- 1 year,1 mounth
	duration INT NOT NULL, --tinh bang day
	price FLOAT DEFAULT 0 NOT NULL
)

CREATE TABLE AccountVipHistory
(
	historyId INT PRIMARY KEY IDENTITY(1,1),
	accountId INT FOREIGN KEY (accountId) REFERENCES  dbo.Accounts(accountId),
	typeVipId INT FOREIGN KEY (typeVipId) REFERENCES TypeVip(typeVipId),
	dateRegister DATE DEFAULT GETDATE(),
)
GO


CREATE TABLE Rating
(
	ratingId INT PRIMARY KEY IDENTITY(1,1),
	movieId INT FOREIGN KEY (movieId) REFERENCES dbo.Movies(movieId) ON DELETE CASCADE,
	accountId INT FOREIGN KEY (accountId) REFERENCES dbo.Accounts(accountId),
	star INT CHECK (star BETWEEN  0 AND 10) 
)

GO

CREATE TABLE Favorites
(
	favoriteID INT PRIMARY KEY IDENTITY(1,1),
	accountId INT FOREIGN KEY (accountId) REFERENCES dbo.Accounts(accountId),
	movieId INT FOREIGN KEY (movieId) REFERENCES dbo.Movies(movieId) ON DELETE CASCADE,
	[type] BIT, --phim le:0 phim bo:1
	follow BIT
)
GO

CREATE TABLE Comments
(
	commentId INT PRIMARY KEY IDENTITY(1,1),
	movieId INT FOREIGN KEY (movieId) REFERENCES dbo.Movies(movieId) ON DELETE CASCADE,
	accountId INT FOREIGN KEY (accountId) REFERENCES dbo.Accounts(accountId),
	[time] DATETIME NOT NULL,
	content NVARCHAR(MAX) 
	-- 	{
	--		"content":"text",
	--		"time":"getTime",
	--		"reply":[
	--					{"id":"123","name":"nam","time":"getTime()","content":"text"},
	--					{"id":"234","name":"ha","time":"getTime()","content":"text"}
	--				]
	--}
)
GO

CREATE TABLE Episode
(
	episodeId INT IDENTITY(1,1) PRIMARY KEY,
	movieId INT FOREIGN KEY (movieId) REFERENCES dbo.Movies(movieId) ON DELETE CASCADE,
	episodeName FLOAT NOT NULL,
	[language] VARCHAR(20) NOT NULL,
	res360 VARCHAR(50),
	res480 VARCHAR(50),
	res720 VARCHAR(50),
	res1080 VARCHAR(50),
	subtitle VARCHAR(MAX), -- {"code":"en","lang":"English","name":"batman_en..."}
	broken BIT
)
GO


CREATE TABLE Notifications
(
	notiId INT PRIMARY KEY IDENTITY(1,1),
	senderID INT, -- nguoi gui
	name VARCHAR(50),
	email VARCHAR(100),
	recipientID INT,
	groupID INT FOREIGN KEY(groupID) REFERENCES dbo.Role(roleId),
	title NVARCHAR(100) NOT NULL,
	content NVARCHAR(MAX) NOT NULL,
	[type] VARCHAR(50) NOT NULL, --Loai thong bao(báo lỗi, event) 
	[time] DATETIME DEFAULT GETDATE(),
	isUnread bit DEFAULT 0
)
GO    


----------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE getDetailMovie
 @id INT
 AS
 BEGIN
   SELECT m.movieId,m.title,m.realTitle,m.titleTag,CONVERT(VARCHAR(10), m.releaseDay, 101) AS releaseDay,c.countryName,genre,m.imdb,ISNULL(AVG(r.star),0) AS rate,COUNT(r.star) AS ratecount,m.actors,m.director,m.description,m.type,ISNULL(currentEpisode,0) AS currentEpisode,ISNULL(numberEpisode,0) AS numberEpisode,m.duration,m.views,m.trailer,m.status,m.quantity,m.ageLimit,m.vipOnly
   FROM dbo.Movies AS m JOIN dbo.Country AS c ON c.countryId = m.countryId LEFT JOIN dbo.Rating AS r ON r.movieId = m.movieId FULL JOIN (SELECT movieId,CAST(ISNULL(MAX(episodeName),0) AS Int) AS currentEpisode,COUNT(episodeId) AS numberEpisode FROM dbo.Episode WHERE (res360!='' or res480!='' or res720!=''or res1080!='') AND broken=0 GROUP BY movieId) epi ON epi.movieId = m.movieId
   CROSS APPLY (SELECT STUFF((SELECT ','+'{"genreId":"'+CONVERT(VARCHAR(10),g.genreId)+'","genreName":"'+g.genreName+'"}' FROM dbo.Genre AS g JOIN dbo.Movies_Genre AS mg ON mg.GenreID = g.genreId WHERE mg.MovieID = m.movieId FOR XML PATH('')),1,1,'') AS genre) Genre
   WHERE m.movieId = @id  AND m.status = 1
   GROUP BY m.movieId,m.title,m.realTitle,m.titleTag,releaseDay,c.countryName,genre,m.imdb,m.actors,m.director,m.description,m.TYPE,currentEpisode,numberEpisode,m.duration,m.views,m.trailer,m.status,m.quantity,m.ageLimit,m.vipOnly
 END
 GO

CREATE PROCEDURE getLinkMovie
@movieId INT
 AS
 BEGIN
 SELECT * FROM dbo.Episode WHERE movieId = @movieId AND (res360!='' or res480!='' or res720!=''or res1080!='') AND broken= 0 ORDER BY language,episodeName
 END
 GO
 
 CREATE PROCEDURE getListMovieByDayRange
 @start VARCHAR(10),
 @end VARCHAR(10)
 AS
 BEGIN
	SELECT * FROM dbo.Movies WHERE uploadDay >= CAST(@start AS DATE) AND uploadDay <= CAST(@end AS DATE) ORDER BY views DESC,uploadDay DESC
 END
 GO

CREATE PROCEDURE getCountNoti
@title VARCHAR(20)
AS
BEGIN
	SELECT STUFF((SELECT ','+'{"count":'+ CONVERT(VARCHAR(10),COUNT(notiId))+
	',"lastTime":"'+CONVERT(VARCHAR(20),(SELECT DATEDIFF(MINUTE,(SELECT ISNULL((SELECT TOP 1(t.time) FROM dbo.Notifications t WHERE t.title =@title AND t.isUnread = 0 ORDER BY t.time DESC),0)),GETDATE())),120)+ '"}' FROM dbo.Notifications WHERE title=@title AND isUnread = 0 FOR XML PATH('')),1,1,'')		
END
go

CREATE PROCEDURE getMovieBox
@userID INT
AS
BEGIN
	SELECT m.movieId,m.title,m.realTitle,m.titleTag,CONVERT(VARCHAR(10), m.releaseDay, 101) AS releaseDay,c.countryName,genre,m.imdb,ISNULL(AVG(r.star),0) AS rate,COUNT(r.star) AS ratecount,m.actors,m.director,m.description,m.type,ISNULL(currentEpisode,0) AS currentEpisode,ISNULL(numberEpisode,0) AS numberEpisode,m.duration,m.views,m.trailer,m.status,m.quantity,m.ageLimit,m.vipOnly,f.follow
   FROM dbo.Movies AS m JOIN dbo.Country AS c ON c.countryId = m.countryId LEFT JOIN dbo.Rating AS r ON r.movieId = m.movieId LEFT JOIN dbo.Favorites f ON f.movieId = m.movieId LEFT JOIN (SELECT e.movieId,CAST(ISNULL(MAX(episodeName),0) AS Int) AS currentEpisode,COUNT(episodeId) AS numberEpisode FROM dbo.Episode e WHERE (res360!='' or res480!='' or res720!=''or res1080!='') AND broken=0 GROUP BY e.movieId) AS epi ON epi.movieId = m.movieId
   CROSS APPLY (SELECT STUFF((SELECT ','+'{"genreId":"'+CONVERT(VARCHAR(10),g.genreId)+'","genreName":"'+g.genreName+'"}' FROM dbo.Genre AS g JOIN dbo.Movies_Genre AS mg ON mg.GenreID = g.genreId WHERE mg.MovieID = m.movieId FOR XML PATH('')),1,1,'') AS genre) Genre
   WHERE m.status = 1 AND f.accountId =@userID
   GROUP BY m.movieId,m.title,m.realTitle,m.titleTag,releaseDay,c.countryName,genre,m.imdb,m.actors,m.director,m.description,m.TYPE,currentEpisode,numberEpisode,m.duration,m.views,m.trailer,m.status,m.quantity,m.ageLimit,m.vipOnly,f.follow
END
GO

CREATE PROCEDURE searchNoti
@id INT,
@title VARCHAR(50),
@recipient INT,
@type VARCHAR(50),
@isRead int
AS
BEGIN

DECLARE @SQL NVARCHAR(MAX)

SET @SQL = 'SELECT DISTINCT * FROM dbo.Notifications'

DECLARE @IsHavaParam BIT = 0

IF (@id IS not NULL AND @id <> -1)
	BEGIN		
		SET @IsHavaParam = 1       

        SET @SQL = @SQL + ' WHERE notiId = '+ CAST(@id AS VARCHAR(50))  
    END

IF (@title IS NOT NULL and @title !='')
	BEGIN
		IF (@IsHavaParam = 0)
		BEGIN
			SET @SQL = @SQL + ' where '
			SET @IsHavaParam = 1
        END
		ELSE
		BEGIN
		SET @SQL = @SQL + ' and '
        END

        SET @SQL = @SQL + ' title = '+''''+@title +''''      
    END

IF (@recipient IS NOT NULL and @recipient <>-1)
	BEGIN
		IF (@IsHavaParam = 0)
		BEGIN
			SET @SQL = @SQL + ' where '
			SET @IsHavaParam = 1
        END
		ELSE
		BEGIN
		SET @SQL = @SQL + ' and '
        END

        SET @SQL = @SQL + ' recipientID = '+CAST(@recipient AS VARCHAR(50))        
    END

IF (@type  IS NOT NULL AND @type != '')
	BEGIN
		IF (@IsHavaParam = 0)
		BEGIN
			SET @SQL = @SQL + ' where '
			SET @IsHavaParam = 1
        END
		ELSE
		BEGIN
		SET @SQL = @SQL + ' and '
        END

        SET @SQL = @SQL + 'type = '+''''+@type +''''
    END 

IF (@isRead IS not NULL AND @isRead <> -1)
	BEGIN
		IF (@IsHavaParam = 0)
		BEGIN
			SET @SQL = @SQL + ' where '
			SET @IsHavaParam = 1
        END
		ELSE
		BEGIN
		SET @SQL = @SQL + ' and '
        END

        SET @SQL = @SQL + ' isUnread = ' + CAST(@isRead AS VARCHAR(10))   
    END    

SET @SQL = @SQL + ' ORDER BY notiId DESC'

PRINT @SQL

EXEC sp_executesql @SQL

END
GO


CREATE PROCEDURE getListTrailerMovie
 AS
 BEGIN
 SELECT TOP(10) m.movieId,m.title,m.realTitle,m.titleTag,CONVERT(VARCHAR(10), m.releaseDay, 101) AS releaseDay,c.countryName,genre,m.imdb,ISNULL(AVG(r.star),0) AS rate,COUNT(r.star) AS ratecount,m.actors,m.director,m.description,m.type,ISNULL(currentEpisode,0) AS currentEpisode,ISNULL(numberEpisode,0) AS numberEpisode,m.duration,m.views,m.trailer,m.status,m.quantity,m.ageLimit,m.vipOnly
   FROM dbo.Movies AS m JOIN dbo.Country AS c ON c.countryId = m.countryId LEFT JOIN dbo.Rating AS r ON r.movieId = m.movieId FULL JOIN (SELECT movieId,CAST(ISNULL(MAX(episodeName),0) AS Int) AS currentEpisode,COUNT(episodeId) AS numberEpisode FROM dbo.Episode WHERE (res360!='' or res480!='' or res720!=''or res1080!='') AND broken=0 GROUP BY movieId) epi ON epi.movieId = m.movieId
   CROSS APPLY (SELECT STUFF((SELECT ','+'{"genreId":"'+CONVERT(VARCHAR(10),g.genreId)+'","genreName":"'+g.genreName+'"}' FROM dbo.Genre AS g JOIN dbo.Movies_Genre AS mg ON mg.GenreID = g.genreId WHERE mg.MovieID = m.movieId FOR XML PATH('')),1,1,'') AS genre) Genre
   WHERE m.status = 1 AND (epi.numberEpisode IS NULL OR epi.numberEpisode =0)
   GROUP BY m.movieId,m.title,m.realTitle,m.titleTag,releaseDay,c.countryName,genre,m.imdb,m.actors,m.director,m.description,m.TYPE,currentEpisode,numberEpisode,m.duration,m.views,m.trailer,m.status,m.quantity,m.ageLimit,m.vipOnly
	ORDER BY m.movieId DESC
 END
 GO

CREATE PROCEDURE getListMovieByType
 @type BIT,
 @num int
 AS
 BEGIN
	SELECT TOP(@num) m.movieId,m.title,m.realTitle,m.titleTag,CONVERT(VARCHAR(10), m.releaseDay, 101) AS releaseDay,c.countryName,genre,m.imdb,ISNULL(AVG(r.star),0) AS rate,COUNT(r.star) AS ratecount,m.actors,m.director,m.description,m.type,ISNULL(currentEpisode,0) AS currentEpisode,ISNULL(numberEpisode,0) AS numberEpisode,m.duration,m.views,m.trailer,m.status,m.quantity,m.ageLimit,m.vipOnly
   FROM dbo.Movies AS m JOIN dbo.Country AS c ON c.countryId = m.countryId LEFT JOIN dbo.Rating AS r ON r.movieId = m.movieId FULL JOIN (SELECT movieId,CAST(ISNULL(MAX(episodeName),0) AS Int) AS currentEpisode,COUNT(episodeId) AS numberEpisode FROM dbo.Episode WHERE (res360!='' or res480!='' or res720!=''or res1080!='') AND broken=0 GROUP BY movieId) epi ON epi.movieId = m.movieId
   CROSS APPLY (SELECT STUFF((SELECT ','+'{"genreId":"'+CONVERT(VARCHAR(10),g.genreId)+'","genreName":"'+g.genreName+'"}' FROM dbo.Genre AS g JOIN dbo.Movies_Genre AS mg ON mg.GenreID = g.genreId WHERE mg.MovieID = m.movieId FOR XML PATH('')),1,1,'') AS genre) Genre
   WHERE m.status = 1 AND m.type = @type AND epi.numberEpisode >=1
   GROUP BY m.movieId,m.title,m.realTitle,m.titleTag,releaseDay,c.countryName,genre,m.imdb,m.actors,m.director,m.description,m.TYPE,currentEpisode,numberEpisode,m.duration,m.views,m.trailer,m.status,m.quantity,m.ageLimit,m.vipOnly 
   ORDER BY m.movieId DESC
 END
 GO

 create PROCEDURE getListPaymentByDayRange
 @start VARCHAR(10),
 @end VARCHAR(10)
 AS
 BEGIN
	SELECT * FROM dbo.AccountVipHistory WHERE dateRegister >= CAST(@start AS DATE) AND dateRegister <= CAST(@end AS DATE) ORDER BY dateRegister DESC
 END
 GO

 CREATE PROCEDURE searchMovie
@id INT,
@title NVARCHAR(MAX),
@actor NVARCHAR(MAX),
@director NVARCHAR(MAX),
@type int,
@uploadDay int,
@releaseDay int,
@countryName VARCHAR(MAX),
@genreName VARCHAR(MAX),
@views int
as
begin

DECLARE @SQL NVARCHAR(MAX)

SET @SQL = 'SELECT m.movieId,m.title,m.realTitle,m.titleTag,CONVERT(VARCHAR(10), m.releaseDay, 101) AS releaseDay,c.countryName,genre,m.imdb,ISNULL(AVG(r.star),0) AS rate,COUNT(r.star) AS ratecount,m.actors,m.director,m.description,m.type,ISNULL(currentEpisode,0) AS currentEpisode,ISNULL(numberEpisode,0) AS numberEpisode,m.duration,m.views,m.trailer,m.status,m.quantity,m.ageLimit,m.vipOnly
   FROM dbo.Movies AS m JOIN dbo.Country AS c ON c.countryId = m.countryId LEFT JOIN dbo.Rating AS r ON r.movieId = m.movieId FULL JOIN (SELECT movieId,CAST(ISNULL(MAX(episodeName),0) AS Int) AS currentEpisode,COUNT(episodeId) AS numberEpisode FROM dbo.Episode WHERE (res360!='' or res480!='' or res720!=''or res1080!='') AND broken=0 GROUP BY movieId) epi ON epi.movieId = m.movieId
   CROSS APPLY (SELECT STUFF((SELECT '',''+''{"genreId":"''+CONVERT(VARCHAR(10),g.genreId)+''","genreName":"''+g.genreName+''"}'' FROM dbo.Genre AS g JOIN dbo.Movies_Genre AS mg ON mg.GenreID = g.genreId WHERE mg.MovieID = m.movieId FOR XML PATH('''')),1,1,'''') AS genre) Genre
   WHERE m.status = 1'

IF (@id IS not NULL AND @id <> -1)
	SET @SQL = @SQL + ' and m.movieId = '+ CAST(@id AS VARCHAR(50))
IF (@title IS NOT NULL and @title !='')
	SET @SQL = @SQL + ' and m.title like N''%'+@title+'%'' or m.realTitle like N''%'+@title+'%'' or m.titleTag like N''%'+@title+'%''' 
IF (@actor IS NOT NULL and @actor !='')
	SET @SQL = @SQL + ' and m.actors like N''%'+@actor+'%'' or m.actor_ascii like N''%'+@actor+'%'''
IF (@director IS NOT NULL and @director !='')
	SET @SQL = @SQL + ' and m.director like N''%'+@director+'%'' or m.director_ascii like N''%'+@director+'%'''
IF (@type IS not NULL AND @type <> -1)
	SET @SQL = @SQL + ' and m.type = '+ CAST(@type AS VARCHAR(50))
IF (@countryName IS NOT NULL and @countryName !='')
	SET @SQL = @SQL + ' and c.countryName = '+''''+@countryName +''''
IF (@genreName IS NOT NULL and @genreName !='')
	SET @SQL = @SQL + ' and genre like N''%'+@genreName+'%'''
IF (@releaseDay IS NOT NULL and @releaseDay <> -1)
	SET @SQL = @SQL + ' and YEAR(releaseDay) ='+ CAST(@releaseDay AS VARCHAR(50))
SET @SQL = @SQL + ' and epi.numberEpisode >=1'

SET @SQL = @SQL + ' GROUP BY m.movieId,m.title,m.realTitle,m.titleTag,releaseDay,c.countryName,genre,m.imdb,m.actors,m.director,m.description,m.TYPE,currentEpisode,numberEpisode,m.duration,m.views,m.trailer,m.status,m.quantity,m.ageLimit,m.vipOnly' 

DECLARE @IsHavaParam BIT = 0

IF (@uploadDay IS not NULL AND @uploadDay <> -1)
BEGIN
	SET @IsHavaParam = 1
	SET @SQL = @SQL + ' ORDER by m.movieId DESC'
END
IF (@views IS not NULL AND @views <> -1) 
	IF (@IsHavaParam=1)		
		SET @SQL = @SQL + ', m.views DESC'
	ELSE
		SET @SQL = @SQL + ' ORDER by m.views DESC'
PRINT @SQL

EXEC sp_executesql @SQL

END
GO


CREATE PROCEDURE searchHeader
@title NVARCHAR(MAX)

 AS
 BEGIN
   SELECT m.movieId,m.title,m.realTitle,m.titleTag,CONVERT(VARCHAR(10), m.releaseDay, 101) AS releaseDay,c.countryName,genre,m.imdb,ISNULL(AVG(r.star),0) AS rate,COUNT(r.star) AS ratecount,m.actors,m.director,m.description,m.type,ISNULL(currentEpisode,0) AS currentEpisode,ISNULL(numberEpisode,0) AS numberEpisode,m.duration,m.views,m.trailer,m.status,m.quantity,m.ageLimit,m.vipOnly
   FROM dbo.Movies AS m JOIN dbo.Country AS c ON c.countryId = m.countryId LEFT JOIN dbo.Rating AS r ON r.movieId = m.movieId FULL JOIN (SELECT movieId,CAST(ISNULL(MAX(episodeName),0) AS Int) AS currentEpisode,COUNT(episodeId) AS numberEpisode FROM dbo.Episode WHERE (res360!='' or res480!='' or res720!=''or res1080!='') AND broken=0 GROUP BY movieId) epi ON epi.movieId = m.movieId
   CROSS APPLY (SELECT STUFF((SELECT ','+'{"genreId":"'+CONVERT(VARCHAR(10),g.genreId)+'","genreName":"'+g.genreName+'"}' FROM dbo.Genre AS g JOIN dbo.Movies_Genre AS mg ON mg.GenreID = g.genreId WHERE mg.MovieID = m.movieId FOR XML PATH('')),1,1,'') AS genre) Genre
   WHERE m.status = 1 and (m.title like N'%'+@title+'%' or m.realTitle like N'%'+@title+'%' or m.titleTag like N'%'+@title+'%' or m.actors like N'%'+@title+'%' or m.actor_ascii like N'%'+@title+'%' or m.director like N'%'+@title+'%' or m.director_ascii like N'%'+@title+'%')
   GROUP BY m.movieId,m.title,m.realTitle,m.titleTag,releaseDay,c.countryName,genre,m.imdb,m.actors,m.director,m.description,m.TYPE,currentEpisode,numberEpisode,m.duration,m.views,m.trailer,m.status,m.quantity,m.ageLimit,m.vipOnly
   order by m.movieId DESC
 END
 GO

 CREATE PROCEDURE relatedMovies
 @id INT,
 @title NVARCHAR(MAX),
 @genre VARCHAR(50),
 @actor VARCHAR(50),
 @country VARCHAR(50)
 as
 BEGIN
	  SELECT TOP(10) m.movieId,m.title,m.realTitle,m.titleTag,CONVERT(VARCHAR(10), m.releaseDay, 101) AS releaseDay,c.countryName,genre,m.imdb,ISNULL(AVG(r.star),0) AS rate,COUNT(r.star) AS ratecount,m.actors,m.director,m.description,m.type,ISNULL(currentEpisode,0) AS currentEpisode,ISNULL(numberEpisode,0) AS numberEpisode,m.duration,m.views,m.trailer,m.status,m.quantity,m.ageLimit,m.vipOnly
	   FROM dbo.Movies AS m JOIN dbo.Country AS c ON c.countryId = m.countryId LEFT JOIN dbo.Rating AS r ON r.movieId = m.movieId FULL JOIN (SELECT movieId,CAST(ISNULL(MAX(episodeName),0) AS Int) AS currentEpisode,COUNT(episodeId) AS numberEpisode FROM dbo.Episode WHERE (res360!='' or res480!='' or res720!=''or res1080!='') AND broken=0 GROUP BY movieId) epi ON epi.movieId = m.movieId
	   CROSS APPLY (SELECT STUFF((SELECT ','+'{"genreId":"'+CONVERT(VARCHAR(10),g.genreId)+'","genreName":"'+g.genreName+'"}' FROM dbo.Genre AS g JOIN dbo.Movies_Genre AS mg ON mg.GenreID = g.genreId WHERE mg.MovieID = m.movieId FOR XML PATH('')),1,1,'') AS genre) Genre
	   WHERE m.status = 1 and (m.title like N'%'+@title+'%' or m.realTitle like N'%'+@title+'%' or m.titleTag like N'%'+@title+'%' or m.actors like N'%'+ @actor+'%' or m.actor_ascii like N'%'+ @actor+'%' OR genre LIKE N'%'+ @genre+'%' OR c.countryName = @country) AND epi.numberEpisode >=1 AND m.movieId !=@id
	   GROUP BY m.movieId,m.title,m.realTitle,m.titleTag,releaseDay,c.countryName,genre,m.imdb,m.actors,m.director,m.description,m.TYPE,currentEpisode,numberEpisode,m.duration,m.views,m.trailer,m.status,m.quantity,m.ageLimit,m.vipOnly
	   order by m.movieId DESC
 END
 GO
 
 ------------------------------------------------------------------------------------------------------------


 INSERT INTO dbo.Country VALUES  
('Viet Nam',1),
('China',2),
('Japan',3),
('France',4),
('USA',5),
('Korean',6),
('Taiwan',7),
('Canada',8),
('India',9),
('Thailand',10),
('Australia',11),
('England',12),
('Hong Kong',13),
('Other',14)
GO

INSERT INTO  dbo.Genre VALUES
('Action',1),
('Animation',2),
('Comedy',3),
('Documentary',4),
('Family',5),
('Horror',6),
('Film-Noir',7),
('Musical',8),
('Romance',9),
('Sport',10),
('War',11),
('Adventure',12),
('Biography',13),
('Crime',14),
('Drama',15),
('Fantasy',16),
('History',17),
('Music',18),
('Mystery',19),
('Sci-Fi',20),
('Thriller',21),
('Western',22)
go

INSERT INTO dbo.Role VALUES  
('ROLE_ADMIN','#ff0000'),
('ROLE_UPLOADER','#03a303'),
('ROLE_VIP','#ffff00'),
('ROLE_MEMBER','#04688E')
GO

INSERT INTO  dbo.Accounts
VALUES  ('namintelvn','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','01212893573',2,1 ,'114314139163194.png','namintelvn@gmail.com' ,'2010-06-07' ,1,'',0, N''),
 ('christran' ,'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', '0983393839' ,1,1 ,'114314322496509.png' , 'chris@gmail.com' ,'2010-12-07' ,1,'',0, N''),
 ('thanhthe' ,'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', '0981239871' ,4,1 ,'114314999163108.png' , 'thanhthe@gmail.com' ,'2017-12-12' ,0,'',0, N''),
 ('vanluong' ,'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', '0907483847' ,3,1 ,'131715304089744.png' , 'luong@gmail.com' ,'2014-02-01' ,1,'2018-01-14',0, N''),
 ('camtu' ,'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', '0123456778' ,4,1 ,'' , 'tu@gmail.com' ,'2015-12-01' ,0,'2016-07-30',0, N'')     
GO

 INSERT INTO dbo.TypeVip VALUES 
 ('Basic',7,20000),
 ('Standard',30,70000),
 ('Gold',180,300000),
 ('Platinum',365,500000)
 go

 INSERT INTO dbo.AccountVipHistory VALUES
 (5,3,'2015-01-12'),
 (5,1,'2015-05-12'),
 (4,2,'2016-01-01'),
 (5,2,'2016-03-20'), 
 (5,1,'2016-04-12'),
 (5,2,'2016-07-01'),
 (4,3,'2017-01-19'),
 (4,2,'2017-02-20'),
 (4,1,'2017-05-24'), 
 (4,2,'2017-12-15')
 GO
 

INSERT [dbo].[Movies] VALUES (N'Deadpool 2', N'Deadpool 2 (2018)', N'deadpool,deadpool 2,marvel,xmen,men', CAST(N'2018-03-02' AS Date), 5, 0, N'Ryan Reynolds,
David Harbour', N'Ryan Reynolds,
David Harbour', N'David Leitch', N'David Leitch', N'After surviving a near fatal knee boarding accident , a disfigured guidance counselor (Wade Wilson) struggles to fulfill his dream of becoming Poughkeepsie''s most celebrated French Bulldog breeder while also learning to cope with an open relationship. Searching to regain his passion for life, as well as a new stuffed unicorn, Wade must battle ninjas, tight assed metal men, and babysit a group stereotypical side characters as he journeys around the world to discover the importance of family, friendship, and creative outlets for his very open-minded sex life. He manages to find a new lust for being a do-gooder, a sparkly Hello Kitty backpack, all while earning the coveted coffee mug title of World''s Best 4th Wall Breaking Superhero.', 0, N'0 minutes', 0, CAST(N'2018-01-05' AS Date), N'trailer_1.mp4', 1, N'FullHD', 0, 0)
GO
INSERT [dbo].[Movies] VALUES (N'Black Panther', N'Black Panther (2018)', N'black panther,panther', CAST(N'2018-02-16' AS Date), 5, 0, N'Andy Serkis,
Forest Whitaker,
Daniel Kaluuya', N'Andy Serkis,
Forest Whitaker,
Daniel Kaluuya', N'Ryan Coogler', N'Ryan Coogler', N'T''Challa, after the death of his father, the King of Wakanda, returns home to the isolated, technologically advanced African nation to succeed to the throne and take his rightful place as king.', 0, N'0 minutes', 0, CAST(N'2018-01-05' AS Date), N'trailer_2.mp4', 1, N'FullHD', 0, 0)
GO
INSERT [dbo].[Movies] VALUES (N'Ferdinand', N'Ferdinand (2017)', N'ferdinand', CAST(N'2017-12-22' AS Date), 5, 0, N'Kate Mckinnon,
David Tennant,
John Cena', N'Kate Mckinnon,
David Tennant,
John Cena', N'Carlos Saldanha', N'Carlos Saldanha', N'After Ferdinand, a bull with a big heart, is mistaken for a dangerous beast, he is captured and torn from his home. Determined to return to his family, he rallies a misfit team on the ultimate adventure.', 0, N'0 minutes', 0, CAST(N'2018-01-05' AS Date), N'trailer_3.mp4', 1, N'FullHD', 0, 0)
GO
INSERT [dbo].[Movies] VALUES (N'Annihilation', N'Annihilation (2018)', N'annihilation', CAST(N'2018-02-12' AS Date), 12, 0, N'Natalie Portman,
Tessa Thompson,
Oscar Isaac', N'Natalie Portman,
Tessa Thompson,
Oscar Isaac', N'Alex Garland', N'Alex Garland', N'A biologist signs up for a dangerous, secret expedition where the laws of nature don''t apply.', 0, N'0 minutes', 0, CAST(N'2018-01-05' AS Date), N'trailer_4.mp4', 1, N'FullHD', 0, 0)
GO
INSERT [dbo].[Movies] VALUES (N'RAMPAGE', N'Rampage (2018)', N'rampage', CAST(N'2018-04-11' AS Date), 5, 0, N'Breanne Hill,
Jason Liles,
Destiny Lopez', N'Breanne Hill,
Jason Liles,
Destiny Lopez', N'Brad Peyton', N'Brad Peyton', N'Based on the classic 1980s video game featuring apes and monsters destroying cities.', 0, N'0 minutes', 0, CAST(N'2018-01-05' AS Date), N'trailer_5.mp4', 1, N'FullHD', 0, 0)
GO
INSERT [dbo].[Movies] VALUES (N'Incredibles 2', N'Incredibles 2 (2018)', N'incredibles 2', CAST(N'2018-06-12' AS Date), 5, 0, N'Holly Hunter,
Sarah Vowell', N'Holly Hunter,
Sarah Vowell', N'Brad Bird', N'Brad Bird', N'Bob Parr (Mr. Incredible) is left to care for Jack-Jack while Helen (Elastigirl) is out saving the world.', 0, N'0 minutes', 0, CAST(N'2018-01-05' AS Date), N'trailer_6.mp4', 1, N'FullHD', 0, 0)
GO
INSERT [dbo].[Movies] VALUES (N'DUCK DUCK GOOSE', N'Duck Duck Goose (2018)', N'duck duck goose', CAST(N'2018-05-16' AS Date), 2, 0, N'Zendaya,
Lance Lim,
Greg Proops', N'Zendaya,
Lance Lim,
Greg Proops', N'Christopher Jenkins', N'Christopher Jenkins', N'A bachelor goose must form a bond with two lost ducklings as they journey south.', 0, N'0 minutes', 0, CAST(N'2018-01-05' AS Date), N'trailer_7.mp4', 1, N'FullHD', 0, 0)
GO
INSERT [dbo].[Movies] VALUES (N'Jumanji: Welcome to the Jungle', N'Jumanji: Welcome to the Jungle (2017)', N'jumanji welcome to the jungle,jumanji', CAST(N'2018-07-17' AS Date), 5, 0, N'Missi Pyle,
Jack Black,
 Karen Gillan', N'Missi Pyle,
Jack Black,
 Karen Gillan', N'Jake Kasdan', N'Jake Kasdan', N'Four teenagers are sucked into a magical video game, and the only way they can escape is to work together to finish the game.', 0, N'0 minutes', 0, CAST(N'2018-01-05' AS Date), N'trailer_8.mp4', 1, N'FullHD', 0, 0)
GO
INSERT [dbo].[Movies] VALUES (N'The Legend of Dugu', N'The Legend Of Dugu (2018)', N'the legend of dugu', CAST(N'2018-04-18' AS Date), 2, 0, N'Hu Bing Qing,An Ady,Zhang Andy,Li Yi Xiao', N'Hu Bing Qing,An Ady,Zhang Andy,Li Yi Xiao', N'Tsui Jeremy, Ying Jun', N'Tsui Jeremy, Ying Jun', N'A prophecy bearing the words, "The World of Dugu" reverberates across the lands to imply that the Dugu family was destined to do great things. Because of it, all the attention is turned to Dugu Xin, a court official, and his three daughters, Dugu Ban Ruo , Dugu Man Tuo, and Dugu Jia Luo. Each of the sisters were born blessed with natural beauty and intelligence, and in order to not letthe prophecy destroy the sisters'' relationship, they all vowed to stick by each other and not let any one of them get hurt.', 1, N'55 episode', 0, CAST(N'2018-01-05' AS Date), N'trailer_9.mp4', 1, N'FullHD', 0, 0)
GO
INSERT [dbo].[Movies] VALUES (N'Paddington 2', N'Paddington 2 (2018)', N'paddington 2', CAST(N'2018-03-12' AS Date), 5, 0, N'Imelda Staunton,
Ben Whishaw,
Madeleine Harris', N'Imelda Staunton,
Ben Whishaw,
Madeleine Harris', N'Paul King', N'Paul King', N'Paddington, now happily settled with the Brown family and a popular member of the local community, picks up a series of odd jobs to buy the perfect present for his Aunt Lucy''s 100th birthday, only for the gift to be stolen.', 0, N'0 minutes', 0, CAST(N'2018-01-05' AS Date), N'trailer_10.mp4', 1, N'FullHD', 0, 0)
GO
INSERT [dbo].[Movies] VALUES (N'Thor 3: Ragnarok', N'Thor 3: Ragnarok (2017)', N'thor ragnarok,thor,thor 3', CAST(N'2017-12-13' AS Date), 5, 8.4, N'Tom Hiddleston,
Idris Elba', N'Tom Hiddleston,
Idris Elba', N'Taika Waititi', N'Taika Waititi', N'Imprisoned, the mighty Thor finds himself in a lethal gladiatorial contest against the Hulk, his former ally. Thor must fight for survival and race against time to prevent the all-powerful Hela from destroying his home and the Asgardian civilization.', 0, N'130 minutes', 0, CAST(N'2018-01-05' AS Date), N'trailer_11.mp4', 1, N'FullHD', 0, 0)
GO
INSERT [dbo].[Movies] VALUES (N'TOKYO GHOUL', N'Tôkyô guru (2017)', N'tokyo ghoul', CAST(N'2017-12-13' AS Date), 3, 6.2, N'Kunio Murai', N'Kunio Murai', N'Kentarô Hagiwara', N'Kentaro Hagiwara', N'Truyện lấy bối cảnh thời hiện đại, một thế giới hoàn toàn khác khi mà loài người không phải loài đứng đầu chuỗi thức ăn, có một loài sinh vật khát máu, mang hình dạng giống con người nhưng phát triển hơn với những khả năng đặc biệt để trở thành kẻ đi săn, và con mồi chính là loài người, vốn tưởng mình làm chủ thế giới. Không cam chịu làm kẻ bị săn, loài người đứng lên chống lại loài sinh vật kia – Ghoul, quỷ ăn thịt. CCG (Ủy ban chống Quỷ ăn thịt) ra đời, đào tạo 1 lực lượng các thanh tra có kỹ năng chiến đấu cao nhằm chống lại sự tàn sát con người của quỷ ăn thịt.', 0, N'119 minutes', 0, CAST(N'2018-01-05' AS Date), N'trailer_12.mp4', 1, N'FullHD', 0, 0)
GO
INSERT [dbo].[Movies] VALUES (N'Beyond Skyline', N'Beyond Skyline (2017)', N'beyond skyline,skyline', CAST(N'2017-09-12' AS Date), 5, 5.4, N'Iko Uwais,
Antonio Fargas', N'Iko Uwais,
Antonio Fargas', N'Liam Odonnell', N'Liam Odonnell', N'A tough-as-nails detective embarks on a relentless pursuit to free his son from a nightmarish alien warship.', 0, N'120 minutes', 0, CAST(N'2018-01-05' AS Date), N'trailer_13.mp4', 1, N'FullHD', 0, 0)
GO
INSERT [dbo].[Movies] VALUES (N'The Battleship Island', N'Gun ham do (2017)', N'the battleship island,gun ham do,gun ham do 2017', CAST(N'2017-12-11' AS Date), 6, 5.3, N'Hwang JungMin', N'Hwang JungMin', N'Ryoo SeungWan', N'Ryoo SeungWan', N'During the Japanese colonial era, roughly 400 Korean people, who were forced onto Battleship Island ("Hashima Island") to mine for coal, attempt to a dramatic escape.', 0, N'135 minutes', 0, CAST(N'2018-01-05' AS Date), N'trailer_14.mp4', 1, N'FullHD', 0, 0)
GO
INSERT [dbo].[Movies] VALUES (N'Justice League', N'Justice League (2017)', N'justice league,justice league 2017', CAST(N'2017-09-14' AS Date), 5, 6.2, N'Henry Cavill,
Amy Adams,
Gal Gadot', N'Henry Cavill,
Amy Adams,
Gal Gadot', N'Zack Snyder', N'Zack Snyder', N'Fueled by his restored faith in humanity and inspired by Superman''s selfless act, Bruce Wayne enlists the help of his newfound ally, Diana Prince, to face an even greater enemy.', 0, N'138 minutes', 0, CAST(N'2018-01-05' AS Date), N'trailer_15.mp4', 1, N'FullHD', 0, 0)
GO
INSERT [dbo].[Movies] VALUES (N'Krampus', N'Krampus (2015)', N'krampus,krampus 2015', CAST(N'2015-12-12' AS Date), 5, 6.7, N'David Koechner,
Allison Tolman,
Conchata Ferrell', N'David Koechner,
Allison Tolman,
Conchata Ferrell', N'Michael Dougherty', N'Michael Dougherty', N'Zoe, a strange child, has a not so imaginary friend Krampus, who is the dark companion of St. Nicholas.', 0, N'95 minutes', 0, CAST(N'2018-01-05' AS Date), N'trailer_16.mp4', 1, N'FullHD', 0, 0)
GO
INSERT [dbo].[Movies] VALUES (N'Flatliners', N'Flatliners (2017)', N'flatliners, flatliners 2017', CAST(N'2017-08-04' AS Date), 5, 5, N'Diego Luna,
Nina Dobrev,
James Norton', N'Diego Luna,
Nina Dobrev,
James Norton', N'Niels Arden Oplev', N'Niels Arden Oplev', N'Five medical students, obsessed by what lies beyond the confines of life, embark on a daring experiment: by stopping their hearts for short periods, each triggers a near-death experience - giving them a firsthand account of the afterlife.', 0, N'109 minutes', 0, CAST(N'2018-01-05' AS Date), N'trailer_17.mp4', 1, N'FullHD', 0, 0)
GO
INSERT [dbo].[Movies] VALUES (N'The Foreigner', N'The Foreigner (2017)', N'the foreigner', CAST(N'2017-12-11' AS Date), 2, 5, N'Jackie Chan,
Pierce Brosnan', N'Jackie Chan,
Pierce Brosnan', N'Martin Campbell', N'Martin Campbell', N'A humble businessman with a buried past seeks justice when his daughter is killed in an act of terrorism. A cat-and-mouse conflict ensues with a government official, whose past may hold clues to the killers'' identities.', 0, N'97 minutes', 4, CAST(N'2018-01-04' AS Date), N'trailer_18.mp4', 1, N'FullHD', 0, 0)
GO
INSERT [dbo].[Movies] VALUES (N'The Golden Monk', N'The Golden Monk (2017)', N'the golden monk', CAST(N'2017-12-14' AS Date), 2, 7.2, N'Kar Ying Law, Junjie Mao', N'Kar Ying Law, Junjie Mao', N'Siu Hung Chung, Jing Wong', N'Siu Hung Chung, Jing Wong', N'The world''s top thieves join forces to pull off the heist of a lifetime. But when they find themselves pursued across Europe by a legendary French detective, they''ll have to take their game to the next level.', 0, N'125 minutes', 0, CAST(N'2018-01-04' AS Date), N'trailer_19.mp4', 1, N'FullHD', 0, 0)
GO
INSERT [dbo].[Movies] VALUES (N'Kingsman 2: The Golden Circle', N'Kingsman 2: The Golden Circle (2017)', N'kingsman 2,kingsman 2 the golden circle, the golden circle', CAST(N'2017-12-13' AS Date), 5, 7.5, N'Sophie Cookson,
Pedro Pascal', N'Sophie Cookson,
Pedro Pascal', N'Matthew Vaughn', N'Matthew Vaughn', N'When their headquarters are destroyed and the world is held hostage, the Kingsman''s journey leads them to the discovery of an allied spy organization in the US. These two elite secret organizations must band together to defeat a common enemy.', 0, N'132 minutes', 0, CAST(N'2018-01-05' AS Date), N'trailer_20.mp4', 1, N'FullHD', 0, 0)
GO
INSERT [dbo].[Movies] VALUES (N'One Piece', N'One Piece (1999)', N'one piece, Wan pisu', CAST(N'1999-12-29' AS Date), 3, 8.5, N'Ikue Ôtani,
Mayumi Tanaka,
Kazuya Nakai', N'Ikue Otani,
Mayumi Tanaka,
Kazuya Nakai', N'Eiichiro Oda, Kônosuke Uda', N'Eiichiro Oda, Konosuke Uda', N'Follows the adventures of Monkey D. Luffy and his friends in order to find the greatest treasure ever left by the legendary Pirate, Gol D Roger. The famous mystery treasure named "One Piece".', 1, N'0 episode', 0, CAST(N'2018-01-04' AS Date), N'trailer_21.mp4', 1, N'FullHD', 0, 0)
GO
INSERT [dbo].[Movies] VALUES (N'RUNNING MAN', N'Leonning maen (TV Show) (2010)', N'running man,tvshow,leonning maen', CAST(N'2010-12-29' AS Date), 6, 9, N'Lee Min Ho,
Park Shin Hye', N'Lee Min Ho,
Park Shin Hye', N'Kang Shin Hyo', N'Kang Shin Hyo', N'A variety show in which cast members will go to a South Korean landmark and play games there. There are several games to be played within the landmark and at least one of them has to do with the specific landmark and with running, hence the title Running Man.', 1, N'477 episode', 0, CAST(N'2018-01-05' AS Date), N'trailer_22.mp4', 1, N'FullHD', 0, 0)
GO
INSERT [dbo].[Movies] VALUES (N'Nirvana in Fire 2', N'Nirvana in Fire 2 (2017)', N'Lang ya bang, Nirvana 2017, Lang ya bang 2017', CAST(N'2017-08-07' AS Date), 2, 8.2, N'Yongdai Ding,
Kai Wang', N'Yongdai Ding,
Kai Wang', N'Long Chen', N'Long Chen', N'During the 4th century, war broke out between the feudal Northern Wei dynasty and Southern Liang dynasties, leading Liang''s General Lin Xie to take his only child, the 19 year old Lin Shu, to battle.', 1, N'50 episode', 0, CAST(N'2018-01-04' AS Date), N'trailer_23.mp4', 1, N'FullHD', 0, 0)
GO
INSERT [dbo].[Movies] VALUES (N'Dragon Ball Super', N'Dragon Ball Super: Doragon bôru cho', N'dragon ball super,dragon ball,dragon ball Super doragon bôru cho', CAST(N'2015-12-29' AS Date), 3, 8.6, N'sakura, omoshio hanachi', N'sakura, omoshio hanachi', N'Kimitoshi Chioka', N'Kimitoshi Chioka', N'The continuing adventures of the mighty warrior Son Goku, as he encounters new worlds and new warriors to fight.', 1, N'145 episode', 0, CAST(N'2018-01-05' AS Date), N'trailer_24.mp4', 1, N'FullHD', 0, 0)
GO
INSERT [dbo].[Movies] VALUES (N'While You Were Sleeping', N'Dangshini Jamdeun Saie (2017)', N'while you were sleeping,dangshini jamdeun saie', CAST(N'2017-12-13' AS Date), 6, 7.5, N'Lee JongSuk,
Bae Suzy,
Lee SangYeob', N'Lee JongSuk,
Bae Suzy,
Lee SangYeob', N'Oh ChoongHwan', N'Oh ChoongHwan', N'The drama is about a woman (Bae Suzy) which can see accidents that take place in the future through her dreams. A prosecutor (Lee Jong-Suk) struggles to stop the woman''s dreams from coming true.', 1, N'32 episode', 0, CAST(N'2018-01-05' AS Date), N'trailer_25.mp4', 1, N'FullHD', 0, 0)
GO

INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (1, 1)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (1, 6)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (1, 15)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (2, 16)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (2, 1)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (2, 14)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (3, 2)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (3, 8)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (4, 1)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (4, 6)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (5, 16)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (5, 1)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (5, 6)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (6, 16)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (6, 1)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (6, 2)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (7, 1)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (7, 2)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (7, 5)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (7, 8)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (8, 17)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (8, 1)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (8, 6)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (8, 7)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (9, 18)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (9, 3)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (9, 6)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (9, 15)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (10, 16)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (10, 2)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (10, 18)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (10, 3)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (11, 16)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (11, 1)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (11, 11)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (12, 1)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (12, 6)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (12, 11)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (13, 1)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (13, 6)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (13, 11)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (14, 16)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (14, 1)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (14, 6)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (14, 11)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (15, 16)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (15, 1)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (15, 11)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (16, 6)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (16, 11)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (16, 15)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (17, 6)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (17, 7)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (17, 15)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (18, 1)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (18, 5)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (18, 11)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (19, 16)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (19, 5)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (20, 1)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (20, 10)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (20, 11)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (20, 15)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (21, 16)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (21, 1)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (21, 2)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (21, 6)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (22, 18)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (22, 5)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (22, 15)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (23, 1)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (23, 11)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (23, 15)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (24, 16)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (24, 1)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (24, 2)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (25, 16)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (25, 1)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (25, 5)
GO
INSERT [dbo].[Movies_Genre] ([MovieID], [GenreID]) VALUES (25, 15)
GO

INSERT [dbo].[Episode] VALUES (11, 1, N'English', N'c6r0v_j65qd_1.0_English_1_360.mp4', N'c6r0v_j65qd_1.0_English_1_480.mp4', N'c6r0v_j65qd_1.0_English_1_720.m3u8', N'c6r0v_j65qd_1.0_English_1_1080.m3u8', N'', 0)
GO
INSERT [dbo].[Episode] VALUES (12, 1, N'English', N'ac08m_m3vud_1.0_English_2_360.mp4', N'ac08m_m3vud_1.0_English_2_480.mp4', N'ac08m_m3vud_1.0_English_2_720.m3u8', N'ac08m_m3vud_1.0_English_2_1080.m3u8', N'', 0)
GO
INSERT [dbo].[Episode] VALUES (13, 1, N'English', N'le8sx_svdqs_1.0_English_3_360.mp4', N'le8sx_svdqs_1.0_English_3_480.mp4', N'le8sx_svdqs_1.0_English_3_720.m3u8', N'le8sx_svdqs_1.0_English_3_1080.m3u8', N'', 0)
GO
INSERT [dbo].[Episode] VALUES (14, 1, N'English', N'9qu9e_i6ekx_1.0_English_4_360.mp4', N'9qu9e_i6ekx_1.0_English_4_480.mp4', N'9qu9e_i6ekx_1.0_English_4_720.m3u8', N'9qu9e_i6ekx_1.0_English_4_1080.m3u8', N'', 0)
GO
INSERT [dbo].[Episode] VALUES (15, 1, N'English', N'hv01y_5qlw5_1.0_English_5_360.mp4', N'hv01y_5qlw5_1.0_English_5_480.mp4', N'hv01y_5qlw5_1.0_English_5_720.m3u8', N'hv01y_5qlw5_1.0_English_5_1080.m3u8', N'', 0)
GO
INSERT [dbo].[Episode] VALUES (16, 1, N'English', N'67z4j_n8qj1_1.0_English_6_360.mp4', N'67z4j_n8qj1_1.0_English_6_480.mp4', N'67z4j_n8qj1_1.0_English_6_720.m3u8', N'67z4j_n8qj1_1.0_English_6_1080.m3u8', N'', 0)
GO
INSERT [dbo].[Episode] VALUES (17, 1, N'English', N'xnjlf_sn8i0_1.0_English_7_360.mp4', N'xnjlf_sn8i0_1.0_English_7_480.mp4', N'xnjlf_sn8i0_1.0_English_7_720.m3u8', N'xnjlf_sn8i0_1.0_English_7_1080.m3u8', N'', 0)
GO
INSERT [dbo].[Episode] VALUES (18, 1, N'English', N'1jq3i_ut64z_1.0_English_8_360.mp4', N'1jq3i_ut64z_1.0_English_8_480.mp4', N'1jq3i_ut64z_1.0_English_8_720.m3u8', N'1jq3i_ut64z_1.0_English_8_1080.m3u8', N'', 0)
GO
INSERT [dbo].[Episode] VALUES (19, 1, N'English', N'lw9vo_5d8bu_1.0_English_9_360.mp4', N'lw9vo_5d8bu_1.0_English_9_480.mp4', N'lw9vo_5d8bu_1.0_English_9_720.m3u8', N'lw9vo_5d8bu_1.0_English_9_1080.m3u8', N'', 0)
GO
INSERT [dbo].[Episode] VALUES (20, 1, N'English', N'ak8ml_9dniy_1.0_English_10_360.mp4', N'ak8ml_9dniy_1.0_English_10_480.mp4', N'ak8ml_9dniy_1.0_English_10_720.m3u8', N'ak8ml_9dniy_1.0_English_10_1080.m3u8', N'', 0)
GO
INSERT [dbo].[Episode] VALUES (21, 1, N'Japanese', N'4fm6o_fpe2j_1.0_Japanese_11_360.mp4', N'4fm6o_fpe2j_1.0_Japanese_11_480.mp4', N'4fm6o_fpe2j_1.0_Japanese_11_720.m3u8', N'4fm6o_fpe2j_1.0_Japanese_11_1080.m3u8', N'', 0)
GO
INSERT [dbo].[Episode] VALUES (21, 2, N'Japanese', N'txrgs_rjxvu_2.0_Japanese_12_360.mp4', N'txrgs_rjxvu_2.0_Japanese_12_480.mp4', N'txrgs_rjxvu_2.0_Japanese_12_720.m3u8', N'txrgs_rjxvu_2.0_Japanese_12_1080.m3u8', N'', 0)
GO
INSERT [dbo].[Episode] VALUES (22, 1, N'Korean', N'pal3r_k4qip_1.0_Korean_13_360.mp4', N'pal3r_k4qip_1.0_Korean_13_480.mp4', N'pal3r_k4qip_1.0_Korean_13_720.m3u8', N'pal3r_k4qip_1.0_Korean_13_1080.m3u8', N'', 0)
GO
INSERT [dbo].[Episode] VALUES (23, 1, N'Chinese', N'9qvi6_vif1e_1.0_Chinese_14_360.mp4', N'9qvi6_vif1e_1.0_Chinese_14_480.mp4', N'9qvi6_vif1e_1.0_Chinese_14_720.m3u8', N'9qvi6_vif1e_1.0_Chinese_14_1080.m3u8', N'', 0)
GO
INSERT [dbo].[Episode] VALUES (24, 1, N'Japanese', N'dragonball_1.0_Japanese_15_360.MP4', N'dragonball_1.0_Japanese_15_480.MP4', N'dragonball_1.0_Japanese_15_720.m3u8', N'dragonball_1.0_Japanese_15_1080.m3u8', N'', 0)
GO
INSERT [dbo].[Episode] VALUES (25, 1, N'Korean', N'qmyjm_j9w44_1.0_Korean_16_360.mp4', N'qmyjm_j9w44_1.0_Korean_16_480.mp4', N'qmyjm_j9w44_1.0_Korean_16_720.m3u8', N'qmyjm_j9w44_1.0_Korean_16_1080.m3u8', N'', 0)
GO


