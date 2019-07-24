/* ch 6 */

data aus;
set '/folders/myshortcuts/sas_cert/SAS/Chapter6_data/australia.sas7bdat';
rank = _N_;
run;

data bra (rename=(Menina = Girl Menino = Boy));
set '/folders/myshortcuts/sas_cert/SAS/Chapter6_data/brazil.sas7bdat';
rank = _N_;
run;

data fra (rename=(Fille = Girl Garcon = Boy));
set '/folders/myshortcuts/sas_cert/SAS/Chapter6_data/france.sas7bdat';
rank = _N_;
run;

data ind (rename=(Laraki = Girl Laraka = Boy));
set '/folders/myshortcuts/sas_cert/SAS/Chapter6_data/india.sas7bdat';
rank = _N_;
run;

data rus (rename=(Devushka = Girl Malchik = Boy));
set '/folders/myshortcuts/sas_cert/SAS/Chapter6_data/russia.sas7bdat';
rank = _N_;
run;
data us;
set '/folders/myshortcuts/sas_cert/SAS/Chapter6_data/unitedstates.sas7bdat';
rank = _N_;
run;

data q29;
set aus bra fra ind rus us;
run;

proc sort data= q29;
by rank;
run;

data q29;
set aus bra fra ind rus us;
by rank;
run;

data district(rename=(cg = curriculumgrd));
set '/folders/myshortcuts/sas_cert/SAS/Chapter6_data/district.sas7bdat';
run;

data teachers;
set '/folders/myshortcuts/sas_cert/SAS/Chapter6_data/teachers.sas7bdat';
run;

proc sort data = district;
by curriculumgrd;
run;

proc sort data = teachers;
by curriculumgrd;
run;


data q30(where= (teacherscore ^= .));
 merge district teachers;
 by curriculumgrd;
run;

proc sort data = q30;
by teacher;
run;

data q31;
set '/folders/myshortcuts/sas_cert/SAS/Chapter6_data/aveprices.sas7bdat';
run;

proc report data=q31 out=q31a;
columns year  commodity price, MEAN;
define commodity / group;
define year / group;
run;


proc report data=q31 out=q31b;
columns year month  commodity price, MEAN;
define commodity / group;
define year / group;
define month / group;
run;


proc format;
	value months
	1 = 'jan'
	2 = 'Feb'
	3 = 'Mar'
	4 = 'Apr'
	5 = 'May'
	6 = 'June'
	7 = 'July'
	8 = 'Aug'
	9 = 'Sept'
	10 = 'Oct'
	11 = 'Nov'
	12 = 'Dec';
run;

data q31c(drop=_BREAK_);
merge q31a q31b;
by year;
format month months.;
run;

data visits;
set '/folders/myshortcuts/sas_cert/SAS/Chapter6_data/visits.sas7bdat';
run;

data txgroup;
set '/folders/myshortcuts/sas_cert/SAS/Chapter6_data/txgroup.sas7bdat';
run;

proc sort data = visits;
by id;
run;

proc sort data = txgroup noduprecs;
by id;
run;

data q32c;
merge visits txgroup;
by id;
run;

proc means data=q32 median;
var B_cholesterol;
output out = med_chol median(B_cholesterol) = Median_cholesterol;
run;

data q32d (drop= _TYPE_ _FREQ_);
if _n_ = 1 then set med_chol;
set q32c;
if B_cholesterol > median_cholesterol then chol_level = 'above';
else if B_cholesterol =< median_cholesterol then chol_level = 'below';
run;

data q32e;
	set q32d(keep=ID visitdt visit chol_level);
	
	array visits (3) visit1-visit3;
	
	do i = 1 to 3 by 1;
		visits(i) =  visitdt + (i * 30);
end;
drop i;
format visitdt mmddyy10. visit1-visit3 mmddyy10.;
run;
proc print data=q32d;
run;

data users;
set '/folders/myshortcuts/sas_cert/SAS/Chapter6_data/users.sas7bdat';
run;

data projects;
set '/folders/myshortcuts/sas_cert/SAS/Chapter6_data/projects.sas7bdat';
run;

proc sort data=projects;
by userid;
run;

data incomplete complete no_project;
merge users projects;
by userid;
if enddate = . then output incomplete;
else if enddate ne . then output complete;
else if projectid = . then output no_project;
 
if first.userid then total = 0;
if enddate <> . then total + 1;
run;

libname ch6 '/folders/myshortcuts/sas_cert/SAS/Chapter6_data'; 
proc sort data = ch6.iluvthe80s out=sorted_bands;
by band;
run;

data q34;
set sorted_bands;
if first.band then song_count = 0;
song_count + 1;
run;

proc sort data = q34 out = sorted_genre;
	by genre;
run;

proc means data = genre_sort median noprint;
	by genre;
	var length;
	output out = median_song_length(drop=_type_ _freq_) median(length) = MedianLength;
run;

libname ch6 '/folders/myshortcuts/sas_cert/SAS/Chapter6_data'; 

proc sort data = ch6.schoolsurvey out=sorted_survey;
by family_id;
run;


data sixth_grade(rename=(dob = sixthgrade_dob));
set sorted_survey;
where grade = '6th';
run;

data survey_merged;
merge sixth_grade sorted_survey;
by family_id;
age_diff_days = dob - sixthgrade_dob;
age_diff_years = yrdif(dob, sixthgrade_dob, '30/360');
run;

proc freq data = survey_merged;
	where age_diff_days < 0;
	tables family_id / out = older_sib(drop=percent rename=(count=older_siblings)) nopercent nocum norow nocol;
run;

proc freq data = survey_merged;
	where age_diff_days > 0;
	tables family_id / out = younger_sib(drop=percent rename=(count=younger_siblings)) nopercent nocum norow nocol;
run;

data sib_6grade_merged;
merge survey_merged  older_sib younger_sib;
by family_id;
run;


proc means data=sib_6grade_merged print MEAN MIN MAX;
	class school;
	var age_diff_days;
run;

proc print data = sib_6grade_merged;
run;

libname ch6 '/folders/myshortcuts/sas_cert/SAS/Chapter6_data'; 

proc print data=ch6.friends;
run;

proc print data=ch6.newinfo;
run;


data newinfo;
set ch6.newinfo;
run;

proc sort data=newinfo;
by id;
run;

data friends;
set ch6.friends;
run;

data friends;
update friends  newinfo;
by id;
run;

proc summary data=friends print sum;
var donation;
class id;
output out = friends_donations;
run;

data friends;
update friends friends_donations;
by id;
run;