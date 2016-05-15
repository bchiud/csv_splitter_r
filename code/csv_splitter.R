### setup ###

# load packages
package_loader<-function(package_names){
  for(i in package_names){
    if(!i %in% rownames(installed.packages())) install.packages(i, repos="http://cran.r-project.org")
    library(i, character.only=T)
  }
}
package_loader(c("data.table", "stringr", "tidyr"))


### parameters ###

# directories #
# work_dir<-"/Users/bradychiu/Dropbox (Uber Technologies)/R/csv_splitter_r"
# setwd(work_dir)
data_dir="input/"
deliverable_dir="output/"

# set file name
file_name<-commandArgs(trailingOnly=T)[1]

# set rows per csv for output
rows_per_csv<-commandArgs(trailingOnly=T)[2]


### error handling ###

# check if file exists
if(!file.exists(paste0(data_dir, file_name))){
  print(paste(file_name, "does not exists in the input directory."))
  stop()
}

# check if input is integer
is_not_int_error<-function(){
  print(paste(rows_per_csv, "is not an integer."))
  stop()
}
rows_per_csv<-tryCatch(as.numeric(rows_per_csv),
                       error=function(e) is_not_int_error(),
                       warning=function(w) is_not_int_error(),
                       finally={
                         if(as.numeric(rows_per_csv)%%1!=0) is_not_int_error()
                         else as.integer(rows_per_csv)
                       })

# create output dir if it does not exists
if(!file.exists(deliverable_dir)){
  dir.create(deliverable_dir)
}


### processing ###

# notify user processing has begun
print(paste("Processing", file_name, "into files of", rows_per_csv, "rows."))

# load file
df<-read.csv(paste0(data_dir, file_name), stringsAsFactors=F)

# set row names
row.names(df)<-c(1:nrow(df))

# split df
split_df<-split(df, (as.numeric(rownames(df))-1) %/% rows_per_csv)

# create each csv
num_files<-0
for(i in 1:length(split_df)){
  new_file_name<-paste0(
    str_extract(file_name, "(^.+)(?=\\.csv)")
    ,"_"
    ,str_pad(i, 3, pad="0")
    ,".csv"
  )
  new_df<-data.frame(split_df[i])
  colnames(new_df)<-names(df)
  write.csv(new_df, paste0(deliverable_dir, new_file_name), row.names=F)
  num_files<-num_files+1
}

# notify user processing has ended
print(paste("Process complete. Created", num_files, "file(s)."))


### unit test ###

# create mock_csv_file.csv
# write.csv(data.table(a=1:100000,
#                      b=LETTERS[1:26],
#                      c=letters[1:26]),
#           paste0(data_dir, "mock_csv_file.csv"),
#           row.names=F
#           )