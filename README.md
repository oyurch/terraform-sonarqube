# SonarCloud Onboarding with Terraform

This repository contains Terraform configurations to automate the creation of projects in SonarCloud, assign quality gates, and set up associated conditions for these gates.

## Prerequisites

- **Terraform**: Ensure you have Terraform installed. You can download it from [Terraform's official site](https://www.terraform.io/downloads.html).
- **SonarCloud Account**: You need a SonarCloud account and an organization set up.
- **SonarCloud API Token**: Generate a token from your SonarCloud account to authenticate API requests.

## Onboarding a New Project

To onboard a new project:

	1.	Go to the https://sonarcloud.io/account/security. Generate a token and store it on the GitHub secrets as a `SONAR_TOKEN`.
    2.  Add the project details in the projects variable in terraform.tfvars.
	3.	Define the necessary quality gates and conditions, if not already defined.
	4.	Run terraform apply again to create the project in SonarCloud and assign the appropriate quality gate.

Example CI/CD Pipeline Configuration

For GitHub Actions, here’s an example of how you can integrate SonarCloud into your CI/CD pipeline:

```yaml
  - name: SonarCloud Scan
    uses: SonarSource/sonarcloud-github-action@v1.5
    env:
      SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
    with:
      projectBaseDir: custom-dir
      args: >
        -Dsonar.projectKey=your_project_key
        -Dsonar.organization=your_organization_key
        -Dsonar.language=py
        -Dsonar.host.url=https://sonarcloud.io
        -Dsonar.python.coverage.reportPaths=coverage.xml
        -Dsonar.python.version=3.12
        -Dsonar.sourceEncoding=UTF-8
        -Dsonar.sources=.
```

Replace the `your_organization_key` and `your_project_key` with your SonarCloud organization and project keys.