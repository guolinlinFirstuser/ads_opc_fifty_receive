#!/bin/sh 
source /usr/local/pub_function/send_email.sh
source ../conf/hive.conf
source ../conf/time_info.conf
source /usr/local/push-data/conf/secret_key_config
echo -e "发起邀请人的用户ID\t用户名\t年级\t真实姓名\t电话\t地区\t地区\t所购50元课程年级id\t所购50元课程年级名\t所购50元课程科目id\t所购50元课程科目名\t被邀请学员ID\t年级\t购买课程\t课程所属年级id\t课程所属年级名\t课程所属科目id\t课程所属年级名\t邀请成功时间\t所购课程学年\t所购课程学期\t是否春季在读学生
" >'../data/ads_opc_fifty_receive.xls'

${HIVE_BIN} -e "select 
userid,
getsecret(name,'${stu_name_key}','2') as name,
cur_grade,
getsecret(realname,'${stu_name_key}','2') as realname,
getsecret(phone,'${phone_key}','2') as phone,
area_id,
area_name,
user_grade_ids,
user_grade_names,
user_subject_ids,
user_subject_names,
userid_buy,
buy_cur_grade,
current_course_id_buy,
buy_grade_ids,
buy_grade_names,                                                                                                                      
buy_subject_ids,
buy_subject_names,
buy_create_time,
year_id,
term_id,
in_progress
from ads_opc_fifty_receive
where dt='${yes_date}' and userid>100000
" >>'../data/ads_opc_fifty_receive.xls'

iconv -f UTF-8 -t GBK -c  ../data/ads_opc_fifty_receive.xls > ../data/ads_opc_fifty_receive1.xls
 
send_email "chengwenyan@100tal.com,shibai@100tal.com" "wangshouzheng@100tal.com,guxueru@100tal.com,zhangqing@100tal.com,shenchunhui@100tal.com" "五十元课老带新" "详情见附件" "../data/ads_opc_fifty_receive1.xls"
#send_email "chengwenyan@100tal.com,shibai@100tal.com" "" "五十元课老带新" "详情见附件" "../data/ads_opc_fifty_receive1.xls"

#send_email "zhanglecheng@100tal.com" "" "E卡使用情况" "
#详情见附件
#" "../data/ads_stu_exchange_info_gbk.xls"
