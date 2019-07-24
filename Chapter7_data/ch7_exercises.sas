/* ch 7 */
libname ch7 '/folders/myshortcuts/sas_cert/SAS/Chapter7_data';
%let col = Origin;
%let val = Thailand;

data cats;
set ch7.cats;
run;

%let col = derivation;
%let val = Mutation;

proc freq data=cats;
	tables &col * breed / nocol norow;
	where &col = "&val";
run;


%macro cat_macro(col=,val=);
proc freq data=cats;
	tables &col * breed / nocol norow;
	where &col = "&val";
run;
%mend cat_macro;

%LET val= Long;
%LET col= Hair;
ods pdf file="/folders/myshortcuts/sas_cert/SAS/Chapter7_data/cat_output_&val.pdf"; 
%cat_macro(col = &col, val = &val);
ods pdf close;


%macro temp_macro(col=);

%if col = month %then %do;
proc freq data=ch7.virginiakey;
tables month;
run;
%end;

%else %if col = warning %then %do;
proc freq data=ch7.virginiakey;
tables month;
run;
%end;

%else %if col = airtemp %then %do;
proc means data =ch7.virginiakey N Mean std min max;
var airtemp; 
run;
%end;

%else %if col = windspeed %then %do;
proc means data =ch7.virginiakey N Mean std min max;
var airtemp; 
run;
%end;

title "report for variable &col";
%mend temp_macro;

libname ch7 '/folders/myshortcuts/sas_cert/SAS/Chapter7_data';

proc sort data = ch7.airtraffic;
by airline;
run;
%let year_val = 1992;
%let city_val = BOS;
options noserror;

%macro flying(year_val, city_val);

proc means data = ch7.airtraffic sum noprint;
var quarter airline &city_valpassengers &year_valflights;

where year = &year_val;
by airline quarter;
output out = &city_val_report(drop=_type_ _freq_)
		sum(&city_valpassengers &city_valflights) = sum_pass sum_flights;
run;

proc sort data = &city_val_report;
by Descending sum_pass;
run;

data _null_;
set &city_val_report;
if _n_ = 1 then call symput("most_passenger", airline);
else stop;
run;

data &city_val&year_val;
set &city_val_report;
airport = $city_val;
where airline = &most_passenger;
run;
%mend flying;


%flying(year_val=&year_val, city_val=&city_val);



libname ch7 '/folders/myshortcuts/sas_cert/SAS/Chapter7_data';


data q22;
set ch7.studytime;
hours_per_unit = time / units; 
run;

proc sort data=q22;
by section;
run;

proc means data = q22;
	by section;
	var hours_per_unit;
	output out = rate_output(drop = _freq_ _type_) 
	mean(hours_per_unit) = avg_time;
run;
	
	 
proc print data = rate_output;
run;

%macro print_avg_per_class(section=);
data _null_;
	set rate_output;
	call_symput('study_time', avg_time)
	where section = &section;
run;

%if &avg_time > 2 %then %do;
proc print data = study;
	title "Average Study Time Per Student of Section &Section";
	footnote "Note: Section &Section study time meets 2 hour minimum with an average time of &avgstudy";
	where section = &section;
run;
%end;

%else %if &avgstudy <= 2 %then %do;
proc print data = study;
	title "Average Study Time Per Student of Section &Section";
	footnote "Note: Section &Section study time does not meet 2 hour minimum with an average time of &avgstudy";
	where Section = &Section;
run;
%end;
%mend print_avg_per_class;

%print_avg_per_class(Section='01');
%print_avg_per_class(Section='02');	
%let min_price = 800000;
%let house_type = 1;


libname ch7 '/folders/myshortcuts/sas_cert/SAS/Chapter7_data';

options symbolgen;

%macro loans(min_price=, house_type=);
data find; 
set ch7.loanapp;
where loanapproved= 1 and price > &min_price and proptype = &house_type;
run;

proc sort data =find;
by branch;
run; 

%if &house_type=1 %then %do;
proc means data = find;
	by branch;
		var creditscore interest percentdown;
		output out = type_&house_type(drop = _freq_ _type_)
		mean (creditscore interest percentdown) = mean_credit_score mean_interest mean_percent_down;
run;

data type_&house_type;
	set type_&house_type;
	cutoff = &min_price;
	
	length property_type  $30;
	
	property_type='primary residence';
	
run;
%end;

%else %do;
proc means data = find;
	by branch;
		var creditscore interest percentdown;
		output out = type_&house_type(drop = _freq_ _type_)
		mean (creditscore interest percentdown) = mean_credit_score mean_interest mean_percent_down;
run;

data type_&house_type;
	set type_&house_type;
		
	length property_type  $30;

if &house_type = 2 then property_type = "second residence"; 
	else if &house_type = 3 then property_type = "investment or rental"; 
	else if &house_type = 4 then property_type = "commercial property"; 
	else property_type = 'unknown';

cutoff = &min_price;
run;
%end;
%mend loans;

%loans(house_type=1, min_price=800000);
%loans(house_type=2, min_price=800000);
%loans(house_type=3, min_price=1000000);
%loans(house_type=4, min_price=1200000);

data together;
	set type_1 type_2 type_3 type_4;
run;

proc print data = together;

format cutoff dollar8.
mean_credit_score 6.2 mean_interest 6.2 mean_percent_down 6.2;
run;
