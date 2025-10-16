# def sum_st(a,b):
#     sum=a+b
#     print(sum)
#     return sum

#------WAF to get length of list provided ----


# def find_length_st(list):
#     length=len(list)
#     return length

# list1=[1,5,8,6,9,7,5,75]
# list2=[1,5,8,6,9,7,5,75,66,55,44,88,77,33]
# data2=find_length_st(list1)   # calling function(argument passing)
# print(data2)

#-----------WAF to print values of list in single line with space------------

# list1=["pune","mumbai","delhi","kolkata","chennai"]
# print(list1)

def print_list_with_space_st(list):
    for i in list:
        print(i,end=" ")


fruits=["mango","apple","orange","grapes","kiwi"]

print_list_with_space_st(fruits)