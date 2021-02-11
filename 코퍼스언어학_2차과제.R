# 1900년대 이후 공화당, 민주당 대통령 연설문
repub <- vector()
democ <- vector()
re <- c("1909","1921","1925","1929","1953","1957","1969","1973","1981","1985","1989","2001","2005")
de <- c("1913","1917","1933","1937","1941","1945","1949","1961","1965","1977","1993","1997","2009")
for(i in list.files(path='.',pattern='[.]txt$')){
	text <- substring(i,1,4)
	file <- scan(file=i,what="char",quote = NULL)
	if(text %in% re){
		repub <- c(repub,file)
	}
	else if(text %in% de){
		democ <- c(democ,file)
	}
}
# 공화당, 민주당의 dataframe&상대빈도, 브라운코퍼스 dataframe 30개까지 빈도분석
repub.t <- sort(table(repub),decreasing = T)
democ.t <- sort(table(democ),decreasing = T)
repub.freq <- data.frame(row.names = names(repub.t), Freq = as.vector(repub.t))
democ.freq <- data.frame(row.names = names(democ.t), Freq = as.vector(democ.t))
brown <- read.delim(file="12_BrownCorpus_frequency.txt",
	sep="\t",header=T,row.names=1,quote=NULL)
repub.freq['rel.freq'] = round(repub.freq$Freq/sum(repub.freq$Freq),3)
democ.freq['rel.freq'] = round(democ.freq$Freq/sum(democ.freq$Freq),3)
head(repub.freq,30)
head(democ.freq,30)
head(brown,30)
# 워드클라우드
library(wordcloud)
wordcloud(rownames(repub.freq), repub.freq$Freq, scale=c(3, 0.8), min.freq=2,
max.words=200, random.order=F, rot.per=0.4,colors = brewer.pal(8, "Dark2"))
wordcloud(rownames(democ.freq), democ.freq$Freq, scale=c(3, 0.8), min.freq=2,
max.words=200, random.order=F, rot.per=0.4,colors = brewer.pal(8, "Dark2"))

#n-gram 추출 :bi, tri (we, in) de : -- new thier /re : which
list <- c('(^we$|^We$)','(^in$)','(^--$)','(^new$)','(^their$)','(^which$)')
for(i in list){
de.idx <- grep(i,democ)
de.pre.tri <- paste(democ[de.idx-2],democ[de.idx-1],democ[de.idx])
de.pos.tri <- paste(democ[de.idx],democ[de.idx+1],democ[de.idx+2])
de.pre.bi <- paste(democ[de.idx-1],democ[de.idx])
de.pos.bi <- paste(democ[de.idx],democ[de.idx+1])
de.pre.f1 <- data.frame(sort(table(de.pre.bi),decreasing = T))
de.pos.f1 <- data.frame(sort(table(de.pos.bi),decreasing = T))
de.pre.f2 <- data.frame(sort(table(de.pre.tri),decreasing = T))
de.pos.f2 <- data.frame(sort(table(de.pos.tri),decreasing = T))
re.idx <- grep(i,repub)
re.pre.bi <- paste(repub[re.idx-1],repub[re.idx])
re.pos.bi <- paste(repub[re.idx],repub[re.idx+1])
re.pre.tri <- paste(repub[re.idx-2],repub[re.idx-1],repub[re.idx])
re.pos.tri <- paste(repub[re.idx],repub[re.idx+1],repub[re.idx+2])
re.pre.f1 <- data.frame(sort(table(re.pre.bi),decreasing = T))
re.pos.f1 <- data.frame(sort(table(re.pos.bi),decreasing = T))
re.pre.f2 <- data.frame(sort(table(re.pre.tri),decreasing = T))
re.pos.f2 <- data.frame(sort(table(re.pos.tri),decreasing = T))
print(head(de.pre.f1,10))
print(head(de.pos.f1,10))
print(head(de.pre.f2,10))
print(head(de.pos.f2,10))
print(head(re.pre.f1,10))
print(head(re.pos.f1,10))
print(head(re.pre.f2,10))
print(head(re.pos.f2,10))
}

# 키워드 분석
data <- data.frame(words=vector())
data <- merge(data,data.frame(repub.t),by.x = "words",by.y="repub",all=T)
data <- merge(data,data.frame(democ.t),by.x = "words",by.y="democ",all=T)
colnames(data)[c(2,3)] <- c("repub","democ")
data[is.na(data)] <- 0
data <- data.frame(row.names=data$words, data[2:length(data)])
# comparison cloud
library(wordcloud)
comparison.cloud(data[c(1,2)],random.order=FALSE,scale=c(2,0.9),rot.per=0.4,
max.words=200,colors=brewer.pal(8,"Dark2"),title.size=1.1)
# 민주당 공화당의 카이스퀘어
chi <- chisq.test(data[c(1,2)])$residuals
chi <- as.data.frame(chi)
head(chi[order(chi$repub, decreasing = T),], 30)
head(chi[order(chi$democ, decreasing = T),], 30)
# 민주당, 브라운 / 공화당, 브라운 카이스퀘어
re.br.df <- merge(brown,data.frame(repub.t),by.x="Word",by.y="repub",all=T)
colnames(re.br.df)[c(3)]<-c("repub")
re.br.df[is.na(re.br.df)] <- 0
re.br.df <- data.frame(row.names = re.br.df$Word, re.br.df[c(2,3)])
re.chi <- chisq.test(re.br.df)$residuals
re.chi <- as.data.frame(re.chi)
head(re.chi[order(re.chi$repub, decreasing = T),], 30)
de.br.df <- merge(brown,data.frame(democ.t),by.x="Word",by.y="democ",all=T)
colnames(de.br.df)[c(3)]<-c("democ")
de.br.df[is.na(de.br.df)] <- 0
de.br.df <- data.frame(row.names = de.br.df$Word, de.br.df[c(2,3)])
de.chi <- chisq.test(de.br.df)$residuals
de.chi <- as.data.frame(de.chi)
head(de.chi[order(de.chi$democ, decreasing = T),], 30)

# 연어
#1
node <- c('(^will$)','(^can$)')
d.index <- grep(node,democ)
r.index <- grep(node,repub)
d.span <- vector()
r.span <- vector()
for(i in d.index)
{
d.span <- c(d.span,c((i-4):(i-1),(i+1):(i+4)))
}
d.span <- d.span[d.span>0&d.span<=length(democ)]
d.crc <- democ[d.span]
for(i in r.index)
{
r.span <- c(r.span,c((i-4):(i-1),(i+1):(i+4)))
}
r.span <- r.span[r.span>0&r.span<=length(repub)]
r.crc <- repub[r.span]
#2
dfreq.span<-sort(table(d.crc),decreasing=T)
dfreq.all <- table(democ)
dfreq.co <- data.frame(w1=vector(), w2=vector(),w1w2=vector(),n=vector())
n<-1
for(i in (1:length(dfreq.span)))
{
dfreq.co[n,] <- c(length(d.index),
dfreq.all[names(dfreq.all)==names(dfreq.span)[i]],
dfreq.span[i], length(democ))
rownames(dfreq.co)[n] <- names(dfreq.span)[i]
n <- n+1
}
rfreq.span<-sort(table(r.crc),decreasing=T)
rfreq.all <- table(repub)
rfreq.co <- data.frame(w1=vector(), w2=vector(),w1w2=vector(),n=vector())
n<-1
for(i in (1:length(rfreq.span)))
{
rfreq.co[n,] <- c(length(r.index),
rfreq.all[names(rfreq.all)==names(rfreq.span)[i]],
rfreq.span[i], length(repub))
rownames(rfreq.co)[n] <- names(rfreq.span)[i]
n <- n+1
}
#3
d.coll <- data.frame(dfreq.co, t.score=(dfreq.co$w1w2 - 
((dfreq.co$w1*dfreq.co$w2)/dfreq.co$n))/sqrt(dfreq.co$w1w2),
MI = log2((dfreq.co$w1w2*dfreq.co$n)/(dfreq.co$w1*dfreq.co$w2)))
dt.sort <- d.coll[order(d.coll$t.score,decreasing=T),]
dm.sort <- d.coll[order(d.coll$MI,decreasing=T),]
head(dm.sort[dm.sort$w1w2>2,],20)
head(dt.sort[dt.sort$w1w2>2,],20)
r.coll <- data.frame(rfreq.co, t.score=(rfreq.co$w1w2 - 
((rfreq.co$w1*rfreq.co$w2)/rfreq.co$n))/sqrt(rfreq.co$w1w2),
MI = log2((rfreq.co$w1w2*rfreq.co$n)/(rfreq.co$w1*rfreq.co$w2)))
rt.sort <- r.coll[order(r.coll$t.score,decreasing=T),]
rm.sort <- r.coll[order(r.coll$MI,decreasing=T),]
head(rm.sort[rm.sort$w1w2>2,],20)
head(rt.sort[rt.sort$w1w2>2,],20)

# 탐색적 분석
# 불용어를 제거한 뒤 계층적 군집분석
tdm <- data.frame(words=vector())
re <- c("1909","1921","1925","1929","1953","1957","1969","1973","1981","1985","1989","2001","2005")
de <- c("1913","1917","1933","1937","1941","1945","1949","1961","1965","1977","1993","1997","2009")
for(i in list.files(path='.',pattern='[.]txt$')){
	text <- substring(i,1,4)
	file <- scan(file=i,what="char",quote = NULL)
	if(text %in% re | text %in% de){
		tdm <- merge(tdm, data.frame(table(file)),by.x="words",
		by.y="file",all=T)
	colnames(tdm)[length(tdm)]<-substring(i,1,4)
	}
}
tdm <-data.frame(row.names=tdm$words,tdm[2:length(tdm)])
tdm[is.na(tdm)] <- 0
tdm['rowsum'] <- rowSums(tdm)
stop <- scan(file="13_EnglishStopwords.txt",what="char",quote=NULL)
NEW <- tdm[!(rownames(tdm) %in% stop),]
NEW <- head(NEW[order(NEW$rowsum,decreasing =T),],30)
plot(hclust(dist(scale(t(NEW[1:20,-length(NEW)])),method='minkowski'),
method='ward.D2'))
# 민주당과 공화당 사이에 자주 쓰인 카이스퀘어를 통한 계층적 군집분석
r.ch = head(chi[order(chi$repub, decreasing = T),], 10)
d.ch = head(chi[order(chi$democ, decreasing = T),], 10) 
rownames(r.ch)
rownames(d.ch)
chis<- union(rownames(d.ch),rownames(r.ch))
NEW2 <- tdm[(rownames(tdm) %in% chis),]
NEW2 <- head(NEW2[order(NEW2$rowsum,decreasing =T),],30)
plot(hclust(dist(scale(t(NEW2[1:20,-length(NEW2)])),method='minkowski'),
method='ward.D2'))