proc options option=date;
run;

/*--to define path of input files--*/
%let pathdm=/home/ameerkhoso470/workshop/DAPAssignment;
libname dm "&pathdm";

/*Import Procedure*/
data Work.Crime_data;
	/* to define length and type of variable; */
	length State $32
	 city  $32
	 year $32
	 Population 8
	 Violent_crime 8
	 Murder 8 
	 Rape_revised_defination 8
	 Rape_legacy_defination 8
	 Robbery 8 
	 Aggravated_assult 8
	 Property_crime 8
	 Burglary 8
	 Larcency_theft 8
	 Motor_vehicle_theft 8
	 Arson 8;

	/* to define file name and delimeter*/
	infile "&pathdm/DataSet.csv" dlm=',';

	/* to define length and type of variable from input file*/
	input State 
		
	city  $
	 year $
	 Population $
	 Violent_crime $
	 Murder $
	 Rape_revised_defination $
	 Rape_legacy_defination $ 
	 Robbery $ 
	 Aggravated_assult $
	 Property_crime $ 
	 Burglary $
	 Larcency_theft $ 
	 Motor_vehicle_theft $
	 Arson $;

	/* to define format of numeric fields */
	format Population COMMA12.2;
run;

/*--Pie Chart for Population--*/
title3 "Population across 3 States of US In 2014 and 2015";
/*--Define Pie Template--*/
proc template ;
	define statgraph WebOne.Pie;
		begingraph;
		layout region;
		piechart category=State response= population / start=90 centerFirstSlice=1;
		endlayout;
		endgraph;
	end;
run;
/*--Set output size--*/
ods graphics / reset imagemap;

/*--SGRENDER proc statement--*/
proc sgrender template=WebOne.Pie data=work.crime_data;
run;

ods graphics / reset;
--Set output size--/ ods graphics / reset imagemap;

/*--SGPLOT proc statement--*/
proc sgplot data=work.crime_data;
	/*--TITLE and FOOTNOTE--*/
	title 'Violent Crimes Occured in 3 different State';

	/*--Bar chart settings--*/
	vbar State / response=Violent_Crime group=Year groupdisplay=Cluster datalabel 
		stat=Sum name='Bar';

	/*--Response Axis--*/
	yaxis label='Violent Crime' grid;
run;

ods graphics / reset;
title;
--Set output size--/ ods graphics / reset imagemap;

/*--SGPLOT proc statement--*/
proc sgplot data=work.crime_data;
	/*--TITLE and FOOTNOTE--*/
	title 'Count of Robbery across 3 different States in US';

	/*--Bar chart settings--*/
	hbar State / response=Robbery group=Year groupdisplay=Cluster datalabel 
		stat=Sum;

	/*--Response Axis--*/
	xaxis grid;
run;

ods graphics / reset;
title;
/

/* Highest crime rate all three states*/
title1 'Highest Crime Rate in All three states';
proc means data=work.crime_data sum;
var Violent_crime Murder Rape_revised_defination Rape_legacy_defination 
Robbery Aggravated_assult Property_crime Burglary Larcency_theft  Motor_vehicle_theft Arson ;
run; 

/*number of cities within each states for the year 2014 and 2015 respectively*/
proc freq data=work.crime_data nlevels order=freq;
tables year*state / nopercent norow nocol list;
run;

/*Total crime in all three states*/
data work.crime_data;
infile "&pathdm/DataSet.csv" dlm=',';
   input state city year population Violent_crime Murder Rape_revised_defination Rape_legacy_defination Robbery 
   Aggravated_assult Property_crime Burglary Larcency_theft Motor_vehicle_theft Arson;
   Total_crime=sum(Violent_crime, Murder, Rape_revised_defination, Rape_legacy_defination, 
Robbery, Aggravated_assult, Property_crime, Burglary, Larcency_theft, Motor_vehicle_theft, Arson);
run;

/* Total crime in 2014*/
title 'Overall crime in all three states in 2014';
proc means data= work.crime_data;
where year=2014 ;
proc means data=work.crime_data sum nonobs;
class state city;
var total_crime;
run;

/*observe highest and lowest crime*/
title 'Highest and Lowest Crime';
proc univariate data=work.crime_data;
var total_crime;
run;
proc sort data=work.crime_data;
by year descending total_crime;
where year=2014 and population > 1000000;
run;
title 'CALIFORNIA SATAE CRIME DATA IN 2014';
proc print data=work.crime_data;
where State= CALIFORNIA and year=2014;
run;

data work.crime_data;
infile "&pathdm/DataSet.csv" dlm=',';
   input state city year population Violent_crime Murder Rape_revised_defination Rape_legacy_defination Robbery 
   Aggravated_assult Property_crime Burglary Larcency_theft Motor_vehicle_theft Arson;
   violent_crime =sum(Murder, Rape_revised_defination, Rape_legacy_defination, Robbery, Aggravated_assult);
  Property_crime= sum(Burglary, Larcency_theft, Motor_vehicle_theft, Arson);
     total_crime=sum(violent_crime, Property_crime);
  st_name=sum(CALIFORNIA,NEWYORK,TEXAS);
  total_city=sum(ANAHEIM,ANTIOCH,BAKERSFIELD,BERKELEY,BURBANK,CARLSBAD,CHULA_VISTA,CONCORD,CORONA,
  COSTA_MESA,DALY_CITY,DOWNEY,EL_CAJON,ELK_GROVE,EL_MONTE,ESCONDIDO,FAIRFIELD,FONTANA,FREMONT,FULLERTON,
  FULLERTON,GARDEN_GROVE,GLENDALE,HAYWARD,HAYWARD,HUNTINGTON_BEACH,INGLEWOOD,IRVINE,LANCASTER,LONG_BEACH,
  LOS_ANGELES,NORWALK,OCEANSIDE,ONTARIO,ORANGE,OXNARD,PALMDALE,PASADENA,POMONA,RANCHO_CUCAMONGA,RIALTO,MODESTO,
  MORENO_VALLEY,MURRIETA,RIVERSIDE,ROSEVILLE,SACRAMENTO,SALINAS,SAN_BERNARDINO,SAN_DIEGO,SAN_FRANCISCO,SAN_JOSE,
  SAN_MATEO,SANTA_ANA,SANTA_CLARA,SANTA_MARIA,SANTA_ROSA,SIMI_VALLEY,STOCKTON,STOCKTON,SUNNYVALE,TEMECULA,THOUSAND_OAKS,
  TORRANCE,VALLEJO,VENTURA,VICTORVILLE,VISALIA,WEST_COVINA,AMHERST_TOWN,BUFFALO,NEWYORK,ROCHESTER,SYRACUSE,YONKERS,
  ABILENE,ABILENE,AMARILLO,AMARILLO,ARLINGTON,BEAUMONT,BROWNSVILLE,CARROLLTON,COLLEGE_STATION,CORPUS_CHRISTI,DALLAS,DENTON,EL_PASO);
run;

PROC TABULATE DATA=work.Crime_data;
 title2 'Total Crimes By Categories & State over the years';
     CLASS  st_name year;
     VAR population violent_crime property_crime arson total_city;
     TABLE ST_name='' , 
           year*(population*(SUM=''*f=comma16.) 
           violent_crime*(SUM=''*f=comma16.) 
           property_crime*(sum=''*f=comma16.) 
           arson*(sum=''*f=comma16.) 
           total_city='Total Crime in State'*(sum=''*{s={fontweight=bold} f=comma16.}))
         / box='State';
RUN;

/* to break data into years 2014 / 2015*/
data work.crime_data;
format total_ratio 8. t_ratio 8.;
set dap.state_totals;
where year=2014;
total_ratio=(total_city_sum/population_sum)*100000;
t_ratio=total_ratio;
run;


/* Display Frequency of all crime attributes */
title 'Frequency Of All Crimes';
PROC FREQ DATA=work.crime_data;
TABLES state city year population Violent_crime Murder Rape_revised_defination Rape_legacy_defination Robbery 
   Aggravated_assult Property_crime Burglary Larcency_theft Motor_vehicle_theft Arson /  nocum;
RUN;

/* Plot histogram and summary statistics to bin data */
title 'Histogram and summary Statistics of Data';
PROC Univariate DATA =work.crime_data;
var population Violent_crime Murder Rape_revised_defination Rape_legacy_defination Robbery 
   Aggravated_assult Property_crime Burglary Larcency_theft Motor_vehicle_theft Arson;
   HISTOGRAM population Violent_crime Murder Rape_revised_defination Rape_legacy_defination Robbery 
  Aggravated_assult Property_crime Burglary Larcency_theft Motor_vehicle_theft Arson / NORMAL;
RUN;
/* Corss tabulation analysis 
proc freq data=work.crime_data order=freq;
   tables Murder*Robbery*Motor_vehicle_theft / nocum
       plots=freqplot(twoway=stacked orient=horizontal);
run; */

/*--Define Pie Template--*/
proc template ;
	define statgraph WebOne.Pie;
		begingraph;
		entrytitle 'Total Murders in 3 States';
		layout region;
		piechart category=State response=Murder / group=Year groupgap=2% 
			start=270 centerFirstSlice=1 datalabellocation=INSIDE;
		endlayout;
		endgraph;
	end;
run;

/*--Set output size--*/
ods graphics / reset imagemap;

/*--SGRENDER proc statement--*/
proc sgrender template=WebOne.Pie data=WORK.CRIME_DATA;
run;

ods graphics / reset;

/*--Set output size--*/
ods graphics / reset imagemap;


/*--Define Pie Template--*/
proc template ;
	define statgraph WebOne.Pie;
		begingraph;
		entrytitle 'Total Robbery in 3 States Robbery';
		layout region;
		piechart category=State response=Robbery / group=Year groupgap=2% 
			start=270 centerFirstSlice=1 datalabellocation=INSIDE;
		endlayout;
		endgraph;
	end;
run;

/*--Set output size--*/
ods graphics / reset imagemap;

/*--SGRENDER proc statement--*/
proc sgrender template=WebOne.Pie data=WORK.CRIME_DATA;
run;

ods graphics / reset;

/*--Set output size--*/
ods graphics / reset imagemap;

