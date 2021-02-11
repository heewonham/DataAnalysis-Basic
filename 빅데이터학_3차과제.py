%matplotlib inline
import matplotlib.pyplot as plt
import pandas as pd, numpy as np
import re, requests
from ast import literal_eval

corpora = dict(eng_us_2012 = 17, eng_us_2009 = 5, eng_gb_2012 = 18, 
eng_gb_2009 = 6, chi_sim_2012 = 23, chi_sim_2009 = 11, eng_2012 = 15, 
eng_2009 = 0, eng_fiction_2012 = 16, eng_fiction_2009 = 4, eng_1m_2009 = 1, 
fre_2012 = 19, fre_2009 = 7, ger_2012 = 20, ger_2009 = 8, heb_2012 = 24, 
heb_2009 = 9, spa_2012 = 21, spa_2009 = 10, rus_2012 = 25, rus_2009 = 12, 
ita_2012=22)

def GoogleNgrams(A, B = 1900,C = 2008,D = 'eng_2012'):
    search = dict(content = A, year_start = B, year_end = C,
            corpus = corpora[D])
    a = requests.get('http://books.google.com/ngrams/graph',
                    params = search)
    b = literal_eval(re.search('var data = (.*?);\\n', a.text).group(1))
    if b :
        df = pd.DataFrame({i['ngram']:i['timeseries'] for i in b},
                          index = pd.Index(np.arange(search['year_start'],search['year_end'] +1)
                                           ,name = 'year'))
       
    else :
        df = '검색결과가 없습니다.'
    return(df)

# women&men ratio barh(stacked = True) 차트 1
us1 = GoogleNgrams('women,men',B = 1800 , D='eng_us_2012')
gb1 = GoogleNgrams('women,men',B = 1800 , D='eng_gb_2012')
c = pd.merge(us1['women'],gb1['women'],right_index = True, left_index = True).sum(1)
d = pd.merge(us1['men'],gb1['men'],right_index = True, left_index = True).sum(1)
e = pd.DataFrame({'women':c.values, 'men':d.values},index = range(1800,2009))
f = (e[['women','men']].T/e[['women','men']].sum(1)).T
g = f.rename(index = {i : str(i)[:-1]+'0' for i in c.index})
g.index.name = 'year'
g.columns.name = 'sex'
h = g.groupby('year',as_index=False).sum()/10
h.plot.barh(stacked = True)
plt.title('1800~2008 women&men ratio')
plt.yticks(range(0,21),np.arange(1800,2009,10))
plt.ylabel('year')

# women&men ratio barh(stacked = True) 차트 2
h.plot()
plt.title('1800~2008 women&men ratio')
plt.xticks(range(0,21),np.arange(1800,2009,10), rotation = 90)
plt.xlabel('year')

# racism & sexism ratio (차트 2) >> 성별차이와 인종차이의 관심이 둘다 상승
us2 = GoogleNgrams('sexism, racism, feminist',D ='eng_us_2012')
gb2 = GoogleNgrams('sexism, racism, feminist',D ='eng_gb_2012')
discrim = pd.merge(us2[['sexism', 'racism']], gb2[['sexism', 'racism']], right_index = True,
                   left_index = True, suffixes = ['_us','_gb'])
discrim.columns = pd.MultiIndex.from_product([['US','GB'],['sexism', 'racism']],
                                             names = ['corpora', 'verbs'])
discrim.groupby(level = 'verbs',axis = 1).agg('median').plot()

# 변동률, 상관계수(차트 3)
eng1 = GoogleNgrams('feminist, racism, women, sexism')
eng1.pct_change().plot()
eng1.corr()

# 히스토그램(차트 4) ---> racism, feminism
eng = GoogleNgrams('racism, feminist')
eng['racism'].pct_change().hist(alpha = 0.5, label = 'racism')
eng['feminism'].pct_change().hist(alpha = 0.5, label = 'feminism')
plt.legend()

# 척도가 다른 두개 y축을 하나의 차트로 - feminist, racism (필수차트1) >> 상승이 비슷하다
i = pd.merge(us2['racism'],gb2['racism'],right_index = True, left_index = True).sum(1)
j = pd.merge(us2['feminist'],gb2['feminist'],right_index = True, left_index = True).sum(1)
tem1 = pd.DataFrame({'racism':i.values})
tem2 = pd.DataFrame({'feminist':j.values})
fig,ax1 = plt.subplots()
ax1.set_xlabel('year')
plt.xticks(range(0,110,20),range(1900,2010,20))
ax1.set_ylabel('feminist',color = 'red')
ax1.plot(tem2, color = 'red')
ax1.tick_params(axis = 'y',labelcolor = 'red')
ax2 = ax1.twinx()
ax2.set_ylabel('racism', color = 'blue')
ax2.plot(tem1, color = 'blue')
ax2.tick_params(axis = 'y', labelcolor = 'blue')

# 점 대신 텍스트 삽입(필수차트2)
us_1900_1 = GoogleNgrams('sexism, misogyny, misandry, anti-semitism, ladyish, for ladies,',B = 1900,
                         C = 1925, D ='eng_us_2012')
us_2008_1 = GoogleNgrams('sexism, misogyny, misandry, anti-semitism, ladyish, for ladies,',B = 1986,
                         C = 2010, D ='eng_us_2012')
gb_1900_1 = GoogleNgrams('sexism, misogyny, misandry, anti-semitism, ladyish, for ladies,',B = 1900,
                         C = 1925, D ='eng_us_2012')
gb_2008_1 = GoogleNgrams('sexism, misogyny, misandry, anti-semitism, ladyish, for ladies,',B = 1986,
                         C = 2010, D ='eng_us_2012')
us_1900_2 = GoogleNgrams('racism, feminist, womanly ,manly',B = 1900, C = 1925,
                         D ='eng_us_2012')
us_2008_2 = GoogleNgrams('racism, feminist, womanly ,manly',B = 1986, C = 2010, 
                         D ='eng_us_2012')
gb_1900_2 = GoogleNgrams('racism, feminist, womanly ,manly',B = 1900, C = 1925, 
                         D ='eng_us_2012')
gb_2008_2 = GoogleNgrams('racism, feminist, womanly ,manly',B = 1986, C = 2010, 
                         D ='eng_us_2012')
df1 = us_1900_1.applymap(float).sum(0) + gb_1900_1.applymap(float).sum(0)*10000
df2 = us_2008_1.applymap(float).sum(0) + gb_2008_1.applymap(float).sum(0)*10000
df3 = us_1900_2.applymap(float).sum(0) + gb_1900_2.applymap(float).sum(0)*1000
df4 = us_2008_2.applymap(float).sum(0) + gb_2008_2.applymap(float).sum(0)*1000
df = pd.DataFrame(df1,columns = ['1900~1925'])
df['1986~2010'] = pd.DataFrame(df2)
df = df.add(pd.DataFrame(df3,columns = ['1900~1925']),fill_value = 0)
df = df.add(pd.DataFrame(df4,columns = ['1986~2010']),fill_value = 0)
for x in df.T:
    plt.annotate(x, df.loc[x].values)
plt.title("Increasing & Decreasing Trend scatterplot")
plt.xlabel("Mean Regularity 1900~1975")
plt.ylabel("Mena Regularity 1986~2010")
x = np.arange(-0.1,0.5,.001)
plt.plot(x,x,'--')
print(df)
