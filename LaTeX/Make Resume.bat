title Make Resume

taskkill /IM FoxitPhantomPDF.exe

@echo off

echo.
echo.
echo.
echo Making Lance A Endres - CV


echo Do pdfLaTeX...
pdflatex "Lance A Endres - CV.tex"


echo.
echo.
echo.
echo.
echo.


echo Do BibTeX...
bibtex "Lance A Endres - CV.tex"
bibtex "publications"
bibtex "patents"


echo.
echo.
echo.
echo.
echo.


echo Do pdf (again)...
pdflatex "Resume-XSLT.tex"
latex "Resume-XSLT.tex"


REM LAUNCH PDF.
rem set file="%CD%\Resume-XSLT.pdf"

rem "pagemode" has to be the first open action.
rem pagemode=bookmarks

rem start "" /max "C:\Program Files\Adobe\Reader 9.0\Reader\AcroRd32.exe" /A "pagemode=thumbs&page=20&zoom=80&scrollbar=1=OpenActions" %file%
start Resume-XSLT.pdf


echo.
echo Done!
rem pause