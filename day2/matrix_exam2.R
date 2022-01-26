#############################################################
### R 메모리 변수 모두 제거
### rm(list=ls())
#############################################################


rm(list=ls())
ls()


#############################################################
### 데이터로드 후 재작업해서 다시 로드
#############################################################
dir()[9]
df=read.csv(dir()[9], stringsAsFactor=TRUE) #stringsAsFactors  : 문자열 컬럼을 팩터화 할 것인지 여부
head(df)
str(df)

# df의 1~9번열만 df1에 할당 
df1=df[,c(1:9)]
str(df1)

# df1자료를 작업자료.csv로 저장
write.csv(df1, '작업자료.csv')
dir()

# 메모리 변수 모두 제거
# df로 작업자료.csv 부르기

rm(list=ls())
df=read.csv('작업자료.csv',stringsAsFactor=TRUE)
df=df[,-1] #rowNum 제거
str(df)



#############################################################
### 기술통계
#############################################################
names(df)[7]; str(names(df)[7])
summary(df[,7]) #제목-집계빈도수
data.frame(val=summary(df[,7])) #[7]-error:NA값 있어서


### NA값 지우고
sum(is.na(df))
colName=names(df)
colName
cnt=length(colName)
for(i in 1:cnt){
	print(colName[i])
	print(sum(is.na(df[,i])))
}


## naniar 패키지 : 결측치 요약
install.packages('naniar')
library(naniar) #naniar 패키지를 불러옵니다.
naniar::miss_case_summary(df) # case : 행 기준
naniar::miss_var_summary(df) # variable : 변수 기준
naniar::vis_miss(df)         # 결측치 시각화
naniar::gg_miss_var(df)
naniar::gg_miss_upset(df)

install.packages('VIM')
library(VIM);VIM::aggr(df)



install.packages('Amelia')
library(Amelia)
missmap(df)
savePlot("무인카메라결측치2", type="png")


# 결측치 제거
df=na.omit(df)
missmap(df)
str(df)


tableDf=data.frame(table(df[,2]))
names(tableDf)[1]='title'
tableDf
tableDf$pro=tableDf$Freq/sum(tableDf$Freq) * 100
tableDf$pro

table #빈도수 집계



tmp=split(df$도로노선방향, df$시도명)
head(tmp,1)
tmp[[1]] # 01 = 서초구
mean(tmp[[1]]) # 3


sapply(tmp, mean) # sapply() : 리스트 대신 행렬, 벡터 등의 데이터 타입으로 결과를 반환
data.frame(sapply(tmp,sum))

tapply(df$도로노선방향,df$시도명, mean) # tapply() : 데이터 요소별 함수 적용

# dplyr 패키지 : 데이터 프레임을 처리하는 함수군으로 구성
# dataframe과 plyr이 합쳐진 이름으로 data.frame 전용 plyr 패키지