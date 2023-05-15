class PTStats
{
	[string]$Name
	[bool]$ReadmeFinished
	[bool]$GitPushed
	[bool]$GalleryPublished
}

function Get-ProjectStatus{
	$obj = New-Object PTStats
	$obj.Name = $dir.Name
	cd $dir.FullName
	if (Test-Path ProjectStatus.xml) {
		$xml = [xml]$(Get-Content ProjectStatus.xml)
		$obj.GalleryPublished = $xml.ProjectStatus.GalleryPublished
		$obj.ReadmeFinished = $xml.ProjectStatus.ReadmeFinished
		$obj.GitPushed = $xml.ProjectStatus.GitPushed
	}
}

function Get-ProjectsStatus {
	$repositories = Get-ChildItem
	$result = @()
	foreach ($dir in $repositories) {
		$result += $obj
	}

	$result | Format-Table Name, ReadmeFinished, GitPushed, GalleryPublished
}

function GetFullPath {
	$path = Get-Location
	$fullPath = "$path\ProjectStatus.xml"
	Write-Host "FullPath: $fullPath"
	return $fullPath;
}

function ValidateFile{
	$fileExists = Test-Path $(GetFullPath)
	if ($fileExists -eq $false) {
		Write-Output "File missing";
		throw "File missing";
	}
}

function Set-ReadmeAutiomationToProjectStatusFile {

	[Cmdletbinding()]
	param(
		[string]$XXXX
	)
	

	ValidateFile

	$xml = [XML](Get-Content $(GetFullPath))
	$nodeExists = $xml.ReadmeAutomation
	Write-Host $xml
	if ($nodeExists -eq $null) {
		$newelement = $xml.CreateElement("ReadmeAutomation")
		if ($xml.ProjectStatus -eq "") {
			$zeroElements=$xml.FirstChild.NextSibling
			Write-Output $zeroElements
			$zeroElements.AppendChild($newelement);

		}
		else {
			$xml.ProjectStatus.AppendChild($newelement)
		}
	}
	#$xml.ReadmeAutomation = $true;
	$xml.Save($(GetFullPath))
		
}

function Add-ReadmeAutiomationToProjectStatusFile {
	ValidateFile
	
	Set-ReadmeAutiomationToProjectStatusFile 
	
}

function Create-NewProjectStatusFile {
	$path = Get-Location
	$xmlWriter = New-Object System.XMl.XmlTextWriter("$path\ProjectStatus.xml", $Null)
	$xmlWriter.WriteStartDocument()
	$xmlWriter.WriteStartElement("ProjectStatus")  # catalog Start Node
	$xmlWriter.WriteEndElement()  # catalog end node.
	$xmlWriter.WriteEndDocument()
	$xmlWriter.Flush()
	$xmlWriter.Close()
	#New-Item -ItemType File ProjectStatus.xml
}

Export-ModuleMember Get-ProjectStatus
Export-ModuleMember Get-ProjectsStatus
Export-ModuleMember Create-NewProjectStatusFile
Export-ModuleMember Add-ReadmeAutiomationToProjectStatusFile
Export-ModuleMember Set-ReadmeAutiomationToProjectStatusFile