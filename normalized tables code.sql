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
    Profit_after_wage DECIMAL(10,2),
	PRIMARY KEY (StoreNo),
	FOREIGN KEY (StoreNo) REFERENCES StoreInfo(StoreNo)
);
