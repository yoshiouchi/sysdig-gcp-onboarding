# Sysdig GCP Cloud Detection and Response (CDR)

This repository provides resources and guidance for enabling Cloud Detection and Response (CDR) with Sysdig in a Google Cloud Platform (GCP) environment.

## Prerequisites

Before using this repository, ensure the following prerequisites are met:

1. **GCP APIs and Sysdig CSPM**:
   - You must have already enabled the required GCP APIs and configured Cloud Security Posture Management (CSPM) with Sysdig.
   - Follow the steps outlined in the Sysdig documentation: [Install GCP using the Wizard](https://docs.sysdig.com/en/docs/sysdig-secure/connect-cloud-accounts/gcp/#install-gcp-using-the-wizard).

2. **Sysdig Documentation**:
   - The steps described in the Sysdig documentation for integrating GCP accounts are mandatory and assumed to be completed before proceeding with this repository.
   - Refer to the Sysdig documentation here: [Connect GCP Accounts](https://docs.sysdig.com/en/docs/sysdig-secure/connect-cloud-accounts/gcp/).

## Repository Contents

This repository contains the following resources:

- **Terraform Scripts**: Automate the setup of Sysdig Cloud Detection and Response (CDR) in GCP.
- **Configuration Examples**: Examples to configure policies, alerts, and monitoring for GCP environments.
- **Documentation**: Detailed steps and descriptions to assist with the deployment process.

## Getting Started

To begin:

1. Clone this repository:
   ```bash
   git clone https://github.com/yoshiouchi/sysdig-gcp-cdr.git
   cd sysdig-gcp-cdr
   ```

2. Ensure all prerequisites listed above are completed.

3. Follow the setup instructions provided in the repository files (e.g., Terraform scripts and configuration examples).

## Support

If you encounter any issues or have questions about this repository, please refer to the [Sysdig Support Documentation](https://docs.sysdig.com/en/) or open an issue in this repository.

## License

This project is licensed under the [MIT License](LICENSE).

---

By enabling Cloud Detection and Response (CDR) with Sysdig, you gain visibility and security insights for your cloud workloads and infrastructure on GCP. Happy monitoring!
