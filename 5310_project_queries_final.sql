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

-- *4. How many supermarkets in each state has home delivery service?
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
    R.StoreNo,
    R.Sales_m,
    SI.Location,
    SI.State
FROM
    Revenue R
JOIN
    StoreInfo SI ON R.StoreNo = SI.StoreNo
ORDER BY
    R.Sales_m DESC
LIMIT 5;


-- 7. Is advertising a crucial factor of high revenue?
SELECT
    R.StoreNo,
    R.Sales_m,
    C.Adv_1000,
    (C.Adv_1000 / 1000) AS Adv_m, -- Convert advertising cost to millions
    ((C.Adv_1000 / 1000) / R.Sales_m) * 100 AS Adv_Percentage_of_Sales -- Calculate the percentage
FROM
    Revenue R
JOIN
    Cost C ON R.StoreNo = C.StoreNo
ORDER BY
    R.Sales_m DESC;
	
-- 8. Does a higher percentage of unionized employees (UnionPerc) correlate with different cost structures or sales figures?
SELECT
    E.StoreNo,
    E.UnionPerc,
    C.Wages_m,
    R.Sales_m
FROM
    Employees E
JOIN
    Cost C ON E.StoreNo = C.StoreNo
JOIN
    Revenue R ON E.StoreNo = R.StoreNo
ORDER BY
    E.UnionPerc DESC;
	

SELECT
    CASE 
        WHEN UnionPerc BETWEEN 0 AND 25 THEN '0-25%'
        WHEN UnionPerc BETWEEN 26 AND 50 THEN '26-50%'
        WHEN UnionPerc BETWEEN 51 AND 75 THEN '51-75%'
        WHEN UnionPerc > 75 THEN '76-100%'
    END AS UnionPerc_Range,
    AVG(C.Wages_m) AS Average_Wages,
    AVG(R.Sales_m) AS Average_Sales
FROM
    Employees E
JOIN
    Cost C ON E.StoreNo = C.StoreNo
JOIN
    Revenue R ON E.StoreNo = R.StoreNo
GROUP BY
    UnionPerc_Range
ORDER BY
    UnionPerc_Range;

-- 9. Is there a relationship between the number of staff and store performance metrics like sales or profit margins ?
SELECT
    SD.StoreNo,
    SD.No_Staff,
    R.Sales_m,
    R.GrossProfit,
    (R.GrossProfit / R.Sales_m) * 100 AS Profit_Margin_Percentage
FROM
    StoreDetails SD
JOIN
    Revenue R ON SD.StoreNo = R.StoreNo
ORDER BY
    SD.No_Staff;

-- 10. Is there a relationship between the number of training managers receive (Mng_Train) and store performance in terms of sales or profitability?
SELECT
    SI.StoreNo,
    S.CarSpaces,
    SI.Location,
    R.Sales_m,
    R.GrossProfit,
    (R.GrossProfit / R.Sales_m) * 100 AS Profit_Margin_Percentage
FROM
    Service S
JOIN
    StoreInfo SI ON S.StoreNo = SI.StoreNo
JOIN
    Revenue R ON SI.StoreNo = R.StoreNo
WHERE
    SI.Location = 'Country'
ORDER BY
    S.CarSpaces DESC, R.Sales_m DESC;
	
	
SELECT
    MD.Mng_Train,
    AVG(R.Sales_m) AS Average_Sales,
    AVG(R.GrossProfit) AS Average_Profit
FROM
    Manager_detail MD
JOIN
    Revenue R ON MD.StoreNo = R.StoreNo
GROUP BY
    MD.Mng_Train
ORDER BY
    MD.Mng_Train;



								

								
				
										
					