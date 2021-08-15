# This notebook is written to analyze the template data set obtained from https://www.kaggle.com/jackdaoud/marketing-data. It serves as a practice for myself and a demonstration of my basic data analysis knowledge.


```python
import numpy as np
import pandas as pd
import matplotlib as plt
import seaborn as sns
```


```python
df = pd.read_csv(r'C:\Users\morris69.HKUPC2\Desktop\morris\marketing_data.csv')
```


```python
df.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ID</th>
      <th>Year_Birth</th>
      <th>Education</th>
      <th>Marital_Status</th>
      <th>Income</th>
      <th>Kidhome</th>
      <th>Teenhome</th>
      <th>Dt_Customer</th>
      <th>Recency</th>
      <th>MntWines</th>
      <th>...</th>
      <th>NumStorePurchases</th>
      <th>NumWebVisitsMonth</th>
      <th>AcceptedCmp3</th>
      <th>AcceptedCmp4</th>
      <th>AcceptedCmp5</th>
      <th>AcceptedCmp1</th>
      <th>AcceptedCmp2</th>
      <th>Response</th>
      <th>Complain</th>
      <th>Country</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1826</td>
      <td>1970</td>
      <td>Graduation</td>
      <td>Divorced</td>
      <td>$84,835.00</td>
      <td>0</td>
      <td>0</td>
      <td>6/16/14</td>
      <td>0</td>
      <td>189</td>
      <td>...</td>
      <td>6</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>SP</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1</td>
      <td>1961</td>
      <td>Graduation</td>
      <td>Single</td>
      <td>$57,091.00</td>
      <td>0</td>
      <td>0</td>
      <td>6/15/14</td>
      <td>0</td>
      <td>464</td>
      <td>...</td>
      <td>7</td>
      <td>5</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>CA</td>
    </tr>
    <tr>
      <th>2</th>
      <td>10476</td>
      <td>1958</td>
      <td>Graduation</td>
      <td>Married</td>
      <td>$67,267.00</td>
      <td>0</td>
      <td>1</td>
      <td>5/13/14</td>
      <td>0</td>
      <td>134</td>
      <td>...</td>
      <td>5</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>US</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1386</td>
      <td>1967</td>
      <td>Graduation</td>
      <td>Together</td>
      <td>$32,474.00</td>
      <td>1</td>
      <td>1</td>
      <td>5/11/14</td>
      <td>0</td>
      <td>10</td>
      <td>...</td>
      <td>2</td>
      <td>7</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>AUS</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5371</td>
      <td>1989</td>
      <td>Graduation</td>
      <td>Single</td>
      <td>$21,474.00</td>
      <td>1</td>
      <td>0</td>
      <td>4/8/14</td>
      <td>0</td>
      <td>6</td>
      <td>...</td>
      <td>2</td>
      <td>7</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>SP</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 28 columns</p>
</div>




```python
df.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 2240 entries, 0 to 2239
    Data columns (total 28 columns):
     #   Column               Non-Null Count  Dtype 
    ---  ------               --------------  ----- 
     0   ID                   2240 non-null   int64 
     1   Year_Birth           2240 non-null   int64 
     2   Education            2240 non-null   object
     3   Marital_Status       2240 non-null   object
     4    Income              2216 non-null   object
     5   Kidhome              2240 non-null   int64 
     6   Teenhome             2240 non-null   int64 
     7   Dt_Customer          2240 non-null   object
     8   Recency              2240 non-null   int64 
     9   MntWines             2240 non-null   int64 
     10  MntFruits            2240 non-null   int64 
     11  MntMeatProducts      2240 non-null   int64 
     12  MntFishProducts      2240 non-null   int64 
     13  MntSweetProducts     2240 non-null   int64 
     14  MntGoldProds         2240 non-null   int64 
     15  NumDealsPurchases    2240 non-null   int64 
     16  NumWebPurchases      2240 non-null   int64 
     17  NumCatalogPurchases  2240 non-null   int64 
     18  NumStorePurchases    2240 non-null   int64 
     19  NumWebVisitsMonth    2240 non-null   int64 
     20  AcceptedCmp3         2240 non-null   int64 
     21  AcceptedCmp4         2240 non-null   int64 
     22  AcceptedCmp5         2240 non-null   int64 
     23  AcceptedCmp1         2240 non-null   int64 
     24  AcceptedCmp2         2240 non-null   int64 
     25  Response             2240 non-null   int64 
     26  Complain             2240 non-null   int64 
     27  Country              2240 non-null   object
    dtypes: int64(23), object(5)
    memory usage: 490.1+ KB
    

sdfs


```python

```
