@echo off
wmic process where "CommandLine like '%%HardwareMonitor\\monitor.py%%'" delete >nul 2>&1
wmic process where "CommandLine like '%%monitor.py%%' and Name='pythonw.exe'" delete >nul 2>&1
echo LumiHUD closed.
timeout /t 1 >nul
