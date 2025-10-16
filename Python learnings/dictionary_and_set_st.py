
# ---------------------------sets-----defined in curly brackets-----------------------

# set1={10,22,14,15,98,66,77,35}   --sets defined in curly brackets and it is list of unique values and you can not do indexing like list and tuples coz output is not consistent, it store values in random way
# print(set1)   ----also sets does not support duplicate values

# -------------------------------dictionaries-----defined as key:value pair=-----------------

# dict1={1:'raj',2:'viki',3:'rahul',6:'vijay'}
# print(dict1)
# print(dict1[1])   #--will result value of key 1 which is raj

# print(dict1.get(2))  #----get fucntion to get value from key number

# dict1[7]='praveen'   #adding  praveen wih key number=7
# print(dict1)   # printing dictionary

# del dict1[6]   #value for key 6 is deleted from the dictionary
# print(dict1)   

# id(dict1)

#####--------------------------dictionary------------------------############

# dict1={
#     1:"raj",
#     2:"swapnil",
#     3:35,
#     4:[1,2,3,4]
# }

# print(dict1)

# dict2={
#     "Name":"raj",
#     "Surname":"Tambade",
#     "Age":35,
#     "address":[1,2,3,4]

# }
# print(dict2)

# #####--------------------------dictionary-methods/operations-----------------------############

# myDict.keys( ) #returns all keys
# myDict.items( ) #returns all (key, val) pairs as tuples
# myDict.update( newDict ) #inserts the specified items to the dictionary
# myDict.values( ) #returns all values
# myDict.get( “key““ ) #returns the key according to value Apna

# print(dict1.keys())

# print(dict1.values())

# print(dict1.items())


# a=dict1[2] 
# # this  brings value of repective key, but  throws error when we provide invalid key
# b=dict1.get(2) 
# #get function and calling value from index number is similar,  only difference is get function doesnt show any error even if index number is invalid
# print(a)
# print(b)

# dict1.update({6:"kedar"})  #update value in dictionary
# print(dict1)

#------------------------Sets-------------------------

set1={1,2,3,5,6,"Raj","rahul",10.5}
print(set1)


#----methods/function/operators on set-------------
# set.add( el ) #adds an element
# set.remove( el ) #removes the elem an
# set.clear( ) #empties the set
# set.pop( ) #removes a random value Apn

# set.union( set2 ) #combines both set values & returns new
# set.intersection( set2 ) #combines common values & returns new
