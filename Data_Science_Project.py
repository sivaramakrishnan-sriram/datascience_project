#!/usr/bin/env python
# coding: utf-8

# In[201]:


#Importing required packages
import pandas as pd
import numpy as np
import re
from sklearn.feature_extraction.text import TfidfVectorizer


# In[203]:


#Reading the two datasets
salaries = pd.read_csv("Downloads\salaries.csv",low_memory=False)
loan = pd.read_csv("Downloads\loan.csv",low_memory=False)


# In[204]:


#Printing the dimensions of Salaries
print(salaries.shape)


# In[205]:


salaries


# In[206]:


#Printing the Dimensions of Salaries
print(loan.shape)


# In[207]:


#Identifying the missing data in the salaries dataset
salaries.isnull().sum()


# In[208]:


#Dropping NA's and Unnecessary columns
salaries = salaries.drop(["ID1", "Notes", "Status", "Agency"], axis = 1)
salaries = salaries.dropna()


# In[209]:


salaries.shape


# In[210]:


#Identifying the missing data in the loan dataset
loan.isnull().sum()


# In[211]:


total = np.product(loan.shape) # total will be 35772660
miss_values = loan.isnull().sum().sum() # Total missing values are 10027602
per_total = (miss_values/total)*100
print(f"The total percentage of missing values in data set is {(per_total)}")


# In[212]:


print(loan.isnull().any().value_counts(), "\n")

print(f"The columns that have missing values are total {loan.isnull().any().sum()}")


# In[213]:


total_num = loan.isnull().sum().sort_values(ascending=False)
perc = loan.isnull().sum()/loan.isnull().count() *100
df_miss = pd.concat([total_num, perc], axis =1 , keys =["Total Missing Values", "Percentage %"]).sort_values(by ="Percentage %", ascending = False)


# In[214]:


#Identifying top missing values columns in loan dataset
top_mis = df_miss[df_miss["Percentage %"]>40]
top_mis.reset_index(inplace=True)
top_mis


# In[215]:


# Dropping the 42 columns with more than 40% null values
list_to_drop = top_mis['index']
loan_copy = loan
loan_copy = loan_copy.drop(list_to_drop,axis=1)
loan_copy.shape


# In[218]:


loan_copy.dropna()


# In[219]:


loan_copy.shape


# In[220]:


#Identifying null values in the rest 102 columns
print(loan_copy.isnull().any().value_counts(), "\n")
print(f"The columns that have missing values are total {loan_copy.isnull().any().sum()}")


# In[221]:


total_num = loan_copy.isnull().sum().sort_values(ascending=False)
perc = loan_copy.isnull().sum()/loan_copy.isnull().count() *100
df_miss = pd.concat([total_num, perc], axis =1 , keys =["Total Missing Values", "Percentage %"]).sort_values(by ="Percentage %", ascending = False)


# In[222]:


#Identifying top missing values columns in the rest of the loan dataset
top_mis = df_miss[df_miss["Percentage %"]>0]
top_mis.reset_index(inplace=True)
top_mis


# In[93]:


unq_emp_title = loan_copy['emp_title'].unique()
unq_emp_title.shape


# In[223]:


loan_copy.dropna(axis = 'index')


# In[199]:


loan_copy.shape


# In[224]:


loan_copy['emp_title'] = loan_copy['emp_title'].astype(str)


# In[225]:


def ngrams(string, n=3):
    string = string.encode("ascii", errors="ignore").decode() #remove non ascii chars
    string = string.lower() #make lower case
    chars_to_remove = [")","(",".","|","[","]","{","}","'","@","#","%","*"]
    rx = '[' + re.escape(''.join(chars_to_remove)) + ']'
    string = re.sub(rx, '', string) #remove the list of chars defined above
    string = string.replace('&', 'and')
    string = string.replace(',', ' ')
    string = string.replace('-', ' ')
    string = string.title() # normalise case - capital at start of each word
    string = ''.join([i for i in string if not i.isdigit()])
    string = string.strip()
    string = re.sub(' +',' ',string).strip() # get rid of multiple spaces and replace with a single space
    string = re.sub(r'[,-./]|\sBD',r'', string)
    return string


# In[226]:


temp =[]
for x in loan_copy['emp_title']:
    a = ngrams(x)
    temp.append(a)


# In[227]:


loan_copy['emp_title_cleaned'] = temp


# In[230]:


temp =[]
for x in loan_copy['emp_title_cleaned']:
    a = x.split()
    if len(a) > 1:
        temp.append(a[-1])
    else:
        temp.append(a)


# In[231]:


loan_copy['category'] = temp


# In[232]:


loan_copy


# In[234]:


loan_copy['category'] = loan_copy['category'].astype(str)


# In[237]:


c = loan_copy['category'].unique()
len(c)


# In[238]:


min(loan_copy['annual_inc'])


# In[239]:


max(loan_copy['annual_inc'])


# In[240]:


df_salary = pd.DataFrame({'salary': np.random.randint(0.0, 9757200.0, 10)})


# In[241]:


df_salary


# In[ ]:




