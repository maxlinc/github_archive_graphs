library(ggplot2)
library(scales)
library(plyr)
library(reshape2)
library(zoo)

gh_stats = read.csv('~/Dropbox/tw_github_events.csv')
gh_stats <- gh_stats[gh_stats$type == 'PushEvent',]
gh_stats <- gh_stats[gh_stats$repository_owner != 'www-thoughtworks-com',]
gh_stats$timestamp <- as.POSIXct(gh_stats$timestamp/1e6, origin="1970-01-01", tz="UTC")

df <- data.frame(timestamp=gh_stats$timestamp, repository_owner=gh_stats$repository_owner)
data.long <- dcast(df, timestamp ~ repository_owner, value.var="repository_owner")
for(i in c(2:ncol(data.long))) {
  data.long[,i] <- as.numeric(data.long[,i])
}
myzoo <- zoo(data.long[,-1], order.by=data.long[,1])
myzoo <- aggregate(myzoo, by=as.yearmon, FUN=sum)
tsRainbow <- rainbow(ncol(myzoo))
plot(x = myzoo, plot.type="single", col=tsRainbow, screens=1, lwd=3)
legend(x="topright", legend = colnames(myzoo), lty = 1, lwd=3, col = tsRainbow)
