title Make Dissertation

rem close "Adobe Reader - [Endres Dissertation.pdf]"

@echo off

echo.
echo.
echo.

rem cd LaTeX

echo Do pdfLaTeX...
pdflatex "Resume-XSLT.tex"


echo.
echo.
echo.
echo.
echo.
echo.
echo.


echo Do BibTeX...
bibtex "Resume-XSLT.tex"
bibtex "publications"
bibtex "patents"


echo.
echo.
echo.
echo.
echo.
echo.
echo.


echo Do pdf (again)...
pdflatex "Resume-XSLT.tex"
latex "Resume-XSLT.tex"


REM LAUNCH PDF.
set file="%CD%\Resume-XSLT.pdf"

rem "pagemode" has to be the first open action.
rem pagemode=bookmarks

rem start "" /max "C:\Program Files\Adobe\Reader 9.0\Reader\AcroRd32.exe" /A "pagemode=thumbs&page=20&zoom=80&scrollbar=1=OpenActions" %file%
start Resume-XSLT.pdf


echo Do LaTeX...
rem latex "Resume-XSLT.tex" -output-format dvi --src


echo.
echo Done!


rem pause