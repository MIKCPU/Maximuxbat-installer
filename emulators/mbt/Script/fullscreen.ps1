$wshell = New-Object -ComObject wscript.shell
Start-Sleep -Seconds 1
$wshell.SendKeys('{F11}')
