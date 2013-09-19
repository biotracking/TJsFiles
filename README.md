TJsFiles
========

Yerkes macaque tracking data is usually in .csv format with the following columns

TAG NUMBER, UNIX TIMESTAMP, X-COORDINATE, Y-COORDINATE, Z-COORDINATE

In the data that we have had up until now (August 2013) each macaque has 4 tags on its collar. 
(Its easier if the tag to monkey mapping is already available)

The features we are attempting to learn are
1. Social structure (Tie-strengths)
2. Dominance behaviour

The folder monkeyfiles contains matlab functions that allow
1. Filtering of noisy position data
2. Synchronising the tags at a frequency of 30Hz and combining them.
3. Derive velocity and orientation
4. Calculate tie strength based on time of interaction within a distance threshold.
   This also records the neighbouring monkey's id and counts it as an interaction.
5. Create a video visualization of the monkeys in their enclosure.   
6. Convert this to a pseudo-btf matrix (to work on in matlab) or to convert them to btf files.

The workflow is as follows :

1. Initially we get a large Log file that has data from several days. "splitfilebydays.m" 
is used to split this log file into n number of files, one for each day that is present.

2. "generatetrackandbtf.m" is the master script that generates results day-wise. Use this after "splitfilebydays.m", we get 
three .mat files : {"prefix",daynumber}.mat (This contains the entire matlab workspace after generating data for a single day), 
{"prefix",daynumber,"btf"}.mat (This contains only the btf data in matlab matrix format, can be loaded directly into matlab),
{"prefix",daynumber,"matrixofinteraction"}.mat (This contains only the matrix of interaction)

The btf matrix in Matlab has the following columns

TAG NUMBER, UNIX TIMESTAMP, X-COORDINATE, Y-COORDINATE, Z-COORDINATE, SPEED, X-ORIENTATION, Y-ORIENTATION, Z-ORIENTATION, NEIGHBOURING MONKEY (ONLY ONE SELECTED)


3. Use "generateheatmap.m" to get the heatmaps as .png images in the current directory (Format can be changed within the program). 
4. "createvisualization.m" is used to generate a video on matlab. (Usually use camtasia/jing screen capture to generate .mp4 files)
5. "convertmatrix2btf.m" to get btf files for individual days in a user input folder
6. To draw the social graphs I have used Gephi previously but this doesnt meet some of our requirements. A shift to graphviz is imminent.
Gephi uses .gml (Just a markup style file where I have to specify nodes i.e. monkeys and edges with their metadata) files so "writegmlfile.m" converts the matrixofinteraction into a gml file in the current directory. 

