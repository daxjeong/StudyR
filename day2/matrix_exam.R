setwd("C:/Sources/StudyR/day2")
dir()

fileName="전국무인교통단속카메라표준데이터.csv"
df=read.csv(fileName)
head(df)
str(df)
table(df$시도명)
barplot(table(df$시도명))


## 탐색적 데이터 분석(EDA)

# 01, 03, 10, 9
tmp=head(subset(df, 시도명=='01')) # 서울 서초구
tmp=head(subset(df, 시도명=='03')) # 대구광역시 중구
tmp=head(subset(df, 시도명=='10')) # 강원도 양구군
tmp=head(subset(df, 시도명=='9')) # 경기도 가평군
str(tmp)

## 시군구명이 과연 '서초구'만 있는지 확인 필요
summary(factor(tmp$시군구명))
table(tmp$시군구명)
unique(tmp$시군구명) # 중복제거
unique(tmp$소재지도로명주소)
unique(tmp$소재지지번주소)

#factor : 정해진 범주 내에서 카테고리별로 분석(범주형 자료 분석)을 하기 위해 주로 사용되는 데이터 자료형
#범주 = 레벨 = 카테고리



#############################################################
### 데이터 형 변환
### 1. character를 factor로 변환
### 시도명, 시군구명, 도로종류, 설치연도, 도로노선명
### 
### 2. 숫자(int)를 factor로 변환하는 파생변수
### 설치연도, 제한속도
#############################################################

# 1. character를 factor로 변환
df$시도명=factor(df$시도명)
df[,3]=factor(df[,3]) # df$시군구명=factor(df$시군구명)
df[,4]=factor(df[,4]) # 도로종류
df[,6]=factor(df[,6]) # 도로노선명
str(df)
summary(df)
levels(df[,2])

# 2. 숫자(int)를 factor로 변환하는 파생변수
df$설치연도Factor=factor(df$설치연도)
str(df) # 24개 variables
df[,25]=factor(df$제한속도)
str(df)
summary(df)

plot(df[,24]) # 무인단속카메라의 설치 개수가 늘어나고 있다.
# 2020년에 왜 급증했는지?

table(df[,25])
table(df[,24])



#############################################################
### 복습용 176쪽 매트릭스 구조가 필요한 이유
#############################################################

str(df)

ma=df$제한속도
dim(ma)
ncol(ma)
nrow(ma)
length(ma)
mean(ma)

ma=df[,c(10,11)] # 위도, 경도
head(ma)
colSums(ma)
rowSums(ma)



#############################################################
### 2. 컬럼명 정리
### names(df) 작업해서 인덱싱번호에다가 컬럼명 변경
### names(df)=c(' ',' ')...
#############################################################

names(df)[1]='카메라Num'
names(df)[25]='제한속도factor'
names(df)
names(df)[1]=names(df)[1]+'dj' # R은 문자열 연결을 +로 못함
names(df)[1]=paste(names(df)[1],'-dj',sep="")

paste('e','k','1213124',sep="") # paste() : 문자열 합치기
help(paste)



#############################################################
### 3. 필요한 컬럼만 모아서 별도의 데이터셋 제작
### 첫번째: 불필요한 컬럼을 제거함으로써 수행속도를 높힘
### 두번째: 분석하고자 하는 내용에 맞게끔 새로운 데이터프레임 구성
#############################################################

names(df) # 컬럼 번호를 빠르게 알 수 있음

df1=df[,c(2,3,4,7,12,13,14,16)]
str(df1)
df2=df[,c(10,11,13,14)] # 위경도로 지도그리고 싶을 때
str(df2)



#############################################################
### 4. 조건에 맞는 자료만 필터링
### subset으로
#############################################################

str(df1)

# 단속구분을 unique하게 받아보기
unique(df1$단속구분)

# subset을 이용하여서 단속구분이 1인 자료만 필터링
head(subset(df1, 단속구분=="1")) # 단속구분 chr형

# subset을 이용하여서 제한속도가 50인 자료만 필터링
head(subset(df1, 제한속도==50))

# subset을 이용하여서 단속구분이 1 제외하고 필터링
subset(df1, 제한속도!=1)

# 두개의 조건 모두 만족하면 AND연산(&)
# 두개 중 한개만 만족하면 OR(|)
# subset을 이용하여서 단속구분이 1이면서(&) 시군구명이 '경기도'인 자료
subset(df1, 단속구분=="1" & 시도명=="경기도")
table(df1$시군구명)

시도.경기명=subset(df1, 시도명=="경기도")



#############################################################
### 5. 자료셋을 새로 제작해서 csv로 저장하기
#############################################################

# write.csv : csv 파일로 저장하기

부산=subset(df1, 시도명=='부산광역시')
unique(부산$시군구명) # 22개의 시군구가 있음

sido=unique(df1$시도명)
sido
index=1
tmp=subset(df1, 시도명==sido[index]) # for돌릴 때

select='경기도'
tmp=subset(df1, 시도명==select) # 사용자한테 input받을 때
head(tmp)
head(rownames(tmp))

index=1
fileName=paste(sido[index],'.csv',sep='')
write.csv(tmp, fileName)

index=2
fileName=paste(sido[index],'.csv',sep='')
write.csv(tmp, fileName)

index=3
fileName=paste(sido[index],'.csv',sep='')
write.csv(tmp, fileName)

length(sido) # 21개



## for문 : for(i in data){ i를 사용한 문장 }
## 시도명
for(index in 1:21){
tmp=subset(df1, 시도명==sido[index])

fileName=paste('C:/Sources/StudyR/day2/저장/',sido[index],'.csv',sep='')
write.csv(tmp, fileName)
}

## 시군구명
sido=unique(df1$시군구명)
cnt=length(sido)

for(index in 1:cnt){
	tmp=subset(df1, 시군구명==sido[index])
	fileName=paste('C:/Sources/StudyR/day2/저장/',sido[index],'.csv',sep='')
	write.csv(tmp, fileName)
}

#-------------------------------------------

tmp=names(df1)
for(index in 1:length(tmp)){
findcol=tmp[index]
폴더명=paste('./저장/', findCol, sep='')
dir.create("폴더명") # 폴더생성

#-------------------------------------------


df$findcol # error - "시도명"으로 들어가서 
head(unique(df[,1]))

dataList=unique(df1[,index])
for(index2 in 1:length(dataList)){
	tmp=subset(df1, df1[,index]==index2)
	fileName=paste(폴더명, index2, '.csv', sep="")
	write.csv(tmp,fileName)
}

}



#############################################################
### R 메모리 변수 모두 제거
### rm(list=ls())
#############################################################


rm(list=ls())
ls()