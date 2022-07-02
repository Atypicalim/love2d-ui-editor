# select file

param(
[string]$funcName,
[string]$arg1,
[string]$arg2,
[string]$arg3,
[string]$arg4,
[string]$arg5
)

Function select_file($windowTitle, $filterDesc, $startFolder)
{
    Add-Type -AssemblyName System.Windows.Forms
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.Title = $windowTitle
    $OpenFileDialog.InitialDirectory = $startFolder
    $OpenFileDialog.filter = $filterDesc
    If ($OpenFileDialog.ShowDialog() -eq "Cancel") 
    {
    Return ""
    }
    $Global:SelectedFile = $OpenFileDialog.FileName
    Return $SelectedFile
}

function save_file($windowTitle, $filterDesc, $startFolder) 
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    $OpenFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $OpenFileDialog.Title = $windowTitle
    $OpenFileDialog.initialDirectory = $startFolder
    $OpenFileDialog.filter = $filterDesc
    $OpenFileDialog.ShowDialog() |  Out-Null
    return $OpenFileDialog.filename
}

Function select_folder($windowTitle, $startFolder)
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = $windowTitle
    $foldername.rootfolder = "MyComputer"
    $foldername.SelectedPath = $startFolder

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}

Function show_eror($title, $message, $buttons, $iconDesc)
{
    Add-Type -AssemblyName System.Windows.Forms
    $msgBoxInput =  [System.Windows.Forms.MessageBox]::Show($message, $title, $buttons, $iconDesc)
    return $msgBoxInput
}

Function show_input($title, $message, $default)
{
    Add-Type -AssemblyName Microsoft.VisualBasic
    $inputText = [Microsoft.VisualBasic.Interaction]::InputBox($message, $title, $default)
    return $inputText
}

& $funcName $arg1 $arg2 $arg3 $arg4 $arg5
