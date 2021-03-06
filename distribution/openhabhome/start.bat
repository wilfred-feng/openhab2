@echo off

:: set path to eclipse folder. If local folder, use '.'; otherwise, use c:\path\to\eclipse
set ECLIPSEHOME="runtime/server"

:: set ports for HTTP(S) server
set HTTP_PORT=8080
set HTTPS_PORT=8443
 
:: get path to equinox jar inside ECLIPSEHOME folder
for /f "delims= tokens=1" %%c in ('dir /B /S /OD %ECLIPSEHOME%\plugins\org.eclipse.equinox.launcher_*.jar') do set EQUINOXJAR=%%c

IF NOT [%EQUINOXJAR%] == [] GOTO :Launch
echo No equinox launcher in path '%ECLIPSEHOME%' found!
goto :eof

:Launch 
:: start Eclipse w/ java
echo Launching the openHAB runtime...
java ^
-DmdnsName=openhab ^
-Dopenhab.logdir=./userdata/logs ^
-Dsmarthome.servicecfg=./runtime/etc/services.cfg ^
-Dsmarthome.servicepid=org.openhab ^
-Dsmarthome.userdata=./userdata ^
-Dosgi.clean=true ^
-Declipse.ignoreApp=true ^
-Dosgi.noShutdown=true ^
-Djetty.port=%HTTP_PORT% ^
-Djetty.port.ssl=%HTTPS_PORT% ^
-Djetty.home.bundle=org.openhab.io.jetty ^
-Dlogback.configurationFile=./runtime/etc/logback.xml ^
-Dfelix.fileinstall.dir=./addons ^
-Djava.library.path=./lib ^
-Djava.security.auth.login.config=./runtime/etc/login.conf ^
-Dorg.quartz.properties=./runtime/etc/quartz.properties ^
-Dequinox.ds.block_timeout=240000 ^
-Dequinox.scr.waitTimeOnBlock=60000 ^
-Djava.awt.headless=true ^
-Dfelix.fileinstall.active.level=4 ^
-jar %EQUINOXJAR% %* ^
-console 
