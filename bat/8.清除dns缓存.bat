@echo off

ipconfig /flushdns

ping 127.0.0.1 -n 3 >nul