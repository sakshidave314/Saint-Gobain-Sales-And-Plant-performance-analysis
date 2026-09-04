# 🏭 Saint-Gobain Glass Manufacturing — Sales, Quality & Delivery Performance Analysis

Analyzing 4 years of order data across 3 plants to find where profit is leaking, which plant-shift is producing defects, and why one region's deliveries run twice as late as the rest — using PostgreSQL, Power Query, and Power BI.


### Independent portfolio project. This is an unofficial, self-directed analysis inspired by Saint-Gobain's glass manufacturing business, built for skill demonstration using order-level data structured to reflect that context. It is not affiliated with, endorsed by, or representative of Saint-Gobain's actual internal data or systems.

## 📌 TL;DR

Saint-Gobain, operating 3 plants (Howrah, Chennai, Pune) in this analysis, is generating revenue, but nobody had connected the dots between where the money's actually being made, where the defects are coming from, and why customers in one region wait almost twice as long for delivery. This project pulls 8,160 order records from a PostgreSQL source, cleans out the duplicate rows and data-entry errors it's carrying, and builds a 3-page Power BI dashboard that answers all three questions in one place — sales & profitability, product quality, and delivery performance — instead of three separate reports nobody cross-references.


## 🎯 The Story Behind This Project

The dashboard isn't the point — here's the thinking behind it.

### What problem was I solving? 

Three functions in this business — sales, quality control, and logistics — were effectively invisible to each other. Sales could see revenue by product, but not whether that product line was also the one generating the most complaints. Quality could see defect rates by plant, but not whether a specific shift was driving them. Nobody had connected delivery performance to region in a way that would explain why one region's customers were waiting so much longer. The problem wasn't "we need a dashboard" — it was that three related questions were being asked with three disconnected answers.

### Why did I choose these metrics?

Margin % by product type, not just revenue — because the highest-revenue product isn't automatically the most profitable one; a business optimizing for the wrong number risks pushing a product line that actually erodes margin.
Defect rate broken out by plant and shift, not just by plant — because averaging across shifts would have hidden exactly the kind of localized problem (a specific plant-shift combination) that's actually fixable, versus a vague "quality is inconsistent" finding nobody can act on.
On-time delivery rate as a hard threshold (≤3 days), not just an average delay — because an average can look acceptable while still masking a large share of customers who wait far longer; a threshold-based rate is what a logistics team can set a real target against.
Complaint rate correlated against both defect rate and delivery delay, rather than just reported on its own — because it's tempting to assume complaints simply track quality or delivery issues; testing that assumption instead of asserting it is the more honest analysis.

### What did I find — and what decision does it enable?

See Key Findings and Insights & Recommendations for the full breakdown, but the short version: one plant-shift combination is producing defects at more than double the company average (a targeted quality-control decision), one region is waiting almost twice as long for delivery for reasons that don't trace back to any single plant (a logistics-routing decision), and — just as importantly — customer complaints turned out not to track cleanly with either defect rate or delivery delay, which means "reduce defects to reduce complaints" isn't actually the safe assumption it sounds like.

### 🧩 The Business Problem

Revenue is being tracked, but nobody has broken it down by product-line profitability — some products may be generating volume without generating margin.
Product defect rates vary, but there's no clear read on where in the operation (which plant, which shift) the problem is concentrated.
Delivery delays are common enough to be a baseline expectation rather than an exception, and it's unclear whether that's a plant capacity problem or a regional logistics problem.
Customer complaints are being logged, but nobody has checked whether they actually correlate with the operational metrics (defects, delays) the business assumes are driving them.
The underlying order data has real quality issues (duplicates, missing fields, data-entry errors) that need to be resolved before any of the above can be trusted.

## ❓ Stakeholder Questions This Project Answers

### Sales & Commercial Leadership

Which product line generates the most revenue, and is that the same product line that generates the most profit?
How is revenue trending year over year — growing, flat, or declining?
Which plants and regions are driving the most business, and which sales reps are top performers?

### Quality / Plant Operations

What's the company-wide average defect rate, and which plant is furthest from it?
Is defect rate a plant problem, a shift problem, or a specific plant-shift combination?
Which product types carry the highest complaint rates?

### Logistics / Supply Chain

What % of orders are delivered on time (within 3 days), and how does that vary by plant and region?
Is one region's delivery performance meaningfully worse than the others, and if so, is that explained by which plant serves it?

### Customer Experience

Do customer complaints actually track with defect rate and delivery delay, or is something else driving them?
Which products and regions generate the highest complaint rates?

## 🏗️ Project Workflow
1. Data Source — order-level data (8,160 rows) pulled from a PostgreSQL order table via Power Query, covering Jan 2022 – Dec 2025.
2. Data Cleaning — handled in Power Query / the data model: standardizing types, and identifying the duplicate, missing, and invalid records documented below.
3. Modeling — DAX measures built for revenue, cost, profit, margin %, average defect rate, complaint rate, average delivery delay, and on-time delivery rate, plus a dedicated "worst plant-shift defect" measure.
4. Reporting — a 3-page Power BI report:
Home Page — navigation landing page
Sales & Profitability — KPI cards, margin trend over time, margin by product type, regional profit vs. revenue, and a profit-ranked product funnel
Quality & Delivery Performance — KPI cards, complaints by product and region, a defect-rate trend, and delivery delay by region and plant

## 🧹 Data Cleaning & Known Data Quality Issues

The source data carries real, unresolved data-quality issues worth documenting rather than quietly working around:

. 320 exact duplicate rows (160 order IDs, each appearing twice with identical data) — inflate order counts and revenue if not excluded.

. 116 rows with negative quantity_units (as low as −778) — not flagged as returns or credits in any other field, so they read as data-entry errors rather than legitimate transactions.

. 120 rows with a defect_rate_percent above 10% (up to 80%, against a typical range of 1–5%) — statistical outliers that skew a simple average defect rate if not treated separately.

. 402 rows (4.9%) missing unit_price_inr — makes revenue/profit calculation impossible for those rows without imputation or exclusion.

. 884 rows (10.8%) missing sales_representators — limits rep-level performance analysis to the ~89% of orders with attribution.

Approach used for the financial figures in this README: revenue, cost, and profit figures below are calculated on the 7,564 rows with a positive quantity and a valid unit price (92.7% of the dataset) — the 596 excluded rows are the negative-quantity and missing-price records above, kept out rather than imputed so the headline numbers aren't built on invented data.

# 📊 Dashboard Screenshots

Add your exported Power BI screenshots here. Open glass_company_project.pbix in Power BI Desktop, go to each page, and use File → Export → Export to Image/PDF, or take a clean screenshot. Save them into an /assets folder in this repo and update the paths below.

Home Page

assets/home-page.png

markdown
![Home Page](assets/home-page.png)
Sales & Profitability

assets/sales-profitability.png

KPI cards alongside a margin trend over time, margin by product type (donut), regional profit vs. revenue (combo chart), and a profit-ranked product funnel.

markdown
![Sales and Profitability](assets/sales-profitability.png)
Quality & Delivery Performance

assets/quality-delivery.png

KPI cards alongside complaints by product and region, a defect-rate view, and delivery delay by region and plant.

markdown
![Quality and Delivery Performance](assets/quality-delivery.png)

## 💡 Key Findings
. 💰 ₹24.1 Crore in total revenue (₹241,057,505) across 7,564 valid orders, against ₹21.2 Crore in cost, for a total profit of ₹2.91 Crore and an overall margin of 12.07%.

. 📦 Insulated Glass Units are the real profit driver, not the revenue leader. Tempered Glass generates the most revenue (₹6.19 Cr) but only a 10.60% margin; Insulated Glass Units generate less revenue (₹5.77 Cr) at a 15.66% margin — the highest of any product line. Glass Bottles have the lowest margin at 7.70%.

. 📉 Revenue peaked in 2023 and has declined since. ₹4.87 Cr (2022) → ₹7.06 Cr (2023, peak) → ₹6.78 Cr (2024) → ₹5.39 Cr (2025) — a trend worth investigating rather than a one-off dip.

. 🏭 Pune's Night shift is the quality outlier. Company-wide average defect rate is 3.85%, and Night shifts overall run higher (5.01% vs. ~3.4–3.5% for Morning/Evening) — but Pune's Night shift specifically averages 8.31% defects, more than double the company average and the clear standout in the plant × shift breakdown.

. 🚚 Only 41.89% of orders are delivered on time (within 3 days), and this is consistent across all three plants (~41–42% each) — meaning it's a systemic delivery-target issue, not a single plant's problem.

. 🗺️ The Central region's delivery delay (5.88 days) is nearly double every other region's (2.94–3.05 days for North, South, East, and West) — and since it isn't explained by a single underperforming plant, it points to a regional logistics/routing issue rather than a production one.

. 🔍 Complaints don't cleanly track defect rate or delivery delay. The correlation between complaint rate and defect rate is effectively zero (0.047), and between complaint rate and delivery delay it's also weak (0.070) — a genuinely useful finding, since it means "just reduce defects" isn't a safe assumption for reducing complaints.

. 🏷️ Discount % shows a weak-to-moderate negative correlation with margin % (−0.238) — discounting is eating into margin as expected, though not as steeply as it could be.

## 🧠 Insights & Recommendations

1. Product mix — Insulated Glass Units are underweighted relative to their profitability Insulated Glass Units carry the highest margin (15.66%) of any product line but rank behind Tempered Glass, Float Glass, and Laminated Glass in order volume.

Recommendation: Shift sales incentive structure and marketing push toward Insulated Glass Units — growing volume in the highest-margin line is a more direct profit lever than growing volume in the highest-revenue-but-lower-margin line (Tempered Glass).
Owner: Sales & Commercial Leadership
Priority: 🔴 High — direct margin impact, no operational change required

2. Quality — Pune Night shift defect rate is more than double the company average Pune's Night shift averages 8.31% defects against a 3.85% company-wide average, and Night shifts overall trend higher across all plants (5.01% vs. ~3.4–3.5%).

Recommendation: Run a targeted root-cause review of Pune's Night shift specifically — staffing levels, supervision coverage, and equipment maintenance scheduling during that shift are the natural starting points, since the gap is too large to be normal variance.
Owner: Plant Operations / Quality Control
Priority: 🔴 High — largest, most specific quality gap found

3. Delivery — Central region's delay isn't a plant problem, it's a routing problem Central region orders average 5.88 days of delay versus 2.94–3.05 days everywhere else, but on-time delivery rate is nearly identical across all three plants (~41–42%) — so the regional gap doesn't trace back to a single plant underperforming.

Recommendation: Investigate the logistics/distribution path specifically serving the Central region (carrier performance, warehouse routing, last-mile distance) rather than looking at plant-level production capacity, since the data rules out a plant-specific cause.
Owner: Logistics / Supply Chain
Priority: 🔴 High — large, region-specific, and currently unexplained

4. Delivery target — a systemic gap, not an isolated one Only 41.89% of all orders meet a 3-day delivery target, and that rate is nearly flat across all three plants — this is a company-wide capacity/planning issue, not a single site's problem.

Recommendation: Before investing in any single plant, revisit whether the 3-day target itself is realistic for current volume, or whether cross-plant capacity planning needs to change to hit it consistently.
Owner: Operations Leadership
Priority: 🟠 Medium — important, but needs a company-wide decision rather than a local fix

5. Complaints — don't assume the obvious cause Complaint rate shows almost no correlation with either defect rate (0.047) or delivery delay (0.070), which contradicts the common assumption that complaints are primarily a quality or logistics symptom.

Recommendation: Before funding a "reduce complaints by reducing defects" initiative, investigate other likely drivers — pricing/discount disputes, communication and expectation-setting, or complaint-logging inconsistency — since the data doesn't support defects or delays as the primary cause.
Owner: Customer Experience / Data Science
Priority: 🟡 Medium — prevents a well-intentioned but likely ineffective fix

6. Data quality — clean before you trust the numbers 320 duplicate rows, 116 negative-quantity records, and 402 missing prices exist in the source data, and were excluded (not imputed) from the financial figures in this analysis.

Recommendation: Add validation at the point of data entry or ETL (reject negative quantities, flag duplicate order IDs, require a unit price) so future reporting doesn't need to manually exclude ~7% of records every time.
Owner: Data Engineering
Priority: 🟢 Low — doesn't change current findings, but prevents recurring cleanup work

## 🔧 A Few Notes on the Power BI Model

While reviewing the DAX behind this report, a few measure definitions are worth revisiting for polish before publishing:

Total_Quantity is currently defined as COUNT('public order'[quantity_units]), which counts the number of orders rather than summing units shipped — worth changing to SUM(...) if the intent is total volume.
Margin % is currently DIVIDE([Total_Revenue],[Total_profit]) (revenue ÷ profit) — the conventional definition is profit ÷ revenue, so this measure's output should be read as its inverse of what the name suggests until corrected.
Total_Revenue and Total_cost currently sum unit_price_inr and unit_cost_inr directly rather than multiplying by quantity_units first — meaning the measures in the live dashboard reflect per-unit pricing summed across rows, not quantity-weighted revenue. The figures in this README's Key Findings were calculated independently (quantity × price, net of discount) to reflect true order-level revenue, so they won't match the dashboard's current KPI cards until that measure is updated.

None of this changes the analysis or the findings above — it's flagged here so the DAX and the README stay honest with each other, and so it's an easy, visible fix before this goes live in the repo.

## 🛠️ Tech Stack
. Data source — PostgreSQL (order table)

. Data preparation — Power Query (M)

. Modeling — DAX measures and calculated columns

. Reporting & visualization — Power BI Desktop

## 🚀 What This Project Demonstrates
Cross-functional analysis: connecting sales, quality, and logistics data instead of reporting on each in isolation.
DAX and data modeling: custom measures for margin, complaint rate, on-time delivery rate, and a targeted plant-shift defect calculation.
Statistical honesty: testing an intuitive assumption (complaints track defects/delays) instead of asserting it, and reporting the result even though it wasn't what was expected.
Data quality awareness: identifying and documenting duplicates, invalid values, and missing fields, and being transparent about how they were handled rather than silently working around them.
Self-review discipline: catching and documenting measure-definition issues in the model itself, rather than only reporting numbers without checking how they were built.

## 📬 Contact

[Sakshi Dave] — sakshidave115@gmail.com

If you're a recruiter or hiring manager and want to talk through the design decisions behind this project, I'd love to chat.
