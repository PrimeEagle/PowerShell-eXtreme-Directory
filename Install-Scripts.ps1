<#
	.SYNOPSIS
	Installs prerequisites for scripts.
	
	.DESCRIPTION
	Installs prerequisites for scripts.

	.INPUTS
	None.

	.OUTPUTS
	None.

	.EXAMPLE
	PS> .\Install-Scripts
#>
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Requires -Version 5.0
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
param ([Parameter()] [switch] $UpdateHelp,
	   [Parameter(Mandatory = $true)] [string] $ModulesPath)

Begin
{
	$script = $MyInvocation.MyCommand.Name
	if(-Not (Test-Path ".\$script"))
	{
		Write-Host "Installation must be run from the same directory as the installer script."
		exit
	}

	if(-Not (Test-Path $ModulesPath))
	{
		Write-Host "'$ModulesPath' was not found."
		exit
	}

	$Env:PSModulePath += ";$ModulesPath"
	
	if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
		Start-Process -FilePath "pwsh.exe" -ArgumentList "-File `"$PSCommandPath`"", "-ModulesPath `"$ModulesPath`"" -Verb RunAs
		exit
	}
}

Process
{	
	Add-PathToProfile -PathVariable 'Path' -Path (Get-Location).Path
	Add-PathToProfile -PathVariable 'PSModulePath' -Path $ModulesPath
	
	Add-AliasToProfile -Script 'Set-DirectoryX-Console' -Alias 'x'
	Add-AliasToProfile -Script 'Set-DirectoryX-Both' -Alias 'xb'
	Add-AliasToProfile -Script 'Set-DirectoryX-Child-Console' -Alias 'xc'
	Add-AliasToProfile -Script 'Set-DirectoryX-Child-Both' -Alias 'xcb'
	Add-AliasToProfile -Script 'Set-DirectoryX-Child-Explorer' -Alias 'xce'
	Add-AliasToProfile -Script 'Set-DirectoryX-Explorer' -Alias 'xe'
	Add-AliasToProfile -Script 'Set-DirectoryX-Parent-Console' -Alias 'xp'
	Add-AliasToProfile -Script 'Set-DirectoryX-Parent-Both' -Alias 'xpb'
	Add-AliasToProfile -Script 'Set-DirectoryX-Parent-Explorer' -Alias 'xpe'
	Add-AliasToProfile -Script 'Get-eXtremeDirectoryHelpo' -Alias 'gxdh'
	Add-AliasToProfile -Script 'Get-eXtremeDirectoryHelpo' -Alias 'xdhelp'
}

End
{
	Format-Profile
	Complete-Install
}