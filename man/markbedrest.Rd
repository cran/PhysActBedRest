\name{markbedrest}
\alias{markbedrest}
\title{Bedrest Marking, Universal}
\description{
Processes data from (Actigraph) accelerometers and classifies each epoch as either bedrest or active. The output contains an additional (compared to input) "Bedrest" column. The column has a return of "a" for activity or "br" for bedrest in each line (i.e. epoch). An additional option allows for a nap ("n") classification. The "n" differs from "br" only in how long the bedrest period is. The nap cutoff is specifiable, see below. The function is designed to be used after wearingMarking function in the Physical Activity package.

Like activity level cut points vary depending upon the age of the person wearing the accelerometer and the body location it was worn, the function requires arguments calibrated to the wearer and location.   These may be specified in one of two ways: 1) enter arguments for age and location (loc)., or 2) enter arguments for TH, wd and nvm.  These are described briefly below.  See Tracy et al. (2014) for a more detailed explanation.  We have calibrated for waist and wrist in adults (19-64) and youth (10-18) and waist for preschoolers (3-5).   Adult and Youth calibrations were on \bold{Axis1}.  Preschooler calibrations were on \bold{VM}.  All calibrations are for \bold{1 minute} epoch data.}

\usage{markbedrest(dset, TS, cts, age, loc, rstdr, rstfl, per, TH, wd, 
nvm, nmin, nmax, EC)}

\arguments{
  \item{dset}{A matrix containing the following two columns:}
  \item{TS}{[Optional] A "timestamp" column (m)m/dd/yyyy (h)h:mm (24h) created by the timestamp function. The default is "TS".}
  \item{cts}{[Optional] The name of the column contianing counts (an Axis or "Vector Magnitude"). The default is "Axis1" for Adult and Youth; and "VM" for Preschool.}
  \item{age}{[Optional] The age category of the person who wore the accelerometer.  Options are "preschool" (\bold{ps}) [3-7 year old], "youth" (\bold{yo}) [8-18 year old], or "adult" (\bold{ad}) [19-64 year old].}
  \item{loc}{[Optional] The body location where the accelerometer was worn. Options are "waist" (\bold{wa}) and "wrist" (\bold{wr}).} 
  \item{rstdr}{[Optional] A folder to place resulting csv files, which are supplemented with the bedrest column.  The default is the working directory.}
  \item{rstfl}{[Optional] The name to be assigned to the csv file with the beginning and end time for each interval classified as bedrest. The default is "subj_bdr_sum".}
  \item{per}{[Optional] The number of epochs in the blocks for the coarse (initial) analysis.  The default is 60.} 
  \item{TH}{[Optional] (CP1) A threshold for the maximum average of counts/epoch in each \emph{per}-long block.  In the first step of  analysis, a block with the average counts/epoch below the threshold is classified as bedtime rest. (Fine analysis is applied to block where there are transitions.)}
  \item{wd}{[Optional] (CP2) A threshold for the minimum number of counts/epoch required in the first epoch (e.g., min) to be marked as activity.}
  \item{nvm}{[Optional] negligible vertical movement A number of counts below which movement is classified as \emph{bedrest} (\bold{br}) in the fine (upstream) search of transition periods (e.g. from \emph{bedrest} to \emph{active}).}
  \item{nmin}{[Optional] nap minimum: The minimum number of epochs to be classified as a napping interval. The default value is 60.} 
  \item{nmax}{[Optional] nap maximum: The maximum number of epochs to be classified as napping interval. The default value is 60.}
  \item{EC}{[Optional] Epoch Checks: Logical, If TRUE checks to see that data is in correct epoch length (1 min).  Can be set to FALSE to overide check.  The default is TRUE.}
}
  
\details{Designed to be used after the wearingMarking function in the PhysicalActivity package is applied to identify accelerometer nonwear time intervals from the dataset. In addition to the dataframe, the function also generates a csv file with columns for the beginning and end time points of intervals classified as bedrest. These files could be read and merged into batch files and reviewed for accuracy. 

Data should be in 1 minute epochs. 

The values the various age-loc combinations called maximized (sensitivity * specificity) Axis1 data. The youth study is described in Tracy et al. (2014). The values can be changed to investigator-selected values (e.g. threshold for maximum number of counts). If appropriate values for TH, wd, nvm and per were available, the functions could process data from accelerometers worn at other locations (e.g. ankle) or other populations (e.g. seniors), vector magnitude (VM) could be specified as the counts column (cts) data obtained from triaxial accelerometer. 

Note: nmin and nmax work in tandem.  Setting them equal, as is the default does returns no nap intervals.  To mark naps differently than other Bedrest,  nmin must be less than nmax, e.g. 60 and 120 minutes, respectively.  If this is the case, time intervals below the 60 min threshold (nmin) are classified as activity ("a"), those between 60 and 120 min are classified as nap ("n"), and those greater than 120 min (nmax) are classified as bedtime rest ("br").}

\value{A data frame with an additional column, "BedRest".  Bedrest will return "br" for bedtime rest and "a" activity in each line.  Options also allow for "n" nap which only differ than "br" in being for a shorter (specifiable) time period.}

\references{Tracy JD, Xu Z, Choi L, Acra S, Chen KY and Buchowski MS (2014) Separating bedtime rest from activity using waist or wrist-worn accelerometers in youth.  \emph{PLOS ONE} DOI: 10.1371/journal.pone.0092512

Tracy JD, Acra S, Chen KY and Buchowski MS (2018) Identifying bedrest using 24-h waist or wrist accelerometry in adults. \emph{PLOS ONE}, DOI: 10.1371/journal.pone.0194461 } 

\seealso{
\pkg{PhysicalActivity}
}
\examples{
data(zPhysActBedRest)


##  Example 1:  
\dontrun{wr_ad_lb1499 = read.csv("wr_ad_lb1499.csv")}
    wr_ad_lb1499_slp = markbedrest(dset=wr_ad_lb1499, age="ad", loc="wr"
                                   , rstdr = tempdir()
    ## previous line is only included to comply with CRAN policies
                                   )

##	Example 2 (transforms data set to demonstrate other arguments):  
    alt_wr_ad_lb1499 = wr_ad_lb1499
    colnames(alt_wr_ad_lb1499) = c("tstmp", "Counts")

alt_wr_ad_lb1499_slp = markbedrest(dset = alt_wr_ad_lb1499,
                                   TS = "tstmp", 
                                   cts = "Counts", 
                                   TH = 400,
                                   wd = 1500,
                                   nvm = 150,
                                   per = 30, 
                                   rstdr = tempdir(),
                                   rstfl = "alt_wr_ad_lb1499_sum",
                                   EC = FALSE)
## Note: the two examples have the same result, as can be verified: 
table(alt_wr_ad_lb1499_slp$bedrest==wr_ad_lb1499_slp$bedrest)}



