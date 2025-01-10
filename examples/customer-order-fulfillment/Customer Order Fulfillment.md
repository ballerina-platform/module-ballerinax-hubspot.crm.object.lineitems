## Customer order fulfillment in a warehouse management system

This use case demonstrates how the `hubspot.crm.obj.lineitems` API can be utilized to manage inventory and streamline order fulfillment in a warehouse management system. The example involves a sequence of actions leveraging the HubSpot CRM API v3 to automate creating, verifying, updating, searching, and deleting line items in batches. It begins with batch creation for multiple products, followed by verifying batch details, searching inventory by product name, updating quantities as per customer requests, and finally archiving the batch after order fulfillment.

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