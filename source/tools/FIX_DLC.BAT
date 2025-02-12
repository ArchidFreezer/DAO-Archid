@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
ECHO ********** GOG Version **********
ECHO.
ECHO ----- DLC Item Transfer Patch (v1.20) by Silencer, Originally by Mad Method -----
ECHO.
ECHO This batch script will automatically patch all DLC content to transfer properly
ECHO to DAO Awakening. If you are running this on top of an older fix, you should
ECHO undo the previous fix first.
ECHO.
PAUSE
ECHO.
REG QUERY "HKLM\SOFTWARE\WOW6432Node\GOG.com\Games\1949616134" /v Path >NUL 2>NUL
IF NOT ERRORLEVEL 1 SET NODE=Wow6432Node\
SET AP=Invalid_Path
FOR /F "TOKENS=2*" %%A IN ('REG QUERY "HKLM\SOFTWARE\%NODE%GOG.com\Games\1949616134" /v Path') DO SET AP="%%B"
CALL SET AP=%AP:~,-1%\AddIns"
IF EXIST %AP% CALL :START
FOR /F "TOKENS=2*" %%A IN ('REG QUERY "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Personal') DO SET AP="%%B"
CALL SET AP=%AP:~,-1%\BioWare\Dragon Age\AddIns"
CALL :START
ECHO.
ECHO Done.
SET /P T=Press any key to exit.<NUL
PAUSE>NUL
GOTO :EOF
:START
SETLOCAL ENABLEDELAYEDEXPANSION
%AP:~1,2%
CD %AP%
FOR %%A IN (cp_1 cp_2 cp_3 cp_7 nrx_1) DO IF EXIST dao_prc_%%A\. CALL :FDT "dao_prc_%%A"
FOR %%A IN (1 2 3 4 5 c2 edg emb hod lks lnp me vgl war wkd btk pan gbk) DO IF EXIST dao_prc_promo_%%A\. CALL :FDT "dao_prc_promo_%%A"
GOTO :EOF
:FDT
SET /P T=Fixing %*... <NUL
CD %*
SET MN=%*
SET MNL=0
:SL
SET /A MNL+=1
IF NOT "!MN:~%MNL%,1!"=="" GOTO :SL
SET /A MNL-=1
IF NOT EXIST core\. ECHO Error: There is no "core" folder in the AddIn?!&GOTO :EF
IF NOT EXIST module\. ECHO Error: There is no "module" folder in the AddIn?!&GOTO :EF
MD core\override\DLC_FIX\talktables 2>NUL
FOR %%A IN (module\data\*.*) DO COPY /Y "%%A" "core\override\DLC_FIX\%%~nA2%%~xA">NUL
FOR /F "delims=" %%A IN ('DIR /A /B /S module\*.tlk') DO CALL :RT "%%A"
IF NOT EXIST module\audio\sound\. GOTO :GEF
MD core\override\DLC_FIX\sound 2>NUL
COPY /Y module\audio\sound\*.* core\override\DLC_FIX\sound\>NUL
:GEF
ECHO Fixed.
:EF
CD ..
GOTO :EOF
:RT
SET F=%~n1
FOR %%A IN (cp_1 cp_2 promo_1 promo_btk promo_pan promo_gbk) DO IF %MN%=="dao_prc_%%A" COPY %* "core\override\DLC_FIX\talktables\">NUL&GOTO :EOF
COPY %* "core\override\DLC_FIX\talktables\%MN%_c_!F:~%MNL%!.tlk">NUL