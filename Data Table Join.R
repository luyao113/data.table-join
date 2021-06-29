install.packages("data.table")
library(data.table)

#X[Y] in data.table package, better efficiency on data table joins, especially (join+update)-------------------------
DT1 <- data.table(a = 1:4, b = 12:15)  #eg: DT1 has col 1,2,3
DT2 <- data.table(a = 2:3, b = 13:14)  #eg: DT2 has col 4,5,6
#want to keep all DT1, and join DT2's b on DT1 if there's a match
#1. 
result1 <- DT2[DT1, on='a']  #result has all DT1, DT1 is not updated, just joined; col shown as: a, b, i.b
#2.
result2 <- DT1[DT2, on='a', newb:=i.b] #DT1 is updated with column newb, col shown as: a, b, newb
#3.
DT1 <- data.table(a = 1:4, b = 12:15)
DT2 <- data.table(a = 2:3, b = 13:14)
result3 <- DT1[DT2, on='a'] #result has all DT2, DT2 is not updated, just joined; col shown as:a, b, i.b

#conclusion-----------------------------------------------------
DT1[DT2] #the table inside of the brackets(DT2) will have all of its rows in the resultant table; w
#so above will return all DT2 and any matching DT1
#https://www.gormanalysis.com/blog/r-introduction-to-data-table-joins/

#1.only join
#1.1 join on single column
DT1[DT2, on ='a single col']
DT1[DT2, on = .(col1,col2)]
#1.2 join on multi columns
DT1[DT2, on = c(DT1_col1 = "DT2_col3", DT1_col2 = "DT2_col4")] #https://stackoverflow.com/questions/16047253/merging-tables-with-different-column-names

#2.update-by-reference (update by join/ update DT1 with DT2 column's value)
#2.1 update on single column
DT1[DT2, on = ...., newcol := i.col3]  #first join DT1 and DT2, and then upate on DT1: add newcol on DT1 and pull value from DT2_col3
#where i=DT2; i comes from the structure DT[i,j,by]
#2.2 update on multi column
DT1[DT2, on = ...., `:=` (col1 = "col4", col2 = "col5")] #col without quotes are from DT1, with quotes are from DT2


#tip: join quicker when we key both tables
setkey(DT1, "col_10")
setkey(DT2, "col_10")
DT1[DT2] #default join on the key of the two tables
#But note that setting a key is always going to faster to subsequently join to if you can pay the upfront cost of setkey (which is pretty fast in data.table). 
#The concept is similar to a clustered index in SQL.

#------------------------------------------------------------
#The advantage of X[Y] syntax vs merge() 
#is that you can include j and by inside the same [...] query. 
#Such a query is optimized so only the columns needed by the j expression are joined, saving time and RAM. 
#https://stackoverflow.com/questions/34644707/left-outer-join-with-data-table-with-different-names-for-key-variables/34645997#34645997

#about memory efficiency:
#https://stackoverflow.com/questions/34598139/left-join-using-data-table

#merge in dplyr, mostly used in data frame joins------------------------------
install.packages("dplyr")
library(dplyr)

merge(X,Y, all.x=TRUE)
#nomatch=0, allow.cartesian=TRUE

