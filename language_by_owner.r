library(ggplot2)
library(scales)

gh_stats = read.csv('~/Dropbox/tw_github_events.csv', na.strings=c("NA","NaN", "", " ") )

library(plyr)
library(reshape2)

m <- melt(data.frame(repository_language=gh_stats$repository_language, repository_owner=gh_stats$repository_owner), id="repository_language")
language_by_owner <- aggregate(m$value, by=list(repository_language = m$repository_language, repository_owner = m$value), FUN=length)
language_by_owner <- ddply(language_by_owner, .(repository_owner), transform, rescale = rescale(x), na.rm=TRUE)

ggplot(language_by_owner, aes(repository_language, repository_owner)) + geom_tile(aes(fill=rescale), colour = "white") + scale_fill_gradient(low = "white", high = "steelblue") + theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))