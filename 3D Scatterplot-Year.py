#!/usr/bin/env python
# coding: utf-8

# In[2]:


get_ipython().run_line_magic('matplotlib', 'qt')
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from mpl_toolkits.mplot3d import Axes3D

def get_clean_dataframe(df):
    df.columns = df.iloc[0]
    df = df[1:]
    # get new df from columns of interest
    df = df[['Zipcode', 'Living Area', 'Price', 'Year Built']]
    # drop all rows that contain NaN/Null under column_name
    df = df.dropna()
    # drop all empty and '--' rows
    df = df[df!='']
    df = df[df!='--']
    # changed to 'float' dtype
    df = df.astype('float64')
    # drop all rows based on the below conditions 
    df = df[df['Living Area']>100]
    df = df[df['Price']>10000]
    df = df[df['Year Built']>1950]
    # add a new column to df
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

def scatterplot3d_between_columns(df, col1, col2, col3):
    fig = plt.figure(figsize=(8, 6))
    sns.set(style="darkgrid")
    ax = plt.axes(projection='3d')
    ax.grid(b=True,
            color='white',
            linestyle='-',
            linewidth=0.3,
            alpha=0.2)
    cmap = plt.get_cmap('hsv')
    x=df[col1]
    y=df[col2]
    z=df[col3]
    sctt = ax.scatter3D(x,
                        y,
                        z,
                        alpha=0.8,
                        c=z,
                        cmap=cmap,
                        marker='o')
    ax.tick_params(axis='both',
                   which='major',
                   labelsize=8)
    cbar = fig.colorbar(sctt,
                        ax=ax,
                        shrink=0.5,
                        aspect=20)    
    cbar.ax.tick_params(labelsize=8)
    ax.set_xlabel(col1, fontsize=10, fontweight='bold')
    ax.set_ylabel(col2, fontsize=10, fontweight='bold')
    ax.set_zlabel(col3, fontsize=10, fontweight='bold')
    plt.title('3D scatterplot')
    plt.show()
    return

# read csv file
df = pd.read_csv('final_zillow.csv', low_memory=False)
df = get_clean_dataframe(df)
# write csv file
df.to_csv('clean_data.csv', index=False)
scatterplot3d_between_columns(df, 'Year Built', 'Zipcode', 'Price/Sqft')


# In[ ]:





# In[ ]:




