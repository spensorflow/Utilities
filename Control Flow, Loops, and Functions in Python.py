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
