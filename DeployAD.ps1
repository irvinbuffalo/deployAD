$logFile = "$env:USERPROFILE\Desktop\ADSetupLog.txt"

# Clear the log file if it exists or create a new one
New-Item -Path $logFile -ItemType File -Force

# Install AD Domain Services
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools >> $logFile

# Import AD module for subsequent commands
Import-Module ADDSDeployment >> $logFile

# Install new forest
$domainName = "customera.local"
$domainNetbiosName = "CUSTOMERA"
$safeModeAdministratorPassword = ConvertTo-SecureString -AsPlainText "12345qwert!@#$%QWERT" -Force

Install-ADDSForest `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "Win2012R2" `
    -DomainName $domainName `
    -DomainNetbiosName $domainNetbiosName `
    -ForestMode "Win2012R2" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$false `
    -SysvolPath "C:\Windows\SYSVOL" `
    -SafeModeAdministratorPassword $safeModeAdministratorPassword `
    -Force:$true >> $logFile
    
# Create Organizational Units (OUs)
New-ADOrganizationalUnit -Name "Facilities" -Path "DC=customera,DC=local" >> $logFile
New-ADOrganizationalUnit -Name "NYC" -Path "OU=Facilities,DC=customera,DC=local" >> $logFile
New-ADOrganizationalUnit -Name "Nashville" -Path "OU=Facilities,DC=customera,DC=local" >> $logFile
New-ADOrganizationalUnit -Name "Huntsville" -Path "OU=Facilities,DC=customera,DC=local" >> $logFile
New-ADOrganizationalUnit -Name "Users" -Path "DC=customera,DC=local" >> $logFile
New-ADOrganizationalUnit -Name "Groups" -Path "DC=customera,DC=local" >> $logFile
New-ADOrganizationalUnit -Name "Computers" -Path "DC=customera,DC=local" >> $logFile
New-ADOrganizationalUnit -Name "Servers" -Path "DC=customera,DC=local" >> $logFile

#Reboot the VM after the installation
Restart-Computer -Force
