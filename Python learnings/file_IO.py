# #--------------------------------open the file and read data----------------
# f=open("fruits.txt","r")
# data=f.read()
# print(data)
# print(type(data))
# f.close()

# #---------------------------------readline-------------------------
# f=open("fruits.txt","r")
# line1=f.readline()
# print(line1)
# line2=f.readline()
# print(line2)

# f.close()

#---------------------------Create a new file “practice.txt” using python. Add the following data in it:------------

# with open("sample.txt","w") as f:
#     f.write("Hello Everyone\n We are learning JAVA\n we love JAVA")

# -----WAF that replace all occurrences of “java” with “python” in above file.    ---

# with open("sample.txt","r") as f:
#     data=f.read()
#     print(data)

#     data1=data.replace("JAVA","PYTHON")
#     print(data1)

# with open("sample.txt","w") as f:
#     f.write(data1)    #this overwrite new data in same file

#----Search if the word “learning” exists in the file or not.---------

# def find_given_word():     #created below code as custom function
#     word="learning"
#     with open("sample.txt","r") as f:
#         data1=f.read()
#         if (data1.find(word) != -1):
#             print("given word found")
#         else:
#             print("word not found")

# find_given_word()  

#------------use this list in sample file and find even numbers [2,5,4,8,6,12,22,55,53,101]-----

count=0
with open("num_list.txt","r") as f:
    data1=f.read()
    # print(type(data1))
   
    nums=data1.split(",")
    print(type(nums))
    for val in nums:
        if((int(val)%2) == 0):
            count+=1

  
print(count)