#!/bin/bash

# Find the most recent .json file in the current directory
LATEST_JSON=$(ls -t *.json | head -n 1)

# Extract the default region from line 2 (after "Attempting to create job in default region:")
DEFAULT_REGION=$(sed -n '2p' "$LATEST_JSON" | awk -F': ' '{print $2}')

# Check if line 4 contains "Unable to create job in default region"
LINE4=$(sed -n '4p' "$LATEST_JSON")

if echo "$LINE4" | grep -q "Unable to create job in default region"; then
    # If line 4 contains "Unable to create job in default region", extract the region after "Running in permitted region:"
    REGION=$(echo "$LINE4" | awk -F'Running in permitted region: ' '{print $2}')
else
    # Otherwise, use the default region from line 2
    REGION=$DEFAULT_REGION
fi

# Extract the Job ID value after "Job ID:"
JOB_ID=$(grep "Job ID:" "$LATEST_JSON" | awk -F': ' '{print $2}')

# List of possible regions
POSSIBLE_REGIONS="GCP_US_EAST4,GCP_US_WEST1,GCP_US_CENTRAL1,GCP_EUROPE_WEST3,GCP_AUSTRALIA_SOUTHEAST1,GCP_NORTHAMERICA_NORTHEAST1,GCP_EUROPE_WEST2,GCP_ASIA_SOUTHEAST1,GCP_ASIA_SOUTHEAST2,GCP_ASIA_SOUTH1,GCP_ASIA_NORTHEAST1,AWS_US_EAST_1,AWS_US_EAST_2,AWS_US_WEST_2,AWS_AP_NORTHEAST_1,AWS_AP_SOUTHEAST_1,AWS_AP_SOUTHEAST_2,AWS_EU_CENTRAL_1,AWS_EU_WEST_1,AWS_EU_WEST_2,AWS_AP_SOUTH_1,AWS_CA_CENTRAL_1,AWS_US_GOV_WEST_1,AZURE_EASTUS2,AZURE_AUSTRALIAEAST,AZURE_UKSOUTH,AZURE_WESTEUROPE,AZURE_CENTRALUS,AZURE_CANADACENTRAL,AZURE_UAENORTH,AZURE_SOUTHEASTASIA,AZURE_EASTUS,AZURE_JAPANEAST,AZURE_CENTRALINDIA"

# Validate if the extracted region is in the list of possible regions
if [[ ! ",$POSSIBLE_REGIONS," =~ ",$REGION," ]]; then
    echo "Error: Extracted region '$REGION' is not in the list of possible regions."
    exit 1
fi

# Check if both region and job ID were extracted
if [ -z "$REGION" ] || [ -z "$JOB_ID" ]; then
    echo "Error: Could not extract Region or Job ID from $LATEST_JSON"
    exit 1
fi

# Print the file name, region, and job ID
echo "File: $LATEST_JSON"
echo "Region: $REGION"
echo "Job ID: $JOB_ID"

# Run the salame command with the extracted values
salame shell -r="$REGION" download -d=/Users/conal.king/runmock/output/ "$JOB_ID"