@echo off

rem This file is for calling from WinEdt.  The root name of the document is passed as the first argument.
rem This file then passes that on the "makedocument" and adds additional options.
rem The "makedocument" batch file is found "C:\Custom Program Files\MiKTeK" (or similar) and it does the main processing work.

rem Calling signature: makedocument arg1 arg2
rem arg1 - The root file name passed to this file, always pass as "%1" (without quotes).
rem arg2 - The type of glossary package processing.
rem		0 - No processing.
rem		1 - Processing for the "glossary" package.
rem		2 - Processing for the "glossaries" package.

title Make Resume
taskkill /IM FoxitPhantomPDF.exe

call make_document %1 0
bibtex "publications"
bibtex "patents"
call make_document %1 0

echo %1.pdf
start "" %1.pdf

rem pause
