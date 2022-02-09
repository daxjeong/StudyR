# 그래프 만들기
# 산점도 - 변수 간 관계 표현하기
# ggplot2 레이어 구조 이해하기
# 1단계 : 배경 설정(축)
# 2단계 : 그래프 추가(점, 막대, 선)
# 3단계 : 설정 추가(축 범위, 색, 표식)

# 산점도(Scatter plot) : 데이터를 x축과 y축에 점으로 표현한 그래프
# 나이와 소득처럼, 연속 값으로 된 두 변수의 관계를 표현할 때 사용

#ggplot2 로드
library(ggplot2)

# 1. 배경 설정하기
# x축 displ, y축 hwy로 지정해 배경 생성
ggplot(data=mpg, aes(x=displ, y=hwy))

# 2. 배경에 산점도 추가
ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_point()

# 3. 축 범위를 조정하는 설정 추가하기
ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_point() + xlim(3,6)
ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_point() + xlim(3,6) + ylim(10,30)

# ggplot2 코드 가독성 높이기
# 한 줄로 작성
ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_point() + xlim(3,6) + ylim(10,30)
# + 뒤에서 줄 바꾸기
ggplot(data=mpg, aes(x=displ, y=hwy)) + 
  geom_point() + 
  xlim(3,6) + 
  ylim(10,30)

# ggplot() vs qplot()
# qplot() : 전처리 단계 데이터 확인용. 문법 간단, 기능 단순
# ggplot() : 최종 보고용. 색, 크기, 폰트 등 세부 조작 가능

#---------------------------------------------------------------------------
# mpg데이터와 midwest 데이터를 이용
mpg=as.data.frame(ggplot2::mpg)

# Q1. mpg 데이터의 cty(도시 연비)와 hwy(고속도로 연비)로 된 산점도
ggplot(data=mpg, aes(x=cty, y=hwy)) + geom_point()
# 도시 연비보다 고속도로 연비가 더 좋음

# Q2. midwest 데이터의 poptotal(전체인구)와 popasian(아시아인 인구) 간에 관계 파악
midwest=as.data.frame(ggplot2::midwest)
ggplot(data=midwest, aes(x=poptotal, y=popasian))+
  geom_point()+
  xlim(0,500000)+
  ylim(0,10000)
# 전체 인구 대비 아시아 인구는 작은 편임


# 10만 단위가 넘는 숫자는 지수 표기법(Exponetial Notation)에 따라 표현됨
# 1e+05 : 10만(1x10의 5승)
# 정수로 표현하기 : options(scipen=99)실행 후 그래프 생성
# 지수로 표현하기 : options(scipen=0) 실행 후 그래프 생성
# R스튜디오 재실행 시 옵션 원상 복구됨


#---------------------------------------------------------------------------
# 막대 그래프 - 집단 간 차이 표현하기
# 데이터의 크기를 막대의 길이로 표현한 그래프
# 성별 소득 차이처럼 집단 간 차이를 표현할 때 주로 사용

# 막대 그래프 1 - 평균 막대그래프 만들기
# 각 집단의 평균값을 막대 길이로 표현한 그래프
# 1. 집단별 평균표 만들기
df_mpg=mpg %>% 
  group_by(drv) %>% 
  summarise(mean_hwy=mean(hwy))

df_mpg

# 2. 그래프 생성하기
ggplot(data=df_mpg,aes(x=drv, y=mean_hwy))+geom_col()

# 3. 크기 순으로 정렬하기
ggplot(data=df_mpg,aes(x=reorder(drv, -mean_hwy), y=mean_hwy))+geom_col()

# 막대그래프 2 - 빈도 막대 그래프
# 값의 개수(빈도)로 막대의 길이를 표현한 그래프
ggplot(data=mpg, aes(x=drv)) + geom_bar() # x축 범주 변수, y축 빈도
ggplot(data=mpg, aes(x=hwy)) + geom_bar() # x축 연속 변수, y축 빈도도



#---------------------------------------------------------------------------
# mpg 데이터 분석
# Q1. "suv" 차종을 대상으로 평균 cty(도시연비)가 가장 높은 회사 다섯 곳을 막대 그래프로 표현
# 막대는 연비가 높은 순으로 정렬
# 평균 표 생성
df_mpg=mpg %>% 
  filter(class=="suv") %>% 
  group_by(manufacturer) %>% 
  summarise(mean_cty=mean(cty)) %>% 
  arrange(desc(mean_cty)) %>% 
  head(5)

df_mpg

# 그래프 생성
ggplot(data=df_mpg,aes(x=reorder(manufacturer, -mean_cty), 
                       y=mean_cty))+geom_col()


# Q2. class(자동차 종류)의 빈도수를 표현한 막대그래프
ggplot(data=mpg, aes(x=class)) + geom_bar()



#---------------------------------------------------------------------------
# 선그래프 - 시간에 따라 달라지는 데이터 표현하기
# 선그래프(Line Chart) : 데이터를 선으로 표현한 그래프
# 시계열 그래프(Time Series Chart) : 일정 시간 간격을 두고 나열된 시계열 데이터를 
# 선으로 표현한 그래프, 환율, 주가지수 등 경제 지표가 시간에 따라 어떻게 변하는지 표현할 때 활용

# 시계열 그래프 만들기
head(economics)
economics=as.data.frame(ggplot2::economics)
ggplot(data=economics, aes(x=date, y=unemploy))+geom_line()


# Q1. psavert(개인 저축률)가 시간에 따라서 어떻게 변해왔는지 알아보려함
# 시간에 따른 개인 저축률의 변화를 나타낸 시계열 그래프를 만들기
ggplot(data=economics, aes(x=date, y=psavert))+geom_line()


#---------------------------------------------------------------------------
# 상자그림 - 집단 간 분포 차이 표현하기
# 상자 그림(Box plot) : 데이터의 분표(퍼져 있는 형태)를 직사각형 상자모양으로 표현

# 상자 그림 만들기
ggplot(data=mpg, aes(x=drv, y=hwy))+geom_boxplot() # 구동방식 별 고속도로 연비의 관계

# Q1. class(자동차 종류)가 "compact", "subcompact", "suv"인 자동차 cty(도시연비)의 상자 그림
class_mpg=mpg%>% 
  filter(class %in% c("compact", "subcompact", "suv"))
ggplot(data=class_mpg, aes(x=class, y=cty))+geom_boxplot()




# geom_col( ) : 평균값을 막대 길이로 표현할 때 사용
# geom_bar( ) : 값의 개수 즉, 빈도를 막대 길이로 표현할 때 사용