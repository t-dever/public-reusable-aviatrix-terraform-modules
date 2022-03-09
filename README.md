# public-reusable-aviatrix-terraform-modules

Reusable templates to deploy a multi cloud transit network with aviatrix solution.

## How to modify code

```terminal
pip install -U -r requirements.txt
pre-commit install
```

## NOTES

If checkov pre-check is NOT working with python pre-commit check then run from docker container in powershell.

```powershell
cd public-aviatrix-multi-cloud-network
docker run -v ${pwd}:/lint -w /lint ghcr.io/antonbabenko/pre-commit-terraform:latest run -a
```
