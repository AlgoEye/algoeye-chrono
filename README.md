# AlgoEye Chrono
Financial Time Series Database


## Prerequisites
- Linux, tested with Ubuntu 15.04
- Supervisor - run 'pip install supervisor' (see http://supervisord.org/installing.html for details)
- Java 8, the current user profile should have JAVA_HOME environment variable set ('sudo apt-get install openjdk-8-jre' if you don't have one)
- KDB/Q - download from www.kx.com and put into subrirectory 'q' (alternatively, if you already have KDB/Q installed and QHOME already set then remove definition of QHOME from kdb.sh)

## Installation
- run 'git clone https://github.com/AlgoEye/algoeye-chrono.git' from console or use your favourite git client to clone the url
- replace 'pass' password in config/passwords/default.txt with your secure passwords
- put password for app user into feed/adapter-ib.xml
- link supervisor.kdb.conf to Supervisor config (e.g. 'ln -s /algoeye/kdb/supervisor.kdb.conf /etc/supervisor/conf.d/algoeye.kdb.conf')
- configure host/port/client for your IB Gateway in feed/adapter-ib.xml
- configure your symbols in feed/adapter-ib.xml

## Components
- Ticker Plant
- Realtime Database
- Historical Database

## Acknowledgements
- Chrono is based on KDB/Q released by KX
- Chrono uses an open source TorQ framework built by AquaQ


*****
Developed by algoeye.com


