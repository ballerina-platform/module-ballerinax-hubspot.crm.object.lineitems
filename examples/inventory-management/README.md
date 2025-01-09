## Inventory management for an E-commerce platform

This use case demonstrates how the `hubspot.crm.obj.lineitems` API can be utilized to efficiently manage product inventory for an operational deal in an E-commerce platform. The example involves a sequence of actions leveraging the HubSpot CRM API v3 to automate product addition, retrieval, updating, validation, and batch creation.

## Prerequisites

### 1. Setup the Hubspot developer account

Refer to the [Setup guide](../../README.md#setup-guide) to obtain necessary credentials (client Id, client secret, Refresh tokens).

### 2. Configuration

Create a `Config.toml` file in the example's root directory and, provide your Hubspot account related configurations as follows:

```toml
clientId = "<Client ID>"
clientSecret = "<Client Secret>"
refreshToken = "<Access Token>"
```

## Run the example

Execute the following command to run the example:

```bash
bal run
```