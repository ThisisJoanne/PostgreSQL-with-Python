get_ipython().system('pip install -U "psycopg[binary]"')


import psycopg, os

print('Connecting to the PostgreSQL database...')
conn = psycopg.connect(
    host="localhost",
    port='5432',
    dbname="group_project",
    user="postgres",
    password="123") 

# create a cursor
cur = conn.cursor()

#build tables
createCmd = """
CREATE TABLE Manager (
    ManagerNo INT PRIMARY KEY,
    Mng_Sex VARCHAR(10),
    Mng_Age INT
);

CREATE TABLE StoreInfo (
    Location VARCHAR(255),
    State VARCHAR(50),
    Age_Yrs INT,
    ManagerNo INT,
    StoreNo INT PRIMARY KEY,
    FOREIGN KEY (ManagerNo) REFERENCES Manager(ManagerNo)
);


CREATE TABLE StoreDetails(
    No_Staff INT,
    Competitors INT,
    HrsTrading INT,
    StoreNo INT,
    PRIMARY KEY (StoreNo),
    FOREIGN KEY (StoreNo) REFERENCES StoreInfo(StoreNo)
);


CREATE TABLE Revenue (
    Sales_m DECIMAL(10, 2),
    GrossProfit DECIMAL(10, 2),
    StoreNo INT,
    PRIMARY KEY (StoreNo),
    FOREIGN KEY (StoreNo) REFERENCES StoreInfo(StoreNo)
);

CREATE TABLE Manager_detail(
    ManagerNo INT,
    Mng_Exp INT,
    Mng_Train VARCHAR(100),
    PRIMARY KEY (ManagerNo),
    FOREIGN KEY (ManagerNo) REFERENCES Manager(ManagerNo)
);


CREATE TABLE Service (
    StoreNo INT,
    HomeDel BOOLEAN,
    CarSpaces INT,
    PRIMARY KEY (StoreNo),
    FOREIGN KEY (StoreNo) REFERENCES StoreInfo(StoreNo)
);

CREATE TABLE Cost (
    Basket_2013 DECIMAL(10, 2),
    Basket_2014 DECIMAL(10, 2),
    Wages_m DECIMAL(10, 2),
    Adv_1000 DECIMAL(10, 2),
    StoreNo INT,
    PRIMARY KEY (StoreNo),
    FOREIGN KEY (StoreNo) REFERENCES StoreInfo(StoreNo)
);

CREATE TABLE Hours (
    StoreNo INT,
    HrsTrading INT,
    Sundays BOOLEAN,
    PRIMARY KEY (StoreNo),
    FOREIGN KEY (StoreNo) REFERENCES StoreInfo(StoreNo)
);

CREATE TABLE Employees (
    No_Staff INT,
    UnionPerc DECIMAL(5, 2),
    StoreNo INT,
    PRIMARY KEY (StoreNo),
    FOREIGN KEY (StoreNo) REFERENCES StoreInfo(StoreNo)
);

CREATE TABLE Financial_Analysis(
	StoreNo INT,
    GrossMargin DECIMAL(10,2),
    Profit_after_wage DECIMAL(10,2)
	PRIMARY KEY (StoreNo),
	FOREIGN KEY (StoreNo) REFERENCES StoreInfo(StoreNo)
);
"""

cur.execute(createCmd)
conn.commit()

import pandas as pd
from sqlalchemy import create_engine
df = pd.read_csv("C:/Users/joann/OneDrive/桌面/Sping 2023/5310 project/projectdata(3)(1).csv")


#load data into Manager
def load_Manager_data(data):
        for index, row in df.iterrows():
            cur.execute(
                """
                INSERT INTO Manager(Mng_Sex, Mng_Age, ManagerNo)
                VALUES (%s, %s, %s)
                """,
                (row['Mng-Sex'], row['Mng-Age'], index)
            )            
            
load_Manager_data(df)

conn.commit()


#load data into storeinfo
def load_storeinfo_data(data):
        for index, row in df.iterrows():
            cur.execute(
                """
                INSERT INTO StoreInfo(StoreNo, Location, State, Age_Yrs, ManagerNo)
                VALUES (%s, %s, %s, %s, %s)
                ON CONFLICT (StoreNo) DO NOTHING;
                """,
                (row['StoreN'], row['Location'], row['State'], row['AgeYrs'], index)
            )          
            
load_storeinfo_data(df)

conn.commit()


#load data into storedetails
def load_storedetails_data(data):
            for index, row in df.iterrows():
                cur.execute(
                    """
                    INSERT INTO StoreDetails(StoreNo, NO_Staff, Competitors, HrsTrading)
                    VALUES (%s, %s, %s, %s)
                    ON CONFLICT (StoreNo) DO NOTHING;
                    """,
                    (row['StoreN'], row['NoStaff'], row['Competitors'], row['HrsTrading'])
                )         
            
load_storedetails_data(df)

conn.commit()



#load data into revenue
def load_revenue_data(data):
        for index, row in df.iterrows():
            cur.execute(
                """
                INSERT INTO revenue(StoreNo, Sales_m, GrossProfit)
                VALUES (%s, %s, %s)
                ON CONFLICT (StoreNo) DO NOTHING;
                """,
                (row['StoreN'], row['Sales $m'], row['GrossProfit'])
            )
            
load_revenue_data(df)

conn.commit()


#load data into managerdatail
def load_Managerdetail_data(data):
        for index, row in df.iterrows():
            cur.execute(
                """
                INSERT INTO Manager_detail(ManagerNo, Mng_Exp, Mng_Train)
                VALUES (%s, %s, %s)
                """,
                (index, row['Mng-Exp'], row['Mng-Train'])
            )            
            
load_Managerdetail_data(df)

conn.commit()


#load data into Service
def load_Service_data(data):
    for index, row in df.iterrows():
        home_del_bool = True if row['HomeDel (Num)'] == 1 else False
        cur.execute(
            """
            INSERT INTO Service(StoreNo, HomeDel, CarSpaces)
            VALUES (%s, %s, %s)
            ON CONFLICT (StoreNo) DO NOTHING;
            """,
            (row['StoreN'], home_del_bool, row['Car Spaces'])
            )            
            
load_Service_data(df)

conn.commit()

#load data into Cost
def load_Cost_data(data):
        for index, row in df.iterrows():
            basket_2013 = float(row['Basket:2013'].replace("$", "").strip())
            basket_2014 = float(row['Basket:2014'].replace("$", "").strip())
            cur.execute(
                """
                INSERT INTO Cost(StoreNo, Basket_2013, Basket_2014, Wages_m, Adv_1000)
                VALUES (%s, %s, %s, %s, %s)
                ON CONFLICT (StoreNo) DO NOTHING;
                """,
                (row['StoreN'], basket_2013, basket_2014, row['Wages $m'], row['Adv_1000'])
            )            
            
load_Cost_data(df)

conn.commit()


#load data into Hours
def load_Hours_data(data):
        for index, row in df.iterrows():
            sundays_boolean = True if row['sundays'] == 1 else False
            cur.execute(
                """
                INSERT INTO Hours(StoreNo, HrsTrading, Sundays)
                VALUES (%s, %s, %s)
                ON CONFLICT (StoreNo) DO NOTHING;
                """,
                (row['StoreN'], row['HrsTrading'], sundays_boolean)
            )            
            
load_Hours_data(df)

conn.commit()


#load data into Employees
def load_Employees_data(data):
        for index, row in df.iterrows():
            cur.execute(
                """
                INSERT INTO Employees(StoreNo, No_Staff, UnionPerc)
                VALUES (%s, %s, %s)
                ON CONFLICT (StoreNo) DO NOTHING;
                """,
                (row['StoreN'], row['NoStaff'], row['Union%'])
            )            
            
load_Employees_data(df)

conn.commit()


#Load data into FinancialAnalysis
def load_fa_data(data):
    for index, row in df.iterrows():
        cur.execute(
            """
            INSERT INTO Financial_Analysis(StoreNo, GrossMargin, Profit_after_wage)
            VALUES (%s, %s, %s)
            ON CONFLICT (StoreNo) DO NOTHING;
            """,
            (row['StoreN'], row['Gross_Margin'], row['Profit_after_wage'])
        )

                
load_fa_data(df)

conn.commit()
cur.close()
conn.close()

