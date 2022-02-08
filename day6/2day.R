library('readxl')
library(ggplot2)
library(dplyr)

exam=read.csv("./Data/csv_exam.csv")
exam


# 오름차순으로 정렬하기
exam %>% arrange(math)

# 내림차순으로 정렬하기
exam %>% arrange(desc(math))

# 정렬 기준 변수 여러개 지정
exam %>% arrange(class, math)


#---------------------------------------------------------------------------

# mpg 데이터를 이용해 분석
mpg=as.data.frame(ggplot2::mpg)
mpg

# "audi"에서 생산한 자동차 중에 어떤 자동차 모델의 hwy(고속도로 연비)가 높은지 알아보기
mpg %>%filter(manufacturer=='audi')%>% 
  arrange(desc(hwy)) %>% 
  head(5)

#---------------------------------------------------------------------------
exam %>% 
  mutate(total=math+english+science,        # 종합 변수 추가
         mean=(math+english+science)/3) %>% # 총평균 변수 추가
  head                                      # 일부 추출

# mutate()에 iselse()적용하기
exam %>% 
  mutate(test=ifelse(science>=60, "pass","fail")) %>% 
  head

exam

#---------------------------------------------------------------------------
# mpg 데이터를 이용해서 분석
# Q1. mpg데이터 복사본을 만들고, cty와 hwy를 더한 '합산 연비 변수'를 추가
mpg2=mpg
mpg2=mpg2 %>% mutate(mpg_sum=cty+hwy)
# Q2. 앞에서 만든 '합산 연비 변수'를 2로 나눠 '평균 연비 변수'를 추가
mpg2=mpg2 %>% mutate(mpg_avg=mpg_sum/2)

# Q3. '평균 연비 변수'가 가장 높은 자동차 3종의 데이터 출력
mpg2 %>% arrange(desc(mpg_avg)) %>% 
  head(3)

# Q4. 1~3번 문제를 해결할 수 있는 하나로 연결된 dplyr구문 출력
mpg %>% mutate(mpg_sum=cty+hwy,
               mpg_avg=mpg_sum/2) %>% 
  arrange(desc(mpg_avg)) %>% 
  head(3)
          


#---------------------------------------------------------------------------
# 집단별로 요약하기
exam %>% summarise(mean_math=mean(math))

exam %>% 
  group_by(class) %>%              # class 별로 분리
  summarise(mean_maht=mean(math))  # math 평균 산출

exam %>% 
  group_by(class) %>%                # class 별로 분리
  summarise(mean_math=mean(math),    # math 평균
            sum_math=sum(math),      # math 합계
            median_math=median(math),# math 중앙값
            n=n())                   # 학생 수


# 각 집단별로 다시 집단 나누기
mpg %>% 
  group_by(manufacturer, drv) %>%    # 회사별, 구간 방식별 분리
  summarise(mean_cty=mean(cty)) %>%  # cty 평균 산출
  head(10)                           # 일부 출력


#---------------------------------------------------------------------------
# dplyr 조합하기
# 회사별로 "suv" 자동차의 도시 및 고속도로 통합 연비 평균을 구해 내림차순으로 정렬하고,
# 1~5위까지 출력하기
mpg
mpg %>% 
  group_by(manufacturer) %>%            # 회사별로 추출
  filter(class=="suv") %>%              # suv 추출
  mutate(tot=(cty+hwy)/2) %>%           # 통합 연비 변수 생성
  summarise(mpg_tot=mean(tot)) %>%      # 통합 연비 평균 산출
  arrange(desc(mpg_tot)) %>%            # 내림차순 정렬
  head(5)                               # 1~5위


#---------------------------------------------------------------------------
# mpg 데이터를 이용한 분석 문제
# Q1. 어떤 차종의 연비가 높은지 비교. class별 cty 평균 구하기
mpg %>% 
  group_by(class) %>%            # class별 분리
  summarise(mean_cty=mean(cty))  # cty 평균 구하기


# Q2. 어떤 차종의 도시 연비가 높은지 쉽게 알아볼 수 있도록 cty 평균이 높은 순으로 정렬
mpg %>% group_by(class) %>% 
  summarise(mean_cty=mean(cty)) %>% 
  arrange(desc(mean_cty))


# Q3. 어떤 회사 자동차의 hwy(고속도로 연비)가 가장 높은지 알아보려고 한다. 
  # hwy 평균이 가장 높은 회사 세곳을 출력
mpg %>% group_by(manufacturer) %>%   # manufacturer별 분리
  summarise(mean_hwy=mean(hwy)) %>%  # hwy 평균 구하기
  arrange(desc(mean_hwy)) %>%        # 내림차순 정렬하기
  head(3)                            # 상위 3행 출력력


# Q4. 각 회사별 "compact"차종 수를 내림 차순으로 정렬해 출력
mpg %>% 
  filter(class=="compact") %>%  # compact 추출
  group_by(manufacturer) %>%    # mauefacturer별 분리
  summarise(count=n()) %>%      # 빈도 구하기 = n()
  arrange(desc(count))          # 내림차순 정렬
# 조건이 있으면 조건 만들고 그룹핑하기


#---------------------------------------------------------------------------
# 데이터 합치기
# 가로로 합치기
# 데이터 생성
# 중간고사 데이터 생성
test1=data.frame(id=c(1,2,3,4,5),
                 midterm=c(60,80,70,90,85))
# 기말고사 데이터 생성
test2=data.frame(id = c(1,2,3,4,5),
                 final = c(70,83,65,95,80))

# id 기준으로 합치기
total=left_join(test1, test2, by='id') # id 기준으로 합쳐 total에 할당
total
# 주의) by에 변수명을 지정할 때 변수명 앞 뒤에 겹따옴표 입력



# 다른 데이터 활용해 변수 추가하기
# 반별 담임교사 명단 생성
name=data.frame(class=c(1,2,3,4,5),
                teacher=c("kim","lee","park","choi","jung"))

exam_new=left_join(exam, name, by="class")
exam_new

# 세로로 합치기
# 데이터 생성
# 학생 1~5번 시험 데이터 생성
group_a=data.frame(id=c(1,2,3,4,5),
                   test=c(60,80,70,90,85))
# 학생 6~10번 시험 데이터 생성
group_b=data.frame(id=c(6,7,8,9,10),
                   test=c(70,83,65,95,80))

group_all=bind_rows(group_a,group_b)
group_all



#---------------------------------------------------------------------------
# mpg 데이터를 이용해 분석
fuel=data.frame(fl=c("c","d","e","p","r"),
                price_fl=c(2.35,2.38,2.11,2.76,2.22),
                stringsAsFactors = F)
fuel

# Q1. 위에 만든 fuel 데이터를 이용해 mpg데이터에 price_f1(연로가격)변수를 추가
mpg=left_join(mpg, fuel, by="fl")

# Q2. model, f1, price_f1 변수를 추출해 앞부분 5행을 출력
mpg %>% 
  select(model, fl, price_fl) %>% 
  head(5)


#---------------------------------------------------------------------------
### 정리하기
# 1. 조건에 맞는 데이터만 추출하기
# 2. 필요한 변수만 추출하기
# 3. 함수 조합하기, 일부만 출력하기
# 4. 순서대로 정렬하기
# 5. 파생변수 추가하기
## mutate()에 ifelse() 적용하기
## 추가한 변수를 dplyr패키지에 활용
# 6. 집단별로 요약하기
# 7. 데이터 합치기
## 가로로합치기 / 세로로 합치기
#---------------------------------------------------------------------------

# 데이터 정제 : 빠진 데이터, 이상한 데이터 제거하기

# 결측치
# - 누락된 값, 비어있는 값
# - 함수 적용 불가, 분석 결과 왜곡
# - 제거 후 분석 실시

# 결측치 찾기
# 결측치 만들기
# 결측치 표기 - 대문자 NA
df=data.frame(sex=c("M","F",NA,"M","F"),
              score=c(5,4,3,4,NA))
df

is.na(df)        # 결측치 확인
table(is.na(df)) # 결측치 빈도 확인인

# 변수별로 결측치 확인하기
table(is.na(df$sex))
table(is.na(df$score))

# 결측치 포함된 상태로 분석=>결측치 하나라도 있으면 계산안됨
mean(df$score)
sum(df$score)


# 결측치 있는 행 제거하기
df %>% filter(is.na(score)) # score가 NA인 데이터만 출력
df %>% filter(!is.na(score)) # score 결측치 제거

df %>% filter(!is.na(sex))

# 결측치 제외한 데이터로 분석하기
df_nomiss=df %>% filter(!is.na(score))
mean(df_nomiss$score)
sum(df_nomiss$score)

# 여러 변수 동시에 결측치 없는 데이터 추출하기
df_nomiss=df %>% filter(!is.na(score)&!is.na(sex)) # score, sex 결측치 제외
df_nomiss

# 결측치가 하나라도 있으면 제외하기
df_nomiss2=na.omit(df) # 모든 변수에 결측치 없는 데이터 추출
df_nomiss2
# 분석에 필요한 데이터까지 손실 될 가능성 유의
# ex) 성별, 소득 관계 분석하는데 지역 결측치까지 제거

# 함수의 결측치 제외 기능 이용하기-na.rm=T
mean(df$score, na.rm=T) # 결측치 제외하고 평균 산출
sum(df$score, na.rm=T)  # 결측치 제외하고 합계 산출

# summarise()에서 na.rm=T 사용하기
# 결측치 생성
exam[c(3,8,15),"math"]=NA # 3,8,15행의 math에 NA할당

# 평균구하기
exam %>% summarise(mean_math=mean(math))         # 평균 산출
exam %>% summarise(mena_math=mean(math,na.rm=T)) # 결측치 제외하고 평균 산출


# 결측치 대체하기
# - 결측치 많을 경우 모두 제외하면 데이터 손실 큼
# - 대안: 다른 값 채워넣기
# 결측치 대체법(lmputation)
# - 대표값(평균, 최빈값 등)으로 일괄 대체
# - 통계분석 기법 적용, 예측값 추정해서 대체

# 평균으로 대체하기
exam$math=ifelse(is.na(exam$math),55,exam$math) # math가 NA면 55로 대체
table(is.na(exam$math))                         # 결측치 빈도표 생성



#---------------------------------------------------------------------------
# mpg 데이터를 이용한 분석
mpg=as.data.frame(ggplot2::mpg)
mpg[c(65,124,131,153,212),"hwy"]=NA # NA 할당하기
mpg

#Q1. drv(구동방식)별로 hwy(고속도로연비)평균이 어떻게 다른지 알아보려 함
# drv변수와 hwy변수에 결측치가 몇개 있는지 알아보기
table(is.na(mpg$drv)) # 0개
table(is.na(mpg$hwy)) # 5개

# Q2. fillter()를 이용해 hwy 변수의 결측치를 제외하고,
# 어떤 구동방식의 hwy 평균이 높은지 알아보기
mpg %>% 
  filter(!is.na(hwy)) %>% # 결측치 제외
  group_by(drv) %>%       # drv별 분리
  summarise(mean_hwy=mean(hwy))      # hwy 평균 구하기



#---------------------------------------------------------------------------
# 이상치 정제하기
# 이상치(Outlier)-정상범주에서 크게 벗어난 값
# - 이상치 포함시 분석 결과 왜곡
# - 결측 처리 후 제외하고 분석

# 이상치 제거하기- 1. 존재할 수 없는 값
# 논리적으로 존재할 수 없으므로 바로 결측 처리 후 분석시 제외
# 이상치 포함된 데이터 생성-sex 3, score 6
outlier=data.frame(sex=c(1,2,1,3,2,1),
                   score=c(5,4,3,4,2,6))
outlier

# 이상치 확인하기
table(outlier$sex)
table(outlier$score)

# 결측 처리하기 - sex
outlier$sex=ifelse(outlier$sex == 3, NA, outlier$sex)
outlier
# 결측 처리하기 - score
outlier$score=ifelse(outlier$score > 5, NA, outlier$score)
outlier

# 결측치 제외하고 분석
outlier %>% 
  filter(!is.na(sex)&!is.na(score)) %>% 
  group_by(sex) %>% 
  summarise(mean_score=mean(score))


# 이상치 제거하기 - 2. 극단적인 값
# 정상범위 기준 정해서 벗어나면 결측 처리

# 상자그림으로 극단치 기준 정해서 제거하기
mpg=as.data.frame(ggplot2::mpg)
boxplot(mpg$hwy)
# 2사분위 = 중앙값, 하위 50%

# 상자그림 통계치 출력
boxplot(mpg$hwy)$stats
#[1,]:최하위 극단치값
#[5,]:최상위 극단치값

# 결측 처리하기
# 12~37 벗어나면 NA 할당
mpg$hwy=ifelse(mpg$hwy<12 | mpg$hwy>37, NA, mpg$hwy)
table(is.na(mpg$hwy))

# 결측치 제외하고 분석하기
mpg %>% 
  group_by(drv) %>% 
  summarise(mean_hwy=mean(hwy, na.rm=T))


#---------------------------------------------------------------------------
# mpg 데이터 분석
mpg=as.data.frame(ggplot2::mpg)           # mpg 데이터 불러오기
mpg[c(10,14,58,93),"drv"]="k"             # drv 이상치 할당
mpg[c(29,43,129,203),"cty"]=c(3,4,39,42)  # cty 이상치 할당

mpg

# Q1. drv에 이상치가 있는지 확인
# 이상치를 결측 처리한 다음 이상치가 사라졌는지 확인
# 결측 처리할 때는 %in% 기호 활용
table(mpg$drv)
mpg$drv=ifelse(mpg$drv %in% c("k"),NA,mpg$drv)
table(mpg$drv)

# Q2. 상자그림을 이용해서 ctv에 이상치가 있는지 확인
# 상자 그림의 통계치를 이용해 정상 범위를 벗어난 값을 결측 처리
boxplot(mpg$cty)$stats
mpg$cty=ifelse(mpg$cty<9 | mpg$cty>26,NA,mpg$cty)
boxplot(mpg$cty)

# q3. 이상치를 제외한 다음 drv 별로 cty 평균이 어떻게 다른지 확인
# 하나의 dplyr 구문으로 만들기
mpg %>% 
  filter(!is.na(drv)&!is.na(cty)) %>% # 결측치 제외
  group_by(drv) %>%                   # drv별 분리
  summarise(mean_cty=mean(cty))       # cty 평균 구하기


#---------------------------------------------------------------------------
# 그래프 만들기
# 산점도 - 변수 간 관계 표현하기
# ggplot2 레이어 구조 이해하기
# 1단계 : 배경 설정(축)
# 2단계 : 그래프 추가(점, 막대, 선)
# 3단계 : 설정 추가(축 범위, 색, 표식)


