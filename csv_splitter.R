library(dplyr, warn.conflicts=F)
library(stringr, warn.conflicts=F)

work_dir<-"/Users/bradychiu/Dropbox (Uber Technologies)/160428 Rider Incentives/la_160510"
data_dir="data/"
deliverable_dir="deliverables/"
setwd(work_dir)

# set file name
file_name<-"asdf01.csv"

# load file
df<-read.csv(file.path(deliverable_dir, file_name), stringsAsFactors=F)

# set rows per csv for output
rows_per_csv<-99999

# split df
split_df<-split(df, (as.numeric(rownames(df))-1) %/% rows_per_csv)

# create each csv
for(i in 1:length(split_df)){
  new_file_name<-paste0(
    str_extract(file_name, "(^.+)(?=\\.csv)")
    ,"_"
    ,str_pad(i, 3, pad="0")
    ,".csv"
  )
  new_df<-data.frame(split_df[i])
  colnames(new_df)<-names(df)
  write.csv(new_df, new_file_name, row.names=F)
}