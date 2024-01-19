<#
	.SYNOPSIS
	Uninstalls prerequisites for scripts.
	
	.DESCRIPTION
	Uninstalls prerequisites for scripts.

	.INPUTS
	None.

	.OUTPUTS
	None.

	.EXAMPLE
	PS> .\Uninstall-Scripts
#>
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Requires -Version 5.0
[CmdletBinding(SupportsShouldProcess)]
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
	
	Import-LocalModule Varan.PowerShell.SelfElevate
	$boundParams = @{}
	$PSCmdlet.MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $boundParams[$_.Key] = $_.Value }
	Open-ElevatedConsole -CallerScriptPath $PSCommandPath -OriginalBoundParameters $boundParams
}

Process
{	
	Remove-PathFromProfile -PathVariable 'Path' -Path (Get-Location).Path
	
	Remove-AliasFromProfile -Script 'Set-DirectoryX-Console' -Alias 'x'
	Remove-AliasFromProfile -Script 'Set-DirectoryX-Both' -Alias 'xb'
	Remove-AliasFromProfile -Script 'Set-DirectoryX-Child-Console' -Alias 'xc'
	Remove-AliasFromProfile -Script 'Set-DirectoryX-Child-Both' -Alias 'xcb'
	Remove-AliasFromProfile -Script 'Set-DirectoryX-Child-Explorer' -Alias 'xce'
	Remove-AliasFromProfile -Script 'Set-DirectoryX-Explorer' -Alias 'xe'
	Remove-AliasFromProfile -Script 'Set-DirectoryX-Parent-Console' -Alias 'xp'
	Remove-AliasFromProfile -Script 'Set-DirectoryX-Parent-Both' -Alias 'xpb'
	Remove-AliasFromProfile -Script 'Set-DirectoryX-Parent-Explorer' -Alias 'xpe'
	Remove-AliasFromProfile -Script 'Get-eXtremeDirectoryHelpo' -Alias 'gxdh'
	Remove-AliasFromProfile -Script 'Get-eXtremeDirectoryHelpo' -Alias 'xdhelp'
}

End
{
	Format-Profile
	Complete-Install
}