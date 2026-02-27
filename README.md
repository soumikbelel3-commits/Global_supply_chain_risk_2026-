# Global_supply_chain_risk_2026-
Detailed data analysis


# 🚢 Global Supply Chain Risk Analysis 2024–2026

![Python](https://img.shields.io/badge/Python-3.10+-3776AB?style=flat&logo=python&logoColor=white)
![Jupyter](https://img.shields.io/badge/Jupyter-Notebook-F37626?style=flat&logo=jupyter&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-PostgreSQL%20%7C%20MySQL%20%7C%20SQLite-336791?style=flat&logo=postgresql&logoColor=white)
![scikit-learn](https://img.shields.io/badge/scikit--learn-ML-F7931E?style=flat&logo=scikit-learn&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=flat)

> **End-to-end data science project** analyzing disruption patterns across 5,000 global shipments (Jan 2024 – Dec 2025). Includes EDA, statistical analysis, machine learning (Random Forest, AUC 0.817), interactive dashboard, and SQL analytics layer.

---

## 📋 Table of Contents

- [Project Overview](#-project-overview)
- [Key Findings](#-key-findings)
- [Repository Structure](#-repository-structure)
- [Dataset](#-dataset)
- [Questions Answered](#-questions-answered)
- [Tech Stack](#-tech-stack)
- [Getting Started](#-getting-started)
- [Notebook Walkthrough](#-notebook-walkthrough)
- [SQL Queries](#-sql-queries)
- [Model Performance](#-model-performance)
- [Dashboard Preview](#-dashboard-preview)
- [Business Recommendations](#-business-recommendations)
- [License](#-license)

---

## 🎯 Project Overview

Global supply chains are under unprecedented stress. This project builds a **complete analytical pipeline** — from raw CSV to production-ready ML model — to understand what drives shipment disruptions and predict them before they happen.

**The core question:** *Can we predict whether a shipment will be disrupted, and which factors matter most?*

**Answer:** Yes — with **AUC-ROC 0.817** using a Random Forest classifier, and three factors (Lead Time, Weather, Geopolitical Risk) explain 42% of model predictive power.

---

## 🔍 Key Findings

| Finding | Detail |
|---|---|
| 📦 Overall disruption rate | **61.3%** — over 6 in 10 shipments disrupted |
| ⛈️ Hurricane = guaranteed disruption | **100%** disruption rate across all 990 hurricane shipments |
| ⏱️ Lead time penalty | Disrupted shipments take **3× longer** (26d vs 8.9d avg) |
| 🌍 Geopolitical risk gradient | Low risk (0-2): 44% → High risk (8-10): **75%** disruption |
| 🚢 Sea transport hidden cost | Equal disruption rate to Air, but **39.8d** avg lead time vs **1.6d** |
| 🧵 Riskiest product category | **Textiles at 64.9%** — 7pp above average |
| 🤖 ML model | Random Forest **AUC 0.817**, CV 0.805 ± 0.013 — production ready |

---

## 📁 Repository Structure

```
supply-chain-risk-analysis/
│
├── README.md                          ← You are here
├── data/
│   └── global_supply_chain_risk_2026.csv   ← Raw dataset (5,000 rows)
│
├── notebooks/
│   └── supply_chain_risk_analysis.ipynb    ← Full 15-step analysis notebook
│
├── sql/
│   └── supply_chain_queries.sql            ← 10 analytical SQL queries
│
├── dashboard/
│   └── supply_chain_risk_dashboard.html    ← Interactive HTML dashboard
│
├── reports/
│   └── supply_chain_risk_report.md         ← Written findings & recommendations
│
└── requirements.txt                        ← Python dependencies
```

---

## 📊 Dataset

**File:** `global_supply_chain_risk_2026.csv`  
**Rows:** 5,000 shipments | **Columns:** 14 | **Missing values:** None

| Column | Type | Description |
|---|---|---|
| `Shipment_ID` | string | Unique identifier (SC-XXXXX) |
| `Date` | date | Shipment date (Jan 2024 – Dec 2025) |
| `Origin_Port` | categorical | 8 global hubs (Singapore, Rotterdam, etc.) |
| `Destination_Port` | categorical | 8 global hubs |
| `Transport_Mode` | categorical | Air / Rail / Road / Sea |
| `Product_Category` | categorical | Automotive / Electronics / Perishables / Pharmaceuticals / Textiles |
| `Distance_km` | float | Shipping distance in kilometers |
| `Weight_MT` | float | Shipment weight in metric tons |
| `Fuel_Price_Index` | float | Fuel cost index at time of shipment |
| `Geopolitical_Risk_Score` | float | 0–10 risk score for the corridor |
| `Weather_Condition` | categorical | Clear / Fog / Rain / Storm / Hurricane |
| `Carrier_Reliability_Score` | float | 0.5–1.0 reliability rating |
| `Lead_Time_Days` | float | Actual transit time in days |
| `Disruption_Occurred` | int (0/1) | **Target variable** — 1 = disrupted |

---

## ❓ Questions Answered

This project is structured around 10 business-critical questions:

1. **What is the overall disruption rate — is it acceptable?**
2. **Which weather conditions cause the most disruptions?**
3. **Does geopolitical risk linearly increase disruption probability?**
4. **Which transport mode is safest AND fastest?**
5. **Which product categories are most at risk?**
6. **Which origin→destination routes are highest risk?**
7. **How much longer do disrupted shipments take?**
8. **Which features best predict a disruption?**
9. **How accurate is the model — can we deploy it in production?**
10. **What should the business do differently?**

---

## 🛠️ Tech Stack

```
Data Analysis    →  pandas, numpy
Visualization    →  matplotlib, seaborn, Chart.js (dashboard)
Machine Learning →  scikit-learn (Random Forest, Gradient Boosting, Logistic Regression)
Database         →  SQL (PostgreSQL / MySQL / SQLite compatible)
Notebook         →  Jupyter Notebook
Dashboard        →  Vanilla HTML/CSS/JS + Chart.js
```

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/supply-chain-risk-analysis.git
cd supply-chain-risk-analysis
```

### 2. Install dependencies

```bash
pip install -r requirements.txt
```

Or manually:

```bash
pip install pandas numpy matplotlib seaborn scikit-learn jupyter
```

### 3. Launch the notebook

```bash
jupyter notebook notebooks/supply_chain_risk_analysis.ipynb
```

### 4. Load data into SQL (optional)

```sql
-- PostgreSQL
CREATE DATABASE supply_chain;
\c supply_chain
-- Then run the CREATE TABLE statement from sql/supply_chain_queries.sql
COPY shipments FROM '/path/to/global_supply_chain_risk_2026.csv' CSV HEADER;
```

### 5. Open the dashboard

Simply open `dashboard/supply_chain_risk_dashboard.html` in any modern browser — no server required.

---

## 📓 Notebook Walkthrough

The notebook is organized into 15 sequential steps:

| Step | Content |
|---|---|
| 0 | Install & import libraries |
| 1 | Load & inspect data (shape, dtypes, nulls) |
| 2 | Data cleaning & feature engineering (date parsing, risk bins) |
| 3 | **Q1** — Overall disruption rate + pie chart |
| 4 | **Q2** — Weather condition analysis + bar chart |
| 5 | **Q3 & Q4** — Geopolitical risk gradient + transport mode dual-axis chart |
| 6 | **Q5** — Product category & origin port risk |
| 7 | **Q6** — Route risk heatmap (origin × destination) |
| 8 | **Q7** — Lead time distribution: disrupted vs on-time |
| 9 | Correlation matrix (Pearson r vs target) |
| 10 | **Q8 & Q9** — Random Forest model build + evaluation |
| 11 | Confusion matrix + ROC curve |
| 12 | Feature importance visualization |
| 13 | Model comparison (Logistic Regression vs RF vs GBM) |
| 14 | Pre-shipment risk scoring on full dataset |
| 15 | **Q10** — Final summary & recommendations |

---

## 🗄️ SQL Queries

The `sql/supply_chain_queries.sql` file contains **10 production-ready queries**, one per business question:

```sql
-- Example: Q2 — Weather disruption rates
SELECT
    weather_condition,
    COUNT(*) AS shipments,
    ROUND(AVG(disruption_occurred) * 100, 1) AS disruption_rate_pct
FROM shipments
GROUP BY weather_condition
ORDER BY disruption_rate_pct DESC;
```

Queries cover: KPI summary, weather analysis, geopolitical risk banding, route heatmap, lead time comparison, carrier reliability analysis, monthly trends, and a rule-based risk scoring query that runs without ML.

---

## 🤖 Model Performance

Three classifiers were evaluated:

| Model | Test AUC | CV AUC (5-fold) | CV Std |
|---|---|---|---|
| **Random Forest** | **0.8167** | **0.8047** | ±0.013 |
| Gradient Boosting | ~0.810 | ~0.800 | ±0.015 |
| Logistic Regression | ~0.730 | ~0.725 | ±0.012 |

**Random Forest classification report (test set, n=1,000):**

```
                  precision  recall  f1-score  support
No Disruption       0.65      0.67      0.66      379
Disruption          0.80      0.78      0.79      621

accuracy                               0.74     1000
macro avg           0.72      0.73      0.73     1000
weighted avg        0.74      0.74      0.74     1000
```

**Top 3 features (42% of model importance):**
1. Lead Time Days — 14.96%
2. Weather Condition — 14.67%
3. Geopolitical Risk Score — 12.16%

---

## 📈 Dashboard Preview

The interactive HTML dashboard (`dashboard/supply_chain_risk_dashboard.html`) includes 7 live charts:

- Monthly disruption rate trend (Jan 2024 – Dec 2025)
- Weather condition vs disruption rate
- Geopolitical risk gradient bar chart
- Lead time histogram: disrupted vs not disrupted
- Feature importance bars (animated)
- Transport mode scatter: disruption rate vs lead time
- 8×8 route risk heatmap with color coding

Open the HTML file in any browser — zero dependencies, zero server needed.

---

## 💼 Business Recommendations

Based on the analysis, five high-priority actions:

**[1] Deploy the ML model as a pre-shipment risk scorer**
Flag any shipment with predicted probability > 0.70 for review or automatic rerouting before dispatch.

**[2] Implement a weather gate**
Block or escalate shipments during forecast hurricane/storm windows on the planned corridor. Hurricane = 100% disruption — this is a hard rule, not a prediction.

**[3] Build a geopolitical routing matrix**
Score all origin–destination pairs using live geopolitical risk indices. Maintain pre-approved alternative routes for corridors scoring above 7.

**[4] Modal switching protocol for high-value Sea shipments**
Sea has equivalent disruption rate to Air but 25× longer lead times when things go wrong. Pre-approve Air/Rail contingency for high-value or time-sensitive cargo on long-haul sea routes.

**[5] Textiles-specific risk monitoring**
At 64.9% disruption rate (highest category), apply dedicated carrier reliability thresholds (≥ 0.85) and weather monitoring for all textile shipments.

---

## 📄 License

This project is licensed under the MIT License — see [LICENSE](LICENSE) for details.

---

## 🙋 Contact

If you found this useful or have questions, feel free to open an issue or reach out via GitHub.

---

*Built with Python · scikit-learn · pandas · matplotlib · Chart.js*
