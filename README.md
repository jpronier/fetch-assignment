# fetch-assignment
Fetch Rewards Coding Exercise - Analytics Engineer

## Overview
This project is a coding exercise for the Analytics Engineer role at Fetch Rewards.
It allows me to demonstrate my reasoning and approach to solving a problem, as well as my ability to 
communicate my understanding of the data and the business context.

## Data
3 json files containing unstructured data were provided:
- `receipts.json`
- `items.json`
- `brands.json`

## Data Model

To understand the data and come up with a structured relational model, I first examined the data in the json files using the eda notebook.
Using Excalidraw, I then diagrammed the relational model to represent the data, as below:

![Structured Data](assets/structured_data.png)

## Business Analysis

Using the PostgreSQL dialect, I created SQL queries to answer the following questions:
- What are the top 5 brands by receipts scanned for most recent month?
- How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?
- When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
- When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
- Which brand has the most spend among users who were created within the past 6 months?
- Which brand has the most transactions among users who were created within the past 6 months?

## Data Quality Checks




Julie Pronier
