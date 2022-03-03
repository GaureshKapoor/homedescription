#!/usr/bin/env python
# coding: utf-8

# In[5]:


get_ipython().run_line_magic('matplotlib', 'qt')
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from mpl_toolkits.mplot3d import Axes3D

def get_clean_dataframe(df):
    df.columns = df.iloc[0]
    df = df[1:]
    df = df[['Zipcode', 'Living Area', 'Price', 'Year Built', 'View Count', 'Favourite Count']]
    df = df.dropna()
    df = df[df!='']
    df = df[df!='--']
    df = df.astype('float64')
    # drop all rows not based on the below conditions 
    df = df[df['Living Area']>100]
    df = df[df['Price']>10000]
    df = df[df['Year Built']>1950]
    df = df[df['View Count']<20000]
    df = df[df['View Count']>100]
    df = df[df['Favourite Count']<1000]    
    df = df[df['Favourite Count']>10]    
    df['Price/Sqft'] = df['Price'] / df['Living Area']
    # drop all rows based on the below conditions 
    df = df[df['Price/Sqft']>20]
    df = df[df['Price/Sqft']<2000]
    # sort by column
    df = df.sort_values(by=['Price/Sqft'], ascending=True)
    # reset index numbers if desired
    df.reset_index(drop=True, inplace=True)
    # changed to 'int' dtype
    df = df.astype('int32')
    print(df.info())
    return df

def heatmap_between_columns(df, col1, col2):
    df = df[[col1, col2]]
    df = df.sort_values(by=[col1, col2], ascending=[True, True])
    correlation = df.corr()
    plt.figure(figsize=(6, 6))
    sns.heatmap(correlation,
                vmin=0,
                vmax=1,
                square=True,
                linewidths=0.1,
                annot=True,
                annot_kws={"size":10},
                fmt='.2f')
    plt.title('Linear Correlation')
    plt.show()
    return

def scatterplot_between_columns(df, col1, col2):
    plt.figure(figsize=(6, 6))
    sns.scatterplot(x=col1,
                    y=col2,
                    data=df,
                    color='#80B3FF')
    plt.title('Scatterplot')
    plt.show()
    return

# read csv file
df = pd.read_csv('final_zillow.csv', low_memory=False)
df = get_clean_dataframe(df)
# write csv file
df.to_csv('clean_data.csv', index=False)
heatmap_between_columns(df, 'Year Built', 'Price/Sqft')
scatterplot_between_columns(df, 'Year Built', 'Price/Sqft')
heatmap_between_columns(df, 'Price/Sqft', 'Favourite Count')
scatterplot_between_columns(df, 'Price/Sqft', 'Favourite Count')
heatmap_between_columns(df, 'Price/Sqft', 'View Count')
scatterplot_between_columns(df, 'Price/Sqft', 'View Count')


# In[ ]:





# In[ ]:




