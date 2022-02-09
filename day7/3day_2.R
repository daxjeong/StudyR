# 텍스트마이닝
# 문자로 된 데이터에서 가치 있는 정보를 얻어 내는 분석기법
# 형태소 분석(Morphology Analysis) : 문장을 구성하는 어절들이 어떤 품사로 되어 있는지 분석
# 분석 절차
# - 형태소 분석
# - 명사, 동사, 형용사 등 의미를 지닌 품사 단어 추출
# - 빈도표 만들기
# - 시각화


## KoNLP 패키지를 사용하기 위한 사전 준비 사항
## 1. JDK 1.8 설치 > 설치 후 시스템환경에 JAVA_HOME 등록 > path에 bin 설정

## 2. RTools4.0 패스 설정 > 아래 순서대로 진행
##   - 실행 :  writeLines('PATH="${RTOOLS40_HOME}\\usr\\bin;${PATH}"', con = "~/.Renviron") 
##   - 위에 실행 안될 경우 
#        : install.packages("usethis") #설치
#           usethis::edit_r_environ() #실행(보안 설정이 되어 있는 경우 디바이스 허용하기)
#           창이 열리면 PATH="${RTOOLS40_HOME}\\usr\\bin;${PATH} 입력>저장>닫기기
#           RStudio 재시작..
#         : Sys.which("make") 실행 후 make, C:\\rtools40\\usr\\bin\\make.exe 출력되면 성공
# <아래 코드 실행>
install.packages("usethis")
usethis::edit_r_environ()
Sys.which("make")


## 3. KoNLP를 설치
##   - KoNLP의 정식 버전은 CRAN에서 내려간 상태
##   - 따라서, 아래와 같이 수동으로 설치를 진행
##   - 아래 패키지 설치 순서는 지켜줘야 합니다.
##   - 설치 순서 : rJava, remotes, install_github() > * DONE (KoNLP) 메시지 뜨면 성공
# <아래 코드 실행>
install.packages("rJava")
install.packages("remotes")
remotes::install_github('haven-jeon/KoNLP', upgrade = "never", INSTALL_opts=c("--no-multiarch"))


## 4. KoNLP 테스트 : 아래 3줄 코드 입력 후 결과 확인 잘 되면 성공..
# <아래 코드 실행>
library(KoNLP)
text <- "R은 통계 계산과 그래픽을 위한 프로그래밍 언어이자 소프트웨어 환경이자 프리웨어이다.[2] 뉴질랜드 오클랜드 대학의 로버트 젠틀맨(Robert Gentleman)과 로스 이하카(Ross Ihaka)에 의해 시작되어 현재는 R 코어 팀이 개발하고 있다. R는 GPL 하에 배포되는 S 프로그래밍 언어의 구현으로 GNU S라고도 한다. R는 통계 소프트웨어 개발과 자료 분석에 널리 사용되고 있으며, 패키지 개발이 용이해 통계 소프트웨어 개발에 많이 쓰이고 있다."
extractNoun(text)

# 패키지 로드
library(dplyr)
library(KoNLP)

useNIADic()

txt=readLines("./Data/hiphop.txt",encoding = "UTF-8")
txt


