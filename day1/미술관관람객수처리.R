▶1.   csv 자료를 읽기위해서 작업경로를 세팅 
     콘솔창에 커서를 두고 [파일-작업디렉토리변경]    R에서는 setwd('경로명')으로 작업디렉토리 변경가능
▶2. dir() 을 이용하여 파일리스트 확인
▶3. df=read.csv 명령어로 자료를 읽음
   (별도옵션없었기 때문에 가장상단은 제목,  문자는 factor로 읽음)
▶4. 데이셋 샘플 확인 (위로, 아래로)
▶5. 데이터의 구조를 확인 (필드명,성격을 확인등)
▶6. 기술통계를 통하여서 데이터셋의 분포를 확인
   summary(df),   summary(df[,c(1,3)]) 등 일부데이터만
   df[,c(3:12)]
▶7. NA값을 반드시 확인 (summary확인, is.na(df), table(is.na(df)), barplot(table...))
▶8. 참고: 시각화도 가능
summary(df)
par(mfrow=c(3, 1))  #차트창을 닫거나, 
          # par(mfrow=c(1,1))만날때까지 유지
index=1
barplot(table(is.na(df[index])),main=names(df)[index])
index=2
barplot(table(is.na(df[index])),main=names(df)[index])
index=3
barplot(table(is.na(df[index])),main=names(df)[index])

▶9. NA값을 처리 (0으로대체, 중앙값이나 평균값으로대체, 0있는행을 모두 제거, 임의값대체)
df[is.na(df)]=0
summary(df)
par(mfrow=c(3, 1))  #차트창을 닫거나, 
          # par(mfrow=c(1,1))만날때까지 유지
index=1
barplot(table(is.na(df[index])),main=names(df)[index])
index=2
barplot(table(is.na(df[index])),main=names(df)[index])
index=3
barplot(table(is.na(df[index])),main=names(df)[index])
------------------------------------------------------------------------------------------------------------
####--- 자료 검수
▶10. 2018년도 자료가 12개, 2019가 12개, 2020년도가 12개가 나오나
summary(factor(df$연도))           또는 table(df$연도)   또는 barplot(table(df$연도))
▶11. 1월, 2월, 3월~12월달 자료가 각 3개씩 나오나 
-------------------------------------------------------------------------------------------------------------
#### 년도별 월의 관람객수를 차트로 표시하고자 함.
#### 년도별로 자료를 먼저 나누어야함.. R에서는 split를 이용하여 손쉽게 조건에 맞는 자료를 나눌수 있음.
▶12.  year=split(df,df$연도)         # df의 년,월,관람객수를 df$년의 unique한 값으로 나눔
▶13.  year                               # year[[1]]  은 2018년도 / year[[2]]는 2019년도   / year[[3]]은 2020년도 자료가 있음.
▶14.  par(mfrow=c(3, 1))

▶15. index=1
▶16.  yearData=year[[index]]
▶17.  yearData                                          # 해보면 2018 년도 자료만 있음.  summary(yearData) ,     table(yearData[,1])
▶18.  title=year[[index]][1,1]                            # year[[1]]은 2018년도 의 연도, 월, 관람객수 ,    그중 [1,1]은 1행1열  1열은 연도니까 가장 위에 있는 연도 자료임
                                                                # 15~19번 처럼 하는 이유는 나중에 for로 만들기 위한 인덱싱 작업임. 직접 title='2018년도 자료' 해도 됨.
▶19.  plot(yearData$월, yearData$관람객수, main=title)

▶----15,16번,18,19번 반복   (2019년도 자료)
index=2 ;  yearData=year[[index]]; title=year[[index]][1,1] 
plot(yearData$월, yearData$관람객수, main=title)

▶----15,16번,18,19번 반복  (2020년도 자료)
index=3 ;  yearData=year[[index]]; title=year[[index]][1,1] 
plot(yearData$월, yearData$관람객수, main=title)
