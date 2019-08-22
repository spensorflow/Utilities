# Control Flow

# Assign 5 to a variable
num_drinks = 5

# if statement
if num_drinks < 0:
    print('error')
# elif statement
elif num_drinks <= 4:
    print('non-binge')
# else statement
else:
    print('binge')
   
  
################################   

# Looping

num_drinks = [5, 4, 3, 3, 3, 5, 6, 10]

# Write a for loop
for drink in num_drinks:
    # if/else statement
    if drink <= 4:
        print('non-binge')
    else:
        print('binge')
        
        
################################

# Defining Functions

# Binge status for males
def binge_male(num_drinks):
    if num_drinks <= 5:
        return('non-binge')
    else:
        return('binge')
        
# Check function output
print(binge_male(6))


# Binge status for females
def binge_female(num_drinks):
    if num_drinks <= 4:
        return('non-binge')
    else:
        return('binge')

# Check function output
print(binge_female(2))


# A function that returns a binge status given a sex and number of drinks, based on previously defined 
def binge_status(sex, num_drinks):
    if sex == 'male':
        return binge_male(num_drinks)
    else:
        return binge_female(num_drinks)

## Run example
print(binge_status('male',6))


################################

# Lambda (anonymous) function
# A function that takes a value and returns its square
def sq_func(x):
    return(x**2)
    
# A lambda function that takes a value and returns its square
sq_lambda = lambda x: sq_func(x)

# Use the lambda function
print(sq_lambda(3))

################################
# Map function (equivalent of R apply function)
# map the binge_male function to num_drinks
print(list(map(binge_male, num_drinks)))

# map the binge_female function to num_drinks
print(list(map(binge_female, num_drinks)))


##################################
 # List Comprehension (alternative to a for loop)
    
# Append dataframes into list with for loop
dfs_list = [1,2,3]
for f in inflam_files:
    dat = pd.read_csv(f)
    dfs_list.append(dat)

# Re-write the provided for loop as a list comprehension: dfs_comp
dfs_comp = [pd.read_csv(i) for i in inflam_files]
print(dfs_comp)

#################################
# Dictionary Comprehension

# Write a dict comprehension in which the key is the first element and the value is the second
tf_dict = {key:value for key,value in twitter_followers}

# Print tf_dict
print(tf_dict)


####################
# For loop and if else for computing average within a group
opened_file = open('AppleStore.csv')
from csv import reader
read_file = reader(opened_file)
apps_data = list(read_file)

free_apps_ratings = []
for row in apps_data[1:]:
    rating = float(row[7])
    # Complete the code from here
    price = float(row[4])
    
    if price == 0.0:
        free_apps_ratings.append(rating)
        
        
avg_rating_free = sum(free_apps_ratings) / len(free_apps_ratings)

############################################################
### Calculate percentage distribution from dictionary

content_ratings = {'4+': 4433, '12+': 1155, '9+': 987, '17+': 622}
total_number_of_apps = 7197


for i in content_ratings:
    content_ratings[i] /= total_number_of_apps
    content_ratings[i] *= 100


percentage_17_plus = content_ratings['17+']
percentage_15_allowed = 100 - content_ratings['17+']
#######################################################
### Create proportion and percentage dictionaries from dictionary
content_ratings = {'4+': 4433, '12+': 1155, '9+': 987, '17+': 622}
total_number_of_apps = 7197
c_ratings_proportions = {}
c_ratings_percentages = {}

for i in content_ratings:
    proportion = content_ratings[i] / total_number_of_apps
    print('Key:',i)
    print('Proportion value', proportion)
    
    percentage = proportion * 100
    print('Key:',i)
    print('Percentage value',percentage)
    
    c_ratings_proportions[i] = proportion
    c_ratings_percentages[i] = percentage
