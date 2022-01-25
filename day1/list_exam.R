# 리스트 생성
cafe=list(espresso=c(4,5,3,6,5,4,7),
	americano=c(63,68,64,68,72,89,94),
	latte=c(61,70,59,71,71,92,88),
	price=c(2.0,2.5,3.0),
	menu=c('espresso','americano','latte'))

# 위와 같은 표현
# cafe=list(espresso=espresso,americano=espresso,latte=latte,price=price,menu=menu)

cafe

str(cafe)
summary(cafe)

# 생성한 리스트에서 메뉴만 추출해 팩터로 변경
cafe$menu=factor(cafe$menu) # cafe[[5]]=factor(cafe[[5]])
cafe$menu

# 리스트 내 가격 벡터를 선택해 값의 이름을 메뉴명으로 설정
names(cafe$price)=cafe$menu
cafe$price
names(cafe$price)
str(cafe)

# 가격정보 * 판매량
cafe$price[3]
cafe$price['espresso']*cafe$espresso

# R에는 내장데이터를 많이 제공
# 자동차 연비와 관련된 mtcars
mtcars   # read없는 자료는 내장자료
# vs와 am은 명목형 데이터(0과 1, True and False)

str(mtcars) # 구조확인
head(mtcars) # 위에서부터 데이터 확인
head(mtcars,3)
summary(mtcars)
plot(mtcars$mpg)


summary(factor(mtcars$cyl)) # factor = 같은 것끼리 묶는 것

# unique 값 찾기(3가지)
names(summary(factor(mtcars$cyl)))
levels(factor(mtcars$cyl))
unique(mtcars$cyl) # 맨 위에 데이터부터 중복제거

tmp=summary(factor(mtcars$cyl))
tmp
names(tmp)=c('cyl:4','cyl:6','cyl:8')
str(tmp)
tmp[1]

### split(자료, 기준) 작업하면 리스트화됨
tmp=split(mtcars, mtcars$cyl)
str(tmp)
tmp$4 # error
tmp[[1]] # cyl4의 dataset
tmp[[2]]

split(tmp[[1]],tmp[[1]]$am)
split(tmp[[1]],tmp[[1]][9])



# DataFrame

# 열의 이름 : 필드 = 변수 = item

iris
iris[,c(1,2)] # 1, 2열의 모든 데이터
iris[,c(1,3,5)] # 1,3,5열의 모든 데이터
iris[,c(1,5)] # 1, 5열의 모든 데이터
iris[1:5,] # 1~5행의 모든 데이터
iris[1:5, c(1,3)] # 1~5행의 데이터 중 1, 3열의 데이터