install.packages('reshape2')
library(reshape2)



# 자료 파악 : 변수의 성격과 해설

# total_bill : 전체지불비용
# tip : tip비용
# sex : 성별
# smoker : 흡연석/비흡연석
# day : 요일
# time : 방문시간(lunch, dinner)
# size : 방문인원

head(tips)
str(tips)
summary(tips)

levels(tips$day) # unique(tips$day) # 데이터 셋은 4개

sum(is.na(tips)) # 결측치 확인

unique(tips[,1]) # 숫자데이터는 unique의미x
unique(tips[,3])


for (i in 1:length(tips)){
	if(class(tips[,i])=='factor'){
		print(unique(tips[,i]))
	}
}



###################################################
#####  가설과 검증
#####
###################################################
# 1번 가설 : 성별(독립변수,x값)에 따르는 tips(종속변수,y값,레이블)의 비용은 같다
# 		0가설(귀무가설)
# 		검증을 통해서 비용은 같다=>귀무가설 채택
# 		비용이 다르다=>귀무가설 기각/대립가설 채택
#		pvalue통해서 확인함.(통계에서는)
# 일반적인 가설검증은 데이터집계를 통해서 비교


table(tips[,3]) 
table(tips[,4])


for (i in 3:7){
	print(paste('----',names(tips)[i],'----'))
	print(table(tips[,i])) # 성별의 빈도수, 전체 데이터에서 발생 횟수
} 				     # for 안에는 print 필수

x=unique(tips$time)
din=subset(tips,time=='Dinner') # time=x[0]
lun=subset(tips,time=='Lunch')  # time=x[1]

table(tips$time) # 디너가 2.5배 많다 (대립가설)
table(din$day)
table(lun$day)
head(din)


table(tips$time)
colMeans(din[c('total_bill','tip','size')])
colMeans(lun[c('total_bill','tip','size')]) #din과 lun차이가 별로 없음


colSums(din[c('total_bill','tip','size')])
colSums(lun[c('total_bill','tip','size')])

par(mfrow=c(2,1))
plot(din$tip)
plot(lun$tip)

summary(lun)
tmp=subset(lun, tip>=4) # tip을 많이 주는 사람은 size가 크다

summary(tmp)# smoker 차이x
summary(lun)# smoker 차이 많이 남

summary(subset(tips, tips$day=='Fri'))
tmp=subset(tips, tips$day=='Fri')
table(tmp$size)

# 요일에 따라 tip의 발생비용이 달라진다.



#------------------------------------------------
# 성별에 따라 tip의 차이가 없다.

# tips 성별별 빈도수 확인
table(tips[,3])

s.f=subset(tips, sex=='Female')
s.m=subset(tips, sex=='Male')
summary(s.f)# 여자의 평균 tip은 2.83
summary(s.m)# 남자의 평균 tip은 3.09

par(mfrow=c(2,1))
plot(s.f$tip, main='F of Tips')
plot(s.m$tip, main='S of Tips')

plot(s.f$size, main='F of size')
plot(s.m$size, main='S of size')




plot(tips)

plot(tips[,1])
plot(tips[,1],tips[,2])
plot(tips[,7],tips[,1]) # 인원수 대비 가격

str(tips) # 숫자데이터 1,2,7
colNum=c(1,2,7)
par(mfrow=c(3,1))

for(i in colNum){
	plot(tips[,i], main=names(tips)[i])
}


mtcars
str(mtcars)
plot(mtcars)#1,3,5,6
plot(mtcars[,c(1,3,5,6)])

# 피어슨상관계수(-1~1사이값) 
# 문자데이터 들어가면 error
cor(mtcars[,c(1,3,5,6)])


install.packages("PerformanceAnalytics")
library(PerformanceAnalytics)
chart.Correlation(mtcars[,c(1,3,5,6)], histogram=TRUE, pch=19)

str(tips)
chart.Correlation(tips[,c(1,2,7)], histogram=TRUE, pch=19)

boxplot(state.x77[,'Population'])
