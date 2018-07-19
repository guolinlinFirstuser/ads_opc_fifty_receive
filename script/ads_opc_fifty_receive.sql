insert overwrite table ads_opc_fifty_receive partition(dt='${hiveconf:yes_date}')
select distinct c.userid,name,cur_grade,realname,phone,area_id,area_name,c.grade_ids,c.grade_names,c.subject_ids,c.subject_names,
		c3.userid_buy,buy_cur_grade,current_course_id_buy,c3.grade_ids,c3.grade_names,c3.subject_ids,c3.subject_names,c3.create_time,year_id,term_id,in_progress
from
(	select distinct c1.userid,c1.userid_buy,c2.name,cur_grade,realname,phone,area_id,area_name,c2.grade_ids,c2.grade_names,c2.subject_ids,c2.subject_names
	from
	(
	select distinct userid,userid_buy,create_time from sds_xes_opc_fifty_receive
	)c1
	left join
	(
		--发起邀请人的用户ID、用户名、报名时填写年级、真实姓名、地区、电话、所购50元课程年级及科目
		select distinct userid,name,userid_buy,cur_grade,realname,phone,grade_ids,grade_names,subject_ids,subject_names,area_id,area_name
		from
		(	
			select userid,userid_buy,create_time,concat_ws(',',collect_set(grade_ids)) as grade_ids,
				concat_ws(',',collect_set(grade_names)) as grade_names,
				concat_ws(',',collect_set(subject_ids)) as subject_ids,
				concat_ws(',',collect_set(subject_names)) as subject_names,area_id,area_name
			from
			(
		      select distinct userid,userid_buy,create_time from sds_xes_opc_fifty_receive where dt='all' and userid>100000
		      
			)a1
			left join
			(
			select distinct stu_id,grade_ids,grade_names,subject_ids,subject_names,area_id,area_name
			from ads_sales_detail_is_rebuy_base_v2 
			where year=18 and term=2 and course_type =4 and is_return=0 and stu_id>100000
			
			)a2
			on a1.userid=a2.stu_id
		    group by userid,userid_buy,create_time,area_id,area_name
		  
		)a
		left join 
		(
		select distinct id,name,cur_grade,realname,phone from ods_dim_student where dt='${hiveconf:yes_date}' and id>100000
		)c
		on a.userid=c.id
	)c2
	on c1.userid=c2.userid and c1.userid_buy=c2.userid_buy
)c
left join 
(
	--被邀请学员ID，学生报名时填写年级，年级，购买课程，邀请成功时间，被邀请学员是否为春季在读学员。
	select userid,userid_buy,buy_cur_grade,current_course_id_buy,
		grade_ids,grade_names,subject_ids,subject_names,year_id,term_id,concat_ws(',',collect_set(b.create_time))as create_time,
		in_progress
	from
	(
		select distinct userid,userid_buy,current_course_id as current_course_id_buy,
			grade_ids,grade_names,subject_ids,subject_names,year_id,term_id,b1.create_time as create_time,in_progress
		from
		(
		select distinct userid,userid_buy,create_time from sds_xes_opc_fifty_receive where dt='all' and userid_buy>100000
		)b1
		left join
		(
		select distinct stu_id,current_course_id,grade_ids,grade_names,subject_ids,subject_names,create_time,year_id,term_id,
				if((year_id=17 and term_id =1)=1,1,0) as in_progress
		from ads_sales_detail_is_rebuy_base_v2 
		where is_return=0 and create_time>='2018-01-01 00:00:00' and stu_id>100000
		)b2
		on b1.userid_buy=b2.stu_id 
	)b
	left join 
	(
	select distinct id,cur_grade as buy_cur_grade from ods_dim_student where dt='${hiveconf:yes_date}' and id>100000
	)c2
	on b.userid_buy =c2.id
	group by userid,userid_buy,buy_cur_grade,current_course_id_buy,
			grade_ids,grade_names,subject_ids,subject_names,year_id,term_id,in_progress
)c3
on c.userid=c3.userid and c.userid_buy=c3.userid_buy
