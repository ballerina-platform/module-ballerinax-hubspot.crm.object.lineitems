_Author_:  <!-- TODO: Add author name --> @hanaahh21\
_Created_: <!-- TODO: Add date --> 2024/12/12\
_Updated_: <!-- TODO: Add date --> 2025/01/03\
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from HubSpot CRM Objects Line Items
The OpenAPI specification is obtained from [Line_items OpenAPI](https://github.com/HubSpot/HubSpot-public-api-spec-collection/blob/main/PublicApiSpecs/CRM/Line%20Items/Rollouts/424/v3/lineItems.json).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.


1. Change the url property of the servers object:

    * Original: `https://api.hubapi.com`
    * Updated: `https://api.hubapi.com/crm/v3/objects/line_items`
    * Reason: This change is made to ensure that    all API paths are relative to the versioned base URL (crm/v3/objects/line_items), which improves the consistency and usability of the APIs.

2. Update API Paths:

    * Original: `/crm/v3/objects/line_items`
    * Updated: `/`
    * Reason: This modification simplifies the API paths, making them shorter and more readable. It also centralizes the versioning to the base URL, which is a common best practice.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/openapi.json --mode client --license docs/license.txt -o ballerina
```
Note: The license year is hardcoded to 2024, change if necessary.