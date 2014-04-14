library(ggplot2)
library(scales)

gh_prs = read.csv('~/Dropbox/tw_github_prs.csv')

gh_stats <- data.frame(timestamp=gh_prs$timestamp, repository_name=gh_prs$repository_name, repository_language=gh_prs$repository_language)

gh_stats$timestamp <- as.POSIXct(gh_stats$timestamp/1e6, origin="1970-01-01", tz="UTC")

# Reorder levels from most to least popular
gh_stats$repository_name <- reorder(gh_stats$repository_name, gh_stats$repository_name, FUN=length)
gh_stats$repository_name <- factor(gh_stats$repository_name, levels=rev(levels(gh_stats$repository_name)))
gh_stats$repository_language <- reorder(gh_stats$repository_language, gh_stats$repository_language, FUN=length)
gh_stats$repository_language <- factor(gh_stats$repository_language, levels=rev(levels(gh_stats$repository_language)))

ggplot(gh_stats, aes(x=timestamp, fill=repository_name)) + geom_histogram(aes(y=..count..)) + scale_x_datetime(breaks=date_breaks("3 months"), labels=date_format("%b %y"))
ggplot(gh_stats, aes(x=timestamp, fill=repository_language)) + geom_histogram(aes(y=..count..)) + scale_x_datetime(breaks=date_breaks("3 months"), labels=date_format("%b %y"))