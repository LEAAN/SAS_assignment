LIBNAME SASDATA '/folders/myfolders/';
DATA MYDATA;
	SET SASDATA.assignment1;
RUN;
* Remove columns "unit" & "time";
DATA sliced;
	SET SASDATA.assignment1(keep=BATCH RUN OUTCOME);
run;
* Check normality of outcomes by batch;
proc univariate data=sliced normaltest ROBUSTSCALE;
	var outcome;
	by batch;	
run;
* Transfer outcome values to logarithmic scale;
data log;
	set sliced;
	log_outcome = log(outcome);
run;
proc univariate data=log normaltest ROBUSTSCALE;
	var log_outcome;
	qqplot log_outcome/normal;	
run;
* Check normality of outcomes by batch on logarithmic scale;
proc univariate data=log normaltest ROBUSTSCALE;
	qqplot outcome/normal;
	var log_outcome;
	by batch;
run;





