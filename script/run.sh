source ../conf/hive.conf
source ../conf/time_info.conf
sourse ../secret.sh

#for i in {44..50}
#do
#yes_date=`date --date=''$i' days ago' +%Y%m%d`
echo $yes_date

${HIVE_BIN} -hiveconf  yes_date=${yes_date} -hiveconf start_date=${start_date} -f ads_opc_fifty_receive.sql &
wait
#done
bash secret.sh
