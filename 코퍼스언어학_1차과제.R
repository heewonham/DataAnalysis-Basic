# 1
TEXT1 <- scan(file=paste0("./Q1/","Q1_01.txt"),what="char",quote=NULL)
TEXT2 <- scan(file=paste0("./Q1/","Q1_02.txt"),what="char",quote=NULL)
TEXT1 <- gsub('^[[:punct:]]+|[[:punct:]]+$','',tolower(TEXT1))
TEXT2 <- gsub('^[[:punct:]]+|[[:punct:]]+$','',tolower(TEXT2))
data1<-table(TEXT1[TEXT1%in%TEXT2])
data2<-table(TEXT2[TEXT2%in%TEXT1])
freq <- data.frame(row.names=names(data2),Q1_01.txt = as.vector(data1),Q1_02.txt=as.vector(data2))
write.table(freq, file = "out1.txt", quote = F, sep = "\t", col.names=NA)

#2
dir.create("./Q2_out")
for(i in list.files(path = './Q2',pattern='[.]txt$'))
{
	TEXT <- vector()
	temp <- scan(file=paste("./Q2/", i , sep=""),what = "char", quote = NULL)
	TEXT <- temp[grep("^<body>.*",temp):length(temp)]
	TEXT <- TEXT[grepl('^.*">[^<].*',TEXT)]
	TEXT <- gsub('^.*?">|</.*>$','',TEXT)
	cat(TEXT, file = paste0("./Q2_out/",toupper(gsub('[.]txt',"",i)),".txt"),sep="\n")
}

#3
dir.create("./Q3_out")
TEXT <- scan(file=paste0("./Q3/","Q3.txt"),what="char",quote=NULL,sep='\n')
name <- vector()
for(i in TEXT)
{
	if(grepl('^.*:',i)){
		name <- unlist(strsplit(i,':'))[1]
		cat(i, file = paste0("./Q3_out/",name,".txt"),sep="\n",append=TRUE)
	}
	else{
		cat(i, file = paste0("./Q3_out/",name,".txt"),sep="\n",append=TRUE)
	}
}