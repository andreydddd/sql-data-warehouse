/*
DDL Script - Создание Бронзовых Таблиц
	Создает таблицы в bronze схеме, удаляет таблицы если такие уже имеются
	Запуск кода для переорпеделения DDL структуры bronze таблиц

Также создается хранимая процедура всего скрипта - CREATE OR REPLACE PROCEDURE bronze.load_bronze
	Эта процедура загрузит данные из CSV файлов в bronze схему
	- Сначала она очистит таблицы(Truncate) перед загрузкой данных
	- Использует массовую вставку 'BULK INSERT' для загрузки данных в таблицы
Параметры:
	Нет параметров, хранимая процедура не принемает и не позвращает никаких параметров

Пример:
	EXEC bronze.load_bronze
*/
--вставка данных

--СОзданте скрипта для загрузки данных в бронзовый уровень
CREATE OR ALTER PROCEDURE bronze.load_bronze as
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @start_all_time DATETIME, @end_all_time DATETIME;
	BEGIN TRY
--очищение перед вставкой(полная загрузка - сначала удаляем потом вставляем)
--1

	PRINT 'Loading Bronze Layer';


	PRINT 'Loading CRM Tables';

	SET @start_all_time = GETDATE();
	
	--PRINT '>> Truncating Table'
	TRUNCATE TABLE bronze.crm_cust_info;

	SET @start_time = GETDATE();
	PRINT '>> Inserting Data Into: bronze.crm_cust_info';
	BULK INSERT bronze.crm_cust_info
	FROM 'E:\Study\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	WITH (
		FIRSTROW = 2, 
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR)+ 'seconds';
	PRINT '------------------------';

	--2
	TRUNCATE TABLE bronze.crm_prd_info;

	SET @start_time = GETDATE();
	PRINT '>> Inserting Data Into: bronze.crm_prd_info';
	BULK INSERT bronze.crm_prd_info
	FROM 'E:\Study\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	WITH (
		FIRSTROW = 2, 
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR)+ 'seconds';
	PRINT '------------------------';

	--3
	TRUNCATE TABLE bronze.crm_sales_details;

	SET @start_time = GETDATE();
	PRINT '>> Inserting Data Into: bronze.crm_sales_details';
	BULK INSERT bronze.crm_sales_details
	FROM 'E:\Study\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	WITH (
		FIRSTROW = 2, 
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR)+ 'seconds';
	PRINT '------------------------';


	--ERP Files
	--4
	PRINT 'Loading ERP Tables';

	TRUNCATE TABLE bronze.erp_cust_az12;

	SET @start_time = GETDATE();
	PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
	BULK INSERT bronze.erp_cust_az12
	FROM 'E:\Study\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
	WITH (
		FIRSTROW = 2, 
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR)+ 'seconds';
	PRINT '------------------------';

	--5
	TRUNCATE TABLE bronze.erp_loc_a101;

	SET @start_time = GETDATE();
	PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
	BULK INSERT bronze.erp_loc_a101
	FROM 'E:\Study\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
	WITH (
		FIRSTROW = 2, 
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR)+ 'seconds';
	PRINT '------------------------';


	--6
	TRUNCATE TABLE bronze.erp_px_cat_g1v2;

	SET @end_time = GETDATE();
	PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
	BULK INSERT bronze.erp_px_cat_g1v2
	FROM 'E:\Study\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
	WITH (
		FIRSTROW = 2, 
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR)+ 'seconds';
	PRINT '------------------------';

	SET @end_all_time = GETDATE();
	PRINT 'Full Load Duration:' + CAST(DATEDIFF(second, @start_all_time, @end_all_time) AS NVARCHAR) + 'seconds';
	
	END TRY
	BEGIN CATCH
	PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
	PRINT 'Error Message' + ERROR_MESSAGE();
	PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
	END CATCH
END
