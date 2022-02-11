# 인터랙티브 그래프
# plotly 패키지로 인터랙티브 그래프 만들기
# 인터랙티브 그래프 만들기
# 패키지 준비하기
install.packages("plotly")
library(plotly)

#ggplot으로 그래프 만들기
library(ggplot2)
p = ggplot(data=mpg, aes(x=displ, y=hwy, col=drv))+geom_point()
ggplotly(p)

# 인터랙티브 막대 그래프 만들기
p = ggplot(data=diamonds, aes(x=cut, fill=clarity))+
  geom_bar(position = "dodge")
ggplotly(p)


# dygraphs 패키지로 인터랙티브 시계열 그래프 만들기
# 인터랙티브 시계열 그래프 만들기
# 패키지 준비하기
install.packages("dygraphs")
library(dygraphs)


# 데이터 준비하기
economics = ggplot2::economics
head(economics)

# 시간 순서 속성을 지니는 xts 데이터 타입으로 변경
library(xts)

eco=xts(economics$unemploy, order.by=economics$date)
head(eco)

# 그래프 생성
dygraph(eco)
dygraph(eco) %>% dyRangeSelector()


# 여러 값 표현하기
# 저축률
eco_a = xts(economics$psavert, order.by=economics$date)

# 실업자 수
eco_b = xts(economics$unemploy/1000, order.by=economics$date)

# 합치기
eco2 = cbind(eco_a, eco_b)                 # 데이터 결합
colnames(eco2) = c("psavert", "unemploy")  # 변수명 바꾸기기
head(eco2)

# 그래프 마늘기
dygraph(eco2) %>% dyRangeSelector()


#---------------------------------------------------------------------------
# odjbc.jar를 이용하여 데이터 접속을 위한 라이브러리

## - 사전 설치 사항
## - jdk 설치 및 환경변수 등록하기

install.packages("RJDBC")
library(RJDBC)

# 오라클 드라이버 연결 결로 설정
driver=JDBC("oracle.jdbc.OracleDriver",
            classPath="C:/Recture/ojdbc8.jar")
driver

# 오라클 접속하기
conn = dbConnect(driver,
                 "jdbc:oracle:thin:@//localhost:1521/orcl",
                 "busan","dbdb")
conn
# localhost = 127.0.0.0.1


########## 데이터 [입력/수정/삭제] 하기
########## - dbSendQuery() 함수는 동일하게 사용
########## - SQL 구문만 입력/수정/삭제에 따라 변경
########## - dbSendQuery()에서 입력 시에는 [한건만 입력] 가능

sql_in = paste("Insert into test",
               "(AA,BB,CC)",
               "values('a1','b1','c1')")
sql_in

in_stat = dbSendQuery(conn, sql_in)
in_stat

dbClearResult(in_stat)


########## 데이터 조건 [조회]하기
sql_sel = "Select * From test Where AA = 'a1'"
sql_sel

getData = dbGetQuery(conn, sql_sel)
getData

getData$AA

str(getData)


########## **중요** 필수) 무조건 오라클 접속 해제하기
dbDisconnect(conn)



#--------------------------------------------------------------------------------
# 빅데이터 자료 수집
# 파일 데이터셋 자료 수집
# 웹 스크래핑
# 오픈 API 기반 자료수집

# 1. 파일 데이터셋 자료 수집
# 다양한 기관이 공익적인 목적에서 제공하는 파일 데이터셋을 통하여 자료를 수집
# 일반적으로 파일 데이터셋은 정형데이터와 비정형 데이터로 구분
# 정형데이터는 CSV나 엑셀 파일 형식으로 제공
# 비정형 데이터는 텍스트파일로 제공

# CSV 텍스트 파일 불러오기
library(readxl)
data=read.csv("./Data/전라남도_목포시_장애인_복지시설_20210802.csv", head=T, fileEncoding="EUC-kR")
data
# 엑셀 파일의 경우 엑셀에서 CSV로 변경하여 사용




#--------------------------------------------------------------------------------
# 웹 스크래핑
# 웹문서로부터 유용한 정보를 추출하는 기술
# 텍스트와 이미지가 혼합되어 있는 HTML 형식으로 구성된 웹사이트에서 웹스크래핑을 통하여 정보를 추출

# 웹스크래핑을 위한 필요 패키지
install.packages("rvest")   # 웹 스크래핑 패키지
install.packages("stringr") # 문자열 처리 패키지

library(rvest)
library(stringr)

# 웹 스크래핑 순서
# 1) 웹 스크래핑 대상 URL 할당
url="http://www.bobaedream.co.kr/cyber/CyberCar.php?gubun=K&page=1"
url

# 2) 웹 문서 가져오기
usedCar=read_html(url)
usedCar

# 3) 특정 태그의 데이터 추출
# 가져온 usedCar에서 css가 ".product-item"인 것을 찾음
carInfos=html_nodes(usedCar, css=".product-item")
carInfos

# 차량 명칭 추출
title_tmp=html_nodes(carInfos, css=".tit.ellipsis")
title_tmp

title = html_text(title_tmp)
title



title=str_trim(title) # 문자열에서 공백 제거
title

# 차량 연식 추출
year_tmp = html_nodes(carInfos, css=".mode-cell.year")
year_tmp

year = html_text(year_tmp)
year

year=str_trim(year)
year

# 연료구분
fuel_tmp = html_nodes(carInfos, css=".mode-cell.fuel")
fuel_tmp

fuel = html_text(fuel_tmp)
fuel

fuel=str_trim(fuel)
fuel

# 주행거리 추출
km_tmp=html_nodes(carInfos, css=".mode-cell.km")
km_tmp

km=html_text(km_tmp)
km

km=str_trim(km)
km


# 판매가격 추출
price_tmp=html_nodes(carInfos, css=".mode-cell.price")
price_tmp

price=html_text(price_tmp)
price

price=str_trim(price)
price

price=str_replace(price, '\n', '') # 문자열 변경(\n을 스페이스로 변경)
price

# 차량 명칭으로부터 제조사 추출
maker = c()
maker

title

for(i in 1:length(title)){
  maker=c(maker, unlist(str_split(title[i],' '))[1]) # str_split : 문자열 분리
}
maker

# unlist : 리스트를 벡터로 변환

# 데이터 프레임 만들기
usedcars = data.frame(title, year, fuel, km, price, maker)
View(usedcars)

# 4) 데이터 정제
# km 자료 숫자로 변경
usedcars$km

# gsub(찾을 것, 바꿀 것, 열 지정) : 찾아바꾸기
usedcars$km = gsub("만km", "0000", usedcars$km) # 문자열 변환
usedcars$km = gsub("천km", "000", usedcars$km)
usedcars$km = gsub("km", "", usedcars$km)
usedcars$km = gsub("미등록", "", usedcars$km)
usedcars$km = as.numeric(usedcars$km)           # 숫자형으로 변경

usedcars$km

# price 자료 숫자로 변경
usedcars$price

usedcars$price = gsub("만원", "", usedcars$price)
usedcars$price = gsub("계약", "", usedcars$price)
usedcars$price = gsub("팔림", "", usedcars$price)
usedcars$price = gsub("금융리스", "", usedcars$price)
usedcars$price = gsub(",", "", usedcars$price)
usedcars$price = as.numeric(usedcars$price)

usedcars$price

View(usedcars)

# 웹 스크래핑 자료 파일로 저장하기
# 디렉터리 설정
setwd("./Data")
write.csv(usedcars, "usedcars_new.csv") # csv 파일로 저장하기기



#--------------------------------------------------------------------------------
# 오픈 API 기반 자료수집
# 오픈 API로 가져온 자료를 XML형식으로 변경하는데 사용되는 함수들을 지원하는 "XML"패키지
install.packages("XML")
library(XML)

# 오픈 API 근간의 자료수집 순서
# 1) 오픈 API 제공 웹사이트에 접속 및 로그인
# 2) 오픈 API 자료 검색
# 3) 활용신청 및 개발계정 API키 신청
# 4) 승인 받은 개발계정 API키 확인
# 5) 오픈 API 접속을 위한 웹 URL 및 요청변수 확인
# 6) R에서 오픈 API를 이용한 자료요청
# 7) 데이터 프레임 만들기

# 웹사이트 URL 설정
api_url <- "http://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getCtprvnRltmMesureDnsty"

# 승인 받은 KEY 등록
service_key <- "zRNPK%2FZMLJrqNDRirsCYPsPaCAYB3PKQTYk64h7rK2SfhhOWOVrox9V3G2C6H8vs5FPMVXCRPuOSAJmzTerjPQ%3D%3D"

# 요청변수 등록
numOfRows="30"
sidoName="경기"

sidoName=URLencode(iconv(sidoName, to="UTF-8")) # 한글을 웹 URL 코드화화
sidoName

searchCondition="DAILY"

# 오픈 API URL
# paste와 paste0의 차이
paste("a","b","c") # 공백을 구분자로 묶기
# paste("a","b","c", sep=" ") # 원래는 이상태
# psste("a","b","c", sep="/") # 공백 대신 특수문자로 구분 가능
paste0("a","b","c") # 구분자 없이 모두 묶기

# URL 주소를 공백없이 모두 묶기
open_api_url = paste0(api_url, "?servicekey=", service_key,
                      "&numOfRows=", numOfRows,
                      "&sidoName=",sidoName,
                      "&searchCondition", searchCondition)
open_api_url

# 오픈 API 통하여 XML형식으로 자료 가져오기
raw.data = xmlTreeParse(open_api_url,
                        useInternalNodes = TRUE,
                        encoding = "utf-8")
raw.data


# XML 형식의 자료를 데이터프레임으로 변경하기
# </item> 태그 별로 데이터 구분하기
air_pollution = xmlToDataFrame(getNodeSet(raw.data," //item"))
air_pollution

View(air_pollution)

# subset() : 데이터프레임 내에서 검색 조건(select)에 맞는 항목(컬럼)들만 가지고오기
air_pollution = subset(air_pollution,
                       select=c(dataTime,
                                stationName,
                                so2Value,
                                coValue,
                                o3Value,
                                no2Value,
                                pm10Value))
air_pollution


# 오픈 API 자료 파일로 저장하기
# 디렉토리 설장
write.csv(air_pollution, "air_pollution_new.csv") # CSV 파일로 저장




#--------------------------------------------------------------------------------
## 건강보험심사평가원_코로나19병원정보(국민안심병원 외)서비스
# 웹사이트 URL 설정
api_url <- "http://apis.data.go.kr/B551182/pubReliefHospService/getpubReliefHospList"
api_url

# 승인 받은 KEY 등록
service_key <- "zRNPK%2FZMLJrqNDRirsCYPsPaCAYB3PKQTYk64h7rK2SfhhOWOVrox9V3G2C6H8vs5FPMVXCRPuOSAJmzTerjPQ%3D%3D"


# 요청변수 등록
numOfRows="50"
sidoNm="부산"

sidoNm=URLencode(iconv(sidoNm, to="UTF-8")) # 한글을 웹 URL 코드화화
sidoNm


# URL 주소를 공백없이 모두 묶기
open_api_url_1 = paste0(api_url, "?servicekey=", service_key,
                      "&numOfRows=", numOfRows,
                      "&sidoNm=",sidoNm,
                      "&searchCondition", searchCondition
                      )
open_api_url_1

# 오픈 API 통하여 XML형식으로 자료 가져오기
raw.data_1 = xmlTreeParse(open_api_url_1,
                        useInternalNodes = TRUE,
                        encoding = "utf-8")
raw.data_1


# XML 형식의 자료를 데이터프레임으로 변경하기
# </item> 태그 별로 데이터 구분하기
corona_hosp = xmlToDataFrame(getNodeSet(raw.data_1," //item"))
corona_hosp

View(corona_hosp)

# subset() : 데이터프레임 내에서 검색 조건(select)에 맞는 항목(컬럼)들만 가지고오기
corona_hosp = subset(corona_hosp,
                       select=c(sidoNm,
                                sgguNm,
                                yadmNm,
                                telno,
                                adtFrDd
                                ))
corona_hosp
View(corona_hosp)


# 오픈 API 자료 파일로 저장하기
# 디렉토리 설장
write.csv(corona_hosp, "corona_hosp_new.csv") # CSV 파일로 저장



#----------------------------------------------------------------------
# 국립중앙의료원_전국 약국 정보 조회 서비스
# 웹사이트 URL 설정
api_url <- "http://apis.data.go.kr/B552657/ErmctInsttInfoInqireService/getParmacyListInfoInqire"
api_url

# 승인 받은 KEY 등록
service_key <- "zRNPK%2FZMLJrqNDRirsCYPsPaCAYB3PKQTYk64h7rK2SfhhOWOVrox9V3G2C6H8vs5FPMVXCRPuOSAJmzTerjPQ%3D%3D"


# 요청변수 등록
numOfRows="50"
Q0="부산광역시"

Q0=URLencode(iconv(Q0, to="UTF-8")) # 한글을 웹 URL 코드화화
Q0


# URL 주소를 공백없이 모두 묶기
open_api_url_2 = paste0(api_url, "?servicekey=", service_key,
                        "&numOfRows=", numOfRows,
                        "&Q0=",Q0,
                        "&searchCondition", searchCondition
)
open_api_url_2

# 오픈 API 통하여 XML형식으로 자료 가져오기
raw.data_2 = xmlTreeParse(open_api_url_2,
                          useInternalNodes = TRUE,
                          encoding = "utf-8")
raw.data_2


# XML 형식의 자료를 데이터프레임으로 변경하기
# </item> 태그 별로 데이터 구분하기
pharmacy = xmlToDataFrame(getNodeSet(raw.data_2," //item"))
pharmacy

View(pharmacy)

# subset() : 데이터프레임 내에서 검색 조건(select)에 맞는 항목(컬럼)들만 가지고오기
pharmacy = subset(pharmacy,
                     select=c(
                              dutyName,
                              dutyAddr,
                              dutyMapimg,
                              dutyTel1
                              
                     ))
pharmacy
View(pharmacy)


# 오픈 API 자료 파일로 저장하기
# 디렉토리 설장
write.csv(pharmacy, "pharmacy_new.csv") # CSV 파일로 저장

