#check missing values
# any(is.na(df))
# colSums(is.na(df))
# df <- na.omit(df)
# colnames(df)[colnames(df)=='_id'] <- 'id'
# colnames(df)
#check er_name and er_code period
# unique(df$er_name)#87
# unique(df$er_code_code_re)#86
# # reason: two economic regions called Northeast, one in ON, one in BC, thus groupby(prov, er_code) necessary
# unique(df[df$er_name=='Northeast', 'prov'])

# length(unique(df$id))# 28109
# unique(df$reference_period)#2016-2022
# unique(df$noc_title_eng)#600
#too many titles, outliers per noc visualized infeasible