USE [master]
GO
/****** Object:  Database [NutriaryDatabase]    Script Date: 7/22/2024 9:21:47 AM ******/
CREATE DATABASE [NutriaryDatabase]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'NutriaryDatabase', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.BSISQLEXPRESS\MSSQL\DATA\NutriaryDatabase.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'NutriaryDatabase_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.BSISQLEXPRESS\MSSQL\DATA\NutriaryDatabase_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [NutriaryDatabase] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [NutriaryDatabase].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [NutriaryDatabase] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [NutriaryDatabase] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [NutriaryDatabase] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [NutriaryDatabase] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [NutriaryDatabase] SET ARITHABORT OFF 
GO
ALTER DATABASE [NutriaryDatabase] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [NutriaryDatabase] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [NutriaryDatabase] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [NutriaryDatabase] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [NutriaryDatabase] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [NutriaryDatabase] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [NutriaryDatabase] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [NutriaryDatabase] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [NutriaryDatabase] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [NutriaryDatabase] SET  DISABLE_BROKER 
GO
ALTER DATABASE [NutriaryDatabase] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [NutriaryDatabase] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [NutriaryDatabase] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [NutriaryDatabase] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [NutriaryDatabase] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [NutriaryDatabase] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [NutriaryDatabase] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [NutriaryDatabase] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [NutriaryDatabase] SET  MULTI_USER 
GO
ALTER DATABASE [NutriaryDatabase] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [NutriaryDatabase] SET DB_CHAINING OFF 
GO
ALTER DATABASE [NutriaryDatabase] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [NutriaryDatabase] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [NutriaryDatabase] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [NutriaryDatabase] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [NutriaryDatabase] SET QUERY_STORE = OFF
GO
USE [NutriaryDatabase]
GO
/****** Object:  UserDefinedFunction [dbo].[CalculateBMRFunction]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[CalculateBMRFunction]
(
    @gender NVARCHAR(10),
    @age INT,
    @weight DECIMAL(5, 2),
    @height DECIMAL(5, 2),
    @activity_level_multiplier DECIMAL(5, 2),
    @calorie_adjustment INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @bmr DECIMAL(10, 2)

    IF (@gender = 'Male')
    BEGIN
        SET @bmr = 66.5 + (13.75 * @weight) + (5.003 * @height) - (6.755 * @age)
    END
    ELSE
    BEGIN
        SET @bmr = 655.1 + (9.563 * @weight) + (1.850 * @height) - (4.676 * @age)
    END

    -- Adjust BMR based on activity level
    SET @bmr = @bmr * @activity_level_multiplier

    -- Adjust BMR based on target goal
    SET @bmr = @bmr + @calorie_adjustment

    RETURN @bmr
END
GO
/****** Object:  UserDefinedFunction [dbo].[CalculateRemainingBMR]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CalculateRemainingBMR]
(
    @user_id INT,
    @total_calories DECIMAL(10, 2)
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @bmr DECIMAL(10, 2);

    -- Mendapatkan nilai BMR pengguna dari tabel UserCalorieInformation
    SELECT @bmr = bmr
    FROM UserCalorieInformation
    WHERE user_id = @user_id;

    -- Menghitung sisa angka BMR
    DECLARE @remaining_bmr DECIMAL(10, 2);
    SET @remaining_bmr = @bmr - @total_calories;

    RETURN @remaining_bmr;
END
GO
/****** Object:  Table [dbo].[DailyLogs]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DailyLogs](
	[log_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[food_id] [nvarchar](50) NOT NULL,
	[quantity] [decimal](5, 2) NOT NULL,
	[log_date] [date] NOT NULL,
 CONSTRAINT [PK__DailyLog__9E2397E04EDBF15D] PRIMARY KEY CLUSTERED 
(
	[log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FoodNutritionInfo]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FoodNutritionInfo](
	[food_id] [nvarchar](50) NOT NULL,
	[food_name] [nvarchar](50) NOT NULL,
	[energy_kal] [decimal](5, 2) NOT NULL,
	[protein_g] [decimal](5, 2) NOT NULL,
	[fat_g] [decimal](5, 2) NOT NULL,
	[carbs_g] [decimal](5, 2) NOT NULL,
	[fiber_g] [decimal](5, 2) NOT NULL,
	[calcium_mg] [decimal](5, 2) NOT NULL,
	[fe_mg] [decimal](5, 2) NOT NULL,
	[natrium_mg] [decimal](5, 2) NOT NULL,
 CONSTRAINT [PK_FoodNutritionInfo] PRIMARY KEY CLUSTERED 
(
	[food_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[username] [nvarchar](50) NOT NULL,
	[email] [nvarchar](100) NOT NULL,
	[password] [nvarchar](100) NOT NULL,
	[firstname] [nvarchar](100) NOT NULL,
	[lastname] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK__Users__B9BE370FC263C3F0] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[WeeklyProgressView]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[WeeklyProgressView] AS
SELECT 
    U.user_id,
    DL.start_of_week,
    DL.end_of_week,
    SUM(FNI.energy_kal) AS total_energy_kal,
    SUM(FNI.protein_g) AS total_protein_g,
    SUM(FNI.fat_g) AS total_fat_g,
    SUM(FNI.carbs_g) AS total_carbs_g,
    SUM(FNI.fiber_g) AS total_fiber_g,
    SUM(FNI.calcium_mg) AS total_calcium_mg,
    SUM(FNI.fe_mg) AS total_fe_mg,
    SUM(FNI.natrium_mg) AS total_natrium_mg
FROM (
    SELECT 
        user_id,
        DATEADD(DAY, 1 - DATEPART(WEEKDAY, log_date), log_date) AS start_of_week,
        DATEADD(DAY, 7 - DATEPART(WEEKDAY, log_date), log_date) AS end_of_week,
        food_id,
        SUM(quantity) AS quantity
    FROM DailyLogs
    GROUP BY user_id, DATEADD(DAY, 1 - DATEPART(WEEKDAY, log_date), log_date), DATEADD(DAY, 7 - DATEPART(WEEKDAY, log_date), log_date), food_id
) AS DL
JOIN FoodNutritionInfo AS FNI ON DL.food_id = FNI.food_id
JOIN Users AS U ON DL.user_id = U.user_id
GROUP BY 
    U.user_id,
    DL.start_of_week,
    DL.end_of_week;
GO
/****** Object:  View [dbo].[ConsumedFoodsView]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------

CREATE VIEW [dbo].[ConsumedFoodsView]
AS
SELECT
    DL.log_id,
    DL.user_id,
    DL.food_id,
    FNI.food_name,
    DL.quantity,
    DL.log_date
FROM
    DailyLogs DL
INNER JOIN
    FoodNutritionInfo FNI ON DL.food_id = FNI.food_id;
GO
/****** Object:  UserDefinedFunction [dbo].[CalculateNutrition]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[CalculateNutrition]
(
    @food_id NVARCHAR(50),
    @quantity DECIMAL(5, 2)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        energy_kal * @quantity / 100 AS energy_kal,
        protein_g * @quantity / 100 AS protein_g,
        fat_g * @quantity / 100 AS fat_g,
        carbs_g * @quantity / 100 AS carbs_g,
        fiber_g * @quantity / 100 AS fiber_g,
        calcium_mg * @quantity / 100 AS calcium_mg,
        fe_mg * @quantity / 100 AS fe_mg,
        natrium_mg * @quantity / 100 AS natrium_mg
    FROM FoodNutritionInfo
    WHERE food_id = @food_id
)
GO
/****** Object:  View [dbo].[FoodConsumptionSummary]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[FoodConsumptionSummary]
AS
SELECT 
    DL.log_id,
    DL.user_id,
    DL.food_id,
    DL.quantity,
	DL.log_date,
    FNI.food_name,
    CN.energy_kal AS total_energy_kcal,
    CN.protein_g AS total_protein_g,
    CN.fat_g AS total_fat_g,
    CN.carbs_g AS total_carbs_g,
    CN.fiber_g AS total_fiber_g,
    CN.calcium_mg AS total_calcium_mg,
    CN.fe_mg AS total_fe_mg,
    CN.natrium_mg AS total_natrium_mg
FROM 
    DailyLogs DL
JOIN 
    FoodNutritionInfo FNI ON DL.food_id = FNI.food_id
CROSS APPLY
    dbo.CalculateNutrition(DL.food_id, DL.quantity) AS CN;
GO
/****** Object:  Table [dbo].[ActivityLevels]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActivityLevels](
	[activity_id] [int] IDENTITY(1,1) NOT NULL,
	[activity_name] [nvarchar](50) NOT NULL,
	[activity_multiplier] [decimal](5, 2) NOT NULL,
 CONSTRAINT [PK__Activity__482FBD63D29234C2] PRIMARY KEY CLUSTERED 
(
	[activity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TargetGoals]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TargetGoals](
	[goal_id] [int] IDENTITY(1,1) NOT NULL,
	[goal_name] [nvarchar](50) NOT NULL,
	[calorie_adjustment] [int] NOT NULL,
 CONSTRAINT [PK__TargetGo__76679A24D4D6967A] PRIMARY KEY CLUSTERED 
(
	[goal_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserCalorieInformation]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserCalorieInformation](
	[calorie_info_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[activity_level_id] [int] NOT NULL,
	[target_goal_id] [int] NOT NULL,
	[bmr] [decimal](10, 2) NULL,
 CONSTRAINT [PK__UserCalo__3D49CC5F0A704D6D] PRIMARY KEY CLUSTERED 
(
	[calorie_info_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserDiary]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserDiary](
	[diary_id] [int] IDENTITY(1,1) NOT NULL,
	[log_date] [datetime] NOT NULL,
	[notes] [text] NOT NULL,
	[user_id] [int] NOT NULL,
 CONSTRAINT [PK_UserDiary] PRIMARY KEY CLUSTERED 
(
	[diary_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserProfile]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserProfile](
	[profile_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[gender] [nvarchar](10) NOT NULL,
	[age] [int] NOT NULL,
	[height] [decimal](5, 2) NOT NULL,
	[weight] [decimal](5, 2) NOT NULL,
 CONSTRAINT [PK__UserProf__AEBB701F948C8E48] PRIMARY KEY CLUSTERED 
(
	[profile_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_firstname]  DEFAULT (N'john') FOR [firstname]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_lastname]  DEFAULT (N'doe') FOR [lastname]
GO
ALTER TABLE [dbo].[DailyLogs]  WITH CHECK ADD  CONSTRAINT [FK__DailyLogs__food___37A5467C] FOREIGN KEY([food_id])
REFERENCES [dbo].[FoodNutritionInfo] ([food_id])
GO
ALTER TABLE [dbo].[DailyLogs] CHECK CONSTRAINT [FK__DailyLogs__food___37A5467C]
GO
ALTER TABLE [dbo].[DailyLogs]  WITH CHECK ADD  CONSTRAINT [FK__DailyLogs__user___36B12243] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[DailyLogs] CHECK CONSTRAINT [FK__DailyLogs__user___36B12243]
GO
ALTER TABLE [dbo].[UserCalorieInformation]  WITH CHECK ADD  CONSTRAINT [FK__UserCalor__activ__31EC6D26] FOREIGN KEY([activity_level_id])
REFERENCES [dbo].[ActivityLevels] ([activity_id])
GO
ALTER TABLE [dbo].[UserCalorieInformation] CHECK CONSTRAINT [FK__UserCalor__activ__31EC6D26]
GO
ALTER TABLE [dbo].[UserCalorieInformation]  WITH CHECK ADD  CONSTRAINT [FK__UserCalor__user___30F848ED] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[UserCalorieInformation] CHECK CONSTRAINT [FK__UserCalor__user___30F848ED]
GO
ALTER TABLE [dbo].[UserCalorieInformation]  WITH CHECK ADD  CONSTRAINT [FK_UserCalorieInformation_TargetGoals] FOREIGN KEY([target_goal_id])
REFERENCES [dbo].[TargetGoals] ([goal_id])
GO
ALTER TABLE [dbo].[UserCalorieInformation] CHECK CONSTRAINT [FK_UserCalorieInformation_TargetGoals]
GO
ALTER TABLE [dbo].[UserDiary]  WITH CHECK ADD  CONSTRAINT [FK_UserDiary_Users] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[UserDiary] CHECK CONSTRAINT [FK_UserDiary_Users]
GO
ALTER TABLE [dbo].[UserProfile]  WITH CHECK ADD  CONSTRAINT [FK__UserProfi__user___2A4B4B5E] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[UserProfile] CHECK CONSTRAINT [FK__UserProfi__user___2A4B4B5E]
GO
/****** Object:  StoredProcedure [dbo].[GetConsumedFoodsOnDate]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetConsumedFoodsOnDate]
    @user_id INT,
    @log_date DATE = NULL
AS
BEGIN
    SELECT
        log_id,
        user_id,
        food_id,
        food_name,
        quantity,
        log_date
    FROM
        ConsumedFoodsView
    WHERE
        user_id = @user_id
        AND (@log_date IS NULL OR CONVERT(DATE, log_date) = @log_date);
END;
GO
/****** Object:  StoredProcedure [dbo].[GetConsumedFoodsToday]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[GetConsumedFoodsToday]
    @user_id INT,
    @food_name NVARCHAR(100) = NULL
AS
BEGIN
    DECLARE @today DATE;
    SET @today = CONVERT(DATE, GETDATE());

    SELECT *
    FROM
        FoodConsumptionSummary
    WHERE
        user_id = @user_id
        AND CONVERT(DATE, log_date) = @today
        AND (@food_name IS NULL OR food_name LIKE '%' + @food_name + '%');
END;
GO
/****** Object:  StoredProcedure [dbo].[GetConsumptionDatesForUser]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[GetConsumptionDatesForUser]
    @user_id INT
AS
BEGIN
    SELECT DISTINCT CONVERT(DATE, log_date) AS log_date
    FROM DailyLogs
    WHERE user_id = @user_id;
END;
GO
/****** Object:  StoredProcedure [dbo].[GetConsumptionReport]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Stored procedure untuk melihat laporan total nutrisi dan sisa angka BMR
CREATE PROCEDURE [dbo].[GetConsumptionReport]
    @user_id INT,
    @log_date DATE
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Variabel untuk menyimpan total nutrisi
        DECLARE @total_energy_kal DECIMAL(10, 2),
                @total_protein_g DECIMAL(10, 2),
                @total_fat_g DECIMAL(10, 2),
                @total_carbs_g DECIMAL(10, 2),
                @total_fiber_g DECIMAL(10, 2),
                @total_calcium_mg DECIMAL(10, 2),
                @total_fe_mg DECIMAL(10, 2),
                @total_natrium_mg DECIMAL(10, 2);

        -- Menghitung total nutrisi dari konsumsi makanan pengguna pada tanggal tertentu
        SELECT 
            @total_energy_kal = SUM(FNI.energy_kal),
            @total_protein_g = SUM(FNI.protein_g),
            @total_fat_g = SUM(FNI.fat_g),
            @total_carbs_g = SUM(FNI.carbs_g),
            @total_fiber_g = SUM(FNI.fiber_g),
            @total_calcium_mg = SUM(FNI.calcium_mg),
            @total_fe_mg = SUM(FNI.fe_mg),
            @total_natrium_mg = SUM(FNI.natrium_mg)
        FROM DailyLogs DL
        INNER JOIN FoodNutritionInfo FNI ON DL.food_id = FNI.food_id
        WHERE DL.user_id = @user_id AND DL.log_date = @log_date;

        -- Mendapatkan nilai BMR pengguna dari tabel UserCalorieInformation
        DECLARE @bmr DECIMAL(10, 2);
        SELECT @bmr = bmr
        FROM UserCalorieInformation
        WHERE user_id = @user_id;

        -- Menghitung total kalori yang dikonsumsi
        DECLARE @total_calories DECIMAL(10, 2);
        SET @total_calories = @total_energy_kal;

        -- Menghitung sisa angka BMR
        DECLARE @remaining_bmr DECIMAL(10, 2);
        SET @remaining_bmr = @bmr - @total_calories;

        -- Menampilkan laporan total nutrisi dan sisa angka BMR
        SELECT 
            @total_energy_kal AS total_energy_kal,
            @total_protein_g AS total_protein_g,
            @total_fat_g AS total_fat_g,
            @total_carbs_g AS total_carbs_g,
            @total_fiber_g AS total_fiber_g,
            @total_calcium_mg AS total_calcium_mg,
            @total_fe_mg AS total_fe_mg,
            @total_natrium_mg AS total_natrium_mg,
            @remaining_bmr AS remaining_bmr;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        -- Menampilkan pesan kesalahan jika terjadi masalah
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[GetFoodInformationByLogId]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[GetFoodInformationByLogId]
    @log_id INT
AS
BEGIN
    SELECT
        DL.log_id,
        DL.user_id,
        DL.food_id,
        FNI.food_name,
        DL.quantity,
        DL.log_date
    FROM
        DailyLogs DL
    INNER JOIN
        FoodNutritionInfo FNI ON DL.food_id = FNI.food_id
    WHERE
        DL.log_id = @log_id;
END;
GO
/****** Object:  StoredProcedure [dbo].[GetWeeklyProgressReport]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[GetWeeklyProgressReport]
    @user_id INT
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Mengambil data dari view WeeklyProgressView untuk user_id tertentu
        SELECT *
        FROM WeeklyProgressView
        WHERE user_id = @user_id;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        -- Menampilkan pesan kesalahan jika terjadi masalah
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateUserBMR]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[UpdateUserBMR]
    @user_id INT,
    @gender NVARCHAR(10),
    @age INT,
    @weight DECIMAL(5, 2),
    @height DECIMAL(5, 2),
    @activity_level_id INT,
    @target_goal_id INT
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @activity_multiplier DECIMAL(5, 2)
        DECLARE @calorie_adjustment INT

        -- Get activity multiplier based on activity level
        SELECT @activity_multiplier = activity_multiplier
        FROM ActivityLevels
        WHERE activity_id = @activity_level_id

        -- Get calorie adjustment based on target goal
        SELECT @calorie_adjustment = calorie_adjustment
        FROM TargetGoals
        WHERE goal_id = @target_goal_id

        -- Calculate BMR using the function
        DECLARE @bmr DECIMAL(10, 2)
        SET @bmr = dbo.CalculateBMRFunction(@gender, @age, @weight, @height, @activity_multiplier, @calorie_adjustment)

        -- Update BMR in UserCalorieInformation table
        UPDATE UserCalorieInformation
        SET bmr = @bmr
        WHERE user_id = @user_id

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        -- Handle error
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateUserProfile]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateUserProfile]
    @username NVARCHAR(50),
    @email NVARCHAR(100),
    @gender NVARCHAR(10),
    @age INT,
    @height DECIMAL(5, 2),
    @weight DECIMAL(5, 2)
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Update informasi profil pengguna
        UPDATE UserProfile
        SET gender = @gender, age = @age, height = @height, weight = @weight
        FROM UserProfile up
        INNER JOIN Users u ON u.user_id = up.user_id
        WHERE u.username = @username;

        -- Update informasi email pada tabel Users
        UPDATE Users
        SET email = @email
        WHERE username = @username;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        -- Menampilkan pesan kesalahan jika terjadi masalah
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_AddFoodConsumption]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[usp_AddFoodConsumption]
    @user_id INT,
    @food_id NVARCHAR(50),
    @quantity DECIMAL(5, 2)
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY

        -- Memasukkan data konsumsi makanan ke dalam tabel DailyLogs
        INSERT INTO dbo.DailyLogs(user_id, food_id, quantity, log_date)
        SELECT
            @user_id,
            @food_id,
            @quantity,
            GETDATE()


        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        -- Menampilkan pesan kesalahan jika terjadi masalah
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_AddFoodConsumptionByName]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_AddFoodConsumptionByName]
    @user_id INT,
    @food_name NVARCHAR(100), -- Change parameter to food_name
    @quantity DECIMAL(5, 2)
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @food_id NVARCHAR(50);

        -- Get the food_id based on the provided food_name using LIKE
        SELECT @food_id = food_id
        FROM dbo.FoodNutritionInfo
        WHERE food_name LIKE '%' + @food_name + '%' -- Using LIKE for partial matching
		ORDER BY food_name ASC;

        IF @food_id IS NOT NULL
        BEGIN
            -- Insert data into DailyLogs table
            INSERT INTO dbo.DailyLogs(user_id, food_id, quantity, log_date)
            VALUES (@user_id, @food_id, @quantity, GETDATE());

            COMMIT TRANSACTION;
            PRINT 'Food consumption added successfully.';
        END
        ELSE
        BEGIN
            -- Food not found, rollback transaction
            ROLLBACK TRANSACTION;
            PRINT 'Food not found.';
        END
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        -- Display error message if an error occurs
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_AddOrUpdateUserDiaryNote]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_AddOrUpdateUserDiaryNote]
    @user_id INT,
    @log_date DATE,
    @notes TEXT
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @diary_id INT;

        -- Periksa apakah sudah ada catatan untuk tanggal dan user_id tertentu
        SELECT @diary_id = diary_id
        FROM UserDiary
        WHERE user_id = @user_id AND log_date = @log_date;

        IF @diary_id IS NOT NULL
        BEGIN
            -- Jika sudah ada, perbarui catatan
            UPDATE UserDiary
            SET notes = @notes
            WHERE diary_id = @diary_id;
        END
        ELSE
        BEGIN
            -- Jika belum ada, tambahkan catatan baru
            INSERT INTO UserDiary (log_date, notes, user_id)
            VALUES (@log_date, @notes, @user_id);
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        -- Tangani error di sini
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ChangePasswordByUserId]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_ChangePasswordByUserId]
    @user_id INT,
    @old_password NVARCHAR(100),
    @new_password NVARCHAR(100),
    @confirm_password NVARCHAR(100)
AS
BEGIN
    DECLARE @stored_password NVARCHAR(100);
    DECLARE @hashed_old_password NVARCHAR(100);
    DECLARE @hashed_new_password NVARCHAR(100);
    DECLARE @updateResult INT;

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Mengambil password yang di-hash dari tabel Users berdasarkan user_id
        SELECT @stored_password = password
        FROM Users
        WHERE user_id = @user_id;

        -- Memeriksa apakah user_id ditemukan
        IF (@stored_password IS NOT NULL)
        BEGIN
            -- Hash old password yang dimasukkan pada saat pengubahan
            SET @hashed_old_password = HASHBYTES('SHA2_256', @old_password);

            -- Memeriksa apakah old password cocok
            IF (@hashed_old_password = @stored_password)
            BEGIN
                -- Hash new password
                SET @hashed_new_password = HASHBYTES('SHA2_256', @new_password);

                -- Memeriksa apakah new password dan confirm password cocok
                IF (@new_password = @confirm_password)
                BEGIN
                    -- Update password baru ke dalam tabel Users
                    UPDATE Users
                    SET password = @hashed_new_password
                    WHERE user_id = @user_id;

                    -- Berhasil mengubah password, set nilai hasil update ke 1
                    SET @updateResult = 1;
                    -- Tidak perlu melakukan apa-apa selain melakukan COMMIT
                    COMMIT TRANSACTION;
                    SELECT @updateResult AS 'UpdateResult';
                    RETURN @updateResult;
                END
                ELSE
                BEGIN
                    -- New password dan confirm password tidak cocok, set nilai hasil update ke 0
                    SET @updateResult = 0;
                    -- New password dan confirm password tidak cocok, mengembalikan pesan kesalahan
                    THROW 51000, 'New password and confirm password do not match.', 1;
                    SELECT @updateResult AS 'UpdateResult';
                    RETURN @updateResult;
                END
            END
            ELSE
            BEGIN
                -- Old password tidak cocok, set nilai hasil update ke -1
                SET @updateResult = -1;
                -- Old password tidak cocok, mengembalikan pesan kesalahan
                THROW 51000, 'Old password is incorrect.', 1;
                SELECT @updateResult AS 'UpdateResult';
                RETURN @updateResult;
            END
        END
        ELSE
        BEGIN
            -- user_id tidak ditemukan, set nilai hasil update ke -2
            SET @updateResult = -2;
            -- user_id tidak ditemukan, mengembalikan pesan kesalahan
            THROW 51000, 'User ID not found.', 1;
            SELECT @updateResult AS 'UpdateResult';
            RETURN @updateResult;
        END
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        -- Menampilkan pesan kesalahan
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_DeleteFoodLog]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_DeleteFoodLog]
    @log_id INT
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Periksa apakah log_id ada dalam tabel DailyLogs
        IF EXISTS (SELECT 1 FROM DailyLogs WHERE log_id = @log_id)
        BEGIN
            -- Hapus log makanan berdasarkan log_id
            DELETE FROM DailyLogs
            WHERE log_id = @log_id;

            COMMIT TRANSACTION;
            PRINT 'Log makanan berhasil dihapus.';
        END
        ELSE
        BEGIN
            -- Jika log_id tidak ditemukan, kirimkan pesan kesalahan
            THROW 51000, 'Log ID tidak ditemukan dalam tabel DailyLogs.', 1;
        END
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        -- Tangani error
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_DeleteFoodLogByID]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_DeleteFoodLogByID]
	@log_id INT
AS
BEGIN
	DELETE FROM DailyLogs WHERE 
	log_id = @log_id
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllFood]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_GetAllFood]
AS
BEGIN
    BEGIN TRY
        -- Memilih nama makanan dari tabel FoodNutritionInfo
        SELECT *
        FROM FoodNutritionInfo;
    END TRY
    BEGIN CATCH
        -- Menampilkan pesan kesalahan jika terjadi masalah
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_GetBMRSummaryOnDate]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_GetBMRSummaryOnDate]
    @user_id INT,
    @log_date DATE
AS
BEGIN
    DECLARE @bmr DECIMAL(10, 2);
    DECLARE @consumed_calories DECIMAL(10, 2);

    -- Mengambil data BMR dari tabel UserCalorieInformation
    SELECT @bmr = bmr
    FROM UserCalorieInformation
    WHERE user_id = @user_id;

    -- Menghitung jumlah kalori yang dikonsumsi pada tanggal tertentu
    SELECT @consumed_calories = SUM(n.energy_kal)
    FROM DailyLogs d
    INNER JOIN FoodNutritionInfo f ON d.food_id = f.food_id
    CROSS APPLY dbo.CalculateNutrition(d.food_id, d.quantity) n
    WHERE d.user_id = @user_id AND d.log_date = @log_date;

    -- Menampilkan data BMR, jumlah kalori yang dikonsumsi, dan sisa BMR
    SELECT 
        @user_id AS user_id,
        @log_date AS log_date,
        @bmr AS BMR,
        @consumed_calories AS consumed_calories,
        (CASE 
            WHEN @bmr - @consumed_calories > 0 THEN @bmr - @consumed_calories 
            ELSE 0 
         END) AS remaining_calories;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetCalorieSummary]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_GetCalorieSummary]
    @user_id INT
AS
BEGIN
    DECLARE @log_date DATE = GETDATE(); -- Menggunakan tanggal hari ini

    DECLARE @bmr DECIMAL(10, 2);
    DECLARE @consumed_calories DECIMAL(10, 2);

    -- Mengambil data BMR dari tabel UserCalorieInformation
    SELECT @bmr = bmr
    FROM UserCalorieInformation
    WHERE user_id = @user_id;

    -- Menghitung jumlah kalori yang dikonsumsi pada tanggal tertentu
    SELECT @consumed_calories = COALESCE(SUM(n.energy_kal), 0)
    FROM DailyLogs d
    INNER JOIN FoodNutritionInfo f ON d.food_id = f.food_id
    CROSS APPLY dbo.CalculateNutrition(d.food_id, d.quantity) n
    WHERE d.user_id = @user_id AND d.log_date = @log_date;

    -- Menampilkan data BMR, jumlah kalori yang dikonsumsi, dan sisa BMR
    SELECT 
        @user_id AS user_id,
        @log_date AS log_date,
        @bmr AS BMR,
        @consumed_calories AS consumed_calories,
        (CASE 
            WHEN @bmr - @consumed_calories > 0 THEN @bmr - @consumed_calories 
            ELSE 0 
         END) AS remaining_calories;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetCalorieSummaryOnDate]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_GetCalorieSummaryOnDate]
    @user_id INT,
    @log_date DATE
AS
BEGIN
    DECLARE @bmr DECIMAL(10, 2);
    DECLARE @consumed_calories DECIMAL(10, 2);

    -- Mengambil data BMR dari tabel UserCalorieInformation
    SELECT @bmr = bmr
    FROM UserCalorieInformation
    WHERE user_id = @user_id;

    -- Menghitung jumlah kalori yang dikonsumsi pada tanggal tertentu
    SELECT @consumed_calories = COALESCE(SUM(n.energy_kal), 0)
    FROM DailyLogs d
    INNER JOIN FoodNutritionInfo f ON d.food_id = f.food_id
    CROSS APPLY dbo.CalculateNutrition(d.food_id, d.quantity) n
    WHERE d.user_id = @user_id AND d.log_date = @log_date;

    -- Menampilkan data BMR, jumlah kalori yang dikonsumsi, dan sisa BMR
    SELECT 
        @user_id AS user_id,
        @log_date AS log_date,
        @bmr AS BMR,
        @consumed_calories AS consumed_calories,
        (CASE 
            WHEN @bmr - @consumed_calories > 0 THEN @bmr - @consumed_calories 
            ELSE 0 
         END) AS remaining_calories;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetConsumptionReport]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Stored procedure untuk melihat laporan total nutrisi dan sisa angka BMR
CREATE   PROCEDURE [dbo].[usp_GetConsumptionReport]
    @user_id INT,
    @log_date DATE
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Variabel untuk menyimpan total nutrisi
        DECLARE @total_energy_kal DECIMAL(10, 2),
                @total_protein_g DECIMAL(10, 2),
                @total_fat_g DECIMAL(10, 2),
                @total_carbs_g DECIMAL(10, 2),
                @total_fiber_g DECIMAL(10, 2),
                @total_calcium_mg DECIMAL(10, 2),
                @total_fe_mg DECIMAL(10, 2),
                @total_natrium_mg DECIMAL(10, 2);

        -- Menghitung total nutrisi dari konsumsi makanan pengguna pada tanggal tertentu
		SELECT 
			@total_energy_kal = ISNULL(SUM(FNI.energy_kal), 0),
			@total_protein_g = ISNULL(SUM(FNI.protein_g), 0),
			@total_fat_g = ISNULL(SUM(FNI.fat_g), 0),
			@total_carbs_g = ISNULL(SUM(FNI.carbs_g), 0),
			@total_fiber_g = ISNULL(SUM(FNI.fiber_g), 0),
			@total_calcium_mg = ISNULL(SUM(FNI.calcium_mg), 0),
			@total_fe_mg = ISNULL(SUM(FNI.fe_mg), 0),
			@total_natrium_mg = ISNULL(SUM(FNI.natrium_mg), 0)
		FROM DailyLogs DL
		LEFT JOIN FoodNutritionInfo FNI ON DL.food_id = FNI.food_id
		WHERE DL.user_id = @user_id AND DL.log_date = @log_date;


        -- Mendapatkan nilai BMR pengguna dari tabel UserCalorieInformation
        DECLARE @bmr DECIMAL(10, 2);
        SELECT @bmr = bmr
        FROM UserCalorieInformation
        WHERE user_id = @user_id;

        -- Menghitung total kalori yang dikonsumsi
        DECLARE @total_calories DECIMAL(10, 2);
        SET @total_calories = @total_energy_kal;

        -- Menghitung sisa angka BMR
        DECLARE @remaining_bmr DECIMAL(10, 2);
        SET @remaining_bmr = @bmr - @total_calories;

        -- Menampilkan laporan total nutrisi dan sisa angka BMR
        SELECT 
            @total_energy_kal AS total_energy_kal,
            @total_protein_g AS total_protein_g,
            @total_fat_g AS total_fat_g,
            @total_carbs_g AS total_carbs_g,
            @total_fiber_g AS total_fiber_g,
            @total_calcium_mg AS total_calcium_mg,
            @total_fe_mg AS total_fe_mg,
            @total_natrium_mg AS total_natrium_mg,
            @remaining_bmr AS remaining_bmr;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        -- Menampilkan pesan kesalahan jika terjadi masalah
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetDailyConsumedFoods]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_GetDailyConsumedFoods]
    @user_id INT
AS
BEGIN
    SELECT
        log_id,
        user_id,
        food_id,
        food_name,
        quantity,
        log_date
    FROM
        ConsumedFoodsView
    WHERE
        user_id = @user_id
		AND
		log_date = GETDATE();
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_GetDailyFoodMenu]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_GetDailyFoodMenu]
    @user_id INT,
    @log_date DATE
AS
BEGIN
    -- Menampilkan daftar menu makanan yang dimakan per hari
    SELECT 
        d.log_id,
        d.user_id,
        d.food_id,
        d.quantity,
        d.log_date,
        f.food_name,
        n.energy_kal,
        n.protein_g,
        n.fat_g,
        n.carbs_g,
        n.fiber_g,
        n.calcium_mg,
        n.fe_mg,
        n.natrium_mg
    FROM 
        DailyLogs d
    INNER JOIN 
        FoodNutritionInfo f ON d.food_id = f.food_id
    CROSS APPLY 
        dbo.CalculateNutrition(d.food_id, d.quantity) n
    WHERE 
        d.user_id = @user_id 
        AND d.log_date = @log_date;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetFoodDetailsByLogId]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_GetFoodDetailsByLogId]
    @log_id INT
AS
BEGIN
    BEGIN TRY
        -- Memilih detail informasi makanan berdasarkan log_id
        SELECT DL.log_id,
               DL.user_id,
               DL.food_id,
               DL.quantity,
               DL.log_date,
               FNI.food_name,
               FNI.energy_kal AS total_energy_kcal,
               FNI.protein_g AS total_protein_g,
               FNI.fat_g AS total_fat_g,
               FNI.carbs_g AS total_carbs_g,
               FNI.fiber_g AS total_fiber_g,
               FNI.calcium_mg AS total_calcium_mg,
               FNI.fe_mg AS total_iron_mg,
               FNI.natrium_mg AS total_natrium_mg
        FROM DailyLogs DL
        JOIN FoodNutritionInfo FNI ON DL.food_id = FNI.food_id
        WHERE DL.log_id = @log_id;
    END TRY
    BEGIN CATCH
        -- Menampilkan pesan kesalahan jika terjadi masalah
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_GetFoodNames]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_GetFoodNames]
AS
BEGIN
    BEGIN TRY
        -- Memilih nama makanan dari tabel FoodNutritionInfo
        SELECT food_name
        FROM FoodNutritionInfo;
    END TRY
    BEGIN CATCH
        -- Menampilkan pesan kesalahan jika terjadi masalah
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_GetFoodNutrition]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_GetFoodNutrition]
    @user_id INT,
    @log_date DATE
AS
BEGIN
    DECLARE @bmr DECIMAL(10, 2);
    DECLARE @remaining_bmr DECIMAL(10, 2);

    -- Mengambil BMR berdasarkan user_id
    SELECT @bmr = bmr
    FROM UserCalorieInformation
    WHERE user_id = @user_id;

    -- Menghitung total kalori yang telah dikonsumsi pada log_date
    DECLARE @total_kalori_consumed DECIMAL(10, 2);
    SELECT @total_kalori_consumed = SUM(n.energy_kal)
    FROM DailyLogs d
    JOIN FoodNutritionInfo f ON d.food_id = f.food_id
    CROSS APPLY dbo.CalculateNutrition(d.food_id, d.quantity) n
    WHERE d.user_id = @user_id AND d.log_date = @log_date;

    -- Menghitung remaining BMR
    SET @remaining_bmr = @bmr - @total_kalori_consumed;

    -- Memilih data nutrisi berdasarkan user_id dan log_date
    SELECT 
        d.user_id,
        d.food_id,
        d.quantity,
        d.log_date,
        f.food_name,
        n.energy_kal,
        n.protein_g,
        n.fat_g,
        n.carbs_g,
        n.fiber_g,
        n.calcium_mg,
        n.fe_mg,
        n.natrium_mg,
        @bmr AS bmr,
        @remaining_bmr AS remaining_bmr
    FROM DailyLogs d
    JOIN FoodNutritionInfo f ON d.food_id = f.food_id
    CROSS APPLY dbo.CalculateNutrition(d.food_id, d.quantity) n
    WHERE d.user_id = @user_id AND d.log_date = @log_date;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetLogDatesByUserId]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_GetLogDatesByUserId]
    @user_id INT
AS
BEGIN
    SELECT DISTINCT
        log_date
    FROM
        DailyLogs
    WHERE
        user_id = @user_id
    ORDER BY
        log_date;
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_GetStartEndOfWeek]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_GetStartEndOfWeek]
    @user_id INT
AS
BEGIN
    -- Create a temporary table to store the start and end dates of each week
    CREATE TABLE #Weeks (
        start_of_week DATE,
        end_of_week DATE
    );

    -- Calculate the start and end dates of each week based on the user's logs
    ;WITH WeeksCTE AS (
        SELECT
            DATEADD(WEEK, DATEDIFF(WEEK, 0, log_date), 0) AS start_of_week,
            DATEADD(DAY, 6, DATEADD(WEEK, DATEDIFF(WEEK, 0, log_date), 0)) AS end_of_week,
            ROW_NUMBER() OVER (ORDER BY DATEADD(WEEK, DATEDIFF(WEEK, 0, log_date), 0)) AS week_number
        FROM
            DailyLogs
        WHERE
            user_id = @user_id
        GROUP BY
            DATEADD(WEEK, DATEDIFF(WEEK, 0, log_date), 0)
    )
    INSERT INTO #Weeks (start_of_week, end_of_week)
    SELECT start_of_week, end_of_week
    FROM WeeksCTE;

    -- Return the start and end dates of the weeks
    SELECT start_of_week, end_of_week FROM #Weeks;

    -- Drop the temporary table
    DROP TABLE #Weeks;
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_GetTotalNutritionByDate]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_GetTotalNutritionByDate]
    @user_id INT,
    @log_date DATE
AS
BEGIN
    DECLARE @bmr DECIMAL(10, 2);
    DECLARE @total_kalori_consumed DECIMAL(10, 2);
    DECLARE @remaining_bmr DECIMAL(10, 2);

    -- Mendapatkan BMR dari tabel UserCalorieInformation
    SELECT @bmr = bmr
    FROM UserCalorieInformation
    WHERE user_id = @user_id;

    -- Menghitung total kalori yang dikonsumsi pada log_date
    SELECT @total_kalori_consumed = SUM(n.energy_kal)
    FROM DailyLogs d
    JOIN FoodNutritionInfo f ON d.food_id = f.food_id
    CROSS APPLY dbo.CalculateNutrition(d.food_id, d.quantity) n
    WHERE d.user_id = @user_id AND d.log_date = @log_date;

    -- Menghitung sisa BMR
    SET @remaining_bmr = @bmr - @total_kalori_consumed;

    -- Mengambil total nutrisi per hari
    SELECT 
        d.user_id,
        d.log_date,
        SUM(n.energy_kal) AS total_energy_kal,
        SUM(n.protein_g) AS total_protein_g,
        SUM(n.fat_g) AS total_fat_g,
        SUM(n.carbs_g) AS total_carbs_g,
        SUM(n.fiber_g) AS total_fiber_g,
        SUM(n.calcium_mg) AS total_calcium_mg,
        SUM(n.fe_mg) AS total_fe_mg,
        SUM(n.natrium_mg) AS total_natrium_mg,
        @bmr AS total_bmr,
        @remaining_bmr AS remaining_bmr
    FROM DailyLogs d
    JOIN FoodNutritionInfo f ON d.food_id = f.food_id
    CROSS APPLY dbo.CalculateNutrition(d.food_id, d.quantity) n
    WHERE d.user_id = @user_id AND d.log_date = @log_date
    GROUP BY d.user_id, d.log_date;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetTotalNutritionPerDay]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_GetTotalNutritionPerDay]
    @user_id INT
AS
BEGIN
    DECLARE @log_date DATE = CONVERT(DATE, GETDATE());
    DECLARE @bmr DECIMAL(10, 2);
    DECLARE @total_kalori_consumed DECIMAL(10, 2);
    DECLARE @remaining_bmr DECIMAL(10, 2);

    -- Mendapatkan BMR dari tabel UserCalorieInformation
    SELECT @bmr = bmr
    FROM UserCalorieInformation
    WHERE user_id = @user_id;

    -- Menghitung total kalori yang dikonsumsi pada log_date
    SELECT @total_kalori_consumed = SUM(n.energy_kal)
    FROM DailyLogs d
    JOIN FoodNutritionInfo f ON d.food_id = f.food_id
    CROSS APPLY dbo.CalculateNutrition(d.food_id, d.quantity) n
    WHERE d.user_id = @user_id AND d.log_date = @log_date;

    -- Menghitung sisa BMR
    SET @remaining_bmr = @bmr - @total_kalori_consumed;

    -- Mengambil total nutrisi per hari
    SELECT 
        d.user_id,
        @log_date AS log_date,
        SUM(n.energy_kal) AS total_energy_kal,
        SUM(n.protein_g) AS total_protein_g,
        SUM(n.fat_g) AS total_fat_g,
        SUM(n.carbs_g) AS total_carbs_g,
        SUM(n.fiber_g) AS total_fiber_g,
        SUM(n.calcium_mg) AS total_calcium_mg,
        SUM(n.fe_mg) AS total_fe_mg,
        SUM(n.natrium_mg) AS total_natrium_mg,
        @bmr AS total_bmr,
        @remaining_bmr AS remaining_bmr
    FROM DailyLogs d
    JOIN FoodNutritionInfo f ON d.food_id = f.food_id
    CROSS APPLY dbo.CalculateNutrition(d.food_id, d.quantity) n
    WHERE d.user_id = @user_id AND d.log_date = @log_date
    GROUP BY d.user_id;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetUserDailyReport]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_GetUserDailyReport]
    @user_id INT
AS
BEGIN
    -- Create a temporary table to store the daily report
    CREATE TABLE #DailyReport (
        log_date DATE,
        energy_kcal DECIMAL(10, 2),
        protein_g DECIMAL(10, 2),
        fat_g DECIMAL(10, 2),
        carbs_g DECIMAL(10, 2),
        fiber_g DECIMAL(10, 2),
        calcium_mg DECIMAL(10, 2),
        fe_mg DECIMAL(10, 2),
        natrium_mg DECIMAL(10, 2)
    );

    -- Insert the nutrition details for each day
    INSERT INTO #DailyReport (log_date, energy_kcal, protein_g, fat_g, carbs_g, fiber_g, calcium_mg, fe_mg, natrium_mg)
    SELECT
        dl.log_date,
        SUM(fni.energy_kal) AS energy_kcal,
        SUM(fni.protein_g) AS protein_g,
        SUM(fni.fat_g) AS fat_g,
        SUM(fni.carbs_g) AS carbs_g,
        SUM(fni.fiber_g) AS fiber_g,
        SUM(fni.calcium_mg) AS calcium_mg,
        SUM(fni.fe_mg) AS fe_mg,
        SUM(fni.natrium_mg) AS natrium_mg
    FROM
        DailyLogs dl
    INNER JOIN
        FoodNutritionInfo fni ON dl.food_id = fni.food_id
    WHERE
        dl.user_id = @user_id
    GROUP BY
        dl.log_date;

    -- Return the daily report
    SELECT
        log_date,
        energy_kcal,
        protein_g,
        fat_g,
        carbs_g,
        fiber_g,
        calcium_mg,
        fe_mg,
        natrium_mg
    FROM
        #DailyReport
    ORDER BY
        log_date;

    -- Drop the temporary table
    DROP TABLE #DailyReport;
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_GetUserDataByUsername]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_GetUserDataByUsername]
    @username NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        -- Mengambil data dari tabel Users berdasarkan username
        SELECT *
        FROM Users
        WHERE username = @username;
    END TRY
    BEGIN CATCH
        -- Menampilkan pesan kesalahan jika terjadi masalah
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetUserDiaryNote]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_GetUserDiaryNote]
    @user_id INT,
    @log_date DATE
AS
BEGIN
    BEGIN TRY
        -- Mengambil catatan diary berdasarkan user_id dan log_date
        SELECT diary_id, log_date, notes
        FROM UserDiary
        WHERE user_id = @user_id AND log_date = @log_date;
    END TRY
    BEGIN CATCH
        -- Menampilkan pesan kesalahan jika terjadi masalah
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetUserFoodConsumptionPerWeek]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_GetUserFoodConsumptionPerWeek]
    @user_id INT
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @Today DATE;
        SET @Today = GETDATE();

        DECLARE @StartDate DATE;
        SET @StartDate = DATEADD(DAY, -7, @Today); -- Ambil tanggal 7 hari sebelum hari ini

        DECLARE @EndDate DATE;
        SET @EndDate = @Today; -- Hari ini

        -- Mendapatkan data konsumsi makanan pengguna per hari per minggu
        SELECT
            dl.log_date AS consumption_date,
            dl.quantity,
            f.food_name,
            f.energy_kal,
            f.protein_g,
            f.fat_g,
            f.carbs_g,
            f.fiber_g,
            f.calcium_mg,
            f.fe_mg,
            f.natrium_mg
        FROM
            DailyLogs dl
        INNER JOIN
            FoodNutritionInfo f ON dl.food_id = f.food_id
        WHERE
            dl.user_id = @user_id
            AND dl.log_date BETWEEN @StartDate AND @EndDate;

        -- Menghitung sisa BMR per harinya
        DECLARE @TotalCaloriesConsumed FLOAT;
        DECLARE @BMR FLOAT;
        DECLARE @DailyCalorieLimit FLOAT;
        DECLARE @RemainingBMR FLOAT;

        -- Menghitung total kalori yang dikonsumsi pengguna per hari
        SELECT
            @TotalCaloriesConsumed = SUM(dl.quantity * f.energy_kal)
        FROM
            DailyLogs dl
        INNER JOIN
            FoodNutritionInfo f ON dl.food_id = f.food_id
        WHERE
            dl.user_id = @user_id
            AND dl.log_date BETWEEN @StartDate AND @EndDate;

        -- Mendapatkan BMR dan daily calorie limit pengguna
        SELECT
            @BMR = bmr
        FROM
            UserCalorieInformation
        WHERE
            user_id = @user_id;

        -- Menghitung sisa BMR per harinya
        SET @RemainingBMR = @DailyCalorieLimit - @TotalCaloriesConsumed;

        -- Tampilkan informasi sisa BMR per harinya
        SELECT
            @RemainingBMR AS remaining_bmr;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        -- Tangani error di sini
        THROW;
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetWeeklyFoodConsumption]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_GetWeeklyFoodConsumption]
    @user_id INT
AS
BEGIN
    -- Menampilkan daftar menu makanan yang dimakan per minggu
    WITH WeeklyFoodMenu AS (
        SELECT 
            d.log_id,
            d.user_id,
            d.food_id,
            d.quantity,
            d.log_date,
            f.food_name,
            n.energy_kal,
            n.protein_g,
            n.fat_g,
            n.carbs_g,
            n.fiber_g,
            n.calcium_mg,
            n.fe_mg,
            n.natrium_mg,
            DATEADD(DAY, 1 - DATEPART(WEEKDAY, d.log_date), d.log_date) AS start_of_week,
            DATEADD(DAY, 7 - DATEPART(WEEKDAY, d.log_date), d.log_date) AS end_of_week
        FROM 
            DailyLogs d
        INNER JOIN 
            FoodNutritionInfo f ON d.food_id = f.food_id
        CROSS APPLY 
            dbo.CalculateNutrition(d.food_id, d.quantity) n
        WHERE 
            d.user_id = @user_id
    )
    SELECT 
        user_id,
        start_of_week,
        end_of_week,
        SUM(quantity) AS total_quantity,
        SUM(energy_kal) AS total_energy_kal,
        SUM(protein_g) AS total_protein_g,
        SUM(fat_g) AS total_fat_g,
        SUM(carbs_g) AS total_carbs_g,
        SUM(fiber_g) AS total_fiber_g,
        SUM(calcium_mg) AS total_calcium_mg,
        SUM(fe_mg) AS total_fe_mg,
        SUM(natrium_mg) AS total_natrium_mg
    FROM 
        WeeklyFoodMenu
    GROUP BY 
        user_id,
        start_of_week,
        end_of_week
    ORDER BY 
        start_of_week;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetWeeklyFoodMenu]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_GetWeeklyFoodMenu]
    @user_id INT
AS
BEGIN
    -- Menampilkan daftar menu makanan yang dimakan per minggu
    WITH WeeklyFoodMenu AS (
        SELECT 
            d.log_id,
            d.user_id,
            d.food_id,
            d.quantity,
            d.log_date,
            f.food_name,
            n.energy_kal,
            n.protein_g,
            n.fat_g,
            n.carbs_g,
            n.fiber_g,
            n.calcium_mg,
            n.fe_mg,
            n.natrium_mg,
            DATEADD(DAY, 1 - DATEPART(WEEKDAY, d.log_date), d.log_date) AS start_of_week,
            DATEADD(DAY, 7 - DATEPART(WEEKDAY, d.log_date), d.log_date) AS end_of_week
        FROM 
            DailyLogs d
        INNER JOIN 
            FoodNutritionInfo f ON d.food_id = f.food_id
        CROSS APPLY 
            dbo.CalculateNutrition(d.food_id, d.quantity) n
        WHERE 
            d.user_id = @user_id
    )
    SELECT 
        user_id,
        start_of_week,
        end_of_week,
        SUM(quantity) AS total_quantity,
        SUM(energy_kal) AS total_energy_kal,
        SUM(protein_g) AS total_protein_g,
        SUM(fat_g) AS total_fat_g,
        SUM(carbs_g) AS total_carbs_g,
        SUM(fiber_g) AS total_fiber_g,
        SUM(calcium_mg) AS total_calcium_mg,
        SUM(fe_mg) AS total_fe_mg,
        SUM(natrium_mg) AS total_natrium_mg
    FROM 
        WeeklyFoodMenu
    GROUP BY 
        user_id,
        start_of_week,
        end_of_week
    ORDER BY 
        start_of_week;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetWeeklyFoodNutrition]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_GetWeeklyFoodNutrition]
    @user_id INT,
    @start_of_week DATE,
    @end_of_week DATE
AS
BEGIN
    -- Menampilkan data makanan dan rincian nutrisinya berdasarkan start of week dan end of week
    SELECT 
        d.log_id,
        d.user_id,
        d.food_id,
        d.quantity,
        d.log_date,
        f.food_name,
        n.energy_kal,
        n.protein_g,
        n.fat_g,
        n.carbs_g,
        n.fiber_g,
        n.calcium_mg,
        n.fe_mg,
        n.natrium_mg
    FROM 
        DailyLogs d
    INNER JOIN 
        FoodNutritionInfo f ON d.food_id = f.food_id
    CROSS APPLY 
        dbo.CalculateNutrition(d.food_id, d.quantity) n
    WHERE 
        d.user_id = @user_id
        AND d.log_date BETWEEN @start_of_week AND @end_of_week;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetWeeklyReport]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_GetWeeklyReport]
    @start_of_week DATE,
    @end_of_week DATE,
    @user_id INT
AS
BEGIN
    -- Create a temporary table to store the weekly report
    CREATE TABLE #WeeklyReport (
        log_date DATE,
        energy_kcal DECIMAL(10, 2),
        protein_g DECIMAL(10, 2),
        fat_g DECIMAL(10, 2),
        carbs_g DECIMAL(10, 2),
        fiber_g DECIMAL(10, 2),
        calcium_mg DECIMAL(10, 2),
        fe_mg DECIMAL(10, 2),
        natrium_mg DECIMAL(10, 2)
    );

    -- Insert the nutrition details for each day of the start week
    INSERT INTO #WeeklyReport (log_date, energy_kcal, protein_g, fat_g, carbs_g, fiber_g, calcium_mg, fe_mg, natrium_mg)
    SELECT
        dl.log_date,
        SUM(fni.energy_kal) AS energy_kcal,
        SUM(fni.protein_g) AS protein_g,
        SUM(fni.fat_g) AS fat_g,
        SUM(fni.carbs_g) AS carbs_g,
        SUM(fni.fiber_g) AS fiber_g,
        SUM(fni.calcium_mg) AS calcium_mg,
        SUM(fni.fe_mg) AS fe_mg,
        SUM(fni.natrium_mg) AS natrium_mg
    FROM
        DailyLogs dl
    INNER JOIN
        FoodNutritionInfo fni ON dl.food_id = fni.food_id
    WHERE
        dl.user_id = @user_id
        AND dl.log_date >= @start_of_week
        AND dl.log_date <= @end_of_week
    GROUP BY
        dl.log_date;

    -- Return the weekly report
    SELECT
        log_date,
        energy_kcal,
        protein_g,
        fat_g,
        carbs_g,
        fiber_g,
        calcium_mg,
        fe_mg,
        natrium_mg
    FROM
        #WeeklyReport
    ORDER BY
        log_date;

    -- Drop the temporary table
    DROP TABLE #WeeklyReport;
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertUserBMR]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_InsertUserBMR]
    @user_id INT,
    @gender NVARCHAR(10),
    @age INT,
    @weight DECIMAL(5, 2),
    @height DECIMAL(5, 2),
    @activity_level_id INT,
    @target_goal_id INT
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @activity_multiplier DECIMAL(5, 2)
        DECLARE @calorie_adjustment INT

        -- Get activity multiplier based on activity level
        SELECT @activity_multiplier = activity_multiplier
        FROM ActivityLevels
        WHERE activity_id = @activity_level_id

        -- Get calorie adjustment based on target goal
        SELECT @calorie_adjustment = calorie_adjustment
        FROM TargetGoals
        WHERE goal_id = @target_goal_id

        -- Calculate BMR using the function
        DECLARE @bmr DECIMAL(10, 2)
        SET @bmr = dbo.CalculateBMRFunction(@gender, @age, @weight, @height, @activity_multiplier, @calorie_adjustment)

        -- Insert BMR into UserCalorieInformation table
        INSERT INTO UserCalorieInformation (user_id, bmr)
        VALUES (@user_id, @bmr)

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        -- Handle error
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertUserProfile]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_InsertUserProfile]
    @user_id INT,
    @gender NVARCHAR(10),
    @age INT,
    @height DECIMAL(5, 2),
    @weight DECIMAL(5, 2),
    @activity_level_id INT,
    @target_goal_id INT
AS
BEGIN
    DECLARE @bmr DECIMAL(10, 2);
    DECLARE @activity_multiplier DECIMAL(5, 2);
    DECLARE @calorie_adjustment INT;

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Cek apakah sudah ada UserProfile untuk user_id tertentu
        IF EXISTS (SELECT 1 FROM UserProfile WHERE user_id = @user_id)
        BEGIN
            -- Jika sudah ada, lakukan update
            UPDATE UserProfile
            SET gender = @gender,
                age = @age,
                height = @height,
                weight = @weight
            WHERE user_id = @user_id;

            -- Get activity multiplier based on activity level
            SELECT @activity_multiplier = activity_multiplier
            FROM ActivityLevels
            WHERE activity_id = @activity_level_id;

            -- Get calorie adjustment based on target goal
            SELECT @calorie_adjustment = calorie_adjustment
            FROM TargetGoals
            WHERE goal_id = @target_goal_id;

            -- Calculate BMR using the function
            SET @bmr = dbo.CalculateBMRFunction(@gender, @age, @weight, @height, @activity_multiplier, @calorie_adjustment);

            -- Update BMR in UserCalorieInformation table
            UPDATE UserCalorieInformation
            SET 
                bmr = @bmr,
                activity_level_id = @activity_level_id,
                target_goal_id = @target_goal_id
            WHERE user_id = @user_id;
        END
        ELSE
        BEGIN
            -- Jika belum ada, lakukan insert baru
            INSERT INTO UserProfile (user_id, gender, age, height, weight)
            VALUES (@user_id, @gender, @age, @height, @weight);

            -- Get activity multiplier based on activity level
            SELECT @activity_multiplier = activity_multiplier
            FROM ActivityLevels
            WHERE activity_id = @activity_level_id;

            -- Get calorie adjustment based on target goal
            SELECT @calorie_adjustment = calorie_adjustment
            FROM TargetGoals
            WHERE goal_id = @target_goal_id;

            -- Calculate BMR using the function
            SET @bmr = dbo.CalculateBMRFunction(@gender, @age, @weight, @height, @activity_multiplier, @calorie_adjustment);

            -- Insert data into UserCalorieInformation table
            INSERT INTO UserCalorieInformation (user_id, bmr, activity_level_id, target_goal_id)
            VALUES (@user_id, @bmr, @activity_level_id, @target_goal_id);
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        -- Tangani error di sini
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_LoginUser]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_LoginUser]
    @username NVARCHAR(50),
    @password NVARCHAR(100)
AS
BEGIN
    DECLARE @user_id INT;
    DECLARE @stored_password NVARCHAR(100);
    DECLARE @hashed_password NVARCHAR(100);
    DECLARE @loginResult INT;

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Mengambil user_id, password, firstname, dan lastname yang di-hash dari tabel Users berdasarkan username
        SELECT @user_id = user_id, @stored_password = password
        FROM Users
        WHERE username = @username;

        -- Memeriksa apakah username ditemukan
        IF (@user_id IS NOT NULL)
        BEGIN
            -- Hash password yang dimasukkan pada saat login
            SET @hashed_password = HASHBYTES('SHA2_256', @password);

            -- Memeriksa apakah password cocok
            IF (@hashed_password = @stored_password)
            BEGIN
                -- Berhasil masuk, set nilai hasil login ke 1
                SET @loginResult = 1;
                -- Tidak perlu melakukan apa-apa selain melakukan COMMIT
                COMMIT TRANSACTION;
                SELECT *
                FROM Users
                WHERE username = @username;
                RETURN @loginResult;
            END
            ELSE
            BEGIN
                -- Password tidak cocok, set nilai hasil login ke 0
                SET @loginResult = 0;
                -- Password tidak cocok, mengembalikan pesan kesalahan
                THROW 51000, 'Password salah.', 1;
                SELECT @loginResult AS 'LoginResult';
                RETURN @loginResult;
            END
        END
        ELSE
        BEGIN
            -- Username tidak ditemukan, set nilai hasil login ke 0
            SET @loginResult = 0;
            -- Username tidak ditemukan, mengembalikan pesan kesalahan
            THROW 51000, 'Username tidak ditemukan.', 1;
            SELECT @loginResult AS 'LoginResult';
            RETURN @loginResult;
        END
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        -- Menampilkan pesan kesalahan
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_RegisterUser]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_RegisterUser]
    @username NVARCHAR(50),
    @email NVARCHAR(100),
    @password NVARCHAR(100),
    @firstname NVARCHAR(100),
    @lastname NVARCHAR(100)
AS
BEGIN
    DECLARE @hashed_password NVARCHAR(100);

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Periksa apakah username sudah ada
        IF EXISTS (SELECT 1 FROM Users WHERE username = @username)
        BEGIN
            THROW 51000, 'Username already exists.', 1;
        END

        -- Periksa apakah email sudah ada
        IF EXISTS (SELECT 1 FROM Users WHERE email = @email)
        BEGIN
            THROW 51001, 'Email already exists.', 1;
        END

        -- Hash password
        SET @hashed_password = HASHBYTES('SHA2_256', @password);

        -- Insert ke tabel Users
        INSERT INTO Users (username, email, password, firstname, lastname)
        VALUES (@username, @email, @hashed_password, @firstname, @lastname)

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        -- Tangani error di sini
        THROW;
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateFoodQuantity]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_UpdateFoodQuantity]
    @log_id INT,
    @new_quantity DECIMAL(10, 2)
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Periksa apakah log_id ada dalam tabel DailyLogs
        IF EXISTS (SELECT 1 FROM DailyLogs WHERE log_id = @log_id)
        BEGIN
            -- Update quantity makanan
            UPDATE DailyLogs
            SET quantity = @new_quantity
            WHERE log_id = @log_id;

            COMMIT TRANSACTION;
            PRINT 'Quantity makanan berhasil diperbarui.';
        END
        ELSE
        BEGIN
            -- Jika log_id tidak ditemukan, kirimkan pesan kesalahan
            THROW 51000, 'Log ID tidak ditemukan dalam tabel DailyLogs.', 1;
        END
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        -- Tangani error
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateUserAccount]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_UpdateUserAccount]
    @user_id INT,
    @new_username NVARCHAR(50),
    @new_email NVARCHAR(100),
    @new_firstname NVARCHAR(100),
    @new_lastname NVARCHAR(100)
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Periksa apakah user_id ada dalam tabel Users
        IF EXISTS (SELECT 1 FROM Users WHERE user_id = @user_id)
        BEGIN
            -- Perbarui username, email, firstname, dan lastname
            UPDATE Users
            SET 
                username = @new_username,
                email = @new_email,
                firstname = @new_firstname,
                lastname = @new_lastname
            WHERE user_id = @user_id;

            COMMIT TRANSACTION;
            PRINT 'User details updated successfully.';
        END
        ELSE
        BEGIN
            -- Jika user_id tidak ditemukan
            THROW 50000, 'User ID not found.', 1;
        END
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        -- Tangani error
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateUserBMR]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[usp_UpdateUserBMR]
    @user_id INT,
    @gender NVARCHAR(10),
    @age INT,
    @weight DECIMAL(5, 2),
    @height DECIMAL(5, 2),
    @activity_level_id INT,
    @target_goal_id INT
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @activity_multiplier DECIMAL(5, 2)
        DECLARE @calorie_adjustment INT

        -- Get activity multiplier based on activity level
        SELECT @activity_multiplier = activity_multiplier
        FROM ActivityLevels
        WHERE activity_id = @activity_level_id

        -- Get calorie adjustment based on target goal
        SELECT @calorie_adjustment = calorie_adjustment
        FROM TargetGoals
        WHERE goal_id = @target_goal_id

        -- Calculate BMR using the function
        DECLARE @bmr DECIMAL(10, 2)
        SET @bmr = dbo.CalculateBMRFunction(@gender, @age, @weight, @height, @activity_multiplier, @calorie_adjustment)

        -- Update BMR in UserCalorieInformation table
        UPDATE UserCalorieInformation
        SET 
			bmr = @bmr,
			activity_level_id = @activity_level_id,
			target_goal_id = @target_goal_id
        WHERE user_id = @user_id

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        -- Handle error
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateUserProfile]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_UpdateUserProfile]
    @user_id INT,
    @username NVARCHAR(50),
    @email NVARCHAR(100),
    @firstname NVARCHAR(100),
    @lastname NVARCHAR(100),
    @gender NVARCHAR(10),
    @age INT,
    @height DECIMAL(5, 2),
    @weight DECIMAL(5, 2),
    @activity_level_id INT,
    @target_goal_id INT
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Perbarui user profile
        UPDATE Users
        SET 
            email = @email,
            firstname = @firstname,
            lastname = @lastname
        WHERE user_id = @user_id;

        -- Perbarui informasi profil pengguna
        UPDATE UserProfile
        SET 
            gender = @gender,
            age = @age,
            height = @height,
            weight = @weight
        WHERE user_id = @user_id;

        -- Hitung ulang BMR menggunakan fungsi CalculateBMRFunction
        DECLARE @activity_multiplier DECIMAL(5, 2);
        DECLARE @calorie_adjustment INT;
        DECLARE @bmr DECIMAL(10, 2);

        -- Dapatkan multiplier aktivitas berdasarkan activity_level_id
        SELECT @activity_multiplier = activity_multiplier
        FROM ActivityLevels
        WHERE activity_id = @activity_level_id;

        -- Dapatkan penyesuaian kalori berdasarkan target_goal_id
        SELECT @calorie_adjustment = calorie_adjustment
        FROM TargetGoals
        WHERE goal_id = @target_goal_id;

        -- Hitung ulang BMR
        SET @bmr = dbo.CalculateBMRFunction(@gender, @age, @weight, @height, @activity_multiplier, @calorie_adjustment);

        -- Perbarui BMR di tabel UserCalorieInformation
        UPDATE UserCalorieInformation
        SET 
            bmr = @bmr,
            activity_level_id = @activity_level_id,
            target_goal_id = @target_goal_id
        WHERE user_id = @user_id;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        -- Tangani error
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[ViewUserProfile]    Script Date: 7/22/2024 9:21:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[ViewUserProfile]
    @user_id int
AS
BEGIN
    BEGIN TRY
        -- Mendapatkan informasi profil pengguna berdasarkan username
        SELECT 
            u.user_id, 
            u.username, 
            u.email, 
			u.firstname,
			u.lastname,
            up.gender, 
            up.age, 
            up.height, 
            up.weight,
            a.activity_name AS 'ActivityLevel',
            tg.goal_name AS 'TargetGoal',
            uci.bmr AS 'BMR'
        FROM 
            Users u
        INNER JOIN 
            UserProfile up ON u.user_id = up.user_id
        INNER JOIN
            UserCalorieInformation uci ON u.user_id = uci.user_id
        INNER JOIN
            ActivityLevels a ON uci.activity_level_id = a.activity_id
        INNER JOIN
            TargetGoals tg ON uci.target_goal_id = tg.goal_id
        WHERE 
            u.user_id = @user_id;
    END TRY
    BEGIN CATCH
        -- Menampilkan pesan kesalahan jika terjadi masalah
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO
USE [master]
GO
ALTER DATABASE [NutriaryDatabase] SET  READ_WRITE 
GO
