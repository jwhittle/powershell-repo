# Written By: Jason Whittle
# Version: 1.0
# Description: Get Creds from Azure Vault

Add-Type -AssemblyName System.Windows.Forms

# Create a form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Get Creds from Azure Vault"
$form.Size = New-Object System.Drawing.Size(300, 200)
$form.StartPosition = "CenterScreen"

# Create a label for the VM name input
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10, 20)
$label.Size = New-Object System.Drawing.Size(280, 20)
$label.Text = "Enter the name of the VM:"
$form.Controls.Add($label)

# Create a text box for the VM name input
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10, 40)
$textBox.Size = New-Object System.Drawing.Size(280, 20)
$form.Controls.Add($textBox)

# Create a button to retrieve the credentials
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(100, 80)
$button.Size = New-Object System.Drawing.Size(100, 30)
$button.Text = "Get Credentials"
$button.Add_Click({
    $vm_name = $textBox.Text
    $creds = az keyvault secret show --name $vm_name --vault-name $keyVault --query "value" 
    $creds = $creds -replace '"','' -replace '\\r\\n',''
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
