/*
напоминание о скрипте, где лучше указать все детали чтоб не забыть
создание БД  и схем
*/
-- Создание БД DataWarehouse

CREATE DATABASE DataWarehouse;

use DataWarehouse;

-- Создание схем
CREATE SCHEMA bronze;
GO
  
CREATE SCHEMA silver;
GO
  
CREATE SCHEMA gold;
GO
