# User Churn Analysis
***

## Overview
Codeflix, a streaming video startup, is interested in measuring their user churn rate. In this project, we’ll be helping them answer these questions about their churn.

## Project Goals

The purpose of the project is to consolidate and practice the skills of working with SQL queries.

Here are the few questions we want to answer:

1. Get familiar with the company.
* How many months has the company been operating? Which months do you have enough information to calculate a churn rate?
* What segments of users exist?

2. What is the overall churn trend since the company started?

3. Compare the churn rates between user segments.
* Which segment of users should the company focus on expanding?

## Actions
Analyze data with SQL queries to answer the questions above.

## Data

The dataset provided to you contains one SQL table, `subscriptions`. Within the table, there are 4 columns:

 - `id` - the subscription id
 - `subscription_start` - the start date of the subscription
 - `subscription_end` - the end date of the subscription
 - `segment` - this identifies which segment the subscription owner belongs to

Codeflix requires a minimum subscription length of 31 days, so a user can never start and end their subscription in the same month.