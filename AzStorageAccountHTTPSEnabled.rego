package test.AzureStorageAccountHTTPS

import input as tfplan
# Allow function returning true if Storage Account is being deployed and HTTPS is forced, deny if HTTPS is not enforced
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

# Function checking if the HTTPS is being enforced on Storage Account
HTTPSenabled = true {
	params := tfplan.parameters
    params.supportsHttpsTrafficOnly.value == true
}

# Function checking if there is Storage Account being deployed
IsStorageAccount = true {
	values := tfplan.parameters
    values.storageAccountName
}