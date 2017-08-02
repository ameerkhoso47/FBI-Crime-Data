/** Import an XLSX file.  **/
PROC IMPORT 
		DATAFILE="/home/ameerkhoso470/workshop/DAPAssignment/PopulatedSatatesData.xlsx" 
		OUT=WORK.dap_assignment DBMS=XLSX REPLACE;
RUN;

/** Print the results. **/
PROC PRINT DATA=WORK.dap_assignment;
RUN;
/*
data = work.dap_assignment;

Rape=sum (rape_revised_defination, rape_legacy_defination);
Roberry=sum (robebery, Burlary);
Theft=sum (Larcency_theft, Motor_vehical_theft);
run; */

data work.dap_assignment;
Total_crime = Sum( murder, rape, robery, rape_revised_defination,
aggravated_assault,burlary,rape_legacy_defination,Larcency_theft, Motor_vehical_theft);
sum
run;
proc print data=work.dap_assignment;
run;

