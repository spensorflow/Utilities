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

# Lambda function
# A function that takes a value and returns its square
def sq_func(x):
    return(x**2)
    
# A lambda function that takes a value and returns its square
sq_lambda = lambda x: sq_func(x)

# Use the lambda function
print(sq_lambda(3))

################################
# Map function
# map the binge_male function to num_drinks
print(list(map(binge_male, num_drinks)))

# map the binge_female function to num_drinks
print(list(map(binge_female, num_drinks)))
