#1. 작업자료 다운로드
# 부산광역시_현대미술관 관람객 수.csv

#2. R에서 CSV로 읽기
df=read.csv('....csv')

#3. 구조파악 => str(df) : 타입, 행, 열의 개수

#4. 데이터샘플을 확인 => head(df, 6), tail(df,6)

#5. 데이터의 기본 기술통계 => summary(df)

#6. 빈도수계산
---

# 콘솔창에 커서를 두고
# 파일-작업디렉토리변경 / setwd로 작업디렉토리 설정할 수 있음

dir()  # 파이썬 os.listdir 또는 glob

# csv자료의 가장 윗자료를 필드명으로 가져옴
df=read.csv("부산광역시_현대미술관 관람객 수.csv")
dir()[6]

str(df)
head(df)
names(df)

summary(df)

# 자료의 연도만 출력
str(df)
df[,1] # df$연도
min(df[,1])
max(df[,1])

# 연도와 관람객 수만 출력
df[,c(1,3)]

# 위로 12개의 자료만 출력, 즉 2018년도 자료가 됨
df[1:12,] #head(df,12)

# 아래로 12개의 자료만 출력, 즉 2020년도 자료가 됨
df[25:36,] #tail(df,12)

# 2018년도 월과 관람객 수만 출력
df[1:12, c(2,3)]

# R에서 NA(결측치)값 0으로
is.na(df[3])
summary(is.na(df[3])) # TRUE : 17
plot(summary(is.na(df[3]))) # error

table(is.na(df[3]))
barplot(table(is.na(df[3])))

# par 함수 : 화면분할, 여러 그래프를 한 화면에 그리기
par(mfrow=c(1,3)) #차트창을 닫거나, par(mfrow=c(1,1))만날때까지 유지
barplot(table(is.na(df[1])), main=names(df)[1]) # names(df)[index]
barplot(table(is.na(df[2])), main=names(df)[2])
barplot(table(is.na(df[3])), main=names(df)[3])


-----
summary(factor(df$연도))
table(df$연도) # table() : 정보를 데이터프레임으로 만드는 집계함수
barplot(table(df$연도))