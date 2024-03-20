# Written By: Jason Whittle
# Version: 1.0
# Description: Get Creds from Azure Vault
Add-Type -AssemblyName System.Windows.Forms

# Create a form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Get Creds from Azure Vault"
$form.Size = New-Object System.Drawing.Size(300, 200)
$form.StartPosition = "CenterScreen"

# Create a label for VM name
$labelVMName = New-Object System.Windows.Forms.Label
$labelVMName.Location = New-Object System.Drawing.Point(10, 20)
$labelVMName.Size = New-Object System.Drawing.Size(100, 20)
$labelVMName.Text = "VM Name:"
$form.Controls.Add($labelVMName)

# Create a text box for VM name
$textBoxVMName = New-Object System.Windows.Forms.TextBox
$textBoxVMName.Location = New-Object System.Drawing.Point(120, 20)
$textBoxVMName.Size = New-Object System.Drawing.Size(150, 20)
$form.Controls.Add($textBoxVMName)

# Create a button
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(100, 60)
$button.Size = New-Object System.Drawing.Size(100, 30)
$button.Text = "Get Creds"
$button.Add_Click({
    $vm_name = $textBoxVMName.Text
    $creds = az keyvault secret show --name $vm_name --vault-name $keyVault --query "value" 
    $creds = $creds -replace'"','' -replace'\\r\\n',''
    $creds = $creds.Split(",")
    if (!$creds[2]) {
        [System.Windows.Forms.MessageBox]::Show("VM Name: $vm_name`nCreds: $creds")
    } else {
        [System.Windows.Forms.MessageBox]::Show("VM Name: $vm_name`nUsername: $($creds[0])`nPassword: $($creds[1])`nIP: $($creds[2])")
    }
})
$form.Controls.Add($button)

# Show the form
$form.ShowDialog()





