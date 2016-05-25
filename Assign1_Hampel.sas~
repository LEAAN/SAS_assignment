LIBNAME SASDATA '/folders/myfolders/';
DATA MYDATA;
	SET SASDATA.assignment1;
RUN;
* Load sliced;
LIBNAME SASDATA '/folders/myfolders/';
DATA MYDATA;
	SET SASDATA.sliced;
RUN;
/* Print sliced;
proc print data=sliced;
	id outcome;
	by batch;
run;*/
* Create sliced;
DATA sliced;
	SET SASDATA.assignment1(keep=BATCH RUN OUTCOME);
run;

* 0.Remove outliers within batch;
* 1.Check normalization of raw data;
* 2.Check if double runs within batch influence outcome;
* 3. Do sth with outliers;
* 4. Do sth without outliers;
* Compare between run=0 & run=1;


/* Hampel's test; */
* Median by batch run;
proc means data=sliced median;
	var outcome;
	by batch run;
	output out=median
	median = median;
run;
* MAD by batch run;
proc univariate data=sliced ROBUSTSCALE;
	var outcome;
	by batch run;
	output out=MAD
		MAD = MAD;
run;
/*merge median and MAD*/
data MAD_median;
	merge median MAD;
	by batch run ;
run;
/*Duplicate MAD_median*/
data MAD_median_dup;
	set MAD_median;
	do i=1 to 6 by 1;
		output;
	end;
run;
* Merge with slice;
data sliced;
	merge sliced mad_median_dup (drop = i);
	by batch run;
	ANV = abs(outcome-median)/MAD;
	if ANV > 3.5
	then hampel = 1;
	else hampel = 0;
run;
/* 1.Check normalization of raw data; */
* initial data by batch doesn't follow normal distribution;
proc univariate data=sliced;
	var outcome;
	by batch;
	* histogram outcome/normal;
	qqplot outcome/normal;
run;
* Lognormal;
*symbol v=plus height=3.5pct;
title 'Lognormal Probability Plot for Position Deviations';

proc univariate data=sliced normaltest ROBUSTSCALE;
	by batch;
	probplot outcome/ lognormal(theta=est zeta=est sigma=0.7) href=95 lhref=1 
		square;
run;






