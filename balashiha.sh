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
\begin{document}
' > doc.tex

#for (( x = 37990 ; x < 37970 ; x += 13 ))#
for (( x = 37890 ; x < 37990 ; x += 6 ))
do
    iX=1
    #for (( y = 55790 ; y < 55795 ; y += 5 ))#
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

#        echo "
#\begin{figure}
#    \centering
#    \subfloat[label 1]{{\includegraphics[width=5cm]{$iX-$iY.png} }}
#    \qquad
#    \subfloat[label 2]{{\includegraphics[width=5cm]{$iX-$iY.png} }}
#    \caption{2 Figures side by side}
#    \label{fig:example}
#\end{figure}

#        echo "
#\begin{figure}[h]
#\includegraphics[width=256px]{$iX-$iY.png}
#\caption{column $iX, row $iY}
#\label{fig:image}
#\end{figure}
#" >> doc.tex

        iX+=1
        globalCounter+=1
    done
    iY+=1
done

#pdflatex "$tmpdir.tex" "$tmpdir.pdf"

#echo '\includegraphics{1-1.png}' >> doc.tex

#        echo "
#\begin{figure}[h]
#\includegraphics{1-2.png}
#\caption{column 1, row 1}
#\label{fig:image}
#\end{figure}
#" >> doc.tex

echo '
\end{document}' >> doc.tex

pdflatex doc.tex doc.pdf || exit 1

#\documentclass[12pt]{article}
#usepackage[margin=2cm]{geometry}
#\usepackage[utf8]{inputenc}
#\usepackage[russian]{babel}

#\begin{document}
#\pagenumbering{gobble}
#\maketitle
#\newpage
#\tableofcontents
#\newpage
#\pagenumbering{arabic}
#\end{document}' > doc.tex

#pdflatex doc.tex doc.pdf
