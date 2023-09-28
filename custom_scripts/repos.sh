mkdir EVT
mkdir Launch
mkdir GitHub
mkdir d2s2
mkdir RIT

cd GitHub
. user_cloner.sh

cd ../RIT

cd ../Launch
gh repo clone AarC10/APRS-Forwarder
gh repo clone AarC10/bob
gh repo clone AarC10/DAQ-TFTP-Client
gh repo clone AarC10/GSW-Data-Analysis
gh repo clone RIT-Launch-Initiative/NIGEL-Flight-Computer
gh repo clone RIT-Launch-Initiative/Launch-Ground-Software
gh repo clone RIT-Launch-Initiative/Advanced-Simulation-Software
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
