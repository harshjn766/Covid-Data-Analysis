#!/usr/bin/env python
# coding: utf-8

# In[1]:


import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns


# In[2]:


df_tracks=pd.read_csv(r'C:\Users\Dell\OneDrive\Desktop\dataset\tracks.csv')
df_tracks.head()


# In[4]:


# Null values

pd.isnull(df_tracks).sum()


# In[5]:


# Information of dataset

df_tracks.info()


# In[20]:


# For least popular songs

sorted_df=df_tracks.sort_values('popularity',ascending=True).head(10)
sorted_df


# In[6]:


# For Descriptive Statistics

df_tracks.describe().transpose()


# In[24]:


# For most popular songs
most_popular = df_tracks.query('popularity>90' , inplace= False).sort_values('popularity' , ascending= False)
most_popular[:10]


# In[4]:


# For changing the index

df_tracks.set_index('release_date', inplace=True)
df_tracks.index=pd.to_datetime(df_tracks.index)
df_tracks.head()


# In[26]:


# For index location
df_tracks[["artists"]].iloc[18]


# In[8]:


# To convert the duration from miliseconds to seconds

df_tracks["duration"]= df_tracks["duration_ms"].apply(lambda x: round(x/1000))
df_tracks.drop("duration_ms", inplace=True, axis=1)


# In[9]:


df_tracks.duration.head()


# In[36]:


# for correlation

corr_df= df_tracks.drop(["key","mode","explicit"], axis=1).corr(method="pearson")
plt.figure(figsize=(14,6))
heatmap= sns.heatmap(corr_df,annot=True,fmt=".1g", vmin=-1, vmax=1, center=0, cmap="inferno", linewidths=1, linecolor="Black")
heatmap.set_title("Correlation Heatmap Between Variable")
heatmap.set_xticklabels(heatmap.get_xticklabels(), rotation=90)


# In[37]:


sample_df= df_tracks.sample(int(0.004*len(df_tracks)))


# In[38]:


print(len(sample_df))


# In[41]:


# To create a regression plot

plt.figure(figsize=(10,6))
sns.regplot(data= sample_df, y= "loudness", x= "energy", color= "c").set(title= "Loudness vs Energy Correlation")


# In[42]:


plt.figure(figsize=(10,6))
sns.regplot(data= sample_df, y= "popularity", x= "acousticness", color= "b").set(title= "Popularity vs Acousticness Correlation")


# In[6]:


# To create a new column 'year' from our 'release date' column
df_tracks['dates']=df_tracks.index.get_level_values('release_date')
df_tracks.dates=pd.to_datetime(df_tracks.dates)
years=df_tracks.dates.dt.year


# In[11]:


pip install --user seaborn==0.11.0


# In[7]:


# To create a distribution plot to visualise the total number of songs in each year
sns.displot(years,discrete=True,aspect=2,height=5,kind="hist").set(title="Number of songs per year")


# In[10]:


# To see the duration of songs
total_dr=df_tracks.duration
fig_dims=(18,7)
fig,ax= plt.subplots(figsize=fig_dims)
fig= sns.barplot(x=years,y= total_dr, ax= ax, errwidth= False).set(title='Year vs Duration')
plt.xticks(rotation=90)


# In[11]:


# To analyse the average duration of the songs
total_dr=df_tracks.duration
sns.set_style(style="whitegrid")
fig_dims=(10,5)
fig, ax=plt.subplots(figsize=fig_dims)
fig=sns.lineplot(x=years, y=total_dr, ax=ax).set(title='Year vs Duration')
plt.xticks(rotation=60)


# In[13]:


df_genre=pd.read_csv(r"C:\Users\Dell\OneDrive\Desktop\dataset\spotify features.csv")


# In[14]:


df_genre.head()


# In[16]:


plt.title("Duration of the Songs in Different Genres")
sns.color_palette("rocket", as_cmap= True)
sns.barplot(y='genre', x='duration_ms', data=df_genre)
plt.xlabel("Duration in milli seconds")
plt.ylabel("Genres")


# In[17]:


sns.set_style(style= "darkgrid")
plt.figure(figsize=(10,5))
famous= df_genre.sort_values("popularity", ascending = False).head(10)
sns.barplot(y='genre', x='popularity', data= famous).set(title= 'Top  Genres by Popuarity')


# In[ ]:




