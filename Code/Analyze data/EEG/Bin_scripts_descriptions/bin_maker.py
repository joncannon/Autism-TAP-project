# To create the three bin descriptor files, edit line 47 by pasting in 
# the array of cloze values in the order the words appear in. I.e. we assume
# that the first cloze value correponds to event key 1000, the second with
# event key 2000 and so on. Then, go to terminal / windows powershell where
# this file is located. Type "python3 bin_maker.py" and press enter. The bin
# descriptor files will magically appear in this directory!

# bin maker for n words in n different bins
def bin_maker_1(n):
    ans = "" 
    for i in range(n):
        ans += "bin " + str(i+1) + "\n"
        ans += "event " + str((i+1)*1000) + "\n"
        ans += ".{" + str((i+1)*1000) + "}" + "\n\n"
    return ans

# bin maker that takes array of cloze values and makes three bins
def bin_maker_2(arr):
    # sort arr of cloze values and find cutoffs div1 and div2 
    arr_sorted = sorted(arr)
    div1, div2 = arr_sorted[len(arr)//3], arr_sorted[(len(arr)*2)//3]
    low = "bin 1\nlowest third\n.{"
    mid = "bin 2\nmiddle third\n.{"
    top = "bin 3\ntop third\n.{"
    # create the bins: e.g. low = lowest cloze values
    for i in range(len(arr_sorted)):
        if arr[i] < div1:
            low += str((i+1)*1000) + ";"
        elif arr[i] >= div2:
            top += str((i+1)*1000) + ";"
        else:
            mid += str((i+1)*1000) + ";" 
    low = low[:-1] + "}"
    mid = mid[:-1] + "}"
    top = top[:-1] + "}"
    return low + "\n\n" + mid + "\n\n" + top

# bin for all words
def bin_maker_3(n):
    ans = "bin 1\nwords together\n.{" 
    for i in range(n):
        ans +=  str((i+1)*1000) + ";"
    return ans[:-1] + "}"

# the following lines of code demonstrate creating bin descriptors for
# the cloze values specifically below. Note that len(cloze) = 85
cloze = [0.9,0.5,0.9,0.8,0.67,0.97,0.2,0,0.67,0.13,0.67,0.83,0.83,1,0.43,0.77,0.6,0.73,0.1,0.73,0.6,0.33,0.97,0.83,0.8,0.1,0.8,0.43,0.73,0.97,0.73,0.4,0.53,0.4,0.97,0.8,0.37,0.07,0.27,0.83,0.2,0.27,0.8,0,0.07,0.8,0.93,0.73,0.63,0.7,0.53,0,0.8,0.6,0.6,0.07,0,0.63,0.93,0.87,0.83,0.13,0.67,0,0,0.87,0,0.9,0.73,0,0.37,0.5,0.33,0.73,0.93,0.63,0.5,1,0.97,0,0.97,0.97,0.8,0.7,0.93]
n = len(cloze)

# create the bin with all words separately
inFile = open("bins_words_separate.txt", "w")
inFile.write(bin_maker_1(n))
inFile.close()

# create the bin with words in thirds: lowest, mid, highest
inFile = open("bins_words_thirds.txt", "w")
inFile.write(bin_maker_2(cloze))
inFile.close()

# create the bin with words in thirds: lowest, mid, highest
inFile = open("bins_words_together.txt", "w")
inFile.write(bin_maker_3(n))
inFile.close()




