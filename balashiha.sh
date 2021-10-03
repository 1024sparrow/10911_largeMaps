#!/bin/bash

#sudo apt install -y pdflatex texlive-latex-base texlive-pictures texlive-latex-extr

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

for (( x = 37890 ; x < 37990 ; x += 6 ))
do
    iX=1
    for (( y = 55790 ; y < 55836 ; y += 2 ))
    do
        echo "$(($x/1000)).$(($x%1000)) - $(($y/1000)).$(($y%1000))"
        xPos="$(($x/1000)).$(($x%1000))"
        yPos="$(($y/1000)).$(($y%1000))"
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
