df <- df[df$SEX != "*",]
head(df,10)

## 성별 구매 건수
sex1 <- subset(df, select=c(ORDER_DATE,SEX,QTY))
sex1

install.packages('lubridate') # 구매일자에서 월 정보만 추출하기 위한 lubridate 라이브러리
library(lubridate)

# ORDER_DATE 열에 저장되어 있는 날짜를 이용하여 month 함수로 월만 추출해서 month 라는 새로운 열을 추가한다. 
sex2 <- cbind(sex1, month=month(sex1$ORDER_DATE)) #cbind():열 합치기, rbind()
head(sex2,5)

install.packages('reshape2')
library(reshape2)
dcast(sex2, SEX ~ month,value.var="QTY",sum) # 성별로 구분하여 월별 구매 건수의 총합을 구함

# F나 M 대신 female, male이라고 표시하기 위해서 변환 함수를 만들어서 적용하여 gender라는 열을 추가한다
changeGender <- function(x) { if (x[2] == "M") { return("male") } else { return("female") } }
sex2$gender <- apply(sex2,2,changeGender)
head(sex2)

# 성별 별로 월별 구매 건수를 누적 막대 그래프로 표시한다.
library(ggplot2)
qplot(month,data=sex2,geom="bar",fill=gender)

# 성별 별로 월별 구매 건수를 별도의 막대 그래프로 표시한다
ggplot(sex2,aes(month))+geom_bar()+facet_wrap(~gender)


## 연령대 구매 건수
install.packages('reshape2')
library(reshape2)

# 성별 별로 월별 구매 건수를 별도의 막대 그래프로 표시한다
Age1 <- subset(df, select=c(ORDER_DATE,AGE,QTY))
head(Age1)

Age2 <- cbind(Age1, month=month(Age1$ORDER_DATE)) #ORDER_DATE 열에 저장되어 있는 날짜를 이용하여 month 함수로 월만 추출해서 month 라는 새로운 열을 추가
dcast(Age2, AGE~month, value.var='QTY',sum) #연령별로 구분하여 월별 구매 건수의 총합
Age2 <- cbind(Age2, ages=paste(Age2$AGE,"대")) # 그래프에 표시할 때, 10대, 20대, 30대와 같이 표시될 수 있도록 나이에 “대＂를 붙여서 ages라는 열을 추가한다.


# 연령 별로 월별 구매 건수를 누적 막대 그래프로 표시한다.
qplot(month,data=Age2,geom="bar",fill=ages)

# 연령 별로 월별 구매 건수를 별도의 막대 그래프로 표시한다.
ggplot(Age2,aes(month))+geom_bar()+facet_wrap(~ages)


## 성별/연령대 구매 건수
# 구매일자, 성별, 나이, 구매 건수만 추출하여 별도의 데이터 프레임을 만든다.
sexage1 <- subset(df,select=c(ORDER_DATE,SEX,AGE,QTY))
head(sexage1)

library(plyr)
sexage2 <- ddply(sexage1, .(ORDER_DATE,SEX,AGE), summarize, Sum_F=sum(QTY)) # ddply() 함수를 사용하여 날짜, 성별, 나이로
그룹을 지어 구매 수량을 합쳐서 확인
head(sexage2)

# month() 함수로 월만 추출하여 month 열을 추가하고, ages 열에는 나이에 “대＂를 붙여서 추가한다.
sexage3 <- cbind(sexage2, month=month(sexage2$ORDER_DATE))
sexage3 <- cbind(sexage3, ages=paste(sexage3$AGE,"대"))
head(sexage3)

# 성별과 연령을 기준으로 월별 구매 건수를 별도의 막대 그래프로 표시한다
ggplot(sexage3,aes(month))+geom_bar()+facet_wrap(~SEX+ages)


## 연령대/성별 구매 건수
sexage2 <- ddply(sexage1, .(ORDER_DATE,AGE,SEX), summarise, Sum_F=sum(QTY)) # ddply() 함수를 사용하여 날짜, 나이, 성별로
그룹을 지어 구매 수량을 합쳐서 확인

# month() 함수로 월만 추출하여 month 열을 추가하고, ages 열에는 나이에 “대＂를 붙여서 추가한다.
sexage3 <- cbind(sexage2, month=month(sexage2$ORDER_DATE))
sexage3 <- cbind(sexage3, ages=paste(sexage3$AGE,"대"))

# 연령과 성별을 기준으로 월별 구매 건수를 별도의 막대 그래프로 표시한다
ggplot(sexage3,aes(month))+geom_bar()+facet_wrap(~ages+SEX)


## 월별 고객단위 구매 금액
# 연령과 성별을 기준으로 월별 구매 건수를 별도의 막대 그래프로 표시한다
cust1 <- subset(df, select=c(ORDER_DATE,CUST_SERIAL_NO,PRICE))
head(cust1)

# month() 함수로 월만 추출하여 month 열을 추가한다.
cust2 <- cbind(cust1, month=month(cust1$ORDER_DATE))
nrow(cust2)

# ddply() 함수를 사용하여 고객 번호와 월로 그룹을 지어 구매 금액을 합쳐서 확인한다.
cust3 <- ddply(cust2, .(CUST_SERIAL_NO,month),summarize,Sum_F=sum(PRICE))
nrow(cust3)
head(cust3)

# aggregate() 함수를 이용하여 고객 번호와 월을 기준으로 구매 금액을 합침
df2 <- cbind(df, month=month(df$ORDER_DATE))
aggdata <- aggregate(PRICE~CUST_SERIAL_NO+month,data=df2,sum) 

# 그래프의 범례로 사용하기 위해 월에 “월＂을 붙여서 real_month라는 열을 추가한다.
aggdata <- cbind(aggdata, real_month=paste(aggdata$month,"월"))
head(aggdata)

# 월별 총 구매 금액의 최대값과 최소값, 평균값 등을 비교하기 위해 상자 차트로 표시한다.
p <- ggplot(aggdata, aes(real_month,PRICE))
p+geom_boxplot(aes(fill=real_month))


## 500,000만원 미만으로 Filter
# 구매 금액의 총합이 50만원 미만인 고객을 추출하여 고객 수를 확인한다.
cust4 <- subset(cust3,Sum_F<500000)
nrow(cust4)

# 월별 총 구매 금액이 50만원 미만인 구매에 대해서 최대값과 최소값, 평균값 등을 비교하기 위해 상자 차트로 표시한다.
p <- ggplot(subset(aggdata,PRICE<500000),aes(real_month,PRICE))
p+geom_boxplot(aes(fill=real_month))


## 요일별 구매 금액 합계
# 구매 요일, 구매 건수만 추출하여 별도의 데이터 프레임을 만든다.
day1 <- subset(df,select=c(ORDER_WEEKDAY,PRICE))
head(day1)

# ddply() 함수를 사용하여 요일별로 구매 금액을 합쳐서 확인한다.
day2 <- ddply(day1,.(ORDER_WEEKDAY),summarize,Sum_F=sum(as.numeric(PRICE)))
day2

# ddply() 함수를 사용하여 요일별로 구매 금액을 합친 결과를 aggdata.summary에 저장한다.
aggdata.summary <-
ddply(day1,.(ORDER_WEEKDAY),summarize,Sum_F=sum(as.numeric(PRICE)))


# 그래프에 출력될 때 자동으로 정렬해서 출력되도록 요일 앞에 1부터 7까지의 숫자를 붙이는 함수를 만들어서 적용
changeRday <- function(x) { if (length(grep(x[1],"월"))>0){return("1_월")} 
else if (length(grep(x[1],"화"))>0){return("2_화")}
else if (length(grep(x[1],"수"))>0){return("3_수")}
else if (length(grep(x[1],"목"))>0){return("4_목")}
else if (length(grep(x[1],"금"))>0){return("5_금")}
else if (length(grep(x[1],"토"))>0){return("6_토")}
else if (length(grep(x[1],"일"))>0){return("7_일")}}
aggdata.summary$rday <- apply(aggdata.summary,1,changeRday)
aggdata.summary

# 요일별 구매 금액의 총합을 막대 그래프로 표시한다.
ggplot(aggdata.summary,aes(rday,Sum_F))+geom_bar(stat="identity")


## 요일별 구매 상품 수

# ddply() 함수를 사용하여 요일별로 구매 수량을 합친 결과를 dayamt2에 저장하고, 요일 이름 변경 함수를 적용하여 rday 열을 추가
dayamt1 <- subset(df,select=c(ORDER_WEEKDAY,QTY))
dayamt2 <- ddply(dayamt1,.(ORDER_WEEKDAY),summarize,Sum_F=sum(QTY))
dayamt2$rday <- apply(dayamt2,1,changeRday)
dayamt2


# 요일별 총 구매 수량이 2개를 초과하는 구매에 대해서 최대값과 최소값, 평균값 등을 비교하기 위해 상자 차트로 표시
p <- ggplot(subset(df,QTY>2),aes(ORDER_WEEKDAY,QTY));
p + geom_boxplot(aes(fill=ORDER_WEEKDAY));






## 연관성 분석을 통한 상품 추천
# 장바구니분석, 한 개의 장바구니에는 항목이 unique함
# => 고전적인 데이터마이닝 기법

# 지지도 : 품목A와 품목B를 포함하는 거래 수 / 전체 거래 수
# 신뢰도 : 항목A의 거래 중에서 항목 B가 포함된 거래의 비율(A가 B에 종속 여부)
# 향상도 : 연관규칙이 오른쪽 항목을 예측하기 위한 능력이 얼마나 향상되었는가를 표현 => 신뢰도 / P(B)
# 향상도(B를 기준으로 봄) 숫자가 높을 수록(1 이상) 판매 전략이 좋다.

# 지도학습 : Y값 o
# 비지도학습 : Y값 x
