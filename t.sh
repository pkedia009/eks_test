#!/bin/bash

# Initialize Terraform
echo "Initializing Terraform..."
terraform init

# Validate Terraform configuration
echo "Validating Terraform configuration..."
terraform validate

# Generate and show an execution plan
echo "Generating Terraform execution plan..."
terraform plan

# Apply Terraform changes
read -p "Do you want to apply the Terraform changes? (yes/no): " apply_choice
if [ "$apply_choice" = "yes" ]; then
  echo "Applying Terraform changes..."
  terraform apply
else
  echo "Terraform apply skipped."
fi

