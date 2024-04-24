-- 1. Which state has the highest sales revenue in million?
select DISTINCT(storeinfo.state), sum(revenue.sales_m) as total_revenue
from storeinfo
join revenue on storeinfo.storeno = revenue.storeno
group by storeinfo.state
order by total_revenue desc

-- 2. Which state is the most competitive in food market industry, how many competitors?
select DISTINCT(storeinfo.state), sum(storedetails.competitors) as total_competitors
from storeinfo
join storedetails on storeinfo.storeno = storedetails.storeno
group by storeinfo.state
order by total_competitors desc

-- *3. How many supermarkets in each state has home delivery service?
select DISTINCT(storeinfo.state), count(service.homedel) AS home_deliver
from storeinfo
join service on storeinfo.storeno = service.storeno
where service.homedel = TRUE
group by storeinfo.state
order by home_deliver desc

-- *4. Do stores open on sunday have higher gross margin than those do not open on sunday?
select storeinfo.storeno, financial_analysis.grossmargin as Gross_margin, hours.sundays
from storeinfo
join financial_analysis on storeinfo.storeno = financial_analysis.storeno
join hours on storeinfo.storeno = hours.storeno
group by storeinfo.storeno, financial_analysis.grossmargin, hours.sundays
order by Gross_margin desc


-- 5. Do older managers generate higher gross margin than younger managers?
select DISTINCT(storeinfo.state), AVG(manager.Mng_Age) AS average_age, 
AVG(financial_analysis.grossmargin) AS average_gross_margin
from storeinfo
join manager on storeinfo.managerno = manager.managerno
join financial_analysis on storeinfo.storeno = financial_analysis.storeno
group by storeinfo.state
order by average_gross_margin desc

-- 6. Which Location(Country, Strip, Mall,etc) contribute the most sales?
SELECT
    SI.Location,
    SUM(R.Sales_m) / (SELECT SUM(Sales_m) FROM Revenue) AS Proportion_of_Sales
FROM
    Revenue R
JOIN
    StoreInfo SI ON R.StoreNo = SI.StoreNo
GROUP BY
    SI.Location
ORDER BY
    Proportion_of_Sales DESC;


-- 7. Is advertising a crucial factor of high revenue?
SELECT
    CASE
        WHEN ((C.Adv_1000 / 1000) / R.Sales_m) * 100 BETWEEN 0 AND 0.5 THEN '0 - 0.5%'
        WHEN ((C.Adv_1000 / 1000) / R.Sales_m) * 100 BETWEEN 0.5 AND 1 THEN '0.5 - 1%'
        WHEN ((C.Adv_1000 / 1000) / R.Sales_m) * 100 BETWEEN 1 AND 1.5 THEN '1 - 1.5%'
        WHEN ((C.Adv_1000 / 1000) / R.Sales_m) * 100 BETWEEN 1.5 AND 2 THEN '1.5 - 2%'
        ELSE 'Other'
    END AS Sales_Percentage_Range,
    COUNT(*) AS Num_of_Stores
FROM
    Revenue R
JOIN
    Cost C ON R.StoreNo = C.StoreNo
GROUP BY
    CASE
        WHEN ((C.Adv_1000 / 1000) / R.Sales_m) * 100 BETWEEN 0 AND 0.5 THEN '0 - 0.5%'
        WHEN ((C.Adv_1000 / 1000) / R.Sales_m) * 100 BETWEEN 0.5 AND 1 THEN '0.5 - 1%'
        WHEN ((C.Adv_1000 / 1000) / R.Sales_m) * 100 BETWEEN 1 AND 1.5 THEN '1 - 1.5%'
        WHEN ((C.Adv_1000 / 1000) / R.Sales_m) * 100 BETWEEN 1.5 AND 2 THEN '1.5 - 2%'
        ELSE 'Other'
    END
ORDER BY
    Sales_Percentage_Range;

	
-- 8. Does a higher percentage of unionized employees (UnionPerc) correlate with different cost structures or sales figures?
SELECT
    UnionPerc_Category,
    SUM(Sales_m) AS Total_Sales
FROM (
    SELECT
        E.StoreNo,
        E.UnionPerc,
        C.Wages_m,
        R.Sales_m,
        CASE
            WHEN E.UnionPerc >= 20 AND E.UnionPerc < 25 THEN '20-24%'
            WHEN E.UnionPerc >= 25 AND E.UnionPerc < 30 THEN '25-29%'
            WHEN E.UnionPerc >= 30 AND E.UnionPerc < 35 THEN '30-34%'
            WHEN E.UnionPerc >= 35 AND E.UnionPerc < 40 THEN '35-39%'
            WHEN E.UnionPerc >= 40 AND E.UnionPerc < 45 THEN '40-44%'
            WHEN E.UnionPerc >= 45 AND E.UnionPerc <= 50 THEN '45-50%'
            ELSE 'Other'
        END AS UnionPerc_Category
    FROM
        Employees E
    JOIN
        Cost C ON E.StoreNo = C.StoreNo
    JOIN
        Revenue R ON E.StoreNo = R.StoreNo
    WHERE
        E.UnionPerc BETWEEN 20 AND 50
) AS SalesByCategory
GROUP BY
    UnionPerc_Category
ORDER BY
    UnionPerc_Category;


-- 9. Is there a relationship between the number of staff and store performance metrics like sales or profit margins ?
SELECT
    CASE
        WHEN SD.No_Staff BETWEEN 35 AND 50 THEN '35-50'
        WHEN SD.No_Staff BETWEEN 51 AND 75 THEN '51-75'
        WHEN SD.No_Staff BETWEEN 76 AND 100 THEN '76-100'
        WHEN SD.No_Staff BETWEEN 101 AND 120 THEN '101-120'
        ELSE 'Other'
    END AS Employee_Category,
    SUM(R.Sales_m) AS Total_Sales
FROM
    StoreDetails SD
JOIN
    Revenue R ON SD.StoreNo = R.StoreNo
WHERE
    SD.No_Staff BETWEEN 35 AND 120
GROUP BY
    CASE
        WHEN SD.No_Staff BETWEEN 35 AND 50 THEN '35-50'
        WHEN SD.No_Staff BETWEEN 51 AND 75 THEN '51-75'
        WHEN SD.No_Staff BETWEEN 76 AND 100 THEN '76-100'
        WHEN SD.No_Staff BETWEEN 101 AND 120 THEN '101-120'
        ELSE 'Other'
    END
ORDER BY
    Employee_Category;


-- 10. Is there a relationship between the number of training managers receive (Mng_Train) and store performance in terms of sales or profitability?
SELECT
    Mng_Train,
    AVG(GrossProfit) AS Avg_Profit
FROM
    Manager_detail
JOIN
    Revenue ON Manager_detail.managerno = Revenue.StoreNo
GROUP BY
    Mng_Train
ORDER BY
    Avg_Profit DESC, Mng_Train ASC;
