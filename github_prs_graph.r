library(ggplot2)
library(scales)

# gh_prs = read.csv('~/Dropbox/tw_github_prs.csv')
gh_stats = read.csv('~/Dropbox/github_events.csv')

# gh_stats <- data.frame(timestamp=gh_prs$timestamp, repository_name=gh_prs$repository_name, repository_language=gh_prs$repository_language)

gh_stats$timestamp <- as.POSIXct(gh_stats$timestamp/1e6, origin="1970-01-01", tz="UTC")

# Reorder levels from most to least popular
gh_stats$repository_name <- reorder(gh_stats$repository_name, gh_stats$repository_name, FUN=length)
gh_stats$repository_name <- factor(gh_stats$repository_name, levels=rev(levels(gh_stats$repository_name)))
gh_stats$repository_language <- reorder(gh_stats$repository_language, gh_stats$repository_language, FUN=length)
gh_stats$repository_language <- factor(gh_stats$repository_language, levels=rev(levels(gh_stats$repository_language)))

ggplot(gh_stats, aes(x=timestamp, fill=repository_name)) + geom_histogram(aes(y=..count..)) + scale_x_datetime(breaks=date_breaks("3 months"), labels=date_format("%b %y"))
ggplot(gh_stats, aes(x=timestamp, fill=repository_language)) + geom_histogram(aes(y=..count..)) + scale_x_datetime(breaks=date_breaks("3 months"), labels=date_format("%b %y"))

library(plyr)
library(reshape2)

# tw_stats <- gh_stats[gh_stats$repository_owner=='thoughtworks',]
# tw_stats <- tw_stats[grep('snap-ci', tw_stats$repository_name]
m <- melt(data.frame(repository_language=gh_stats$repository_language, type=gh_stats$type), id="repository_language")
repository_by_event_type <- aggregate(m$value, by=list(repository_name = m$repository_name, event_type = m$value), FUN=length)
repository_by_event_type <- ddply(repository_by_event_type, .(event_type), transform, rescale = rescale(x))
language_by_event_type <- aggregate(m$value, by=list(repository_language = m$repository_language, event_type = m$value), FUN=length)
language_by_event_type <- ddply(language_by_event_type, .(event_type), transform, rescale = rescale(x))

ggplot(repository_by_event_type, aes(repository_name, event_type)) + geom_tile(aes(fill=rescale), colour = "white") + scale_fill_gradient(low = "white", high = "steelblue") + theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))
ggplot(language_by_event_type, aes(repository_name, event_type)) + geom_tile(aes(fill=rescale), colour = "white") + scale_fill_gradient(low = "white", high = "steelblue") + theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))