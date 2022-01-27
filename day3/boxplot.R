# 이상치(극단값, Outlier) = 패턴에서 벗어난 값
# = 중심에서 좀 많이 떨어져 있는 값


str(tips)
boxplot(tip~day, data=tips)

tmp=subset(tips, day=='Sat')
par(mfrow=c(2,2))
boxplot(tip~size, data=tmp)
boxplot(tip~sex, data=tmp)
boxplot(tip~smoker, data=tmp)
boxplot(tip~time, data=tmp)

tmp=subset(tips, day=='Fri')
par(mfrow=c(2,2))
boxplot(tip~size, data=tmp)
boxplot(tip~sex, data=tmp)
boxplot(tip~smoker, data=tmp)
boxplot(tip~time, data=tmp)


boxplot(tips$tip)
tt=subset(tips,tip<=6)
tt

str(tt)
boxplot(tt$tip)
boxplot(tip~day, data=tt)



# 상자그림을 이용하여 자동차 데이터 분석하기

boxplot(mtcars$mpg) # 데이터가 평균보다 작다
par(mfrow=c(1,2))
boxplot(mtcars$mpg~mtcars$gear) # 기어의 수가 4개인 모델이 연비가 높은 경향
plot(mtcars$mpg,mtcars$gear)
cor(mtcars$mpg,mtcars$gear)# 0.4802848


par(mfrow=c(1,2))
boxplot(mtcars$mpg~mtcars$vs) # 대체로 1자형 엔진(vs=1)이 V자형 엔진(vs=0)보다 연비가 높은 경향
plot(mtcars$mpg,mtcars$vs)
cor(mtcars$mpg,mtcars$vs)# 0.6640389



par(mfrow=c(1,2))
boxplot(mtcars$mpg~mtcars$am) # 스틱(am=1)이 오토매틱(am=0)변속기보다 연비가 높은 경향
plot(mtcars$mpg,mtcars$am)
cor(mtcars$mpg,mtcars$am)# 0.5998324


boxplot(mtcars) # disp와 hp만 보이는 문제 발생



# 데이터 정규화(scale)
# 변숫값의 분포를 표준화하는 것
# 표준화는 변수에서 데이터의 평균을 빼거나 변수를 전체 데이터의 표준 편차로 나누는 작업을 포함
# 이렇게 하면 변숫값의 평균이 0이 되고 값의 퍼짐 정도(분포) 또한 일정해짐

tmp=scale(mtcars)
summary(tmp)
