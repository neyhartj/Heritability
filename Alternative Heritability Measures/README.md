# Alternative Estimation Methods for H² on Entry-Mean Basis
There are several alternative estimation methods for broad-sense and narrow-sense heritability on an entry-mean basis. Additionally, we proposed heritability on an entry-difference basis. Please see our articles for more information:

> Schmidt, P.; Hartung, J.; Rath, J.; Piepho, H.-P. (2019): Estimating broad-sense heritability with unbalanced data from agricultural cultivar trials. In Crop Science 59 (2), pp. 525–536. DOI: 10.2135/cropsci2018.06.0376.

> Schmidt, P., Hartung, J., Bennewitz, J., & Piepho, H. P. (2019). Heritability in Plant Breeding on a Genotype-Difference Basis. Genetics, genetics-302134.


### Based on 4 different mixed model functions
* `asreml()` of the R-package [ASReml-R Version 3.0](https://www.vsni.co.uk/software/asreml-r/)
* `mmer2()`  of the R-package [sommer](https://cran.r-project.org/web/packages/sommer/index.html)
* `lmer()`   of the R-package [lme4](http://lme4.r-forge.r-project.org/)
* `PROC MIXED` in [SAS](https://www.sas.com/en_us/home.html)

### Application
**For all R packages** you will find example analyses that you can copy-paste into R and run immediately (given all required packages are installed).

**For SAS** it works similarly, yet you will see that the example analyses make use of SAS `%MACROs`. These macros are also provided in the SAS folders. You do not need to copy-paste or download the macros in order to run the example analyses, since they are included automatically via their URL and a `proc http` command at the top of each code.

**IMPORTANT: Keep in mind that these are example codes which means that they do not necessarily apply to other models/settings. Their purpose is merely to exemplarily demonstrate and thus function as a starting point to be modified for other analyses.**

### Work in progress
Note that at the moment we do not provide code for all methods described in our paper and/or for all of the three mixed model functions. You can find an overview below. Further note that in some cases, denoted by a lower case *x*, the presented codes are **very much** *ad hoc* in the sense that they *e.g.* will definitely only work for that specific model and/or manually obtain variance-covariance matrices and the mixed model equations solutions in order to obtain the desired results.

H² Method | `asreml()` | `mmer2()` | `lmer()` | `PROC MIXED` | 
:--- | :---: | :---: | :---: | :---: |
Standard |  |  |  |  |
Holland |  |  |  |  |
Piepho | X | °° | X | X |
Cullis | X | X | x | X |
Oakey | X | X | x | X |
Reg | X | °° | X | X |
SumDiv | X | °° | X | X |
Simulated | ° | ° | x | X |
Delta (BLUP) | X |  |  |  |
Delta (BLUE) | X |  |  |  |

° *not possible to extract the full matrix (C) of the mixed model equation solutions*  <br />
°° *not possible to obtain e.g. emmeans based on BLUEs*
