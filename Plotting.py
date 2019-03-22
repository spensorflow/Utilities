# Univariate plots
import matplotlib.pyplot as plt

# Histogram of tip
tips.tip.plot(kind='hist')
plt.show()

# Boxplot of the tip column
tips.tip.plot(kind='box')
plt.show()

# Bar plot
cts = tips.sex.value_counts()
cts.plot(kind = 'bar')
plt.show()


############################################
# Bivariate plots

import matplotlib.pyplot as plt

# Scatter plot between the tip and total_bill
tips.plot(x = 'total_bill', y = 'tip', kind = 'scatter')
plt.show()

# Boxplot of the tip column by sex
tips.boxplot(column= 'tip', by='sex')
plt.show()


############################################
# Univariate plots in Seaborn

import seaborn as sns
import matplotlib.pyplot as plt

# Bar plot
sns.countplot(x='sex', data=tips)
plt.show()

# Histogram
sns.distplot(tips['total_bill'])
plt.show()

############################################
# Bivariate plots in Seaborn

import seaborn as sns
import matplotlib.pyplot as plt

# Boxplot for tip by sex
sns.boxplot(x = 'sex', y = 'tip', data=tips)
plt.show()

# Scatter plot of total_bill and tip
sns.regplot(x = 'total_bill', y = 'tip', data=tips)
plt.show()

############################################
# Facet plots in Seaborn

import seaborn as sns
import matplotlib.pyplot as plt

# Scatter plot of total_bill and tip faceted by smoker and colored by sex
sns.lmplot(x='total_bill', y='tip', data=tips, hue='sex', col='smoker')
plt.show()

# FacetGrid of time and smoker colored by sex
facet = sns.FacetGrid(tips, col="time", row='smoker', hue='sex')

# Map the scatter plot of total_bill and tip to the FacetGrid
facet.map(plt.scatter, 'total_bill', 'tip')
plt.show()


############################################
# Univariate and Bivariate plots in Matplotlib

import matplotlib.pyplot as plt

# Univariate histogram
plt.hist(tips.total_bill)
plt.show()

# Bivariate scatterplot
plt.scatter(tips['tip'],tips['total_bill'])
plt.show()

############################################
# Subfigures in Matplotlib

import matplotlib.pyplot as plt

# Create a figure with 1 axes
fig, ax = plt.subplots(1, 1)

# Plot a scatter plot in the axes
ax.scatter(tips.tip, tips.total_bill)
plt.show()

# Create a figure with scatter plot and histogram
fig, (ax1, ax2) = plt.subplots(1, 2)
ax1.scatter(tips['tip'], tips['total_bill'])
ax2.hist(tips['total_bill'])
plt.show()

############################################
# Working with Axes

# Distplot of tip
import seaborn as sns
dis = sns.distplot(tips['tip'])

# Print the type
print(type(dis))

# Figure with 2 axes: regplot and distplot
fig, (ax1, ax2) = plt.subplots(1,2)
sns.distplot(tips['tip'], ax=ax1)
sns.regplot(x='total_bill', y='tip', data=tips, ax=ax2)
plt.show()

###################################################

# More figures
import matplotlib.pyplot as plt
import seaborn as sns

# Create a figure with 1 axes
fig, ax = plt.subplots()

# Draw a displot
ax = sns.distplot(tips['total_bill'])

# Label the title and x axis
ax.set_title('Histogram')
ax.set_xlabel('Total Bill')
plt.show()


