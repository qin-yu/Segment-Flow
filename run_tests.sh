#!/bin/bash
# Test runner for the model discovery functionality

set -e

echo "================================================"
echo "  Running Model Discovery Tests"
echo "================================================"
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Run the Nextflow test
cd "$SCRIPT_DIR"
nextflow run test_model_discovery.nf

echo ""
echo "================================================"
echo "  Test execution completed"
echo "================================================"
