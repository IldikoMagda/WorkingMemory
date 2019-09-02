import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

classes = ['Not remembered', 'Remembered']

#raw data 
TN = 115202
FP = 65998
FN = 81257
TP = 99943

# Data
r = [1,2]
raw_data = {'greenBars': [FN, TP], 'orangeBars': [TN, FP]}
df = pd.DataFrame(raw_data)


#totals 
a = TP + FP #total for each class true pos + false pos
b = TN + FN 

# From raw value to percentage
totals = [i+j for i,j in zip(df['greenBars'], df['orangeBars'])]
greenBars = [i / j * 100 for i,j in zip(df['greenBars'], totals)]
orangeBars = [i / j * 100 for i,j in zip(df['orangeBars'], totals)]

# plot
barWidth = 0.3
names = classes
# Create stack Bars
#bottom
bar1 = plt.bar(r, greenBars, edgecolor='black',color= 'steelblue', width=barWidth)
#top
bar2= plt.bar(r, orangeBars, bottom=greenBars, edgecolor='black',color= 'orangered', width=barWidth)


#write on them their values 
# add text annotation corresponding to the percentage of each data.

#where to actually put them on the bar
ypos = [20, 50]   # bottom values 
ypos2 = [80, 80]    #top values 
for xpos, ypos, yval in zip(r, ypos, greenBars):
    plt.text(xpos, ypos, "%.1f"%yval, ha="center", va="center",fontsize=12)

for xpos, ypos, yval in zip(r, ypos2, orangeBars):
    plt.text(xpos, ypos, "%.1f"%yval, ha="center", va="center", fontsize=12)


# Custom x axis
plt.xticks(r, names)
plt.xlabel("Predicted Classes",fontsize= 12)

#Custom y axis
plt.yticks(np.arange(0,101,10))
plt.ylabel('Percentage of Class predictions',fontsize=12)

#legend
plt.legend((bar1,bar2),('Remembered', 'Not Remembered'),loc= 9, fontsize= 12)

#Title
#plt.title('Percentage of Class Predictions', fontsize=16)
 
# Show graphic
plt.show()

#should work.... but whatever
# plt.savefig('18featuresTABLE1.png')


