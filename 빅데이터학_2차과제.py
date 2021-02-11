%matplotlib inline
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# 1번
data = np.loadtxt('data01.txt',dtype = 'float',delimiter = ',')
a = pd.DataFrame(data,columns = ['Korea','Japan','China'],index = np.arange(1800,2001))
a.index.name = 'year'
a

# 2번
a['SUM'] = a.sum(1)
a

# 3번 
plt.plot(a[['Korea','Japan','China']])
plt.axis([1900,2001,0.0,0.00012])
plt.xlabel('year')
plt.xticks(range(1900,2001,5),rotation = 90)
plt.yticks(np.arange(0.0,0.00012,0.00001))
plt.legend(['Korea','Japan','China'],loc='best')
plt.vlines([1950],0.0,0.00006,linestyles = ':')
plt.hlines([0.00006],1900,2000,linestyles = '-.')
plt.show()

# 4번
a[['Korea','Japan','China']].boxplot()
plt.title('East Asia')
plt.xlabel('1800~2000')
plt.ylabel('Relative Frequency')
plt.show()

# 5번
b = (a[['Korea','Japan','China']].T/a[['Korea','Japan','China']].sum(1)).T
b

# 6번
c = b.sort_values('Korea',ascending = False)
c

# 7번
d = c.idxmax()
d

# 8번
c.loc[1991:1993].plot.barh(stacked = True)
plt.show()

# 9번
c.loc[1991].plot.pie(labels = [i.upper() for i in c.columns],autopct = '%0.1f%%')
plt.show()

# 10번
e = c.sort_index(axis=1).rank(axis = 1,ascending=False).applymap(int)
e

# 11번
e.to_csv('DataFrame.txt',sep='\t')

# 12번
f = e.iloc[:5,:].reindex(range(1990,1999),fill_value = 0)
f

# 13번
g = e.iloc[:,1].value_counts()
g

# 14번
h = e.applymap(str).describe()
h

# 15번
i = h.sort_index().sort_index(axis = 1, ascending = False)
i
