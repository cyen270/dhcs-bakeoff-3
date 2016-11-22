import json
import string

fileNameWords = "ngrams/count_1w.txt"
outfileName = "TextEntryScaffold/data/wordFreqTop70000.json"
outfile2Name = "TextEntryScaffold/data/word2FreqTop70000.json"

wordDict = {}
testCount = 70000
x = 0

# ##oneword
# with open(fileNameWords, 'r') as wordFreq:
#     for line in wordFreq:
#         x += 1
#         if x > testCount:
#             break
#         if x % 10000 == 0:
#             filename = "TextEntryScaffold/data/wordFreqTopAuto%d.json" % x
#             with open(filename, 'w') as outfile:
#                 json.dump(wordDict, outfile)
#             print "Saved at: ", x
#         if x % 1000 == 0:
#             print x
#         A = line.split() #split on whitespace
#         try:
#             assert(len(A) == 2)
#         except:
#             print A
#         word = A[0]
#         wordLen = len(word)
#         for preFixLen in xrange(0, wordLen):
#             prefix = word[:preFixLen]
#             if prefix not in wordDict.keys():
#                 wordDict[prefix] = [word]
#             elif(len(wordDict[prefix]) <= 2):
#                 wordDict[prefix].append(word)
#         #should be top 3
# with open(outfileName, 'w') as outfile:
#     json.dump(wordDict, outfile)


wordFreq = {}

#two words
with open(fileNameWords, 'r') as wordFreq:
    for line in wordFreq:
        A = line.split() #split on whitespace
        # assert (len(A) % 3 == 0)
        for i in xrange(0, len(A), 3):
            x += 1
            if x % 10000 == 0:
                filename = "TextEntryScaffold/data/word2FreqTopAuto%d.json" % x
                with open(filename, 'w') as outfile:
                    json.dump(wordDict, outfile)
                print "Saved 2 at: ", x
            if x > testCount:
                break
            if x % 1000 == 0:
                print x
            # try:
            #     assert(len(A) == 3)
            # except:
            #     print A
            #     break;
            prefixWord = unicode(A[i].lower(), "utf-8")
            word = unicode(A[i+1], "utf-8")
            wordLen = len(word)
            if prefixWord not in wordDict.keys():
                wordDict[prefixWord] = {}
            for preFixLen in xrange(wordLen):
                prefix = word[:preFixLen]
                if prefix not in wordDict[prefixWord].keys():
                    wordDict[prefixWord][prefix] = [word]
                elif(len(wordDict[prefixWord][prefix]) <= 2):
                    wordDict[prefixWord][prefix].append(word)

        #should be top 3

with open(outfile2Name, 'w') as outfile:
    json.dump(wordDict, outfile)
