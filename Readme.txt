Data:
in the home directory folder gerber contains all the gerber images in tif format
in the home directory folder report_3 contains all the Xray images of a PCB

to know the Appropriate Cross-sectional X-ray Image for Gerber layer execute the previous student code (selection)

-------------------------------------------------------------------------
TifConverter.m
-> converts image files to .tif format
located: input > gerber
-------------------------------------------------------------------------
Code:

main file - Comparison.m
-> Takes two input files one gerber and Xray
-> Change the Path of files before executing
-> Will return an excel file, output_Approx_Match

gBrightLayer.m
-> For Gerber images with bright background
-> Images are preprocessed and imfindcircles is called on the image
-> Returns a set of [centers and radii] for the circles identified

gDarkLayer.m
-> For Gerber images with Dark background
-> Images are preprocessed and imfindcircles is called on the image
-> Returns a set of [centers and radii] for the circles identified

getCirclesXRay.m
-> For Xray images
-> Images are preprocessed and imfindcircles is called on the image
-> Returns a set of [centers and radii] for the circles identified

GenerateProp.m
-> Will take a Baseline and a set of [centers and radii] for the circles identified of a image.
-> based on the baseline angle and distance are calculated
-> Returns a by adding 2 new coloumns angle and distance.

--------------------------------------------------------------------------
Results:
for all 6 layers these excel sheets are created and stored in individual folder.


output_Approx_Match
->output of Comparison.m
contains 10 coloumns 
-> first 5 coloumns related to Gerber [x,y, radius, distance, angle]
-> the next 5 columns related to XRay [x,y, radius, distance, angle]


output_Gerber
->output of GenerateProp.m
contains 5 coloumns 
-> 5 coloumns related to Gerber [x,y, radius, distance, angle]

output_Xray
->output of GenerateProp.m
contains 5 coloumns 
-> 5 coloumns related to X Ray [x,y, radius, distance, angle]