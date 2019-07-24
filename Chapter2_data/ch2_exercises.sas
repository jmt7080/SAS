/* ch 2 */
data q43;
	infile '/folders/myshortcuts/sas_cert/SAS/Chapter2_data/CancerRates.dat';
	input id type $ number;
run;

data q44;
	infile '/folders/myshortcuts/sas_cert/SAS/Chapter2_data/AKCbreeds.dat';
	input breed $ 1-25 num1 num2 num3 num4;
run;

data q45;
	infile '/folders/myshortcuts/sas_cert/SAS/Chapter2_data/Vaccines.dat' missover;	
	input vaccine $ 1-30 method $ 31-50 num1 num2 q1 $ q2 $ q3 $ q4 $ q5 $ q6 $ q7 $;
run;


data q46 (drop= n1 n2 n3 n4);
	infile '/folders/myshortcuts/sas_cert/SAS/Chapter2_data/BigCompanies.dat';
	input id 3. Company $30. Country $15. n1 $ n2 $ n3 $ n4 $;
	sales = input(compress(n1, '', 'kd'), dollar13.2) * 1000000000; 
	profits = input(compress(n2, '', 'kd'), dollar13.2) * 1000000000; 
	assets = input(compress(n3, '', 'kd'), dollar13.2) * 1000000000; 
	market_value = input(compress(n4, '', 'kd'), dollar13.2) * 1000000000; 
run;

data q47;
	infile '/folders/myshortcuts/sas_cert/SAS/Chapter2_data/Crayons.dat' missover;
	input crayon_num crayon_color $27. +1 hex_code $8. +1 triplets $17. packsize year_issued year_retired; 
run;

data q48;
	infile '/folders/myshortcuts/sas_cert/SAS/Chapter2_data/Mountains.dat' pad;
	input name $38. height_m comma6. height_ft comma9. year_ascent $ prominence comma8.;
run;

proc print data = q48;
run;

data q49;
		infile '/folders/myshortcuts/sas_cert/SAS/Chapter2_data/CompUsers.dat';
		length first_name $12;
		length last_name $12;
		length email $30;
		length campus_phone $25;
		input id class_group $ first_name $ last_name $ / email $ campus_phone $ department $;
		email = trim(tranwrd(email, 'email:', ' '));
		campus_phone = trim(tranwrd(campus_phone, 'phone:', ' '));
run; 

proc print data = q49;
run;

data q50;
		infile '/folders/myshortcuts/sas_cert/SAS/Chapter2_data/SwineFlu2009.dat';
		input first_id_date 1-3 continent_id_case 14-17 country $ 27 - 59 +1 date_first_reported yymmdd10. 
		april_cases 78-87 may_cases 88-93 june_cases 98-103 july_cases 108-113 august_cases 118-123 last_reported_cases 128-133
		death_date_id 145-148 continent_id_death 155-158 first_death_date @168 first_death_date yymmdd10. 
		@192 may_deaths 5. @202 june_deaths 5. @212 July_deaths 5. @222 August_deaths 5. @232 September_deaths 5.
	    @242 October_deaths  5. @252 November_deaths  5. @262 December_deaths 5.; run;
		label first_id_Date = 'Date of first case reported ';
		label continent_id_case = 'Continent and country identifier';
		label date_first_reported = 'date first reported';
		label april_cases = 'Number of cases reported in april';
		label may_cases = 'Number of cases reported in may';
		label june_cases = 'Number of cases reported in june';
		label july_cases = 'Number of cases reported in july';
		label august_cases = 'Number of cases reported in august';
		label last_reported_cases = 'Last reported number of cases';
		label death_date_id = 'Date of first death';
		label continent_id_death = 'Continent and country identifier';
		label first_death_date = 'Date of first death reported';
		label may_deaths = 'Number of deaths reported in may';
		label june_deaths = 'Number of deaths reported in june';
		label july_deaths = 'Number of deaths reported in july';
		label august_deaths = 'Number of deaths reported in august';
		label september_deaths = 'Number of deaths reported in september';
		label october_deaths = 'Number of deaths reported in october';
		label november_deaths = 'Number of deaths reported in november';
		label december_deaths = 'Number of deaths reported in december';
run;		


proc print data = q50 label;	
run;	

		
data q51;
	infile '/folders/myshortcuts/sas_cert/SAS/Chapter2_data/BenAndJerrys.dat' dlm = ',' dsd;
	length flavor $40.;
	length content_description $40.;
	length notes $40.;
	input flavor portion_size calories calories_from_fat fat saturated_fat trans_fat cholesterol sodium total_carb dietary_fiber $ sugars protein year_introduced $ year_retired $ content_description notes ;

run;

proc print data = q51;	
run;


proc import datafile = '/folders/myshortcuts/sas_cert/SAS/Chapter2_data/Oscars.xlsx' out =oscars;
run;
proc contents data=oscars;
run;


data q53;
	infile '/folders/myshortcuts/sas_cert/SAS/Chapter2_data/Tchol.dat'; 
	input subject_id group $ @; 
		if group ='Treatment' then do 
		input cholesterol_diff pre_treatment_chol post_treatment_chol;
run;		
		
data q53;
	infile '/folders/myshortcuts/sas_cert/SAS/Chapter2_data/Tchol.dat'; 
	length group $10.;
	input subject_id group cholesterol_diff pre_treatment_chol post_treatment_chol @@;
		
run;

data q53;
	infile '/folders/myshortcuts/sas_cert/SAS/Chapter2_data/Tchol.dat'; 
	length group $10.;
	input subject_id group @;
		if group='Treatment' then do; 
			input cholesterol_diff pre_treatment_chol post_treatment_chol @@;	
		end;
		else if group='Control' then delete;
run;

proc import datafile = '/folders/myshortcuts/sas_cert/SAS/Chapter2_data/Pizza.csv' out=pizza;
run;
proc contents data=pizza;
run;

proc print data=pizza;
run;

data q54;
	infile '/folders/myshortcuts/sas_cert/SAS/Chapter2_data/Pizza.csv' dlm=','; 
	input survey_num arugula pinenut squash shrimp eggplant;
	if _n_ = 1 then delete;
run;
