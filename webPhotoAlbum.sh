#!/bin/bash
#photo album script
#script to generate webpages for wiewing pictures
#script takes one argument which is the picture directory, and should be one level down.
#This script changes directory and creates html/javascript code for viewing pictures. 
#Finally, builds a link to be send to friends for viewing of the album
#by 
#Jorge L. Vazquez
#03/21/2014
#modified: 06/01/2014
 
#START
 
#printing usage error to screen
if [ $# -ne 1 ]; then
	echo "USAGE: $(basename $0) directory"
	exit 1
fi
 
#variables
ext="JPG"						#your pics file extension
allPics=""						#string containing list of all pics
firstPic=""						#first picture in directory
title="$1"						#album title
directory="$1"						#pictures directory
linkpage="http://pctechtips.org/pics/slideshow.html"	#ink of first page to be emailed
 
#javascript code
webpage_code() {
 
cat << EOF
<!doctype html>
<html lang="en">
<head>
    <title>Picture Show</title>
    <style>
	* { margin: auto; }
	body { background: #999999; }
	#container { width: 800px; height: 600px; border: 1px solid black; }
	#header { height: 100px;text-align: center;background: #BC2929;border-bottom: 1px solid black; }
	#header h1 { padding-top: 20px;color: #171C68;font-family: sans-serif;}
	#header a { font-size: 20px;border: 1px solid blue;text-decoration: none;background:yellow;}
	#slideShow img { width: 800px;height: 499px;}
    </style>
    <script type="text/javascript">
	//pictures javascript code
	var imgs = [ $1 ];
	var imgNum = 0;
	var imgsLength = imgs.length-1;
	var dir = "$2/"
 
	//changing images function
	function changeImage(n) {    
		imgNum += n;
 
		//last position of array
		if (imgNum > imgsLength) {
	       		imgNum = 0;
		}
 
		//first position of array
		if (imgNum < 0) {
	       		imgNum = imgsLength;
		}
 
		document.image.src = dir + imgs[imgNum];	    
		return false;
	}
    </script>
</head>
<body>
    <!-- Insert your content here -->
    <div id="container">
        <div id="header">
            <h1>$2</h1>
            <a id="prev" href="#" onclick="changeImage(-1);">Previous</a>  
	    <a id="next" href="#" onclick="changeImage(1);">Next</a>         
        </div>
        <div id="slideShow">
            <img name="image" alt="Slide Show" src="$2/$3" />
        </div>
    </div>
</body>
</html>
EOF
}
 
 
##########################################
#       MAIN
##########################################
 
#changing into pics directory
if [ -d $directory ]; then
	cd $PWD/$directory
else
	echo "Dirctory $directory does not exists!.."
fi
 
#getting first picture
firstPic=$(ls -1 | head -1)
 
#creating array of pictures for using in javascript
for file in *.$ext; do
	[[ -z $allPics ]] && allPics="\"$file\"" || allPics="${allPics}, \"$file\""
done
 
#creating the webpage
cd ..
[ $? -eq 0 ] && webpage_code "$allPics" $directory $firstPic > slideshow.html
 
echo "Album Created..."
echo "Email link to friends: $linkpage"
 
#END
