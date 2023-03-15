# Author: Yue (Gary) Zhang
# This scripts take inputs as a list of files with common columns, bind them into a overarching table and save it as a csv
# for example: bind file1 with col1 col2 and file2 with col1 col2 into fileAll using col1 as the anchor will generate fileAll with col1 file1__col2 file2__col2 
# in the command line, simply run:
# Rscript bindcolumns.R 'path' 'pattern' 'filetype' 'cindex' 'cinterest' 'outfname'

## read the input
args <- commandArgs(trailingOnly = TRUE)
# print the help message:
if (length(args) == 1 & args[[1]] == '-h') {
  cat("This scripts take inputs as a list of files with common columns, bind them into a overarching table and save it as a csv. \n For example: it can bind file1 with col1 col2 and file2 with col1 col2 into fileAll using col1 as the anchor. It generates fileAll with col1 file1__col2 file2__col2 \n
      In the command line, simply run: \n
      Rscript bindcolumns.R 'PATH' 'PATTERN' 'FILETYPE' 'CINDEX' 'CINTEREST' 'OUTFNAME' \n
      where PATH is the directory of input files \n
            PATTERN is the common pattern of input files (e.g., if you have file1.tsv, file2.txt, file3_xx.txt, somethingelse.txt, set pattern == 'file' will grab columns from file1.tsv, file2.tsv, file3_xx.txt) \n
            FILETYPE is the separator when reading the dfs; only tsv and csv are supported \n
            CINDEX is the name of the column that merging is based on \n
            CINTEREST is the name of the columns to be included \n
            OUTFNAME is the name of the merged table")
} else{
  # required input
  path = args[[1]] # directory of input files
  pattern = args[[2]] # common pattern of input files (e.g., if you have file1.tsv, file2.txt, file3_xx.txt, somethingelse.txt, set pattern == 'file' will grab columns from file1.tsv, file2.tsv, file3_xx.txt)
  filetype = args[[3]] # separator when reading the dfs; only tsv and csv are supported
  cindex = args[[4]] # a column that merging is based on
  cinterest = args[[5]] # columns to be merged
  outfname = args[[6]] # output file name
  
  # path = '.'
  # filetype = '.tsv'
  # separator = '\t'
  # cindex = 'transcript'
  # cinterest = 'final_count transcript_length final_conf'
  # outfname = 'bronc_merged.csv'
  # 
  # print(path)
  # print(pattern)
  # print(filetype)
  # print(cindex)
  # print(cinterest)
  # print(outfname)

  if (filetype == 'tsv' | filetype == '.tsv') {
    separator = '\t'
  } else if (filetype == 'csv' | filetype == '.csv') {
    separator = ','
  } else {
    warnings('file type is not supported')
  }
  cinterest = unlist(strsplit(cinterest,' '))
  # list all files matched the pattern
  flist = list.files(path = path, pattern = pattern, all.files = FALSE,
                     full.names = FALSE, recursive = FALSE,
                     ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)
  
  
  # print message to screen
  cat("concatenate common columns ", cinterest, "\n from ", flist, 
      "\n using the column ", cindex, "\n and save as ", outfname )
  
  
  for (i in 1:length(flist)) {
    fname = flist[i]
    df = read.csv(paste0(path,'/',fname), sep = separator, header = T, comment.char = '#')
    df.s = df[,c(cindex,cinterest)]
    names(df.s)[2:length(names(df.s))] = paste0(fname,'__',names(df.s)[2:length(names(df.s))])
    if (i == 1) {
      df_merged = df.s
    } else {
      df_merged = merge(df_merged,df.s, by = cindex)
    }
  }
  
  write.csv(df_merged,
            file = outfname,
            quote = F)
  }
