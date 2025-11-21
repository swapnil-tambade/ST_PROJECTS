# dbt CI/CD Automation (GitHub Actions)

This projects demonstrates CI/CD for dbt using:
- GitHub Actions
- SQLFluff linter
- PR-based testing workflow

Pipeline:
1. Run dbt compile
2. Run dbt tests
3. Run SQLFluff
4. Deploy on merge

##workflow .yml file located in .github/workflows folder
