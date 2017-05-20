/* Import Data */
PROC IMPORT OUT= WORK.carmpg
DATAFILE= "C:\Users\toami\Documents\MastersInDataScience\QTW\CaseStudies\car_mpg.csv" 
DBMS=CSV REPLACE;
GETNAMES=YES;
DATAROW=2; 
RUN;


/*Missing Data Pattern */
ods select misspattern;
PROC MI data=carmpg nimpute=0;
var  mpg cylinders size hp weight accel eng_type;
run;
quit;

/*Initial Analysis*/

title ' Predicting MPG: Initial Analysis';
PROC REG data=carmpg;
model mpg= cylinders size hp weight accel eng_type;
run;
quit;

PROC MI data=carmpg nimpute=5
out= miout seed=35399;
var mpg cylinders size hp weight accel eng_type;
run;

title ' PROC Reg imputation output ';
PROC REG data=miout outest= outreg
       covout;
     model mpg=cylinders size hp weight accel eng_type;
by _imputation_;
run;

PROC MIANALYZE data=outreg;
modeleffects cylinders size hp weight accel eng_type Intercept;
run;
