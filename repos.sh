mkdir EVT
mkdir Launch
mkdir GitHub
mkdir d2s2
mkdir RIT

cd RIT
cd ..

cd Launch
git clone https://github.com/AarC10/GSW-Data-Analysis
git clone https://github.com/AarC10/APRS-Forwarder
git clone https://github.com/AarC10/bob
git clone https://github.com/AarC10/DAQ-TFTP-Client
git clone https://github.com/RIT-Launch-Initiative/NIGEL-Flight-Computer
git clone https://github.com/WillMerges/GSW-2021
gh repo clone RIT-Launch-Initiative/launch-core
gh repo clone RIT-Launch-Initiative/sensor-module
gh repo clone RIT-Launch-Initiative/power-module
gh repo clone RIT-Launch-Initiative/radio-module
gh repo clone RIT-Launch-Initiative/autopilot-module

cd ../EVT
git clone https://github.com/RIT-EVT/APM
git clone https://github.com/RIT-EVT/TMS
git clone https://github.com/RIT-EVT/BMS
git clone https://github.com/RIT-EVT/EVT-Core
git clone https://github.com/RIT-EVT/slcanuino

cd ../d2s2
git clone https://github.com/travisdesell/ngafid2.0
git clone https://github.com/travisdesell/exact
