library(arules)

tr=read.transactions('자료_빅카인즈_햇반.txt',format='basket',sep=',')
tr # 6개의 트랜잭션과 230개의 상품

inspect(tr)

rule1=apriori(tr,parameter=list(supp=0.05,conf=0.05))
inspect(rule1[1:10])

library('arulesViz')
plot(rule, method='graph')


## error


-----------------------------------------------------------------------

# 자료_장바구니분석테스트
tr1=read.transactions('자료_장바구니분석테스트.txt',format='basket',sep=',')
tr1 # 4개의 트랜잭션과 7개의 상품

rule=apriori(tr1,parameter=list(supp=0.1,conf=0.1))
inspect(rule)
inspect(rule[1:10])


# 가로(지지도), 세로(신뢰도), 색상(향상도)
# 아래 자료는 지지도 0.25, 신뢰도 0.5와 1일때 향상도가 높음, 진한빨강색이 표시됨
plot(rules)

# 진한 빨간색일수록 향상도가 높은 자료
# 동그라미가 클수록 지지도(많이 나온 빈도수가 높은 자료임)
# 가까운곳에 있는 자료일수록 연관도가 높은 자료임

# 매트릭스차트
# Ihs(가로축)-조건(x아이템)과 rhs(세로축)-결과(y아이템) 으로구성한매트릭스그래프
plot(rules,method="grouped") 

# 각규칙별로어떤아이템들이 연관되어묶여있는지 보여주는네트워크그래프
# 네트워크차트
plot(rules,method="graph")
