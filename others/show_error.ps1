# select file

param(
[string]$mesageContent
)

Function run($mesageContent)
{
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.MessageBox]::Show($mesageContent, "Error", 0, 
    [System.Windows.Forms.MessageBoxIcon]::Exclamation)
}

run($mesageContent)
