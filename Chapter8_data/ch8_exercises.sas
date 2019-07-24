/* ch 8 */
libname ch8 '/folders/myshortcuts/sas_cert/SAS/Chapter8_data';

proc sgplot data =ch8.population;
histogram y1;
run;

proc sgpanel data = ch8.population;
	panelby continent;
	histogram y1;
run;

proc sgplot data = ch8.population;
vbox y1 / category = continent;
run;


libname ch8 '/folders/myshortcuts/sas_cert/SAS/Chapter8_data';
proc sgplot data = ch8.wls;
 vbar q1 / Missing;
run;

proc sgplot data =ch8.wls;
 vbar q1 / Missing
 stat = mean
 response = bmi;
run;

proc sgplot data =ch8.wls;
 vbar q1 / Missing
 stat = mean
 response = bmi
 limitstat = stderr;
run;

proc sgplot data =ch8.wls;
 vbar q1 / Missing
 stat = mean
 response = bmi
 limitstat = stderr;
 yaxis label = "Mean BMI";
 yaxis values = (15 to 30 by 2);
run;

proc transpose data = ch8.wls out=switch(rename=(_name_ = question col1 = answer));
by id bmi;
var q1-q30;
run;


data visits;
	set switch;
		
	if question IN ("Q1", "Q2", "Q3", "Q4", "Q5", "Q6") then visit = 1;
	else if question IN ("Q7", "Q8", "Q9", "Q10", "Q11", "Q12") then visit = 2;
	else if question IN ("Q13", "Q14", "Q15", "Q16", "Q17", "Q18") then visit = 3;
	else if question IN ("Q19", "Q20", "Q21", "Q22", "Q23", "Q24") then visit = 4;
	else if question IN ("Q25", "Q26", "Q27", "Q28", "Q29", "Q30") then visit = 5;	
else visit = .;

	if question IN ("Q1", "Q7", "Q13", "Q19", "Q25") then q_num = 1;
	else if question IN ("Q2", "Q8", "Q14", "Q20", "Q26") then q_num = 2;
	else if question IN ("Q3", "Q9", "Q15", "Q21", "Q27") then q_num = 3;
	else if question IN ("Q4", "Q10", "Q16", "Q22", "Q28") then q_num = 4;
	else if question IN ("Q5", "Q11", "Q17", "Q23", "Q29") then q_num = 5;
	else if question IN ("Q6", "Q12", "Q18", "Q24", "Q30") then q_num = 6;	
else q_num = .;

run;

proc sgpanel data = visits;
	panelby visit / COLUMNS=1;
	vbar q_num / MISSING 
	stat = MEAN
	response = BMI
	limitstat=  STDERR;
	rowaxis values = (20 to 30 by 1);
run; 
	
libname ch8 '/folders/myshortcuts/sas_cert/SAS/Chapter8_data';	

data q25;
set ch8.patents;
where patents > 100;
label = county;
if county not in ('Santa Clara County') then label = " ";
run;

proc sgplot data =q25;
	histogram patents;
	density patents / type = normal transparency=0.5;
run;

proc sgplot data =q25;
	scatter x = patents y = education / datalabel=label transparency=0.5;
run;


libname ch8 '/folders/myshortcuts/sas_cert/SAS/Chapter8_data';	

proc sgplot data=ch8.earthquakes(where=(year ge 2000));
scatter x = year y = magnitude;
series x = year y =magnitude / transparency= .5 ;
keylegend / noborder position = bottomright;
refline 4.0 5.0 6.0 7.0 / label=('light' 'moderate' 'strong' 'major');
run;




libname ch8 '/folders/myshortcuts/sas_cert/SAS/Chapter8_data';	
proc sgplot data =ch8.study_gpa;
vbox avetime / category = section;
run;

proc sgplot data =ch8.study_gpa;
reg x =avetime y =gpa / nolegcli;
run;

proc sgplot data =ch8.study_gpa;
reg x = avetime y =gpa / group=section clm clmtransparency=0.2;
keylegend / position=right;
run;



libname ch8 '/folders/myshortcuts/sas_cert/SAS/Chapter8_data';	

data q28;
set ch8.airlines(keep=passengers airline airportsize year);
run;

proc sgplot data=q28;
series x = year  y = passengers / group = airportsize;
run;

proc sgpanel data=q28;
 panelby airline / columns = 6; 
 series x = year  y = passengers;
run;