# Sysdig GCP Cloud Account Onboarding

This repository provides resources and automation for onboarding Google Cloud Platform (GCP) cloud accounts to Sysdig. The onboarding process is specifically designed for Project-based installations (not Organization-level) and ensures that your GCP environment is connected to Sysdig for continuous monitoring and security.

## Prerequisites

Before starting the onboarding process, ensure the following prerequisites are met:

### GCP Service Account and Permissions

1. Create a Service Account in GCP with the following roles assigned:
    - `roles/iam.serviceAccountAdmin`
    - `roles/iam.roleAdmin`
    - `roles/resourcemanager.projectIamAdmin`
    - `roles/iam.serviceAccountKeyAdmin`
    - `roles/serviceusage.serviceUsageAdmin`

2. Generate a key for the Service Account and download it.

3. Store the key as a **Repository Secret** in GitHub:
    - Go to your GitHub repository and navigate to `Settings > Secrets and Variables > New repository secret`.
    - Name the secret `GCP_CREDENTIALS` and upload the key value.

### Additional Repository Secrets

Set the following secrets in your GitHub repository:

- **`GCP_PROJECT_ID`**: Your GCP Project ID to be onboarded with Sysdig.
- **`GCP_REGION`**: The GCP region code for the project (e.g., `us-central1`).
- **`SYSDIG_SECURE_API_TOKEN`**: Your Sysdig Secure API token.
- **`SYSDIG_SECURE_ENDPOINT_URL`**: Your Sysdig Secure Endpoint URL (e.g., `https://secure.sysdig.com`).

### Tools and Permissions

- **Sysdig Secure SaaS** with admin permissions to configure cloud onboarding.
- **Terraform v1.3.1+** installed. [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).
- **GCP CLI** installed. [Install the GCP CLI](https://cloud.google.com/sdk/docs/install).
- Access to a user with the required permissions to install.

### Enable Required APIs

The following APIs must be enabled in GCP for onboarding:

- [Enable Required APIs](https://docs.sysdig.com/en/docs/sysdig-secure/connect-cloud-accounts/gcp/#enable-required-apis)

## Repository Structure

- **/cdr**: Resources specific to Cloud Detection and Response (CDR) enablement. This is not part of the onboarding process described here.
- **/terraform**: Terraform scripts for automating the onboarding process.

## Getting Started

1. Clone this repository:
   ```bash
   git clone https://github.com/yoshiouchi/sysdig-gcp-onboarding.git
   cd sysdig-gcp-onboarding
   ```

2. Ensure all prerequisites are completed, including setting up the required GitHub repository secrets.

3. Initialize Terraform:
   ```bash
   terraform init
   ```

4. Review and update the `terraform/variables.tf` file to ensure it matches your GCP and Sysdig configuration.

5. Run the Terraform scripts to onboard your GCP cloud account:
   ```bash
   terraform apply
   ```

6. Verify the onboarding process in Sysdig Secure under the **Cloud Accounts** section.

## Support

If you encounter any issues or have questions, refer to the official Sysdig documentation:

- [Sysdig Secure GCP Onboarding Documentation](https://docs.sysdig.com/en/docs/sysdig-secure/connect-cloud-accounts/gcp/#install-gcp-using-the-wizard)

You can also open an issue in this repository for further assistance.

## License

This project is licensed under the [MIT License](LICENSE).

---

By using this repository, you streamline the onboarding of GCP cloud accounts to Sysdig, enabling comprehensive cloud security and monitoring.
