# select file

param(
[string]$startFolder
)

Function run($InitialDirectory)
{
    Add-Type -AssemblyName System.Windows.Forms
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.Title = "Please Select File"
    $OpenFileDialog.InitialDirectory = $InitialDirectory
    $OpenFileDialog.filter = "All files (*.*)| *.*"
    If ($OpenFileDialog.ShowDialog() -eq "Cancel") 
    {
    Return ""
    }
    $Global:SelectedFile = $OpenFileDialog.FileName
    Return $SelectedFile #add this return
}

run($startFolder)


