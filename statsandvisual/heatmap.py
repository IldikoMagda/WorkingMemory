import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

loadTP= pd.read_csv('/home/ildiko/Desktop/PROCESSED_Data/MLRESULTS/40digitsupML/EnsembleResults/TP.csv')
loadTN = pd.read_csv('/home/ildiko/Desktop/PROCESSED_Data/MLRESULTS/40digitsupML/EnsembleResults/TN.csv')
loadFN = pd.read_csv('/home/ildiko/Desktop/PROCESSED_Data/MLRESULTS/40digitsupML/EnsembleResults/FN.csv')
loadFP= pd.read_csv('/home/ildiko/Desktop/PROCESSED_Data/MLRESULTS/40digitsupML/EnsembleResults/FP.csv')
#print(TP)

# this =sns.heatmap(TruePositiveTheta)
# plt.show(this)
#print(loadFN)
AVFN= loadFN.mean(axis=0)
#print(len(AVFN))
AVTP =loadTP.mean(axis=0)
AVTN =loadTN.mean(axis=0)
AVFP= loadFP.mean(axis=0)
print(AVFP)

xlabels =['TN', 'TP','FN', 'FP']
channels= ['P8', 'T8','F8','F4','C4','P4','Fp2','Fp1','Fz','Cz', 'Oz', 'Pz','P3','C3','F3','F7','T7','P7']

data= np.array([[AVTN],[AVTP],[AVFN],[AVFP]])
data = np.squeeze(data)

fig, ax= plt.subplots(1,1, figsize=(8,8))
im =ax.imshow(data, cmap='Greens')
fig.colorbar(im, orientation='horizontal')

ax.set_xticks(np.arange(len(channels)))
ax.set_yticks(np.arange(len(xlabels)))

ax.set_xticklabels(channels)
ax.set_yticklabels(xlabels)

#fig.tigh_layout()
plt.show()
