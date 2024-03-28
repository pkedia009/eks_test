#!/bin/bash

# Initialize Terraform
echo "Initializing Terraform..."
terraform init

# Validate Terraform configuration
echo "Validating Terraform configuration..."
terraform validate

# Generate and save an execution plan
echo "Generating Terraform execution plan..."
terraform plan -out=tfplan.out

# Apply Terraform changes
read -p "Do you want to apply the Terraform changes? (yes/no): " apply_choice
if [ "$apply_choice" = "yes" ]; then
  echo "Applying Terraform changes..."
  terraform apply "tfplan.out"
else
  echo "Terraform apply skipped."
fi

