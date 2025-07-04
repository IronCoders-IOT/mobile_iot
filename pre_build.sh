#!/bin/bash

ENV=$1

if [ -z "$ENV" ]; then
  echo "No environment specified. Exiting."
  exit 1
fi

# Copy the environment-specific file to .env
cp ".env.$ENV" ".env"

# Update the env.dart file to use the correct .env file
sed -i "s/path: '\.env[^']*'/path: '.env.$ENV'/" lib/core/config/env.dart

echo "Environment set to $ENV"
echo "Updated env.dart to use .env.$ENV" 