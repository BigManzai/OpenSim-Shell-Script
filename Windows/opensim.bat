@echo off

Set VERZEICHNIS=%cd%
echo "Aktuelle Verzeichnis %cd%"

echo "################################################################################"
echo "Holen des OpenSimulator und Erweiterungen."

if exist %cd%/opensim (
    cd %cd%\opensim\
    git pull
    cd ..
    ) else (git clone git://opensimulator.org/git/opensim opensim)

if exist %cd%/OpenSimCurrencyServer (
    cd %cd%\OpenSimCurrencyServer\
    git pull
    cd ..
    ) else (git clone https://github.com/BigManzai/OpenSimCurrencyServer-2023 OpenSimCurrencyServer)

if exist %cd%/opensim-ossl-example-scripts (
    cd %cd%\opensim-ossl-example-scripts\
    git pull
    cd ..
    ) else (git clone https://github.com/BigManzai/opensim-ossl-example-scripts opensim-ossl-example-scripts)

echo "################################################################################"
echo "Kopiere MoneyServer."
if exist %cd%/opensim/addon-modules/OpenSim-Data-MySQL-MySQLMoneyDataWrapper (rd %cd%\opensim\addon-modules\OpenSim-Data-MySQL-MySQLMoneyDataWrapper /s /q)
if exist %cd%/opensim/addon-modules/OpenSim-Grid-MoneyServer (rd %cd%\opensim\addon-modules\OpenSim-Grid-MoneyServer /s /q)
if exist %cd%/opensim/addon-modules/OpenSim-Modules-Currency (rd %cd%\opensim\addon-modules\OpenSim-Modules-Currency /s /q)
xcopy %cd%\OpenSimCurrencyServer\addon-modules %cd%\opensim\addon-modules /E /Y

echo "################################################################################"
echo "Alles auf dotnet6 einstellen."
cd %cd%\opensim
git checkout dotnet6

cd ..

echo "################################################################################"
echo "Kopiere Zusatzskripte."
copy %cd%\opensim-ossl-example-scripts\assets\ScriptsAssetSet\*.* %cd%\opensim\bin\assets\ScriptsAssetSet
copy %cd%\opensim-ossl-example-scripts\inventory\ScriptsLibrary\*.* %cd%\opensim\bin\inventory\ScriptsLibrary

cd %cd%\opensim

echo "################################################################################"
echo "Prebuild erstellen."
dotnet bin\prebuild.dll /target vs2022 /targetframework net6_0 /excludedir = "obj | bin" /file prebuild.xml

echo "################################################################################"
echo "OpenSimulator bauen."
dotnet build --configuration Release OpenSim.sln 

echo "################################################################################"
echo "Der fertige OpenSimulator befindet sich jetzt im Verzeichnis opensim\bin."

Pause
