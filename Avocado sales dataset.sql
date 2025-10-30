CREATE DATABASE avocado;
USE avocado;
RENAME TABLE avocado
TO avocado_sales;

SHOW TABLES;

/*4046 - Total number of avocados with PLU 4046 sold
4225 - Total number of avocados with PLU 4225 sold
4770 - Total number of avocados with PLU 4770 sold*/

-- STEP 1 : DATA EXPLORATION
     /* table records*/
SELECT *
FROM avocado_sales;


    /*unique regions where avocado was sold*/
SELECT DISTINCT region
FROM avocado_sales;

    /*number of rows */
SELECT COUNT(*) totalRows
FROM avocado_sales;
    
    /*list of years(distinct)*/
SELECT DISTINCT year
FROM avocado_sales;

    /*first ten records sorted by dates*/
SELECT *
FROM avocado_sales
ORDER BY date
LIMIT 10;

 -- STEP 2: FILTERING AND SORTING
   /*rows for organic avocados*/
SELECT *
FROM avocado_sales
WHERE type = 'organic';

   /*count rows for ' avocados*/
SELECT COUNT(*)
FROM avocado_sales
WHERE type = 'conventional';

  /*retrieve all data for san franscisco*/
SELECT *
FROM avocado_sales
WHERE region = 'SanFrancisco';

  /*2017 records*/
SELECT *
FROM avocado_sales
WHERE year = 2017;

  /*records ordered by total volume DESC*/
SELECT *   
FROM avocado_sales
ORDER BY Total_Volume DESC;

--  STEP 3:AGGREGATION AND SUMMARIES
   /*total volume per year*/
SELECT year,SUM(Total_Volume) total
FROM avocado_sales
GROUP BY year;

   /*avg price per region*/
SELECT region,AVG(AveragePrice) AS AVGprice
FROM avocado_sales 
GROUP BY region;

   /*region with highest averageprice*/
SELECT region,AVG(AveragePrice) AS AVGprice
FROM avocado_sales
GROUP BY region
ORDER BY AVGprice DESC
LIMIT 1;

    /*total volume per avocado type*/
SELECT type,SUM(total_volume) total_sales
FROM avocado_sales
GROUP BY type;

-- STEP 4:INSIGHTS AND SUBQUERIS
    /*year with highest avg price*/
SELECT year,AVG
FROM
   (SELECT year,AVG(AveragePrice) AS AVG
     FROM avocado_sales
     GROUP BY year)
AS yearly_AVG
ORDER BY AVG DESC
LIMIT 1;

 /*top five regions by total volume sold*/
 SELECT region, SUM(Total_Volume) AS tot_V
 FROM avocado_sales
 GROUP BY region
 ORDER BY tot_V
 LIMIT 5;
 
   /*avg prices btwn organic and conventional avocados*/ 
 SELECT type,AVG(AveragePrice) AS AvgP 
 FROM avocado_sales
 GROUP BY type
 ORDER BY AvgP;
     
   /*retrieve months with highest sales in 2018*/
SELECT 
   MONTHNAME(Date) AS month,
    SUM(Total_Volume) AS total_sales
FROM avocado_sales
WHERE YEAR = 2018
GROUP BY MONTHNAME(Date)
ORDER BY total_sales DESC
LIMIT 1;
   
   /*regions where avg prices excees the national avg price*/
   SELECT 
    region,
    AVG(AveragePrice) AS region_avg_price
FROM avocado_sales
GROUP BY region
HAVING region_avg_price > (
    SELECT AVG(AveragePrice)
    FROM avocado_sales
);
   
-- STEP 5: ADVANCED
  /*create a view called 'region summary' summarizing  yearly performance*/
CREATE VIEW region_summary AS
SELECT 
    YEAR(Date) AS year,
    ROUND(AVG(AveragePrice), 2) AS avg_price,
    ROUND(SUM(Total_Volume), 2) AS total_volume
FROM avocado_sales
GROUP BY year(Date);
  
  /*show which region hd the most consistent  prices */
SELECT 
    region,
    ROUND(STDDEV(AveragePrice), 3) AS price_variation
FROM avocado_sales
GROUP BY region
ORDER BY price_variation ASC
LIMIT 1;


