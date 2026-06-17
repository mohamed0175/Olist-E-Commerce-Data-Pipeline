-- ============================================================
--  Create the DWH database
-- ============================================================
CREATE DATABASE EcommerceDWH;
GO
USE EcommerceDWH;
GO

-- ============================================================
--  DIM_DATE
--  Populated automatically with a date range loop
-- ============================================================
CREATE TABLE dim_date (
    date_SK        INT          NOT NULL CONSTRAINT PK_dim_date PRIMARY KEY,
    full_date      DATE         NOT NULL,
    year           INT          NOT NULL,
    quarter        INT          NOT NULL,
    month          INT          NOT NULL,
    month_name     VARCHAR(20)  NOT NULL,
    day            INT          NOT NULL,
    weekday_name   VARCHAR(20)  NOT NULL,
    is_weekend     BIT          NOT NULL
);

-- Populate dim_date from 2016-01-01 to 2020-12-31
DECLARE @d DATE = '2016-01-01';
WHILE @d <= '2020-12-31'
BEGIN
    INSERT INTO dim_date VALUES (
        CAST(FORMAT(@d,'yyyyMMdd') AS INT),    -- date_SK  e.g. 20180101
        @d,
        YEAR(@d),
        DATEPART(QUARTER, @d),
        MONTH(@d),
        DATENAME(MONTH, @d),
        DAY(@d),
        DATENAME(WEEKDAY, @d),
        CASE WHEN DATEPART(WEEKDAY,@d) IN (1,7) THEN 1 ELSE 0 END
    );
    SET @d = DATEADD(DAY, 1, @d);
END;
GO

-- ============================================================
--  DIM_PRODUCT
-- ============================================================
CREATE TABLE dim_product (
    product_SK        INT           NOT NULL IDENTITY(1,1) CONSTRAINT PK_dim_product PRIMARY KEY,
    product_id        VARCHAR(50)   NOT NULL,   -- business key (BK)
    category_name     VARCHAR(100)  NULL,
    category_name_ENG VARCHAR(100)  NULL,  -- <===== ADD ENG Category Name
    weight            FLOAT         NULL,
    length            FLOAT         NULL,
    height            FLOAT         NULL,
    width             FLOAT         NULL
);

-- ============================================================
--  DIM_SELLER
-- ============================================================
CREATE TABLE dim_seller (
    seller_SK       INT          NOT NULL IDENTITY(1,1) CONSTRAINT PK_dim_seller PRIMARY KEY,
    seller_id       VARCHAR(50)  NOT NULL,   -- BK
    zip_code_prefix     INT            NOT NULL,
    lat                 FLOAT          NOT NULL,
    lng                 FLOAT          NOT NULL,
    city                NVARCHAR(100)  NOT NULL,
    state               NVARCHAR(10)   NOT NULL
);

-- ============================================================
--  DIM_CUSTOMER
-- ============================================================
CREATE TABLE dim_customer (
    customer_SK     INT          NOT NULL IDENTITY(1,1) CONSTRAINT PK_dim_customer PRIMARY KEY,
    customer_id     VARCHAR(50)  NOT NULL,   -- BK
    zip_code_prefix     INT            NOT NULL,
    lat                 FLOAT          NOT NULL,
    lng                 FLOAT          NOT NULL,
    city                NVARCHAR(100)  NOT NULL,
    state               NVARCHAR(10)   NOT NULL
);


-- ============================================================
--  DIM_ORDER_REVIEW
-- ============================================================
CREATE TABLE dim_order_review (
    order_review_SK  INT          NOT NULL IDENTITY(1,1) CONSTRAINT PK_dim_order_review PRIMARY KEY,
    review_id        VARCHAR(50)  NOT NULL,   -- BK
    review_score     TINYINT      NOT NULL,   -- 1 to 5
    creation_date    DATE         NOT NULL
);

-- ============================================================
--  FACT_ORDERS  (central fact table)
-- ============================================================
CREATE TABLE fact_orders (
    fact_SK              INT            NOT NULL IDENTITY(1,1) CONSTRAINT PK_fact_orders PRIMARY KEY,

    -- Degenerate dimensions (no dim table, kept on the fact)
    order_id             VARCHAR(50)    NOT NULL,
    item_id              INT            NOT NULL,

    -- Foreign keys to dimensions
    product_FK           INT            NULL CONSTRAINT FK_fact_product  REFERENCES dim_product(product_SK),
    seller_FK            INT            NULL CONSTRAINT FK_fact_seller   REFERENCES dim_seller(seller_SK),
    customer_FK          INT            NULL CONSTRAINT FK_fact_customer REFERENCES dim_customer(customer_SK),
    review_FK            INT            NULL CONSTRAINT FK_fact_review   REFERENCES dim_order_review(order_review_SK),
    purchase_date_SK_FK  INT            NULL CONSTRAINT FK_fact_date     REFERENCES dim_date(date_SK),

    -- Measures
    price                DECIMAL(10,2)  NOT NULL,
    shipping_value       DECIMAL(10,2)  NOT NULL,
    order_status         VARCHAR(30)    NOT NULL
);
GO
