CREATE TABLE `ads_opc_fifty_receive`                                                                                    
(
userid int,
name string,
cur_grade string,
realname string,
phone string,
area_id int,
area_name string,
user_grade_ids int,
user_grade_names string,
user_subject_ids int,
user_subject_names string,
userid_buy string,
buy_cur_grade int,
current_course_id_buy string,
buy_grade_ids int,
buy_grade_names string,
buy_subject_ids int,
buy_subject_names string,
buy_create_time date,
year_id int,
term_id int,
in_progress string
)
 PARTITIONED BY (`dt` string)
 ROW FORMAT DELIMITED
 FIELDS TERMINATED BY '\u0001'
 STORED AS INPUTFORMAT
   'org.apache.hadoop.mapred.SequenceFileInputFormat'
 OUTPUTFORMAT
   'org.apache.hadoop.hive.ql.io.HiveSequenceFileOutputFormat'
 LOCATION
   'hdfs://mycluster/home/ads/bi/ads/ads_opc_fifty_receive'
