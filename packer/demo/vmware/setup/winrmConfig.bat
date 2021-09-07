rem basic config for winrm
cmd.exe /c winrm quickconfig -q

rem allow unencrypted traffic, and configure auth to use basic username/password auth
cmd.exe /c winrm set winrm/config/service @{AllowUnencrypted="true"}
cmd.exe /c winrm set winrm/config/service/auth @{Basic="true"}

rem update firewall rules to open the right port and to allow remote administration
cmd.exe /c netsh advfirewall firewall set rule group="remote administration" new enable=yes

rem restart winrm
cmd.exe /c net stop winrm
cmd.exe /c net start winrm