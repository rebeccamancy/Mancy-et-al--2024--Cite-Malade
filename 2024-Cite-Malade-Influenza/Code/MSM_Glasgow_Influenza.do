************************************************************************************************************************
************************************************************************************************************************
******************************* MARKOV SWITCHING MODEL *****************************************************************
************************************************************************************************************************
************************************************************************************************************************
************************************************************************************************************************
*** This .do file fits the markov switching model to the historical mortality data. ************************************
************************************************************************************************************************

clear
cls
pwd

** Load Influenza data
import excel "..\Data\Glasgow_Resp_Diseases.xlsx", firstrow
qui: gen log_influenza = log(Influenza)


** Fit MS model for Glasgow
tsset Year
mswitch dr log_influenza if inrange(Year,1907,1972), states(2) varswitch

** Calculate critical value for LR test
qui:mat def ll_2 = e(ll)
display "Calculating critical value"
rscv,q(0.99)
qui: eststo Glasgow

** Predict smoothed state probabilities
predict prob if inrange(Year,1907,1972), smethod(smooth) pr

** Fit MS model with 1 state for comparision
qui: mswitch dr log_influenza if inrange(Year,1907,1972), states(1) 
qui:mat def ll_1 = e(ll)
qui:mat def test_statistic = 2*(ll_2-ll_1)
display "Value of Test statistic:" 
mat list test_statistic

tsline (log_influenza) (prob)
** Save Output
esttab Glasgow using "..\Outputs\MS_Model_Output.rtf",append mtitles("Glasgow Influenza") se
export excel Year log_influenza prob using "..\Outputs\MSwitchingModel.xls", sheetreplace firstrow(variables) sheet("Glasgow Influenza")
