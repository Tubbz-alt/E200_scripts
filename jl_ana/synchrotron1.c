#include<stdio.h>
#include<gsl/gsl_sf_synchrotron.h>
#include<stdlib.h>
#include<gsl/gsl_sf_log.h>

int main( int argc, char* argv[]){
  int i;	
  
  
double x=0;
double step_1= 0.000001;
double step_2= 0.0005;	
double step_3= 0.002;
double step_4= 0.01;
double step_5= 7;

//int n=atoi(argv[1]);
int n=5600;
	
double* tab_x;
double* tab_F;
double* tab_logF;

FILE* fp;
//fp= fopen("/home/jacques/Bureau/synchrotron1.txt","w");
fp= fopen("/Users/scorde/Dropbox/SeB/Codes/sources/E200_scripts/jl_ana/synchrotron1bis.txt","w");
if(fp==NULL){
	printf("invalid path"); 
	return 0;}

tab_x= (double*) malloc(n*sizeof(double));
tab_F= (double*) malloc(n*sizeof(double));
tab_logF= (double*) malloc(n*sizeof(double));


for (i=0;i<500;i++){
	x= x + step_1;
	tab_x[i]=x;	
	tab_F[i]=gsl_sf_synchrotron_1(x);
	tab_logF[i]=gsl_sf_log(tab_F[i]);
			}

for (i=500;i<2500;i++){
	x= x + step_2;
	tab_x[i]=x;	
	tab_F[i]=gsl_sf_synchrotron_1(x);
	tab_logF[i]=gsl_sf_log(tab_F[i]);
			}

for (i=2500;i<4500;i++){
	x= x + step_3;
	tab_x[i]=x;	
	tab_F[i]=gsl_sf_synchrotron_1(x);
	tab_logF[i]=gsl_sf_log(tab_F[i]);
			}

for (i=4500;i<5500;i++){
	x= x + step_4;
	tab_x[i]=x;	
	tab_F[i]=gsl_sf_synchrotron_1(x);
	tab_logF[i]=gsl_sf_log(tab_F[i]);
			}

for (i=5500;i<5600;i++){
	x= x + step_5;
	tab_x[i]=x;	
	tab_F[i]=gsl_sf_synchrotron_1(x);
	tab_logF[i]=gsl_sf_log(tab_F[i]);
			}

    
for (i=0;i<n;i++){
	printf("%f ", tab_x[i]);
	fprintf(fp, "%f ", tab_x[i]);
	}

	printf("\n");
	fprintf(fp,"\n");

for (i=0;i<n;i++){
	printf("%f ", tab_F[i]);
	fprintf(fp, "%f ", tab_F[i]);
	}

	printf("\n");
	fprintf(fp,"\n");

for (i=0;i<n;i++){
	printf("%f ", tab_logF[i]);
	fprintf(fp, "%f ", tab_logF[i]);
	}
	
	printf("\n");
fclose(fp);
free(tab_x);
free(tab_F);
free(tab_logF);
	
  return 0;
}
