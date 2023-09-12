Add-Type -AssemblyName System.Windows.Forms

# Create a Windows Form
$form = New-Object Windows.Forms.Form
$form.Text = "Configurator V4.0.1"
$form.Size = New-Object Drawing.Size(500,200)

# Create labels and textboxes for input
$labelCSV = New-Object Windows.Forms.Label
$labelCSV.Text = "CSV File Path:"
$labelCSV.Location = New-Object Drawing.Point(20, 20)
$form.Controls.Add($labelCSV)

$textBoxCSV = New-Object Windows.Forms.TextBox
$textBoxCSV.Location = New-Object Drawing.Point(150, 20)
$textBoxCSV.Size = New-Object Drawing.Size(200, 20)
$form.Controls.Add($textBoxCSV)

$buttonBrowseCSV = New-Object Windows.Forms.Button
$buttonBrowseCSV.Text = "Browse"
$buttonBrowseCSV.Location = New-Object Drawing.Point(360, 20)
$buttonBrowseCSV.Add_Click({
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "CSV Files (*.csv)|*.csv|All Files (*.*)|*.*"
    if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $textBoxCSV.Text = $openFileDialog.FileName
    }
})
$form.Controls.Add($buttonBrowseCSV)

$labelTemplate = New-Object Windows.Forms.Label
$labelTemplate.Text = "Template File Path:"
$labelTemplate.Location = New-Object Drawing.Point(20, 50)
$form.Controls.Add($labelTemplate)

$textBoxTemplate = New-Object Windows.Forms.TextBox
$textBoxTemplate.Location = New-Object Drawing.Point(150, 50)
$textBoxTemplate.Size = New-Object Drawing.Size(200, 20)
$form.Controls.Add($textBoxTemplate)

$buttonBrowseTemplate = New-Object Windows.Forms.Button
$buttonBrowseTemplate.Text = "Browse"
$buttonBrowseTemplate.Location = New-Object Drawing.Point(360, 50)
$buttonBrowseTemplate.Add_Click({
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "Text Files (*.txt)|*.txt|All Files (*.*)|*.*"
    if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $textBoxTemplate.Text = $openFileDialog.FileName
    }
})
$form.Controls.Add($buttonBrowseTemplate)

$labelOutput = New-Object Windows.Forms.Label
$labelOutput.Text = "Output Directory:"
$labelOutput.Location = New-Object Drawing.Point(20, 80)
$form.Controls.Add($labelOutput)

$textBoxOutput = New-Object Windows.Forms.TextBox
$textBoxOutput.Location = New-Object Drawing.Point(150, 80)
$textBoxOutput.Size = New-Object Drawing.Size(200, 20)
$form.Controls.Add($textBoxOutput)

$buttonBrowseOutput = New-Object Windows.Forms.Button
$buttonBrowseOutput.Text = "Browse"
$buttonBrowseOutput.Location = New-Object Drawing.Point(360, 80)
$buttonBrowseOutput.Add_Click({
    $folderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($folderBrowserDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $textBoxOutput.Text = $folderBrowserDialog.SelectedPath
    }
})
$form.Controls.Add($buttonBrowseOutput)

# Create a button to start the process
$buttonGenerate = New-Object Windows.Forms.Button
$buttonGenerate.Text = "Generate"
$buttonGenerate.Location = New-Object Drawing.Point(150, 120)
$buttonGenerate.Add_Click({
    $csvFile = $textBoxCSV.Text
    $templateFile = $textBoxTemplate.Text
    $outputPath = $textBoxOutput.Text

    # Validate if the output directory exists, create if not
    if (-not (Test-Path -Path $outputPath -PathType Container)) {
        Write-Host "Output directory doesn't exist. Creating..."
        New-Item -ItemType Directory -Path $outputPath | Out-Null
    }

    # Call the function to generate the configuration files
    GenerateConfigFilesFromCSV -csvFile $csvFile -templateFile $templateFile -outputPath $outputPath

    [System.Windows.Forms.MessageBox]::Show("Configuration files generated successfully!")
})
$form.Controls.Add($buttonGenerate)

# Function to generate configuration files
function GenerateConfigFilesFromCSV {
    param (
        [string]$csvFile,
        [string]$templateFile,
        [string]$outputPath
    )

    # Read data from the CSV file
    $data = Import-Csv -Path $csvFile

    # Read the template text from the second file
    $templateText = Get-Content $templateFile

    #Edit Line 111-141 with the data you need
    foreach ($row in $data) {
        $hostname = $row.Hostname
        $ip = $row.IP
        $gateway = $row.gateway
        $building = $row.building
        $port = $row.port
        $core = $row.core

        # Replace "{hostname}" with the current hostname
        $newConfigText = $templateText -replace '\{hostname\}', $hostname

        # Replace "{ip}" with the current IP address
        $newConfigText = $newConfigText -replace '\{ip\}', $ip

        # Replace "{gateway}" with the current gateway
        $newConfigText = $newConfigText -replace '\{gateway\}', $gateway

        # Replace "{building}" with the current IP address
        $newConfigText = $newConfigText -replace '\{building\}', $building

        # Replace "{port}" with the configured port range
        $newConfigText = $newConfigText -replace '\{port\}', $port

        # Replace "{core}" with the neighbor core node
        $newConfigText = $newConfigText -replace '\{core\}', $core

        # Generate the output filename using the current hostname
        $outputFileName = Join-Path $outputPath "$hostname.txt"

        # Write the new configuration text to the output file
        $newConfigText | Out-File -FilePath $outputFileName

        # Display the output file path
        Write-Host "Created: $outputFileName"
    }
}

# Show the form
$form.ShowDialog()
