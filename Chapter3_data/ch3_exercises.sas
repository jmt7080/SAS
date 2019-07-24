/* Ch 3. */
data q30;
	infile '/folders/myshortcuts/sas_cert/SAS/Chapter3_data/Hotel.dat';
	input room_id num_guests check_in_month check_in_day check_in_year 
	check_out_month check_out_day check_out_year @41 used_internet $5. 
	@49 days_internet_used 3. @53 room_type $14. @68 room_rate 4.;

	check_in_date = mdy(check_in_month, check_in_day, check_in_year);
	check_out_date = mdy(check_out_month, check_out_day, check_out_year);
	format check_in_date check_out_date  date10.;
	
	if num_guests > 1 then 
	room_cost = room_rate * (check_out_date - check_in_date) + 10 * (num_guests-1);
	else 
	room_cost = room_rate * (check_out_date - check_in_date);
	
	if used_internet = 'YES' then internet_fee = 9.95 + 4.95 * days_internet_used; 
	
	sub_total = room_cost + internet_fee;
	grand_total = sub_total * 7.75 + sub_total;
	
run;

proc print data=q30;
run;


data q31;
	infile '/folders/myshortcuts/sas_cert/SAS/Chapter3_data/Employees.dat' pad;
	
	input ssn $ 1-11 name $ 15-40 @46 dob date10. +1 paygrade $4.+1 monthly_salary dollar8.2 job_title $ 73-99;
	age = int(yrdif(dob, today(), 'age'));
	if paygrade = 'GR20' then minimum = 50000;
		else if paygrade ='GR21' then minimum = 55000;
		else if paygrade ='GR22' then minimum = 60000;
		else if paygrade ='GR23' then minimum = 70000;
		else if paygrade ='GR24' then minimum = 80000;
		else if paygrade ='GR25' then minimum = 100000;
		else if paygrade ='GR26' then minimum = 120000;
	
	if paygrade = 'GR20' then maximum = 70000;
		else if paygrade ='GR21' then maximum = 75000;
		else if paygrade ='GR22' then maximum = 85000;
		else if paygrade ='GR23' then maximum = 100000;
		else if paygrade ='GR24' then maximum = 120000;
		else if paygrade ='GR25' then maximum = 150000;
		else if paygrade ='GR26' then maximum = 200000;
	
	expected_salary = (monthly_salary * 12) * 0.025 + (monthly_salary * 12);	
	if expected_salary > maximum then expected_salary = maximum;
	
	if find(job_title,  'Lead') > 1 then bonus = 1000;
	else if find(job_title, 'Manager') > 1 then bonus = 1000;
	else if find(job_title, 'Director') > 1 then bonus = 1000;
	else bonus = 0;
	
run;


proc print data=q31;
format minimum maximum expected_salary bonus dollar6.2;
run;

data q32;
	infile '/folders/myshortcuts/sas_cert/SAS/Chapter3_data/Conference.dat' pad; 
		input first_name $ 1-15 last_name $ 20-35 id 42-45 +1 business_phone $13. +1 
		home_phone $13. +1 mobile_phone $13. +1 contact_business $3. +1 contact_home $3. +1 
		contact_mobile $3. +1 registration_rate 3. +1 attend_wed $3. +1 attend_thurs $3. +1
		volunteer $3. +1 eating_restrictions $24.;
	
		if registration_rate = 350 then group = 'Regular';
		else if registration_rate = 200 then group = 'Regular';
		else if registration_rate = 450 then group = 'Regular';
		else if registration_rate = 295 then group = 'Early';
		else if registration_rate = 150 then group = 'Early';
		else if registration_rate = 395 then group = 'Early';
		else if registration_rate = 550 then group = 'On-site';

		
		if length(business_phone) < 9 
			then area_code = substr(mobile_phone, 2, 3);
		else if length(mobile_phone) < 9 
			then area_code = substr(home_phone, 2, 3);
		else area_code = substr(business_phone, 2, 3);
		
		if find(propcase(eating_restrictions), 'Vegan') > 1;
			then vegetarian = 1;
		else if find(propcase(eating_restrictions), 'Vegetarian') > 1;
			then vegetarian = 1;
		else vegetarian = 0;
run;


data q33;
	infile '/folders/myshortcuts/sas_cert/SAS/Chapter3_data/RoseBowl.dat'; 	
	input game_date ddmmyy10. +1 winning_team $ 12-34 winning_score 38-39  losing_team $ 40-60 losing_score 67-68;
	point_diff = winning_score - losing_score;
	modify q33;
	by winning_team game_date;
	format game_date weekdate17.;
	game_number+1;


run;

	

proc sort data=q33;
	by winning_team game_date;
run;

data a;
	set q33;
	by winning_team game_date;
	retain wins;
	if first.winning_team then wins = 1;
	else wins +1;
run;



data q34(drop=i in1 - in119 out1 - out119);
		infile '/folders/myshortcuts/sas_cert/SAS/Chapter3_data/NewYears.dat' dlm=','; 	
		length member_id 3.;
		length status $15.;
		
		array checkin (119) $ in1 - in119;
		array checkout (119) $  out1 - out119;
		
		input member_id checkin(*)  checkout(*) ;	
	    array checkin2 in_time_day1 - in_time_day119;
	    array checkout2 out_time_day1 - out_time_day119;
	   	do i = 1 to 119;
	    	checkin2(i) = input(checkin(i), hhmmss.);
	    	checkout2(i) = input(checkout(i), hhmmss.);
	    end;	
	    
		do i = 1 to 119;
		if checkin2(i) = . then status = 'not eligible';
		else if checkout2(i) - checkin2(i) ge 1800
		then status = 'eligible';
		else status = 'not eligible';
	
		average_mins_spent = mean(checkout2(i) - checkin2(i)) / 60;
		end;
		run;

proc print data=q34;
run;	

data q35;
	infile '/folders/myshortcuts/sas_cert/SAS/Chapter3_data/BenAndJerrys.dat' dlm = ',' dsd;
	length flavor $40.;
	input flavor portion_size calories calories_from_fat fat saturated_fat trans_fat cholesterol sodium total_carb dietary_fiber $ sugars protein year_introduced  year_retired  content_description $20. notes $20.;
	
	if year_retired ne . or find(notes, 'Scoop Shop Exclusive') = 1
	then delete;
	
	if calories = . then delete;
	else calories_per_tb = (calories / portion_size) * 15 ;
	
	retain total_calories;
	total_calories = sum(total_calories, calories_per_tb);
	
	retain most_calories 0;
	most_calories = max(calories_per_tb);
	

run;
proc print data=q35;
run;		

data q36(drop=i); 
		infile '/folders/myshortcuts/sas_cert/SAS/Chapter3_data/WLSurveys.dat' dlm ='	';
		
		array v1 (6) visit_one_q1 - visit_one_q6; 
		array v2 (6) visit_two_q1 - visit_two_q6;
		array v3 (6) visit_three_q1 - visit_three_q6;
		array v4 (6) visit_four_q1 - visit_four_q6;
		array v5 (6) visit_five_q1 - visit_five_q6;
		
		input subject_id height weight1- weight5 v1 (*) v1 (*) v2 (*) v3 (*) v4 (*) v5 (*);
		
		array old (15) 
		visit_one_q2 visit_one_q3 visit_one_q5 
		visit_two_q2 visit_two_q3  visit_two_q5 
		visit_three_q2 visit_three_q3  visit_three_q5 
		visit_four_q2 visit_four_q3  visit_four_q5 
		visit_five_q2 visit_five_q3  visit_five_q5 ;
		
		do i = 1 to 15;
			if old(i) = 0 then old(i) = 3;
			else if old(i) = 1 then old(i) = 2;
			else if old(i) = 2 then old(i) = 1;
			else if old(i) = 3 then old(i) = 0;
		end;
		
		do i =  1 to 6;
			if v1(i) = -99 then v1(i) = .;
			if v2(i) = -99 then v2(i) = .;
			if v3(i) = -99 then v3(i) = .;
			if v4(i) = -99 then v4(i) = .;
			if v5(i) = -99 then v5(i) = .;
		end;
		
		array bmi (5) bmi1 - bmi5;
		array weights (5) weight1- weight5;
		
		do i = 1 to 5;
			bmi(i) = (weights(i) / height) * 703;
		end;
		
		run ;
		
proc print data=q36;
run;
