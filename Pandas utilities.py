# Selecting columns with Pandas

# Print the tip column using dot notation
print(tips.tip)

# Print the sex column using square bracket notation
print(tips['sex'])

# Print the tip and sex columns
print(tips[['tip','sex']])

################################################################
# Subsetting rows with Pandas

# Print the first row of tips using iloc
print(tips.iloc[0])

# Print all the rows where sex is Female
print(tips.loc[tips.sex == 'Female'])

# Print all the rows where sex is Female and total_bill is greater than 15
print(tips.loc[(tips.sex == 'Female') & (tips.total_bill > 15)])


################################################################
# Subset rows and columns
print(tips.loc[tips['sex'] == 'Female', ['total_bill', 'tip', 'sex']])

# 3 rows and 3 columns with iloc
print(tips.iloc[0: 3, 0:3])

################################################################
# Integer and float data types
# Convert the size column
tips['size'] = tips['size'].astype(int)

# Convert the tip column
tips.tip = tips.tip.astype(float)

# Look at the types
print(tips.dtypes)

################################################################
# String type
# Convert sex to lower case
tips['sex'] = tips['sex'].str.lower()

# Convert smoker to upper case
tips.smoker = tips.smoker.str.upper()

# Print the sex and smoker columns
print(tips[['sex', 'smoker']])

################################################################
# Category data type
# Convert the type of time column
tips['time'] = tips['time'].astype('category')

# Use the cat accessor to print the categories in the time column
print(tips['time'].cat.categories)

# Order the time category so lunch is before dinner
tips['time2'] = tips['time'].cat.reorder_categories(['Lunch', 'Dinner'], ordered=True)


################################################################
# Dates (1)

import pandas as pd

# Load the country_timeseries dataset
ebola = pd.read_csv('country_timeseries.csv')

# Inspect the Date column
print(ebola['Date'].dtype)

# Convert the type of Date column into datetime
ebola['Date'] = pd.to_datetime(ebola['Date'], format='%m/%d/%Y')

# Inspect the Date column
print(ebola['Date'].dtype)

##########

# Dates (2)
import pandas as pd

# Load the dataset and ensure Date column is imported as datetime
ebola = pd.read_csv('country_timeseries.csv', parse_dates=['Date'])

# Inspect the Date column
print(ebola['Date'].dtype)

# Create a year, month, day column using the dt accessor
ebola['year'] = ebola.Date.dt.year
ebola['month'] = ebola.Date.dt.month
ebola['day'] = ebola.Date.dt.day

# Inspect the newly created columns
print(ebola[['year', 'month', 'day']].head())


################################################################
# Finding missing values, and imputation

# Print the rows where total_bill is missing
print(tips.loc[pd.isnull(tips['total_bill'])])

# Mean of the total_bill column
tbill_mean = tips['total_bill'].mean()

# Fill in missing total_bill
print(tips['total_bill'].fillna(tbill_mean))


################################################################
# Groupby

# Mean tip by sex
print(tips.groupby('sex')['tip'].mean())

# Mean tip by sex and time
print(tips.groupby(['sex', 'time'])['tip'].mean())

################################################################
# Tidying data

# Melt the airquality DataFrame
airquality_melted = pd.melt(airquality, id_vars=['Day', 'Month'])
print(airquality_melted)

# Pivot the molten DataFrame
airquality_pivoted = airquality_melted.pivot_table(index=['Month', 'Day'], columns='variable', values='value')
print(airquality_pivoted)
