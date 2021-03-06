# Generated Form Function

function Show-hashglyph_psf {

	#----------------------------------------------
	#region Import the Assemblies
	#----------------------------------------------
	[void][reflection.assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
	#endregion Import Assemblies

	#----------------------------------------------
	#region Generated Form Objects
	#----------------------------------------------
	[System.Windows.Forms.Application]::EnableVisualStyles()
	$formHashGlyph = New-Object 'System.Windows.Forms.Form'
	$label3 = New-Object 'System.Windows.Forms.Label'
	$label2 = New-Object 'System.Windows.Forms.Label'
	$label1 = New-Object 'System.Windows.Forms.Label'
	$label____________________ = New-Object 'System.Windows.Forms.Label'
	$labelStatus = New-Object 'System.Windows.Forms.Label'
	$statusBox = New-Object 'System.Windows.Forms.RichTextBox'
	$OutputBrowse = New-Object 'System.Windows.Forms.Button'
	$outputFilePath = New-Object 'System.Windows.Forms.TextBox'
	$labelOutputFile = New-Object 'System.Windows.Forms.Label'
	$copySHA512Hash = New-Object 'System.Windows.Forms.Button'
	$copySHA256Hash = New-Object 'System.Windows.Forms.Button'
	$copySHA1Hash = New-Object 'System.Windows.Forms.Button'
	$sha512FileWrite = New-Object 'System.Windows.Forms.Button'
	$sha256FileWrite = New-Object 'System.Windows.Forms.Button'
	$sha1FileWrite = New-Object 'System.Windows.Forms.Button'
	$md5FileWrite = New-Object 'System.Windows.Forms.Button'
	$copyMD5Hash = New-Object 'System.Windows.Forms.Button'
	$SHA512Output = New-Object 'System.Windows.Forms.TextBox'
	$SHA256Output = New-Object 'System.Windows.Forms.TextBox'
	$SHA1Output = New-Object 'System.Windows.Forms.TextBox'
	$MD5Output = New-Object 'System.Windows.Forms.TextBox'
	$labelInputFile = New-Object 'System.Windows.Forms.Label'
	$labelHashOutput = New-Object 'System.Windows.Forms.Label'
	$labelSHA512 = New-Object 'System.Windows.Forms.Label'
	$labelSHA256 = New-Object 'System.Windows.Forms.Label'
	$labelSHA1 = New-Object 'System.Windows.Forms.Label'
	$labelMD5 = New-Object 'System.Windows.Forms.Label'
	$buttonBrowse = New-Object 'System.Windows.Forms.Button'
	$inputTextBox = New-Object 'System.Windows.Forms.TextBox'
	$labelHashGlyph = New-Object 'System.Windows.Forms.Label'
	$TitleLabel = New-Object 'System.Windows.Forms.Label'
	$openfiledialog1 = New-Object 'System.Windows.Forms.OpenFileDialog'
	$savefiledialog1 = New-Object 'System.Windows.Forms.SaveFileDialog'
	$errorprovider1 = New-Object 'System.Windows.Forms.ErrorProvider'
	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
	#endregion Generated Form Objects

	#----------------------------------------------
	# User Generated Script
	#----------------------------------------------
	$formHashGlyph_Load={ 					#Put cursor in bottom status box by default
		$formHashGlyph.Add_Shown({$formHashGlyph.Activate(); $statusBox.focus()})
	}
	
	function inputTextbox #Open input file dialog box, select file, display in field, calculate and display hashes
	{
		$openFileDialog1.ShowHelp = $false
		$openfiledialog1.ShowDialog()
		$inputTextBox.Text = $openfiledialog1.FileName
		$openfiledialog1_FileOK = [System.ComponentModel.CancelEventHandler]{
			[void][System.Windows.Forms.MessageBox]::Show($openfiledialog1.FileName,"Caption")
		}
		if ($inputTextBox.Text.Length -gt 0) #Write values if anything has been selected in the input box
		{
			calcHash
			displayHash
			$statusBox.Text = -join ('Hash values for ', $inputTextBox.Text, ' calculated')
		}
	}
	
	function outputTextbox #Open output file textbox, select file and displays path in box.
	{
		$savefiledialog1.ShowHelp = $false
		if ($savefiledialog1.ShowDialog() -eq 'OK')
		{
			$outputFilePath.Text = $savefiledialog1.FileName
			$fileExists = Test-Path -Path $outputFilePath.Text -PathType Leaf
			if ($fileExists -eq 'True')
			{
				try
				{
					Clear-Content -Path $outputFilePath.Text -ErrorAction Stop #Error action is used so that Catch will detect the non-terminating process
				}
				Catch
				{
					$statusBox.Text = "Error writing to file - please confirm that it is not in use by another process."
					Return
				}
			}
			
			if ($outputFilePath.Text.Length -gt 0)
			{
				$statusBox.Text = -join ('Output file path is set to ', $outputFilePath.Text)
			}
		}
		
		else
		{
			$statusBox.Text = "File Path Selection Canceled"
		}
	}
	
	$buttonBrowse_Click={					#Runs inputTextbox function when browse button is clicked
		inputTextbox	
	}
	
	$OutputBrowse_Click = {					#Runs outputTextbox button when browse button is clicked
		outputTextbox
	}
	
	function calcHash						#Calculates file hashes of all types and writes object property to variable
	{
		$global:md5value = Get-FileHash -Path $inputTextBox.Text -Algorithm MD5 | Select-Object -ExpandProperty Hash
		$global:sha1value = Get-FileHash -Path $inputTextBox.Text -Algorithm SHA1 | Select-Object -ExpandProperty Hash
		$global:sha256value = Get-FileHash -Path $inputTextBox.Text -Algorithm SHA256 | Select-Object -ExpandProperty Hash
		$global:sha512value = Get-FileHash -Path $inputTextBox.Text -Algorithm SHA512 | Select-Object -ExpandProperty Hash
	}
	
	function displayHash						#Displays hash values to display boxes for each hash type
	{
		$md5output.Text = $md5value
		$sha1output.Text = $sha1value
		$sha256output.Text = $sha256value
		$sha512output.Text = $sha512value
	}
	
	function hashOutputFile					#Writes hash information to file and displays status in box.
	{
		$global:filePath = $outputFilePath.text
		$hashList = [PSCustomObject]@{ 'Hash Value' = $hashvalue; 'Hash Type' = $hashType; 'File Path' = $inputTextBox.Text }
		try
		{
			$hashList | Export-Csv -Path $outputFilePath.text -NoTypeInformation -Append
		}
		catch
		{
			$statusBox.Text = "Error writing to file - please confirm that it is not in use by another process."
			validateOutputPath
			Return
		}	
		
		$statusBox.Text = -join ($hashType, ' hash of ', $inputTextBox.Text, ' written to file ', $outputFilePath.text)
		validateOutputPath
		validateInputPath
	}
	
	function validateOutputPath			#Validates that values exist for output path
	{
		if ($outputFilePath.Text.Length -eq 0)
		{
			$statusBox.Text = "Error - please enter a file output path before writing to file."
			Return
		}
	}
	
	function validateInputPath #Validates that values exist for input path
	{
		if ($inputTextBox.Text.Length -eq 0)
		{
			$statusBox.Text = "Error - please enter a file input path."
		}
		Return
	}
	
	function copyActionStatusBox 			#Displays copy message when a hash is copied to clipboard
	{
		$statusBox.Text = -join ($hashType, ' hash of ', $inputTextBox.Text, ' copied to clipboard ')
		validateInputPath
	}		
	
	$copyMD5Hash_Click={					#Copies hash values to clipboard when copy is selected
		$hashType = 'MD5'
		Set-Clipboard $md5value
		copyActionStatusBox
	}
	
	$copySHA1Hash_Click={ 					#Copies hash values to clipboard when copy is selected
		$hashType = 'SHA1'
		Set-Clipboard $sha1value
		copyActionStatusBox
	}
	
	$copySHA256Hash_Click = { 				#Copies hash values to clipboard when copy is selected
		$hashType = 'SHA256'
		Set-Clipboard $sha256value
		copyActionStatusBox
	}
	
	$copySHA512Hash_Click = { 				#Copies hash values to clipboard when copy is selected
		$hashType = 'SHA512'
		Set-Clipboard $sha512value
		copyActionStatusBox
	}
	
	$inputTextBox_TextChanged={				#Re-runs hash calculations and output when input textbox is changed
		calcHash
		displayHash
	}
	
	$md5FileWrite_Click = {					#Sets variables for hash type for file writing when corresponding write button is clicked
		$hashType = 'MD5'
		$hashValue = $md5value
		hashOutputFile
		
	}
	$sha1FileWrite_Click = { 				#Sets variables for hash type for file writing when corresponding write button is clicked
		$hashType = 'SHA1'
		$hashValue = $sha1value
		hashOutputFile
	}
	
	$sha256FileWrite_Click={ 				#Sets variables for hash type for file writing when corresponding write button is clicked
		$hashType = 'SHA256'
		$hashValue = $sha256value
		hashOutputFile
	}
	
	$sha512FileWrite_Click={ 				#Sets variables for hash type for file writing when corresponding write button is clicked
		$hashType = 'SHA512'
		$hashValue = $sha512value
		hashOutputFile
	}
	
	$inputTextBox_Click={					#Runs inputTextBox function if input textbox is clicked with nothing entered into it
		if ($inputTextBox.Text.Length -eq 0)
		{
			inputTextbox
		}
	}
	$outputFilePath_Click={ 				#Runs outputTextBox function if input textbox is clicked with nothing entered into it
		if ($outputFilePath.Text.Length -eq 0)
		{
			outputTextbox
		}
	}
	# --End User Generated Script--
	#----------------------------------------------
	#region Generated Events
	#----------------------------------------------
	
	$Form_StateCorrection_Load=
	{
		#Correct the initial state of the form to prevent the .Net maximized form issue
		$formHashGlyph.WindowState = $InitialFormWindowState
	}
	
	$Form_Cleanup_FormClosed=
	{
		#Remove all event handlers from the controls
		try
		{
			$OutputBrowse.remove_Click($OutputBrowse_Click)
			$outputFilePath.remove_Click($outputFilePath_Click)
			$copySHA512Hash.remove_Click($copySHA512Hash_Click)
			$copySHA256Hash.remove_Click($copySHA256Hash_Click)
			$copySHA1Hash.remove_Click($copySHA1Hash_Click)
			$sha512FileWrite.remove_Click($sha512FileWrite_Click)
			$sha256FileWrite.remove_Click($sha256FileWrite_Click)
			$sha1FileWrite.remove_Click($sha1FileWrite_Click)
			$md5FileWrite.remove_Click($md5FileWrite_Click)
			$copyMD5Hash.remove_Click($copyMD5Hash_Click)
			$buttonBrowse.remove_Click($buttonBrowse_Click)
			$inputTextBox.remove_Click($inputTextBox_Click)
			$inputTextBox.remove_TextChanged($inputTextBox_TextChanged)
			$formHashGlyph.remove_Load($formHashGlyph_Load)
			$formHashGlyph.remove_Load($Form_StateCorrection_Load)
			$formHashGlyph.remove_FormClosed($Form_Cleanup_FormClosed)
		}
		catch { Out-Null <# Prevent PSScriptAnalyzer warning #> }
	}
	#endregion Generated Events

	#----------------------------------------------
	#region Generated Form Code
	#----------------------------------------------
	$formHashGlyph.SuspendLayout()
	$errorprovider1.BeginInit()
	#
	# formHashGlyph
	#
	$formHashGlyph.Controls.Add($label3)
	$formHashGlyph.Controls.Add($label2)
	$formHashGlyph.Controls.Add($label1)
	$formHashGlyph.Controls.Add($label____________________)
	$formHashGlyph.Controls.Add($labelStatus)
	$formHashGlyph.Controls.Add($statusBox)
	$formHashGlyph.Controls.Add($OutputBrowse)
	$formHashGlyph.Controls.Add($outputFilePath)
	$formHashGlyph.Controls.Add($labelOutputFile)
	$formHashGlyph.Controls.Add($copySHA512Hash)
	$formHashGlyph.Controls.Add($copySHA256Hash)
	$formHashGlyph.Controls.Add($copySHA1Hash)
	$formHashGlyph.Controls.Add($sha512FileWrite)
	$formHashGlyph.Controls.Add($sha256FileWrite)
	$formHashGlyph.Controls.Add($sha1FileWrite)
	$formHashGlyph.Controls.Add($md5FileWrite)
	$formHashGlyph.Controls.Add($copyMD5Hash)
	$formHashGlyph.Controls.Add($SHA512Output)
	$formHashGlyph.Controls.Add($SHA256Output)
	$formHashGlyph.Controls.Add($SHA1Output)
	$formHashGlyph.Controls.Add($MD5Output)
	$formHashGlyph.Controls.Add($labelInputFile)
	$formHashGlyph.Controls.Add($labelHashOutput)
	$formHashGlyph.Controls.Add($labelSHA512)
	$formHashGlyph.Controls.Add($labelSHA256)
	$formHashGlyph.Controls.Add($labelSHA1)
	$formHashGlyph.Controls.Add($labelMD5)
	$formHashGlyph.Controls.Add($buttonBrowse)
	$formHashGlyph.Controls.Add($inputTextBox)
	$formHashGlyph.Controls.Add($labelHashGlyph)
	$formHashGlyph.Controls.Add($TitleLabel)
	$formHashGlyph.AutoScaleDimensions = New-Object System.Drawing.SizeF(6, 14)
	$formHashGlyph.AutoScaleMode = 'Font'
	$formHashGlyph.ClientSize = New-Object System.Drawing.Size(463, 608)
	$formHashGlyph.Font = [System.Drawing.Font]::new('Miriam Libre', '8.25')
	$formHashGlyph.Name = 'formHashGlyph'
	$formHashGlyph.Text = 'HashGlyph'
	$formHashGlyph.add_Load($formHashGlyph_Load)
	#
	# label3
	#
	$label3.AutoSize = $True
	$label3.Font = [System.Drawing.Font]::new('Cambria', '15.75')
	$label3.Location = New-Object System.Drawing.Point(87, 416)
	$label3.Name = 'label3'
	$label3.Size = New-Object System.Drawing.Size(340, 25)
	$label3.TabIndex = 37
	$label3.Text = '_________________________________________
'
	#
	# label2
	#
	$label2.AutoSize = $True
	$label2.Font = [System.Drawing.Font]::new('Cambria', '15.75')
	$label2.Location = New-Object System.Drawing.Point(87, 337)
	$label2.Name = 'label2'
	$label2.Size = New-Object System.Drawing.Size(340, 25)
	$label2.TabIndex = 36
	$label2.Text = '_________________________________________
'
	#
	# label1
	#
	$label1.AutoSize = $True
	$label1.Font = [System.Drawing.Font]::new('Cambria', '15.75')
	$label1.Location = New-Object System.Drawing.Point(87, 175)
	$label1.Name = 'label1'
	$label1.Size = New-Object System.Drawing.Size(340, 25)
	$label1.TabIndex = 35
	$label1.Text = '_________________________________________
'
	#
	# label____________________
	#
	$label____________________.AutoSize = $True
	$label____________________.Font = [System.Drawing.Font]::new('Cambria', '15.75')
	$label____________________.Location = New-Object System.Drawing.Point(82, 81)
	$label____________________.Name = 'label____________________'
	$label____________________.Size = New-Object System.Drawing.Size(340, 25)
	$label____________________.TabIndex = 34
	$label____________________.Text = '_________________________________________
'
	#
	# labelStatus
	#
	$labelStatus.AutoSize = $True
	$labelStatus.Font = [System.Drawing.Font]::new('Liberation Sans', '18', [System.Drawing.FontStyle]'Bold')
	$labelStatus.Location = New-Object System.Drawing.Point(193, 447)
	$labelStatus.Name = 'labelStatus'
	$labelStatus.Size = New-Object System.Drawing.Size(85, 27)
	$labelStatus.TabIndex = 33
	$labelStatus.Text = 'Status'
	#
	# statusBox
	#
	$statusBox.BackColor = [System.Drawing.Color]::White 
	$statusBox.DetectUrls = $False
	$statusBox.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '9.75')
	$statusBox.Location = New-Object System.Drawing.Point(87, 487)
	$statusBox.Name = 'statusBox'
	$statusBox.ReadOnly = $True
	$statusBox.Size = New-Object System.Drawing.Size(324, 88)
	$statusBox.TabIndex = 31
	$statusBox.Text = 'Awaiting Input'
	#
	# OutputBrowse
	#
	$OutputBrowse.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '8.25')
	$OutputBrowse.Location = New-Object System.Drawing.Point(357, 392)
	$OutputBrowse.Name = 'OutputBrowse'
	$OutputBrowse.Size = New-Object System.Drawing.Size(59, 22)
	$OutputBrowse.TabIndex = 30
	$OutputBrowse.Text = 'Browse'
	$OutputBrowse.UseVisualStyleBackColor = $True
	$OutputBrowse.add_Click($OutputBrowse_Click)
	#
	# outputFilePath
	#
	$outputFilePath.BackColor = [System.Drawing.Color]::White 
	$outputFilePath.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '8.25')
	$outputFilePath.Location = New-Object System.Drawing.Point(87, 393)
	$outputFilePath.Name = 'outputFilePath'
	$outputFilePath.ReadOnly = $True
	$outputFilePath.Size = New-Object System.Drawing.Size(268, 20)
	$outputFilePath.TabIndex = 29
	$outputFilePath.add_Click($outputFilePath_Click)
	#
	# labelOutputFile
	#
	$labelOutputFile.AutoSize = $True
	$labelOutputFile.Font = [System.Drawing.Font]::new('Liberation Sans', '18', [System.Drawing.FontStyle]'Bold')
	$labelOutputFile.Location = New-Object System.Drawing.Point(161, 363)
	$labelOutputFile.Name = 'labelOutputFile'
	$labelOutputFile.Size = New-Object System.Drawing.Size(140, 27)
	$labelOutputFile.TabIndex = 27
	$labelOutputFile.Text = 'Output File'
	#
	# copySHA512Hash
	#
	$copySHA512Hash.Font = [System.Drawing.Font]::new('Liberation Sans', '8.25')
	$copySHA512Hash.Location = New-Object System.Drawing.Point(307, 314)
	$copySHA512Hash.Margin = '3, 1, 3, 1'
	$copySHA512Hash.Name = 'copySHA512Hash'
	$copySHA512Hash.Size = New-Object System.Drawing.Size(40, 22)
	$copySHA512Hash.TabIndex = 26
	$copySHA512Hash.Text = 'Copy'
	$copySHA512Hash.UseVisualStyleBackColor = $True
	$copySHA512Hash.add_Click($copySHA512Hash_Click)
	#
	# copySHA256Hash
	#
	$copySHA256Hash.Font = [System.Drawing.Font]::new('Liberation Sans', '8.25')
	$copySHA256Hash.Location = New-Object System.Drawing.Point(307, 290)
	$copySHA256Hash.Name = 'copySHA256Hash'
	$copySHA256Hash.Size = New-Object System.Drawing.Size(40, 22)
	$copySHA256Hash.TabIndex = 25
	$copySHA256Hash.Text = 'Copy'
	$copySHA256Hash.UseVisualStyleBackColor = $True
	$copySHA256Hash.add_Click($copySHA256Hash_Click)
	#
	# copySHA1Hash
	#
	$copySHA1Hash.Font = [System.Drawing.Font]::new('Liberation Sans', '8.25')
	$copySHA1Hash.Location = New-Object System.Drawing.Point(307, 267)
	$copySHA1Hash.Name = 'copySHA1Hash'
	$copySHA1Hash.Size = New-Object System.Drawing.Size(40, 22)
	$copySHA1Hash.TabIndex = 24
	$copySHA1Hash.Text = 'Copy'
	$copySHA1Hash.UseVisualStyleBackColor = $True
	$copySHA1Hash.add_Click($copySHA1Hash_Click)
	#
	# sha512FileWrite
	#
	$sha512FileWrite.Font = [System.Drawing.Font]::new('Liberation Sans', '8.25')
	$sha512FileWrite.Location = New-Object System.Drawing.Point(347, 314)
	$sha512FileWrite.Margin = '3, 3, 1, 3'
	$sha512FileWrite.Name = 'sha512FileWrite'
	$sha512FileWrite.Size = New-Object System.Drawing.Size(59, 22)
	$sha512FileWrite.TabIndex = 23
	$sha512FileWrite.Text = 'Write'
	$sha512FileWrite.UseVisualStyleBackColor = $True
	$sha512FileWrite.add_Click($sha512FileWrite_Click)
	#
	# sha256FileWrite
	#
	$sha256FileWrite.Font = [System.Drawing.Font]::new('Liberation Sans', '8.25')
	$sha256FileWrite.Location = New-Object System.Drawing.Point(347, 290)
	$sha256FileWrite.Margin = '3, 3, 1, 3'
	$sha256FileWrite.Name = 'sha256FileWrite'
	$sha256FileWrite.Size = New-Object System.Drawing.Size(59, 22)
	$sha256FileWrite.TabIndex = 22
	$sha256FileWrite.Text = 'Write'
	$sha256FileWrite.UseVisualStyleBackColor = $True
	$sha256FileWrite.add_Click($sha256FileWrite_Click)
	#
	# sha1FileWrite
	#
	$sha1FileWrite.Font = [System.Drawing.Font]::new('Liberation Sans', '8.25')
	$sha1FileWrite.Location = New-Object System.Drawing.Point(347, 267)
	$sha1FileWrite.Margin = '3, 3, 1, 3'
	$sha1FileWrite.Name = 'sha1FileWrite'
	$sha1FileWrite.Size = New-Object System.Drawing.Size(59, 22)
	$sha1FileWrite.TabIndex = 21
	$sha1FileWrite.Text = 'Write'
	$sha1FileWrite.UseVisualStyleBackColor = $True
	$sha1FileWrite.add_Click($sha1FileWrite_Click)
	#
	# md5FileWrite
	#
	$md5FileWrite.Font = [System.Drawing.Font]::new('Liberation Sans', '8.25')
	$md5FileWrite.Location = New-Object System.Drawing.Point(347, 244)
	$md5FileWrite.Margin = '0, 0, 0, 0'
	$md5FileWrite.Name = 'md5FileWrite'
	$md5FileWrite.Size = New-Object System.Drawing.Size(59, 22)
	$md5FileWrite.TabIndex = 20
	$md5FileWrite.Text = 'Write'
	$md5FileWrite.UseVisualStyleBackColor = $True
	$md5FileWrite.add_Click($md5FileWrite_Click)
	#
	# copyMD5Hash
	#
	$copyMD5Hash.Font = [System.Drawing.Font]::new('Liberation Sans', '8.25')
	$copyMD5Hash.Location = New-Object System.Drawing.Point(306, 244)
	$copyMD5Hash.Margin = '3, 3, 1, 1'
	$copyMD5Hash.Name = 'copyMD5Hash'
	$copyMD5Hash.Size = New-Object System.Drawing.Size(40, 22)
	$copyMD5Hash.TabIndex = 19
	$copyMD5Hash.Text = 'Copy'
	$copyMD5Hash.UseVisualStyleBackColor = $True
	$copyMD5Hash.add_Click($copyMD5Hash_Click)
	#
	# SHA512Output
	#
	$SHA512Output.BackColor = [System.Drawing.Color]::White 
	$SHA512Output.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '8.25')
	$SHA512Output.Location = New-Object System.Drawing.Point(126, 316)
	$SHA512Output.Name = 'SHA512Output'
	$SHA512Output.ReadOnly = $True
	$SHA512Output.Size = New-Object System.Drawing.Size(178, 20)
	$SHA512Output.TabIndex = 17
	#
	# SHA256Output
	#
	$SHA256Output.BackColor = [System.Drawing.Color]::White 
	$SHA256Output.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '8.25')
	$SHA256Output.Location = New-Object System.Drawing.Point(126, 292)
	$SHA256Output.Name = 'SHA256Output'
	$SHA256Output.ReadOnly = $True
	$SHA256Output.Size = New-Object System.Drawing.Size(178, 20)
	$SHA256Output.TabIndex = 16
	#
	# SHA1Output
	#
	$SHA1Output.BackColor = [System.Drawing.Color]::White 
	$SHA1Output.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '8.25')
	$SHA1Output.Location = New-Object System.Drawing.Point(126, 268)
	$SHA1Output.Name = 'SHA1Output'
	$SHA1Output.ReadOnly = $True
	$SHA1Output.Size = New-Object System.Drawing.Size(178, 20)
	$SHA1Output.TabIndex = 15
	#
	# MD5Output
	#
	$MD5Output.BackColor = [System.Drawing.Color]::White 
	$MD5Output.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '8.25')
	$MD5Output.Location = New-Object System.Drawing.Point(126, 245)
	$MD5Output.MinimumSize = New-Object System.Drawing.Size(4, 22)
	$MD5Output.Name = 'MD5Output'
	$MD5Output.ReadOnly = $True
	$MD5Output.Size = New-Object System.Drawing.Size(178, 20)
	$MD5Output.TabIndex = 14
	#
	# labelInputFile
	#
	$labelInputFile.AutoSize = $True
	$labelInputFile.Font = [System.Drawing.Font]::new('Liberation Sans', '18', [System.Drawing.FontStyle]'Bold')
	$labelInputFile.Location = New-Object System.Drawing.Point(161, 109)
	$labelInputFile.Margin = '0, 0, 0, 0'
	$labelInputFile.Name = 'labelInputFile'
	$labelInputFile.Size = New-Object System.Drawing.Size(121, 27)
	$labelInputFile.TabIndex = 13
	$labelInputFile.Text = 'Input File'
	#
	# labelHashOutput
	#
	$labelHashOutput.AutoSize = $True
	$labelHashOutput.Font = [System.Drawing.Font]::new('Liberation Sans', '18', [System.Drawing.FontStyle]'Bold')
	$labelHashOutput.Location = New-Object System.Drawing.Point(161, 204)
	$labelHashOutput.Name = 'labelHashOutput'
	$labelHashOutput.Size = New-Object System.Drawing.Size(156, 27)
	$labelHashOutput.TabIndex = 12
	$labelHashOutput.Text = 'Hash Output'
	#
	# labelSHA512
	#
	$labelSHA512.AutoSize = $True
	$labelSHA512.Font = [System.Drawing.Font]::new('Liberation Sans', '9.75', [System.Drawing.FontStyle]'Bold')
	$labelSHA512.Location = New-Object System.Drawing.Point(68, 318)
	$labelSHA512.Margin = '0, 0, 0, 0'
	$labelSHA512.Name = 'labelSHA512'
	$labelSHA512.Size = New-Object System.Drawing.Size(55, 15)
	$labelSHA512.TabIndex = 11
	$labelSHA512.Text = 'SHA512'
	$labelSHA512.TextAlign = 'TopCenter'
	#
	# labelSHA256
	#
	$labelSHA256.AutoSize = $True
	$labelSHA256.Font = [System.Drawing.Font]::new('Liberation Sans', '9.75', [System.Drawing.FontStyle]'Bold')
	$labelSHA256.Location = New-Object System.Drawing.Point(68, 295)
	$labelSHA256.Name = 'labelSHA256'
	$labelSHA256.Size = New-Object System.Drawing.Size(55, 15)
	$labelSHA256.TabIndex = 10
	$labelSHA256.Text = 'SHA256'
	#
	# labelSHA1
	#
	$labelSHA1.AutoSize = $True
	$labelSHA1.Font = [System.Drawing.Font]::new('Liberation Sans', '9.75', [System.Drawing.FontStyle]'Bold')
	$labelSHA1.Location = New-Object System.Drawing.Point(82, 272)
	$labelSHA1.Name = 'labelSHA1'
	$labelSHA1.Size = New-Object System.Drawing.Size(41, 15)
	$labelSHA1.TabIndex = 9
	$labelSHA1.Text = 'SHA1'
	#
	# labelMD5
	#
	$labelMD5.AutoSize = $True
	$labelMD5.Font = [System.Drawing.Font]::new('Liberation Sans', '9.75', [System.Drawing.FontStyle]'Bold')
	$labelMD5.Location = New-Object System.Drawing.Point(89, 249)
	$labelMD5.Name = 'labelMD5'
	$labelMD5.Size = New-Object System.Drawing.Size(34, 15)
	$labelMD5.TabIndex = 8
	$labelMD5.Text = 'MD5'
	#
	# buttonBrowse
	#
	$buttonBrowse.Font = [System.Drawing.Font]::new('Liberation Sans', '8.25')
	$buttonBrowse.Location = New-Object System.Drawing.Point(352, 149)
	$buttonBrowse.Name = 'buttonBrowse'
	$buttonBrowse.Size = New-Object System.Drawing.Size(59, 22)
	$buttonBrowse.TabIndex = 6
	$buttonBrowse.Text = 'Browse'
	$buttonBrowse.UseVisualStyleBackColor = $True
	$buttonBrowse.add_Click($buttonBrowse_Click)
	#
	# inputTextBox
	#
	$inputTextBox.BackColor = [System.Drawing.Color]::White 
	$inputTextBox.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '8.25')
	$inputTextBox.Location = New-Object System.Drawing.Point(87, 150)
	$inputTextBox.Name = 'inputTextBox'
	$inputTextBox.ReadOnly = $True
	$inputTextBox.Size = New-Object System.Drawing.Size(263, 20)
	$inputTextBox.TabIndex = 5
	$inputTextBox.add_Click($inputTextBox_Click)
	$inputTextBox.add_TextChanged($inputTextBox_TextChanged)
	#
	# labelHashGlyph
	#
	$labelHashGlyph.AutoSize = $True
	$labelHashGlyph.Font = [System.Drawing.Font]::new('Elephant', '27.7499962', [System.Drawing.FontStyle]'Bold')
	$labelHashGlyph.ForeColor = [System.Drawing.Color]::Firebrick 
	$labelHashGlyph.Location = New-Object System.Drawing.Point(114, 34)
	$labelHashGlyph.Name = 'labelHashGlyph'
	$labelHashGlyph.Size = New-Object System.Drawing.Size(241, 47)
	$labelHashGlyph.TabIndex = 1
	$labelHashGlyph.Text = 'HashGlyph'
	#
	# TitleLabel
	#
	$TitleLabel.AutoSize = $True
	$TitleLabel.Font = [System.Drawing.Font]::new('Jokerman', '12', [System.Drawing.FontStyle]'Italic')
	$TitleLabel.ForeColor = [System.Drawing.Color]::Orange 
	$TitleLabel.Location = New-Object System.Drawing.Point(138, 10)
	$TitleLabel.Name = 'TitleLabel'
	$TitleLabel.Size = New-Object System.Drawing.Size(194, 24)
	$TitleLabel.TabIndex = 0
	$TitleLabel.Text = 'Admiral SYN-ACKbar''s'
	#
	# openfiledialog1
	#
	$openfiledialog1.DefaultExt = 'txt'
	$openfiledialog1.Filter = 'All Files|*.*'
	$openfiledialog1.ShowHelp = $True
	#
	# savefiledialog1
	#
	$savefiledialog1.Filter = 'CSV (Comma delimited) (*.csv)|*.csv'
	#
	# errorprovider1
	#
	$errorprovider1.ContainerControl = $formHashGlyph
	$errorprovider1.EndInit()
	$formHashGlyph.ResumeLayout()
	#endregion Generated Form Code

	#----------------------------------------------

	#Save the initial state of the form
	$InitialFormWindowState = $formHashGlyph.WindowState
	#Init the OnLoad event to correct the initial state of the form
	$formHashGlyph.add_Load($Form_StateCorrection_Load)
	#Clean up the control events
	$formHashGlyph.add_FormClosed($Form_Cleanup_FormClosed)
	#Show the Form
	return $formHashGlyph.ShowDialog()

} #End Function

#Call the form
Show-hashglyph_psf | Out-Null
