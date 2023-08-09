$credential = Get-Credential
$num = Invoke-Command -ComputerName 172.16.25.23 -Credential $credential -ScriptBlock {
    return 10
}
Write-Host $num
