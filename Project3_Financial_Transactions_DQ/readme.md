# Financial Transactions DQ Pipeline (dbt + SQL Custom Tests)

This project focuses on performing data quality tests using dbt.

## What’s Included
✔ dbt generic tests  
✔ Custom macros for DQ rules  
✔ Amount validation  
✔ Duplicate detection  
✔ Null checks  

## Example Custom Test
- transaction_amount > 0  
- currency in ('USD', 'EUR', 'GBP')  
- unique transaction IDs  
