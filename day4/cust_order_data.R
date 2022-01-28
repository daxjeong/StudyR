## 1. read.csv로 한글이 있는 자료 open
# 1-1. 데이터 읽기전 메모리 모두 제거
rm(list=ls())
ls()
dir()
df=read.csv("cust_order_data.csv",sep='\t',encoding='ANSI',stringsAsFactors=TRUE)

# stringsAsFactors=TRUE : 팩터 타입으로 변환



# 1-2. 총데이터의 갯수와 변수 성격 확인
str(df) # 총데이터의 갯수
summary(df) # 각 변수의 성격 확인
head(df,3) # 위로 3개의 자료만 읽기
names(df) # 변수명(필드명)만 출력


table(df[,1])
tmp=data.frame(table(df[,1]))
head(tmp)
summary(tmp$Freq) # 평균 1.29번 방문
boxplot(tmp$Freq)

unique(df$ORDER_DATE)# 2011년~2012년 자료
# 1년동안 평균 1.29회 구매

boxplot(df[,16]) # 물건구매수량




# 1-3. 아래의 2개 변수(필드)외에 나머지 변수에 대하여 해석
# CUST_SERIAL_NO: 고객번호 / SEX: 고객성별
# AGE : 나이
# REG_DATE :  
# ORDER_DATE : 주문날짜
# ORDER_HOUR : 주문시간
# ORDER_WEEKDAY : 주문요일
# IS_WEEKEND : 주말
# GOODS_CODE : 제품 코드
# LGROUP : 대분류
# MGROUP : 중분류
# SGROUP : 소분류
# DGROUP :
# GOODS_NAME : 제품 이름
# PRICE : 가격
# QTY : 구매개수

table(df$IS_WEEKEND)
table(df$QTY)
table(df$LGROUP)
table(df$MGROUP)
table(df$DGROUP)





## 2. 자료 오류 확인
# 2-1. 결측치 확인
sum(is.na(df)) # df 전체의 결측치 갯수
colSums(is.na(df)) # 각 변수별 결측치 갯수


# 2-2. 결측치 활용법
summary(df$GOODS_NAME)
subset(df, GOODS_NAME=='#NAME?')
sum(is.na(df$GOODS_NAME))


# df$GOODS_NAME의 값이 #NAME?  인 자료에 NA값 할당
df$GOODS_NAME[df$GOODS_NAME=='#NAME?']<-NA 
sum(is.na(df$GOODS_NAME))


# 결측치 시각화
library(naniar)
naniar::gg_miss_var(df)
library(Amelia)
missmap(df)
savePlot("GOODS_NAME결측치", type="png")

df=df[complete.cases(df),]
nrow(subset(df,df$GOODS_NAME=='#NAME?'))
missmap(df)

------------------------------------------
tmp<-df$GOODS_NAME
str(tmp)

tmp[tmp=='#NAME?']<-NA
tmp<-tmp[complete.cases(tmp)]
str(tmp)# levels에 남아있음



# factor의 요인값 제거하여도 levels 값은 변경되지 않음.
# 문자열로 변경후 다시 factor함.(factor은 필요하면 함)
tmp1=as.factor(as.character(tmp))
str(tmp1)




## 3. 문자 자료 날짜자료로 변환후 파생변후(년,월,요일등 제작)
# ORDER_DATE 변수(필드)를 chr 또는 factor에서 Date로 형변환
# Date로 형 변환되면 년, 월, 일, 요일등을 쉽게 제작할수 있음


# 3-1. 형변환
tmp=as.Date(df$ORDER_DATE)
class(tmp)


# 3-2. Date 형식 자료 년,월,일,요일 제작
# year, month 파생변수 제작 (요일은 ORDER_WEEKDAY 에 있음)
install.packages("lubridate")
library(lubridate)

df$year=year(df$ORDER_DATE)
df$month=month(df$ORDER_DATE)


# 3-3. 성별의 F는 'female' / M은 'male'로 변환하여 새로운 gender 변수생성
unique(df[,2])

