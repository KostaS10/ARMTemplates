package StoragewithHttpsOnly


allow = true {
	HTTPSenabled == true
    IsStorageAccount == true
} else = false {
	HTTPSenabled == false
    IsStorageAccount == true

# If no Storage Account is being deployed, pass true as not to break the pipeline
} else = true {
	IsStorageAccount == false
}

default HTTPSenabled = false
default IsStorageAccount = false
default HasValueInParameters = false
default IsTemplateFile = false
default TemplateFileValueValid = false
default ValueInParameters = false
default ProceedWithoutParametersFile = false

# Function checking if the HTTPS is being enforced on Storage Account
HTTPSenabled = true {
	params := input.parameters
    params.supportsHttpsTrafficOnly.value == true
}

# Function checking if there is Storage Account being deployed
IsStorageAccount = true {
	values := input.parameters
    values.storageAccountName
}



##########################################################################################################
# Function returning true if this is templates file, false if it is parameter file

IsTemplateFile = true {
	input.resources != null  
}
# Function checking if we are deploying storage account and if the value is either defined in parameters
# or is true here, false if hardcoded value is false
TemplateFileValidValue = true {
	IsTemplateFile = true
	input.resources[_].type == "Microsoft.Storage/storageAccounts"
    var := input.resources[_].properties.supportsHttpsTrafficOnly
	regex.match(`\bparameters\b`, var)
} else = false {
	IsTemplateFile = true
	input.resources[_].type == "Microsoft.Storage/storageAccounts"
    input.resources[_].properties.supportsHttpsTrafficOnly == "false"
} else = true {
	IsTemplateFile = true
	input.resources[_].type == "Microsoft.Storage/storageAccounts"
    input.resources[_].properties.supportsHttpsTrafficOnly == "true"
    } else = true

# Get exact value from the property
TemplateFileValue[val.supportsHttpsTrafficOnly]{
	val := input.resources[_].properties
}

# Compate the exact value from above if it matches parameters
ValueInParameters = true {
	TemplateFileValue["[parameters('supportsHttpsTrafficOnly')]"]
}

# Proceeding without consulting parameters file is true if value is hardcoded true, otherwise check parameters file
ProceedWithoutParametersFile = true {
	IsTemplateFile = true
	TemplateFileValidValue = true
    ValueInParameters = false
}


