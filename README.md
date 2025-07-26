# Solving-Inventory-Inefficiencies-Using-SQL-
# [cite\_start]Solving Inventory Inefficiencies Using SQL [cite: 1]

### [cite\_start]Introduction [cite: 2]

[cite\_start]In response to increasing operational complexity, Urban Retail Co. aimed to resolve inefficiencies in managing its inventory of over 5,000 SKUs. [cite: 3] [cite\_start]This project utilized advanced SQL-based analytics to gain deep insights, address critical bottlenecks, and optimize inventory performance across various store locations. [cite: 4]

### Data Schema

[cite\_start]Raw data was loaded and then distributed into respective subtables as outlined in the ERD. [cite: 51] [cite\_start]A structured relational schema was established to normalize the dataset, which helps to improve query performance. [cite: 52]

```sql
CREATE TABLE RawData (
    [cite_start]Date DATE, [cite: 7]
    [cite_start]Store_ID VARCHAR(18), [cite: 8]
    [cite_start]Product_ID VARCHAR(10), [cite: 9]
    [cite_start]Category VARCHAR(50), [cite: 10]
    [cite_start]Region VARCHAR(50), [cite: 11]
    Units_Sold INT,
    [cite_start]Inventory_Level INT, [cite: 19]
    [cite_start]Demand_Forecast INT, [cite: 23]
    [cite_start]Price DECIMAL(10,2), [cite: 30]
    [cite_start]Discount DECIMAL(10,2), [cite: 31]
    [cite_start]Competitor_Pricing INT, [cite: 32]
    [cite_start]Weather_Conditions VARCHAR(50), [cite: 33]
    [cite_start]Holiday_Promotion BOOLEAN, [cite: 35]
    [cite_start]Supplier_Rating DECIMAL (10,2), [cite: 37]
    [cite_start]Seasonality VARCHAR(20) [cite: 40]
[cite_start]); [cite: 50]
```

### [cite\_start]SQL Queries & Analysis [cite: 53]

[cite\_start]This section details the key SQL functions and queries used to address specific inventory challenges. [cite: 54] [cite\_start]These queries facilitated the automated detection of issues, generated actionable recommendations, and enabled dynamic inventory monitoring. [cite: 64]

  * [cite\_start]**Stock Level Calculation:** Used `SUM`, `GROUP BY`, and filters to calculate stock levels, providing a foundational understanding of inventory health. [cite: 55, 56]
  * [cite\_start]**Top-Selling Products:** Identified fast-moving SKUs to guide restocking priorities using `GROUP BY Product_ID` and `ORDER BY SUM(Units_Sold) DESC`. [cite: 57]
  * [cite\_start]**Low Inventory Detection:** Flagged SKUs at risk of stockout with a `WHERE Inventory_Level < threshold` check to support proactive replenishment. [cite: 58, 59]
  * [cite\_start]**Reorder Point Estimation:** Employed rolling average logic with `AVG (SUM(Units_Sold)) OVER (...)` to create dynamic reorder thresholds based on demand. [cite: 60]
  * [cite\_start]**Inventory Turnover Analysis:** Calculated turnover rates with `SUM(Units_Sold) / AVG(Inventory_Level)` to identify SKUs that tie up capital. [cite: 61]
  * [cite\_start]**Forecast Accuracy:** Computed forecast errors using `ABS (Units_Sold - Demand_Forecast)` to highlight weaknesses in forecasting. [cite: 62]
  * [cite\_start]**Revenue Leakage Due to Stockouts:** Estimated lost revenue by joining tables and filtering for `Inventory_Level = 0 AND Forecast > 0`. [cite: 63]

#### Example Queries

[cite\_start]**Top Selling Products** [cite: 67]

```sql
[cite_start]SELECT Product_ID, SUM(Units_Sold) AS Total_Sold [cite: 68]
[cite_start]FROM Sales [cite: 69]
[cite_start]GROUP BY Product_ID [cite: 70]
[cite_start]ORDER BY Total_Sold DESC [cite: 71]
[cite_start]LIMIT 10; [cite: 72]
```

[cite\_start]**Weather Based Demand** [cite: 88]

```sql
SELECT
    [cite_start]e.Weather_Conditions, [cite: 90]
    [cite_start]ROUND(AVG(s.Units_Sold), 2) AS Avg_Sales [cite: 91]
[cite_start]FROM Sales s [cite: 92]
[cite_start]JOIN External_Factors e [cite: 93]
    [cite_start]ON s.Sale_Date = e.Factor_Date AND s.Store_ID = e.Store_ID [cite: 94]
[cite_start]GROUP BY e.Weather_Conditions; [cite: 95]
```

[cite\_start]**Forecast Accuracy Query** [cite: 73]

```sql
SELECT
    [cite_start]s.Sale_Date, [cite: 75]
    [cite_start]s.Product_ID, [cite: 76]
    [cite_start]s.Store_ID, [cite: 77]
    [cite_start]s.Units_Sold, [cite: 78]
    [cite_start]f.Demand_Forecast, [cite: 79]
    [cite_start](s.Units_Sold - f.Demand_Forecast) AS Forecast_Error [cite: 80, 81]
[cite_start]FROM Sales s [cite: 82]
[cite_start]JOIN Forecast f [cite: 83]
    [cite_start]ON s.Sale_Date = f.Forecast_Date [cite: 84]
    [cite_start]AND s.Product_ID = f.Product_ID [cite: 86]
    [cite_start]AND s.Store_ID = f.Store_ID; [cite: 85]
```

### [cite\_start]Looker Studio Dashboard [cite: 111]

[cite\_start]Interactive KPI dashboards were created in Google Looker Studio to visualize key metrics. [cite: 112]
[cite\_start][View Dashboard](https://lookerstudio.google.com/reporting/af4086e5-bad2-4e92-ab12-ad998258081d) [cite: 113]

### [cite\_start]Key Insights & Takeaways [cite: 114]

1.  [cite\_start]**Top-Selling and Fast-Moving Products Identified:** Products such as P0016, P0057, P0125, and P0061 were among the highest in units sold and are crucial for revenue. [cite: 115, 116, 117]
2.  [cite\_start]**Low Stock & Stockouts with High Demand:** Multiple instances were found where demand was present but stock was out. [cite: 119] [cite\_start]For example, product P0149 at store S002 resulted in a potential revenue loss of 224. [cite: 120]
3.  [cite\_start]**Overstocked and Slow-Moving Items:** SKUs like P0187 and P0178 had high stock levels but poor sales. [cite: 122] [cite\_start]Some items remained in inventory for over 1,200 days. [cite: 123]
4.  [cite\_start]**Inventory Turnover Variance:** High turnover items like P0070 reflected efficient inventory use, while low turnover items were flagged for review. [cite: 125, 126]
5.  [cite\_start]**Weekly and Seasonal Trends:** Sales showed peaks on weekends and seasonal surges in January, March, and May. [cite: 128, 129]
6.  [cite\_start]**Reorder Point & Restock Delay Analysis:** 7-day rolling averages helped define dynamic reorder levels. [cite: 131] [cite\_start]Delayed restocking was noted for products like P0057 and P0133. [cite: 132]
7.  [cite\_start]**Demand vs Forecast Accuracy:** Stores were compared by their average forecast error to identify areas needing improved forecasting. [cite: 134, 135]
8.  [cite\_start]**Revenue Leakage Summary:** A revenue loss of 224 was directly linked to unfulfilled demand, indicating a potentially significant impact when scaled across the company. [cite: 137, 138]

### [cite\_start]ABC Analysis [cite: 159]

[cite\_start]An ABC Analysis was conducted based on revenue contribution per SKU. [cite: 160]

  * [cite\_start]**Insights:** Products P0066, P0061, and P0133 accounted for over 11% of the revenue share. [cite: 162] [cite\_start]It was recommended that C-class SKUs should be discounted or bundled. [cite: 165]

### [cite\_start]Supplier Performance Metrics [cite: 166]

[cite\_start]Proxy metrics were used due to a lack of direct supplier data. [cite: 167]

  * [cite\_start]**Inferred Lead Time:** Calculated using `LEAD()` functions to compare order and arrival dates. [cite: 168, 169]
  * [cite\_start]**Fulfillment Status:** Assessed supplier reliability by comparing units ordered against the rise in inventory to determine if orders were fully, partially, or unfilled. [cite: 170, 171, 172, 173]

### [cite\_start]Recommendations [cite: 139]

1.  [cite\_start]**Replenish High-Demand Products:** Implement dynamic reorder points for fast-moving items using rolling averages. [cite: 140, 141]
2.  [cite\_start]**Reduce Overstocking:** Clear SKUs aged over one year and introduce holding cost controls. [cite: 142, 143]
3.  [cite\_start]**Improve Forecasting and Buffers:** Adjust buffers for products that are consistently under-forecasted. [cite: 144, 145]
4.  [cite\_start]**Automate Reorder Logic:** Integrate demand-based reorder calculations into the ERP system. [cite: 146, 147]
5.  [cite\_start]**Enhance Supplier Monitoring:** Track fulfillment delays and introduce SLAs. [cite: 148, 149]
6.  [cite\_start]**Use External Factors in Forecasting:** Correlate sales with weather trends to enhance forecast accuracy. [cite: 150, 151]

### [cite\_start]Business Impact [cite: 152]

  * [cite\_start]Improved customer satisfaction from better product availability. [cite: 153]
  * [cite\_start]Enabled data-driven inventory decisions. [cite: 154]
  * [cite\_start]Early identification of poor-performing SKUs. [cite: 155]
  * [cite\_start]Proactive seasonal planning. [cite: 156]
  * [cite\_start]Estimated 30-50% reduction in stockouts. [cite: 157]
  * [cite\_start]Estimated 20-40% optimization in warehouse space. [cite: 158]
