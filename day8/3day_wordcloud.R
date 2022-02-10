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

## 특수문자 제거
# install.packages("stringr")
library(stringr)

# 특수문자 제거
txt <- str_replace_all(txt,"\\W"," ")
head(txt)



## 가장 많이 사용된 단어 알아보기
# 명사 추출하기 -> extracNoun
library(KoNLP)
extractNoun("대한민국의 영토는 한반도와 그 부속도서로 한다")

# 가사에서 명사추출
nouns <- extractNoun(txt)

# 추출한 명사 list를 문자열 벡터로 변환, 단어별 빈도표 생성
wordcount <- table(unlist(nouns))
wordcount


## 자주 사용된 단어 빈도표 만들기
# 데이터 프레임으로 변환
df_word <- as.data.frame(wordcount, stringsAsFactors = F)
df_word

# 변수명 수정
library(dplyr)
df_word <- rename(df_word,
                  word = Var1,
                  freq = Freq)
df_word

# 두 글자 이상 단어 추출
df_word <- filter(df_word, nchar(word) >= 2)
df_word

top_20 <- df_word %>% 
  arrange(desc(freq)) %>% 
  head(20)
top_20


# 워드 클라우드 만들기
# 패키지 준비하기
install.packages("wordcloud")

# 패키지  로드
library(wordcloud)

# 단어색상
# 단어 색상 목록 만들기
pal=brewer.pal(8, "Paired")

# 워드 클라우드 생성
set.seed(1234)                # 난수 고정
wordcloud(word=df_word$word,  # 단어
          freq=df_word$freq,  # 빈도
          min.freq = 2,       # 최소 단어 빈도
          max.words = 200,    # 표현 단어 수
          random.order = F,   # 고빈도 단어 중앙 배치
          rot.per = .1,       # 회전 단어 비율
          scale = c(4, 0.3),  # 단어 크기 범위
          colors = pal)       # 색깔 목록


# 단어 색상 바꾸기
pal=brewer.pal(9, "Purples")[5:9]
wordcloud(word=df_word$word,  # 단어
          freq=df_word$freq,  # 빈도
          min.freq = 2,       # 최소 단어 빈도
          max.words = 200,    # 표현 단어 수
          random.order = F,   # 고빈도 단어 중앙 배치
          rot.per = .1,       # 회전 단어 비율
          scale = c(4, 0.3),  # 단어 크기 범위
          colors = pal)       # 색깔 목록



#---------------------------------------------------------------------------
# 국정원 트윗 텍스트 마이닝
# 데이터로드
twitter <- read.csv("./Data/twitter.csv",
                    header = T,
                    stringsAsFactors = F,
                    fileEncoding = "UTF-8")

twitter
# 변수명 수정
twitter=rename(twitter,
               no = 번호,
               id = 계정이름,
               date = 작성일,
               tw = 내용)


# 특수문자 제거
# twitter$tw <- str_replace_all(twitter$tw, "\\W"," ")
head(twitter$tw)
# str_replace() : (처음으로 매칭하는 값만의)문자의 치환과 삭제에 사용
# str_replace_all() :(매칭하는 모든 값의)문자의 치환과 삭제에 사용


# 단어 빈도표 만들기
# 트윗에서 명사추출
nouns = extractNoun(twitter$tw)

# 추출한 명사 list를 문자열 벡터로 변환, 단어별 빈도표 생성
wordcount=table(unlist(nouns))

# 데이터 프레임으로 변환
df_word = as.data.frame(wordcount, stringsAsFactors = F)

# 변수명 수정
df_word = rename(df_word, 
                 word = Var1,
                 freq = Freq)
df_word


# 두 글자 이상 단어만 추출
df_word = filter(df_word, nchar(word)>=2)

# 상위 20개 추출
top20 = df_word %>% 
  arrange(desc(freq)) %>% 
  head(20)

# 단어 빈도 막대 그래프 만들기
library(ggplot2)
order = arrange(top20, freq)$word  # 빈도 순서 변수 생성

ggplot(data=top20, aes(x=word, y=freq))+   
  ylim(0, 2500)+
  geom_col()+
  coord_flip()+
  scale_x_discrete(limit=order)+            # 빈도 순서 변수 기준 막대 정렬
  geom_text(aes(label = freq), hjust = 0.3)  # 빈도 표시


# 워드 클라우드 만들기
pal = brewer.pal(8, "Blues")[5:9]
wordcloud(word=df_word$word,  # 단어
          freq=df_word$freq,  # 빈도
          min.freq = 2,       # 최소 단어 빈도
          max.words = 200,    # 표현 단어 수
          random.order = F,   # 고빈도 단어 중앙 배치
          rot.per = .1,       # 회전 단어 비율
          scale = c(4, 0.3),  # 단어 크기 범위
          colors = pal)       # 색깔 목록




#-------------------------------------------------------------------------------
# 대통령 연설문
### 이승만 대통령
president_lees <- readLines("./Data/president_lees.txt",encoding = "UTF-8")
head(president_lees)

## 특수문자 제거
# install.packages("stringr")
library(stringr)

# 특수문자 제거
president_lees <- str_replace_all(president_lees,"\\W"," ")
head(president_lees)

## 가장 많이 사용된 단어 알아보기
# 명사 추출하기 -> extracNoun
library(KoNLP)

# 가사에서 명사추출
nouns5 <- extractNoun(president_lees)

# 추출한 명사 list를 문자열 벡터로 변환, 단어별 빈도표 생성
wordcount5 <- table(unlist(nouns5))
wordcount5


## 자주 사용된 단어 빈도표 만들기
# 데이터 프레임으로 변환
df_word5 <- as.data.frame(wordcount5, stringsAsFactors = F)
df_word5

# 변수명 수정
library(dplyr)
df_word5 <- rename(df_word5,
                   word = Var1,
                   freq = Freq)
df_word5

# 두 글자 이상 단어 추출
# nchar -> 글자의갯수
df_word5 <- filter(df_word5, nchar(word) >= 2)
df_word5

top20_5 <- df_word5 %>% 
  arrange(desc(freq)) %>% 
  head(20)
top20_5


## 워드 클라우드 만들기
## 패키지 준비하기
# 패키지 설치
# install.packages("wordcloud")

# 패키지 로드
library(wordcloud)

library(RColorBrewer)

## 단어 색상 목록 만들기
pal <- brewer.pal(8, "Dark2")  # Dark2 색상 목록에서 8개 색상

## 워드 클라우드 생성
set.seed(1234)                      # 난수고정
wordcloud(words = df_word5$word,     # 단어
          freq = df_word5$freq,      # 빈도
          min.freq = 2,             # 최소 단어빈도
          max.words = 200,          # 표현 단어 수
          random.order = F,         # 고빈도 단어 중앙 배치
          rot.per = .1,             # 회전 단어 비율
          scale = c(4, 0.3),        # 단어 크기 범위
          colors = pal)             # 색깔 목록

## 단어 색상 바꾸기
pal <- brewer.pal(9, "Blues")[5:9]  # 색상 목록 생성
set.seed(1234)                      # 난수 고정
wordcloud(words = df_word5$word,     # 단어
          freq = df_word5$freq,      # 빈도
          min.freq = 2,             # 최소 단어빈도
          max.words = 200,          # 표현 단어 수
          random.order = F,         # 고빈도 단어 중앙 배치
          rot.per = .1,             # 회전 단어 비율
          scale = c(4, 0.3),        # 단어 크기 범위
          colors = pal)             # 색깔 목록
