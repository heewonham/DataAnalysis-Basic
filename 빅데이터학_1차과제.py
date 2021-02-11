import numpy as np
import pandas as pd
# 1번
a = np.arange(2,101,2).reshape(10,5)
# 2번
a.shape = (2,5,5)
# 3번
b = np.full((5,5),a[0,4,4])
# 4번
c = np.cumsum(b).reshape(5,5).astype('U')
# 5번
d = c[::-1].astype('float')
# 6번
e = d[1::,::-1]
# 7번
f = np.append(e[:,0:2],e[:,3:],1)
# 8번
g = np.append(f,f[:,1::2].T,0)
# 9번
h = np.insert(g,2,g[::,::3].T,1)
# 10번
h.sort(0)
# 11번
i = pd.Series(h[5],index = h[0].astype('int'),dtype = 'int')
# 12번
i[800<i] = None
# 13번
j = i.fillna(0)
# 14번
k = pd.Series(j,dtype='U')
# 15번
#k.index = [1,3,5,7,9,11]
