install.packages('readxl')
library('readxl')
getwd()
setwd("C:/Recture/Busan_202202_R")

# 데이터 확인
exam=read.csv("./Data/csv_exam.csv")
exam

head(exam)    # 앞에서부터 6행까지 출력
head(exam,10) # 앞에서부터 10행까지 출력

tail(exam)    # 뒤에서부터 6행까지 출력
tail(exam,10) # 뒤에서부터 10행까지 출력

View(exam) # View에서 맨 앞의 V는 대문자, 데이터 뷰어 창에서 exam 데이터 확인
dim(exam) # 행, 열 출력
str(exam) # 데이터 속성 확인
summary(exam) # 요약 통계량 확인, 정수값만


#---------------------------------------------------------
# ggplot2의 mpg 데이터를 데이터 프레임 형태로 불러오기
# 자동차 연비 데이터(내장 데이터)
mpg=as.data.frame(ggplot2::mpg)
mpg

head(mpg,10)
dim(mpg)
str(mpg)
summary(mpg)

install.packages('dplyr')
library('dplyr')

df_raw=data.frame(var1=c(1,2,1),
                  var2=c(2,3,2))
df_raw

df_new=df_raw # 복사본 만들기
df_new

df_new=rename(df_new, v2=var2) #var2 컬럼을 v2로 바꾸기


# 데이터 컨트롤
# 데이터 프레임에 새로운 변수(파생변수) 만들기=>데이터 준비하기
df=data.frame(var1=c(4,3,8),
              var2=c(2,6,1))
df

# 데이터 프레임에 새로운 변수(파생변수) 추가하기
df$var_sum=df$var1+df$var2 # var_sum 파생변수 생성
df$var_sum=10 # 전체가 10으로 들어감
df

df$var_mean=(df$var1+df$var2)/2 #var_mean 파생변수 생성
df


#---------------------------------------------------------
mpg
mpg$total=(mpg$cty+mpg$hwy)/2 # 통합 연비 변수 생성
head(mpg)
mean(mpg$total) # 통합 연비 변수 평균


#---------------------------------------------------------
# 데이터프레임에 새로운 변수(파생변수) 사용하기
summary(mpg$total) #요약 통계 산출
hist(mpg$total) # 통합 연비 데이터를 이용한 히스토그램 생성

# 데이터 컨트롤=>조건문 사용하여 통합연비 합격 여부 조건 처리=> test 변수 추가하기
# 20 이상이면 pass, 그렇지 않으면 fail 부여
mpg$test=ifelse(mpg$total>=20,"pass","fail")
mpg

# 통합 연비 빈도표 조회
table(mpg$test)

library(ggplot2)
qplot(mpg$test) # 연비 합격 빈도 막대 그래프 생성

# 중첩 조건문을 활용하여 통합연비 등급 변수 추가하기
# total을 기준으로 A,B,C 등급 부여(등급->범주)
mpg$grade=ifelse(mpg$total>=30,"A", ifelse(mpg$total>=20, "B","C"))
mpg

# 유의) ifelse()가 두번 반복되므로 열리는 괄호와 닫히는 괄호가 각각 두개, 쉼표도 각각 두개

# 등급(grade 데이터 빈도표 및 빈도 막대 그래프 그리기)
# 등급 빈도표 조회
table(mpg$grade)

# 등급 빈도 막대 그래프 그리기
qplot(mpg$grade)


#---------------------------------------------------------
# 문제1. ggplot2의 midwest데이터를 데이터 프레임 형태로 불러와서 데이터 특성 파악
# midwest : 미국 동북중부 437개 지역의 인구통계 정보
midwest=as.data.frame(ggplot2::midwest)
head(midwest)
tail(midwest)
View(midwest)
dim(midwest)
str(midwest)
summary(midwest)

# 문제2. poptotal(전체인구)을 total로, popasian(아시아인구)을 asian으로 변수명을 수정
library(dplyr)
midwest=rename(midwest, total=poptotal)
midwest=rename(midwest, asian=popasian)

# 문제3. total, asian 변수를 이용해 '전체 인구 대비 아시아 인구 백분율' 파생변수를 만들고,
# 히스토그램을 만들어 도시들이 어떻게 분포하는지 살펴보기
midwest$ratio=(midwest$asian/midwest$total)*100
hist(midwest$ratio)

# 문제4. 아시아 인구 백분율 전체 평균을 구하고,
# 평균을 초과하면 "large", 그 외에는 "small"을 부여하는 파생변수 만들기
mean(midwest$ratio)
midwest$grade=ifelse(midwest$ratio>0.4872462,"large","small")

# 문제5. "large"와 "small"에 해당하는 지역이 얼마나 되는지, 빈도표와 빈도 막대그래프를 만들어 확인하기
table(midwest$grade) # 빈도표
qplot(midwest$grade) # 막대그래프



#---------------------------------------------------------
# 데이터 전처리(Preprocessing)-dplyr 패키지
# 데이터 전처리
# filter() : 행 추출
# select() : 열(변수) 추출
# arrange() : 정렬
# mutate() :  변수 추가
# summarise() : 통계치 산출
# group_by() : 집단별로 나누기
# left_join() : 데이터 합치기(열)
# bind_row() : 데이터 합치기(행)

# 조건에 맞는 데이터만 추출하기
# exam에서 class가 1인 경우만 추출하여 출력
exam
exam %>% filter(class==1) # %>%(~중에서) 단축키 : ctrl+shift+M

# 1반이 아닌 경우
exam %>% filter(class!=1)

# 수학 점수가 50점을 초과한 경우
exam %>% filter(math>50)

# 여러 조건을 충족하는 행 추출하기
# 1반이면서 수학 점수가 50점 이상인 경우(and)
exam %>% filter(class==1 & math>=50)

# 영어점수가 90점 이상이거나 수학 점수가 50점 이상인 경우(or)
exam %>% filter(english>=90 | math>=50)

# 목록에 해당되는 행 추출하기 
exam %>% filter(class==1 | class==3 | class==5) # 1,3,5 반에 해당되면 추출

# %in% 기호 이용하기
exam %>% filter(class %in% c(1,3,5)) # 1,3,5 반에 해당되면 추출

# 추출한 행으로 데이터 만들기
class1=exam %>% filter(class==1) # class가 1인 행 추출, class1에 할당
class2=exam %>% filter(class==2) # class가 2인 행 추출, class2에 할당

mean(class1$math) # 1반 수학 점수 평균 구하기
mean(class2$math) # 2반 수학 점수 평균 구하기


# %/% 나눗셈의 몫
# %% 나눗셈의 나머지


#---------------------------------------------------------
# mpg 데이터를 이용해 분석 문제를 해결

# Q1. 자동차 배기량에 따라 고속도로 연비가 다른지 확인해볼려 한다.
# displ(배기량)이 4 이하인 자동차와 5 이상인 자동차 중 어떤 자동차의 hwy(고속도로 연비)가 평균적으로 더 높은지 알아보세요.
mpg_a=mpg %>% filter(displ<=4)
mpg_b=mpg %>% filter(displ>=5)

mean(mpg_a$hwy)
mean(mpg_b$hwy)


# Q2. 자동차 제조회사에 따라 도시 연비가 다른지 알아보려고 합니다.
# "audi"와 "toyota"중 어느 manufacturer(자동차 제조회사)의 cty(도시연비)가 평균적으로 더 높은지 알아보세요.
mpg_audi=mpg %>% filter(manufacturer == "audi")
mpg_audi=mpg %>% filter(manufacturer == "toyota")

mean(mpg_audi$cty)
mean(mpg_audi$cty)


# Q3 "chevrolet","ford","honda" 자동차의 고속도로 연비 평균을 알아보려 합니다.
# 이 회사들의 자동차를 추출한 뒤 hwy 전체 평균을 구해보세요
mpg_new=mpg %>% filter(manufacturer %in% c("chevrolet","ford","honda"))
mean(mpg_new$hwy)


#---------------------------------------------------------
# 필요한 변수만 추출하기
exam %>% select(math) # math만 추출

exam %>% select(class,math,english)

# 변수 제외하기
exam %>% select(-math) # math 제외
exam %>% select(-math, -english) # math, english 제외


# dplyr 함수 조합하기
# class가 1인 행만 추출한 다음 english 추출
exam %>% filter(class==1) %>% select(english)

# 가독성있게 줄 바꾸기
exam %>% 
  filter(class==1) %>% # class가 1인 행 추출
  select(english)      # english 추출

exam %>% 
  select(id, math) %>% # id, math 추출
  head                 # 앞부분 6행까지 추출


#---------------------------------------------------------
# mpg 데이터를 이용해서 분석 문제 해결
# Q1.mpg 데이터에서 class(자동차 종류),cty(도시 연비)변수를 추출해 새로운 데이터를 만드세요
# 새로 만든 데이터의 일부를 추출해서 두 변수로만 구성되어 있는지 확인
df=mpg %>% select(class, cty)
head(df)

# Q2. 앞에서 추출한 데이터를 이용해서 class(자동차 종류)가 "suv"인 자동차와
# "compact"인 자동차 중 어떤 자동차의 cty(도시연비)가 더 높은지 알아보기
df_suv=df %>% filter(class=="suv")
df_compact=df %>% filter(class=="compact")
mean(df_suv$cty) # 13.5
mean(df_compact$cty) # 20.12766


# 오름차순으로 연결하기

