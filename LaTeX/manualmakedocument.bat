@echo off
echo.
echo.
echo MANUALMAKEDOCUMENT

title Make Resume
taskkill /IM FoxitPhantomPDF.exe


rem Use this file to process the document without WinEdt.
rem It can be double clicked or run from the command line.

rem This file can automatically attempt to find the file name by extracting it from the WinEdt project file name.  For this to work,
rem the main LaTeX document must have the same root file name as the project file.  If this is not the case, the root file name must be
rem manually entered.

rem To automatically detect the root file name, set FILEROOT to "AUTO" (quotation marks are required).
rem To manually enter the root file name, set FILEROOT to the root file name in quotation marks.
rem Do not add spaces around the equals sign.
rem Quotation marks are required for FILEROOT, otherwise the "if" statement will parse out the first word and choke on the rest.
set FILEROOT="AUTO"


rem If automatic mode is on, look for the project file and extract the root name.
rem The "~n" syntax is used to extract the root file name by removing the path and file extension.
if %FILEROOT%=="AUTO" (
	echo File name mode set to automatic detection.
	for %%F in (*.prj) do (set FILEROOT="%%~nF")
) else (
	echo File name mode set to manual.
)
echo File name passed to make document: %FILEROOT%


call runmakedocument %FILEROOT%
bibtex "publications"
bibtex "patents"
call runmakedocument %FILEROOT%

start "" %FILEROOT%.pdf

rem pause
