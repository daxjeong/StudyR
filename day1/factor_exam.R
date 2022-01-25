# 스크립트 창에서
# 작성한 코드는
# 커서를 그 줄에 두고
# Ctrl+R 또는 F5
# 여러줄 명령은 블럭지정 후
# Ctrl+R 또는 F5

# 두개이상의 자료를 갖는 리스트 구조에서
# 파이썬에서는 직업명=['','']. 파이썬에서는 초기화 작업명=[]
# R에서는 직업명=c('',''). R에서는 리스트 초기화 작업명=c()

직업명=c('데이터과학자','엔지니어','엔지니어','세금관리자','분석관리자')
채용수=c(4184,2723,2599,3317,1958)
평균급여=c(110,110,106,110,112)
직업만족도=c(4.4,4.0,4.3,4.0,4.1)
직업명
str(직업명)
summary(직업명) #기본적인 기술통계를 제공하는 내장함수

str(채용수)
summary(채용수)

str(평균급여)
summary(평균급여)

str(직업만족도)
summary(직업만족도)

plot(평균급여)
plot(직업명) # error

직업명fa=as.factor(직업명)
직업명fa # Levels() : 값들의 종류 => 문자열에 중복 제거된 unique값
직업명
summary(직업명fa)
plot(직업명fa)
pie(직업명fa) # error

data=data.frame(직업명,채용수,평균급여,직업만족도)
data
str(data)
summary(data)
plot(data)
data$직업명

# strsplit(변수, 글자를 나눌 기준)
a='python/r/cobolr'
tmp=strsplit(a,"/")
tmp
tmp[[1]][2]
summary(a)
plot(a) # error

# factor형은 strsplit 안됨
b=as.factor(a)
strsplit(b,"/") # error
plot(b)

a=c('python/r/cobolr','aa/b/b/c')
tmp=strsplit(a,"/")
tmp
tmp[[2]]
tmp[[2]][1]

a=c('파이썬','데이터분석가','인공지능','R, 데이터분석가','빅데이터')
tmp=strsplit(a,",")
tmp
summary(unlist(tmp))
tmp1=unlist(tmp)
tmp2=as.factor(tmp1)
summary(tmp2)
plot(tmp2)

a=c('파이썬-20','데이터분석가-20','인공지능','R, 데이터분석가','빅데이터')
tmp=strsplit(a,",")
tmp
summary(unlist(tmp))
tmp1=unlist(tmp)
tmp1
tmp2=as.factor(tmp1)
summary(tmp2)
plot(tmp2)
strsplit(temp2,'-') # error - factor형은 strsplit 안됨
unlist(strsplit(as.character(tmp2),'-'))

# code 4-7
bt = c('A','B','B','O','AB','A')
bt.new <- factor(bt)
bt
bt.new
bt[5]
bt.new[5]
levels(bt.new) # factor에 저장된 값의 종류를 출력
as.integer(bt.new) # factor의 문자값을 숫자로 바꾸어 출력
bt.new[7] = 'B' # factor bt.new의 7번째에 'B'저장
bt.new[8] <- 'C' # error - 'C'가 Levles에 없는 값이기 때문임 => <NA>로 표시됨
# factor는 사전에 정의된 값 외에 다른 값들은 입력하지 못하도록 하는 효과
bt.new