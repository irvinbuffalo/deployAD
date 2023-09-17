# Install AD Domain Services
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

# Import AD module for subsequent commands
Import-Module ADDSDeployment

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
    -Force:$true
    
# Create Organizational Units (OUs)
New-ADOrganizationalUnit -Name "Facilities" -Path "DC=customera,DC=local"
New-ADOrganizationalUnit -Name "NYC" -Path "OU=Facilities,DC=customera,DC=local"
New-ADOrganizationalUnit -Name "Nashville" -Path "OU=Facilities,DC=customera,DC=local"
New-ADOrganizationalUnit -Name "Huntsville" -Path "OU=Facilities,DC=customera,DC=local"
New-ADOrganizationalUnit -Name "Users" -Path "DC=customera,DC=local"
New-ADOrganizationalUnit -Name "Groups" -Path "DC=customera,DC=local"
New-ADOrganizationalUnit -Name "Computers" -Path "DC=customera,DC=local"
New-ADOrganizationalUnit -Name "Servers" -Path "DC=customera,DC=local"

#Reboot the VM after the installation
Restart-Computer -Force
