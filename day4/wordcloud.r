plot(c(1,2,3))
install.packages("languageserver")
library(languageserver)

a=c('sky','a','a','b','a','b')
b=table(a)
install.packages('wordcloud')
library(wordcloud)
b
wordcloud(names(b),b,min.freq=1)
