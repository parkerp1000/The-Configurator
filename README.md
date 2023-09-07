# Configurator V4.0

Configurator V4.0 is a Windows Forms application that simplifies the process of generating configuration files based on data from a CSV file and a template file.

## Getting Started

To use this application, follow these steps:

1. Clone or download this GitHub repository to your local machine.

2. Open the `The_Configurator_v4.ps1` file using PowerShell.

3. The application will open, and you will see a graphical user interface (GUI) with the following input fields:

   - **CSV File Path:** Use the "Browse" button to select the CSV file containing your data. This file should have columns like `Hostname`, `IP`, `gateway`, `building`, `port`, and `core`. You can edit the script to contain the specific columns that suit your specific needs.

   - **Template File Path:** Use the "Browse" button to select the template file that you want to use for generating configuration files. This file should contain placeholders like `{hostname}`, `{ip}`, `{gateway}`, etc., which will be replaced with data from the CSV file.

   - **Output Directory:** Use the "Browse" button to select the directory where the generated configuration files will be saved.

4. After entering the file paths and output directory, click the "Generate Config Files" button.

5. The application will read data from the CSV file, replace placeholders in the template file with data from each row of the CSV, and save the generated configuration files in the specified output directory.

6. A message box will appear, indicating that the configuration files have been generated successfully.

7. You can now find the generated configuration files in the output directory you specified.

## Requirements

- PowerShell (Windows) is required to run this application.

## Notes

- Ensure that the CSV file and template file you provide are correctly formatted. Any discrepancies in the column names or placeholders may result in errors.

- If the specified output directory does not exist, the application will create it for you.

- Feel free to customize the template file and the placeholders as per your requirements.


**Disclaimer:** This application is provided as-is, without any warranties or guarantees. Please use it responsibly and ensure that you have backups of your data.
