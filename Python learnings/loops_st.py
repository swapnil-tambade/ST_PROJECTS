# ##------------------------------While loop--------------------------------------

# #print numbers 1 to 10 and end the loop

# i=1

# while i<=10:
#     print(i)
#     i=i+1
# print("Loop ended")   

# #print numbers 5 to 1 and end the loop

# i=5

# while i>=1:
#     print(i)
#     i=i-1
# print("Loop ended")   

#--print number 20 to 10
# i=20
 
# while i>=10:
#     print(i)
#     i=i-1
# print("loop ended")

#-------------print the multiplication of number n (take number as input)----------

# n=int(input("Enter your number:  "))
# i=1
# a=n
# while a<=(n*10):
#     print(a)
#     i=i+1
#     a=n*i
# print("loops ends")    

# print values of this list [1, 4, 9, 16, 25, 36, 49, 64, 81,100]

# list=[1, 4, 9, 16, 25, 36, 49, 64, 81,100]
# i=1

# while i<10:
#     print(list[i])
#     i=i+1
# print("loop ends")    

#find number 36 in the given tuple list

# list=(10,14,15,36,75,88,95,68,36)

# n=36
# i=1

# while i<len(list):
#     if (list[i]==n):
#         print("found the given number : ",n,"at index",i)
#     else:
#         print("finding..")    
#     i=i+1
# print("loop ends")

####------------------------use of break keyword---------------------
# list=(10,14,15,36,75,88,95,68,36)

# n=36
# i=1

# while i<len(list):
#     if (list[i]==n):
#         print("found the given number : ",n,"at index",i)
#         break  # loop will stop once given number found(given condition matches 1st time)
#     else:
#         print("finding..")    
#     i=i+1
# print("loop ends")

##-------------------------use of continue keyword-----act as skip in iteration------

# i=0

# while i<=5:
#     if (i==3):
#         i+=1
#         continue    #this will skip the further steps when provided condition matches, here skipping printing of value 3
#     print(i)       
#     i+=1
# print("loops ends ST")    

#-------------print odd number between 0-20------------
# i=0
# while i<=20:
#     if(i % 2 == 0):
#         i+=1
#         continue  ##this will skip even values as remainder for even value is 0 and matches our if condition here
#     print(i)
#     i+=1
# print("loop ends ST")    

###############################-----FOR loop------######################################
# list=[1,2,4,5,8,9,11,22,14,16]

# for value1 in list:
#     print(value1)


for i in range(0,20,2):  
    print(i)

