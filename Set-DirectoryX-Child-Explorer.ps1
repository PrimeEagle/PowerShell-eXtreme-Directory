<#
	.SYNOPSIS
	Change to child directory in File Explorer.
	
	.DESCRIPTION
	Change to child directory in File Explorer.

	.PARAMETER Path
	Substring to match a directory.
	
	.PARAMETER All
	Search all drives (default is current drive only).
	
	.INPUTS
	Directory substring, search all drives.

	.OUTPUTS
	None.

	.EXAMPLE
	PS> .\Set-DirectoryX-Child-Explorer.ps1 "temp" -All
#>
using module Varan.PowerShell.Validation
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Requires -Version 5.0
#Requires -Modules Varan.PowerShell.Validation
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
param (	
		[parameter(Position = 0)]	[string]$Path,
		[parameter(Position = 1)]	[switch]$All
	  )
DynamicParam { Build-BaseParameters }

Begin
{	
	Write-LogTrace "Execute: $(Get-RootScriptName)"
	$minParams = Get-MinimumRequiredParameterCount -CommandInfo (Get-Command $MyInvocation.MyCommand.Name)
	$cmd = @{}

	if(Get-BaseParamHelpFull) { $cmd.HelpFull = $true }
	if((Get-BaseParamHelpDetail) -Or ($PSBoundParameters.Count -lt $minParams)) { $cmd.HelpDetail = $true }
	if(Get-BaseParamHelpSynopsis) { $cmd.HelpSynopsis = $true }
	
	if($cmd.Count -gt 1) { Write-DisplayHelp -Name "$(Get-RootScriptPath)" -HelpDetail }
	if($cmd.Count -eq 1) { Write-DisplayHelp -Name "$(Get-RootScriptPath)" @cmd }
}
Process
{
	try
	{
		$isDebug = Assert-Debug
		
		$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
		$includeFile = Join-Path $scriptPath "Directory-Search-Functions.ps1"
		. $includeFile

		$directory = Find-Directory -SearchPath $Path -ChildSearch -SearchAllDrives:$All
		if ($directory) {
			Start-Process "explorer.exe" -ArgumentList $directory
		} else {
			Write-Host "No matching directory found for '$Path'."
		}
	}
	catch [System.Exception]
	{
		Write-DisplayError $PSItem.ToString() -Exit
	}
}
End
{
	Write-DisplayHost "Done." -Style Done
}
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------