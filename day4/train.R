install.packages('arules')
library(arules)

dir()

# 용어: 트랜잭션파일 : 주 파일(master file)의 변경사항을 일시적으로 저장하고 있는 파일/변동성 있는 파일
# 용어: 마스터파일 : 컴퓨터로 데이터를 처리할 때 처리의 중심이 되는 데이터 파일
tran=read.transactions('train.txt',format='basket',sep=',') # 트랜잭션 객체 생성
tran # 4개의 트랜잭션과 7개의 상품

head(tran)
str(tran)
class(tran)

tran@itemInfo
tran@data
tran@data@i

inspect(tran)# 트랜잭션 데이터보기/트랜잭션을 배열의 형태로 출력
str(inspect(tran))

rule=apriori(tran, parameter=list(supp=0.3, conf=0.1)) # 18 rule(s)
# supp:지지도,  conf:신뢰도
str(rule)     #lhs:A에서B로, rhs:B에서 A로
inspect(rule) # 규칙보기
# lift:향상도


[6] 넥타이(A), 셔츠(B) 신뢰도
  넥타이와 셔츠의 지지도/넥타이의 지지도
  0.50/0.50 = 1

[7] 셔츠(B), 넥타이(A)의 신뢰도
  셔츠와 넥타이의 지지도/셔츠의 지지도
  0.50/0.75 = 0.66666


install.packages('arulesViz')
library('arulesViz')
plot(rule, method='graph')


