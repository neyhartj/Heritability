/************************************************************************************************/
/*                             _  _ ___    ___       _                                          */
/*                            | || |_  )  / _ \ __ _| |_____ _  _                               */
/*                            | __ |/ /  | (_) / _` | / / -_) || |                              */
/*                            |_||_/___|  \___/\__,_|_\_\___|\_, |                              */
/*                                                           |__/                               */
/*                                                                                              */
/*	This macro computes the entry-based heritability also known as "generalized heritability"   */
/*  based on eigenvalue analyses.                                                    		    */			
/*																								*/
/*	Example application code can be found on https://github.com/PaulSchmidtGit/Heritability     */
/*																								*/
/*	This method is based on																		*/
/*		Oakey, H., A. Verbyla, and W. Pitchford, and B. Cullis, and H. Kuchel. 2006. Joint      */
/* 		modeling of additive and non-additive genetic line effects in single field trials.      */
/*      TAG. Theoretical and applied genetics.							                        */
/*		[p. 813]																	            */
/*																								*/
/*	Requirements/Input:																			*/
/*		The model that is used to analyze the data beforehand should have a random genotype     */
/*      main in order to obtain the estimated variance-covariance matrices of (i) the random    */
/*      genotype effects and (ii) the genotype BLUPs. 											*/
/*																								*/
/*		SAS/STAT																				*/
/*			Name of genetic effect																*/
/*				ENTRY_NAME=	specifies the genotypic treatment factor (e.g. var, entry, gen, g).	*/	
/*			Dataset 'MMEQSOL'																	*/
/*				MMEQSOL= specifies the MIXED / GLIMMIX ODS output with the solutions of the 	*/
/*				mixed model equations, which requires the MMEQSOL option in the PROC statement. */
/*			Dataset 'G'																	        */
/*				G= specifies the MIXED / GLIMMIX ODS output with the estimated                  */
/*				variance-covariance matrix of the random effects, which requires the G option   */
/*				in the RANDOM statement.													    */
/*          Dataset 'SOLUTIONF'                                                                 */
/*              SOLUTIONF= specifies the MIXED / GLIMMIX ODS output with fixed-effects solution */
/*              vector, which requires the S option in the model statement.                     */
/*			Name for output file																*/
/*				OUTPUT= specifies the name for the output dataset.								*/
/*																								*/
/*	Note that in order to prevent complications due to overwritten data, one should not use 	*/
/*	dataset names starting with "xm_" as some are used in this macro.							*/
/*																								*/
/*	Version 02 October 2018  																	*/
/*																								*/
/*	Written by: Paul Schmidt (Paul.Schmidt@uni-hohenheim.de)									*/
/*																								*/
/************************************************************************************************/

%MACRO H2Oakey(ENTRY_NAME=, MMEQSOL=, G= ,SOLUTIONF=, OUTPUT= );

	/* Run Macros directly from GitHub */
	filename _inbox "%sysfunc(getoption(work))/MACROS getC22g getGFD getGamma.sas";
		proc http method="get" 
		url="https://raw.githubusercontent.com/PaulSchmidtGit/Heritability/master/Alternative%20Heritability%20Measures/SAS/MACROS%20getC22g%20getGFD%20getGamma.sas" out=_inbox;
		run; %Include _inbox; filename _inbox clear;

	/* (i) Extract C22g Matrix "xm_c22g" from MMEQSOL */
	%getC22g(ENTRY_NAME=&ENTRY_NAME., MMEQSOL=&MMEQSOL., SOLUTIONF=);
	
	/* (ii) Extract Gg Matrix "m_D" from G */
	%getGFD(ENTRY_NAME=&ENTRY_NAME., G=&G.);

	PROC IML;
		USE xm_C22g; READ ALL INTO C22g;
		USE m_D;    READ ALL INTO D;

		n_g		 = nrow(D);						  /* number of genotypes */
		inv_D	 = inv(D);						  /* inverse of D */
		M        = I(nrow(D)) - (inv_D * C22g);
		CALL SVD(u, eM, v, M); 					  /* get eigenvalues */
		xm_H2Oak  = sum(eM)/(nrow(eM)-1);         /* divide sum of eigenvalues by number of genotypes minus 1 */

		CREATE xm_H2Oak FROM xm_H2Oak; APPEND FROM xm_H2Oak;
	QUIT; RUN;

	/* Final formatting */
	DATA &OUTPUT.;
		SET xm_H2Oak;
		LABEL  COL1  ="H� Oakey";
		FORMAT COL1 8.2;
		RUN;

	/* Delete temporary files */
	PROC DATASETS LIBRARY=work;
   		DELETE xm_H2Oak;
	RUN;

%MEND H2Oakey;
