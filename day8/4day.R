# 미국
#<1. 미국 주별 강력 범죄율 단계 구분도 만들기>
install.packages("ggiraphExtra")
library(ggiraphExtra)

# 미국 주별 범죄 데이터 준비하기
str(USArrests)
head(USArrests)

library(tibble)

# 행 이름을 state 변수로 바꿔 데이터 프레임 생성
crime = rownames_to_column(USArrests, var="state")
crime

# 지도 데이터와 동일하게 맞추기 위해 stste의 값을 소문자로 수정
crime$state <- tolower(crime$state)
# 대문자 : toupper
crime

str(crime)


# 미국 주 지도 데이터 준비하기
library(ggplot2)
states_map = map_data("state")
str(states_map)
# long : 경도, lat : 위도

# 단계 구분도 만들기
ggChoropleth(data = crime,      # 지도에서 표현할 데이터
             aes(fill=Murder,   # 색깔로 표현할 변수
                 map_id=state), # 지역 기준 변수
             map=states_map)    # 지도 데이터

# 인터랙티브 단계 구분도 만들기
ggChoropleth(data = crime,      # 지도에서 표현할 데이터
             aes(fill=Murder,   # 색깔로 표현할 변수
                 map_id=state), # 지역 기준 변수
             map=states_map,    # 지도 데이터
             interactive = T)   # 인터랙티브



#----------------------------------------------------------------------------
# <2. 대한민국 시도별 인구, 결핵 환자 수 단계 구분도 만들기>
# 대한민국 시도별 인구 단계 구분도 만들기
# 패키지 만들기
install.packages("stringi")
install.packages("devtools")
devtools::install_github("cardiomoon/kormaps2014")

library(kormaps2014) # kormaps2014:우리나라 지도(지역) 데이터

# 대한민국 시도별 인구 데이터 준비하기
# kormaps2014 데이터는 UTF-8 인코딩으로 그대로 사용하면 오류남..
# - changeCode() 함수를 사용하여 인코딩 CP949로 변환해주어야 함.
str(changeCode(korpop1))

library(dplyr)
korpop1 = rename(korpop1,
                 pop=총인구_명,
                 name=행정구역별_읍면동)

str(changeCode(kormap1))

# 단계구분도 만들기
library(ggiraphExtra)
ggChoropleth(data = korpop1,         
             aes(fill = pop,    
                 map_id = code,
                 tooltip = name),  
             map = kormap1,
             interactive = T )



# 대한민국 시도별 결핵 환자 수 단계 구분도 만들기
str(changeCode(tbc))
ggChoropleth(data = tbc,          # 지도에 표현할 데이터
             aes(fill = NewPts,   # 색깔로 표현할 변수
                 map_id = code,   # 지역 기준 변수
                 tooltip = name), # 지도 위에 표시할 지역명 
             map = kormap1,       # 지도 데이터
             interactive = T )    # 인터랙티브



#----------------------------------------------------------------------------
# 사용 데이터 : korpop1, tbc
# 결과물 : 소주제 4개이상 제출
str(changeCode(korpop1))
str(changeCode(tbc))

changeCode(korpop1)
changeCode(tbc)



# 1) 서울특별시 - 연도
# 1. 변수 검토하기
class(tbc$name)
table(changeCode(tbc)$name)

# 2. 전처리
# 이상치 확인
table(changeCode(tbc)$name)

tbc_seoul=changeCode(tbc) %>% 
  filter(name=='서울특별시') %>% 
  arrange(desc(NewPts))

ggplot(data=tbc_seoul, aes(x=year, y=NewPts))+geom_col()



#----------------------------------------------------------------------------
# 2) 지역 - 외국인
# 1. 변수검토하기
class(korpop1$외국인_계_명)
table(changeCode(korpop1)$외국인_계_명)

# 2.
changeCode(korpop1) %>% 
  select(name, 외국인_계_명)


library(ggiraphExtra)
ggChoropleth(data = korpop1,         
             aes(fill = 외국인_계_명,    
                 map_id = code,
                 tooltip = name),  
             map = kormap1,
             interactive = T )


#----------------------------------------------------------------------------
# 3) 지역별 내/외국인 비율 분석하기
# 1. 변수검토하기
korpop1$외국인_계_명 = as.numeric(korpop1$외국인_계_명)
korpop1$pop = as.numeric(korpop1$pop)

str(korpop1$외국인_계_명)
str(korpop1$pop)

# 2. 지역별 비율표 만들기
region_for <- changeCode(korpop1) %>%
  select(name, 내국인_계_명, 외국인_계_명, pop) %>% 
  mutate(for_pct = round(as.numeric(외국인_계_명)/as.numeric(pop)*100, 2)) %>% 
  mutate(native_pct = round(as.numeric(내국인_계_명)/as.numeric(pop)*100, 2))
region_for

# 3. 그래프 만들기
#ggplot(data=region_for, aes(x=name, y=for_pct))+
#  geom_col()+
#  coord_flip()



#--------------------------------------------------------------------------
# 4) 지역별 여자/남자 비율
# 1. 변수검토하기
str(korpop1$여자_명)
table(korpop1$여자_명)

# 2. 지역별 비율표 만들기
str(korpop1$여자_명)
name_female = changeCode(korpop1) %>% 
  filter(!is.na(name)) %>% 
  group_by(name) %>% 
  summarise(pct_f = round(as.numeric(여자_명)/as.numeric(pop)*100,1)) %>% 
  mutate(pct_m = 100 - pct_f)

name_female


# 3. 그래프 만들기
ggplot(data=name_female, aes(x=name, y=pct_m))+
  geom_col()+
  coord_flip()+
  geom_bar(position='stack')
