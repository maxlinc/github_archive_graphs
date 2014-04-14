library(zoo)
library(reshape2)
library(ggplot2)

github_data <- read.csv('~/Documents/graph_test.csv')
github_summary <- melt(github_data, id.vars="X", variable.name="EventType", value.name="events")
github_summary$month <- as.Date(as.yearmon(github_summary$X, '%b-%y'))

ggplot(github_summary, aes(x=month, y=events, fill=EventType)) + geom_area()