install.packages('cowsay')
library(cowsay)

say('heoo',by='cat')

say('heoo',by='snowman')

?say

byNameList=c('cat','ghost','ant')

for (byName in byNameList){
	say('heoo',by=byName)
}

for (index in 1:length(byNameList)){
   say('Hello',by=byNameList[index])
}
