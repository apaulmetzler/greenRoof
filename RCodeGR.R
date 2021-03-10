#neonUtilities

# install neonUtilities - can skip if already installed
install.packages("neonUtilities")
# load neonUtilities
library(neonUtilities)
'''
stackByTable(): Takes zip files downloaded from the Data Portal or downloaded by zipsByProduct(), unzips them, and joins the monthly files by data table to create a single file per table.
zipsByProduct(): A wrapper for the NEON API; downloads data based on data product and site criteria. Stores downloaded data in a format that can then be joined by stackByTable().
loadByProduct(): Combines the functionality of zipsByProduct() and stackByTable(): Downloads the specified data, stacks the files, and loads the files to the R environment.
getPackage(): A wrapper for the NEON API; downloads one site-by-month zip file at a time.
byFileAOP(): A wrapper for the NEON API; downloads remote sensing data based on data product, site, and year criteria. Preserves the file structure of the original data.
byTileAOP(): Downloads remote sensing data for the specified data product, subset to tiles that intersect a list of coordinates.
readTableNEON(): Reads NEON data tables into R, using the variables file to assign R classes to each column.
transformFileToGeoCSV(): Converts any NEON data file in csv format into a new file with GeoCSV headers.
'''

# soil microbe metagenome sequences
metaSeq <- loadByProduct(dpID = "DP1.10107.001",
                         site = "CPER",
                         startdate="2018-05", 
                         enddate="2018-08")
?boxplot()
?pars
