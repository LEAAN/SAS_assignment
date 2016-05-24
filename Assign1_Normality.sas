/* 1.Check normalization of raw data; */
* Outlier-free subset;
data outlier_free;
	set sliced;
	where hampel = 0;
run;
* variance & mean;
proc means data = outlier_free;
	var outcome;
	where run = 2;
	by batch run;
	output out = variance_mean
	mean = mean
	var = variance;
run;
* initial data doesn't follow normal distribution;
proc univariate data=sliced;
	var outcome;
	* by batch;
	* histogram outcome/normal;
	qqplot outcome/normal;
run;
* Lognormal;
proc univariate data=outlier_free normaltest ROBUSTSCALE;
	var outcome;
	by batch run;
	*histogram outcome/lognormal;
	*probplot outcome/ lognormal(theta=est zeta=est sigma= 0.9) href=95 lhref=1 
		square;
	output out = normality;
	*nor = normality;
run;
* log scale of initial dataset;
data log;
	set outlier_free;
	log_outcome = log(outcome);
run;
* T-test;
* 有没有更智能的方法;
data b0b1;
	set outlier_free;
	if BATCH ^='B0' and BATCH ^= 'B1'
	then delete;
run;
PROC TTEST DATA=b0b1;
	*where BATCH = 'B0' or 'B1';
	CLASS BATCH;
	VAR outcome;
RUN;
