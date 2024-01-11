# Machine Learning Pipeline with Terraform and GCP

## Prerequisites
Before you begin, ensure you have the following:

- A Google Cloud Platform (GCP) account.
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed.
- [Terraform](https://www.terraform.io/downloads.html) installed.

## Setup

1. **GCP Authentication**:
   - Create a GCP service account key:
     - Go to the GCP Console.
     - Navigate to "IAM & Admin" > "Service Accounts".
     - Click "Create Service Account" and follow the on-screen instructions.
     - After creating your service account, click "Create Key" and save the JSON file to your project directory.
   - Create `terraform.tfvars` with the path to your service account key.
     - project          = "project-id"
     - credentials_file = "path/to/credentials.json"

2. **Initialize Terraform**:
   - Run `terraform init` in your project directory. This will download the necessary providers and initialize the Terraform project.
