#!/bin/bash

#sudo apt install -y pdflatex texlive-latex-base texlive-pictures texlive-latex-extr

# step 6:
#LEFT=37890
#RIGHT=37990
LEFT=37990
RIGHT=38020

# step 2:
TOP=55840
BOTTOM=55790

#=================================

declare -i iX=0
declare -i iY=1
declare -i globalCounter=0
if [ ! -d pictures ]
then
    mkdir pictures
fi


echo '\documentclass[6pt]{article}
\usepackage{graphicx}
\usepackage[margin=0.5cm]{geometry}
\graphicspath{{pictures/}}
\pagenumbering{arabic}
\begin{document}
' > doc.tex

for (( x = $LEFT ; x < $RIGHT ; x += 6 ))
do
    iX=1
    for (( y = $BOTTOM ; y < $TOP ; y += 2 ))
    do
        #echo "$(($x/1000)).$(($x%1000)) - $(($y/1000)).$(($y%1000))"
        xPos="$(($x%1000))"
        for (( i = ${#xPos} ; i < 3 ; i += 1 ))
        do
            xPos="0$xPos"
        done
        xPos="$(($x/1000)).$xPos"

        yPos="$(($y%1000))"
        for (( i = ${#yPos} ; i < 3 ; i += 1 ))
        do
            yPos="0$yPos"
        done
        yPos="$(($y/1000)).$yPos"

        filePath=pictures/$iX-$iY.png

        if [ ! -f $filePath ]
        then
            wget "https://static-maps.yandex.ru/1.x/?lang=ru_RU&ll=$xPos,$yPos&size=650,450&z=17&l=map" -O $filePath
        fi
        echo -n "\includegraphics[width=10cm]{$iX-$iY.png}" >> doc.tex
        if [ $(($globalCounter % 2)) -eq 0 ]
        then
            echo >> doc.tex
        else
            echo "\\\\" >> doc.tex 
            echo "row $iX, column $iY\\\\" >> doc.tex
        fi

        iX+=1
        globalCounter+=1
    done
    iY+=1
done

echo '
\end{document}' >> doc.tex

pdflatex doc.tex doc.pdf || exit 1
