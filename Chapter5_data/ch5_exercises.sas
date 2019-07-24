/* ch 5 */

ods pdf file ='/folders/myshortcuts/sas_cert/SAS/Chapter5_data/chapter5_data/earthquakes.pdf' STYLE=analysis;
ods noproctitle;
data q24;
set '/folders/myshortcuts/sas_cert/SAS/Chapter5_data/chapter5_data/earthquakes.sas7bdat';
if magnitude ge 7.0 then classified = 'great';
else if magnitude lt 7.0 then classified = 'major';
run;


proc freq data =q24;
tables state * classified /norow nocol ;
run;

ods pdf close;


ods listing;
ods html;
ods rtf;
ods pdf;
data q25;
set '/folders/myshortcuts/sas_cert/SAS/Chapter5_data/chapter5_data/crayons.sas7bdat';
run;

proc sort data=q25;
by issued;
run;

proc freq data=q25;
tables issued / norow nocol nocum nopercent;
 run;
proc report data=q25;
columns color hex issued;
run;

ods listing close;
ods html close;
ods rtf close;
ods pdf close;

ods html file='applicants.html';
ods pdf file = 'applicants.pdf'
data q26;
set '/folders/myshortcuts/sas_cert/SAS/Chapter5_data/chapter5_data/applications.sas7bdat';
if month(startdate) > 5 then ready = 'yes';
run;

proc freq data=q26;
tables typespeed  checkboxes desiredpay / norow nocol nocum nopercent;
run;

proc format;
	value speed 
	low - 40 = 'Slow'
	40 - 80 = 'Medium'
	80 - HIGH = 'Fast';
run;

proc report data=q26;
column applicant typespeed startdate desiredpay ready;
define startdate / format = ddmmyy10. style = {backgroundcolor=gray};
define desiredpay / style = {backgroundcolor=green fontsize=white};

format typespeed speed.; 

run;

title height = 18PT 'Applicants';
title height = 12PT 'based on typing speed and work availability';
ods html close;
ods pdf close;


data q27;
set '/folders/myshortcuts/sas_cert/SAS/Chapter5_data/chapter5_data/loanapp.sas7bdat';
run;

proc format;
	value branches
	1 = 'branch1'
	2 = 'branch2'
	3 = 'branch3'
	4 = 'branch4'
	5 = 'branch5';
	value approval
	1 = 'Yes'
	0 = ' No';
run;
	
proc freq data =q27;
tables branch*loanapproved / norow nocol nocum;
format branch branches. loanapproved approval.;
run;

ods rtf;

proc report data=q27;
column branch loanapproved, N loanamt, MEAN price, MEAN creditscore, MEDIAN;
where loanapproved = 1;
define branch / group;
format loanamt price dollar10.2;
title Height=18CM 'Branch and credit scores';
run;
ods rtf close;

data q28;
set '/folders/myshortcuts/sas_cert/SAS/Chapter5_data/chapter5_data/pvalues.sas7bdat';
run;


proc print data=q28;
run;