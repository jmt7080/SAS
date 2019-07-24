/* ch 4 */
data q37;
set '/folders/myshortcuts/sas_cert/SAS/Chapter4_data/crayons.sas7bdat';
year = year(issued);
rgb = compress(rgb, '(,)');
run;

proc contents data = q37;
run;

proc summary data = q37 print;
run;
/* color = char 26 length */
proc sort data =q37;
by color;
run;
proc freq data =q37;
tables issued * color;
run;
proc sort data=q37;
by rgb;
run;

proc print data=q37;
var rgb color;
run;

data q38; 
infile '/folders/myshortcuts/sas_cert/SAS/Chapter4_data/Donations.dat';
input donor_id @5 first_name $12. @19 last_name $12. @33 street $20. @58 area $20. 
		@89 state $2. @94 zip 5. @100 amount @105 month_donated;
		month = put(mdy(input(substr( put(month_donated,4.) ,3),2.),1,2000),monname3.);
		format amount dollar8.2;
		
file '/folders/myshortcuts/sas_cert/SAS/Chapter4_data/letter.txt' PRINT;

put @5 'To' first_name last_name
// street // area  state zip //

@5 'Thank you for your support! Your donations help us to save hundreds of cats and dogs each year.' 
// @5 'Donations to Coastal Humane Society' // '(Tax ID: 99-5551212)'//
@5 month amount;
put _page_;

run;

data q39;
set '/folders/myshortcuts/sas_cert/SAS/Chapter4_data/gas.sas7bdat';
if month = 1 then quarter = 1;
else if month = 2 then quarter = 1;
else if month = 3 then quarter = 1;
else if month = 4 then quarter = 2;
else if month = 5 then quarter = 2;
else if month = 6 then quarter = 2;
else if month = 7 then quarter = 3;
else if month = 8 then quarter = 3;
else if month = 9 then quarter = 3;
else if month = 10 then quarter = 4;
else if month = 11 then quarter = 4;
else if month = 12 then quarter = 4;

run;

proc sort data=q39;
by year;
run;

proc means data =q39 min max maxdec=2;
by year;
var GasPrice;
run;

proc sort data=q39;
by quarter;
run;

proc means data =q39 mean std maxdec=2;
by quarter;
var GasPrice;
output out = total;
run;

proc means data =q39  maxdec=2;
by year;
var GasPrice year quarter;
output out = total
mean(gasprice) = average_price
std(gasprice) = standard_deviation_price;
run;



data q40;
set '/folders/myshortcuts/sas_cert/SAS/Chapter4_data/sff.sas7bdat';

if april = . then april_cases = 'N';
else if april > 0 then april_cases = 'Y';

if aug = . then august_cases = 'N';
else if aug > 0 then august_cases = 'Y';

if firstdeath ne . and  firstcase = . then error = 'Y';
else error = 'N';
run;

proc report data =q40;
column error, continent country;
define error / group;
define continent / across;
run;





libname library '/folders/myshortcuts/sas_cert/SAS/Chapter4_data';
proc format lib=library;
value tried
. = 'N/A'
1 = 'Never'
2 = 'Might'
3 = 'At least once'
4 = 'Occassionally'
5 = 'Often';
run;

data q41;
set '/folders/myshortcuts/sas_cert/SAS/Chapter4_data/pizzaratings.sas7bdat';
run;

proc print data=q41;
run;

proc report data=q41 missing;
column topping rating, MEAN;
define topping / group;
run;


data q42;
set '/folders/myshortcuts/sas_cert/SAS/Chapter4_data/conference.sas7bdat';
run;

proc print data=q42;
run;

proc report data=q42;
column areacode attendeeid, n;
define areacode / group;
run;

libname library '/folders/myshortcuts/sas_cert/SAS/Chapter4_data';
proc format lib=library;
value veggies
0 = 'No'
1 = 'Yes';
run;

proc report data=q42;
column attendeeid, PCTN areacode regtype;
define regtype / group;
define areacode / group;
run;

proc tabulate data=q42;
class areacode regtype ;
tables areacode * regtype ;
run;

data q43;
set '/folders/myshortcuts/sas_cert/SAS/Chapter4_data/elliptical.sas7bdat';
run;

proc print data=q43;
run;

proc report data=q43;
column state shipping total_cost tax region;
define shipping / analysis mean;
define state / group;
run;

proc report data=q43;
column cost machine shipping tax total_cost state region;
define total_cost / computed;
define machine / N;
compute total_cost;
total_cost = shipping + tax + cost;
endcomp;
compute region / char length =10;
if state = 'California' then region = 'West Coast';
else if state  = 'Oregon' then region = 'West Coast';
else if state ='Washington' then region = 'West Coast';
else region ='Other';
endcomp;

define region / group;
define machine / group;
run;




data q44;
set '/folders/myshortcuts/sas_cert/SAS/Chapter4_data/diving.sas7bdat';
run;

proc print data=q44;
run;

proc means data=q44 min max mean;
var score1 score2;
run;

proc format;
value judge
0 -< 0.5 = 'Completely Failed'
0.5 -< 2.5 = ' UnSatisfactory'
2.5 -< 5 = 'Deficient'
5 -< 7 = 'Satisfactory'
7 -< 8.5 = 'Good'
8.5 -< 9.5 = 'Very Good'
9.5 - HIGH = 'Excellent';
run;

proc summary data=q44 sum print;
var score1 score2;
class name;
run;