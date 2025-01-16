
# Overview

[HubSpot](https://www.hubspot.com/our-story) is an AI-powered customer platform. 

The `ballerinax/hubspot.crm.object.lineitems` package offers APIs to connect and interact with the [HubSpot CRM Lineitems API](https://developers.hubspot.com/docs/reference/api/crm/objects/line-items) endpoints, specially based on [HubSpot REST API v3](https://developers.hubspot.com/docs/reference/api).

# Setup guide

To use the HubSpot Properties connector, you must have access to the HubSpot API through a HubSpot developer account and a HubSpot App under it. Therefore, you need to register for a developer account at HubSpot if you don't have one already. 

#### Step 01 : Create/ Login to a HubSpot Developer Account

 If you have an account already go to the [Hubspot account portal](https://app.hubspot.com/myaccounts-beta)

 If you don't have a developer account, register for a free Hubspot developer account.[(click here)](https://app.hubspot.com/signup-hubspot/developers?_ga=2.207749649.2047916093.1734412948-232493525.1734412948&step=landing_page)

#### Step 02 (Optional) : Create a Developer test account:
Within app developer accounts, you can create [Developer test accounts](https://developers.hubspot.com/beta-docs/getting-started/account-types#developer-test-accounts) to test apps and integrations without affecting any real HubSpot data.

Note: These accounts are only for development and testing purposes. In production you should not use Developer Test Accounts.

1. Go to Test Account section from the left sidebar.

   ![Hubspot Developer Portal](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems/main/docs/setup/resources/test_acc_1.png)


2. Click Create developer test account.

   ![Hubspot Developer Test Account](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems/main/docs/setup/resources/test_acc_2.png)

3. Create developer test account by providing a name

#### Step 03 : Create a HubSpot App under your account

  1. In your developer account, navigate to the [Apps](https://app.hubspot.com/developer/48567544/applications) section.
Click on `Create App`
![create app](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems/main/docs/setup/resources/create_app_1.png)

2. Provide the necessary details, including the app name and description.

#### Step 04 : Configure the Authentication Flow

1. Move to the Auth tab.
![alt text](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems/main/docs/setup/resources/image.png)

2. In the Scopes section, add necessary scopes for your app using the "Add new scope" button. For line items API connector we will have to add the following 3 scopes in addition to existing `oauth` scope.
* `e-commerce`
* `crm.objects.line_items.read`
* `crm.objects.line_items.write`
 
   ![Hubspot set scope](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems/main/docs/setup/resources/image-2.png)

3. Add your Redirect URI in the relevant section. You can also use localhost addresses for local development purposes. Click Create App.  
   ![Hubspot create app final](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems/main/docs/setup/resources/create_app_final.png)


#### Step 5: Get your Client ID and Client Secret

- Navigate to the Auth section of your app. Make sure to save the provided Client ID and Client Secret.  
  ![Hubspot get credentials](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems/main/docs/setup/resources/get_credentials.png)

#### Step 6: Setup Authentication Flow

Before proceeding with the Quickstart, ensure you have obtained the Access Token using the following steps:

1. Create an authorization URL using the following format:

   ```
   https://app.hubspot.com/oauth/authorize?client_id=<YOUR_CLIENT_ID>&scope=<YOUR_SCOPES>&redirect_uri=<YOUR_REDIRECT_URI>
   ```

   Replace the `<YOUR_CLIENT_ID>`, `<YOUR_REDIRECT_URI>` and `<YOUR_SCOPES>` with your specific value.

2. Paste it in the browser and select your developer test account to intall the app when prompted.
3. A code will be displayed in the browser. Copy the code.

   ```
   Received code: na1-129d-860c-xxxx-xxxx-xxxxxxxxxxxx
   ```

4. Run the following curl command. Replace the `<YOUR_CLIENT_ID>`, `<YOUR_REDIRECT_URI`> and `<YOUR_CLIENT_SECRET>` with your specific value. Use the code you received in the above step 3 as the `<CODE>`.

   - Linux/macOS

     ```bash
     curl --request POST \
     --url https://api.hubapi.com/oauth/v1/token \
     --header 'content-type: application/x-www-form-urlencoded' \
     --data 'grant_type=authorization_code&code=<CODE>&redirect_uri=<YOUR_REDIRECT_URI>&client_id=<YOUR_CLIENT_ID>&client_secret=<YOUR_CLIENT_SECRET>'
     ```

   - Windows

     ```bash
     curl --request POST ^
     --url https://api.hubapi.com/oauth/v1/token ^
     --header 'content-type: application/x-www-form-urlencoded' ^
     --data 'grant_type=authorization_code&code=<CODE>&redirect_uri=<YOUR_REDIRECT_URI>&client_id=<YOUR_CLIENT_ID>&client_secret=<YOUR_CLIENT_SECRET>'
     ```

   This command will return the access token necessary for API calls.

   ```json
   {
     "token_type": "bearer",
     "refresh_token": "<Refresh Token>",
     "access_token": "<Access Token>",
     "expires_in": 1800
   }
   ```

5. Store the access token securely for use in your application.

# Quickstart

To use the `HubSpot CRM Object Line items` connector in your Ballerina application, update the `.bal` file as follows:

#### Step 1: Import the module

Import the `hubspot.crm.object.lineitems` module and `oauth2` module.

```ballerina
import ballerinax/hubspot.crm.obj.lineitems as hslineitems;
import ballerina/oauth2;
```

#### Step 2: Instantiate a new connector

1. Instantiate a `OAuth2RefreshTokenGrantConfig` with the obtained credentials and initialize the connector with it.

    ```ballerina
   configurable string clientId = ?;
   configurable string clientSecret = ?;
   configurable string refreshToken = ?;

   hslineitems:OAuth2RefreshTokenGrantConfig auth = {
      clientId,
      clientSecret,
      refreshToken,
      credentialBearer: oauth2:POST_BODY_BEARER 
   };

   final hslineitems:Client hubSpotLineItems = check new ({ auth });
   ```
2. Create a `Config.toml` file and, configure the obtained credentials obtained in the above steps as follows:

   ```toml
    clientId = <Client Id>
    clientSecret = <Client Secret>
    refreshToken = <Refresh Token>
   ```

#### Step 3: Invoke the connector operation

Now, utilize the available connector operations. A sample usecase is shown below.

#### Create a New Line item

```bash
public function main() returns error? {
    hslineitems:SimplePublicObjectInputForCreate payload = {

    "associations": [
    {
        "types": [
        {
          "associationCategory": "HUBSPOT_DEFINED",
          "associationTypeId": 20
        }
      ],
      "to": {
        "id": "31232284502"
      }
   }
      
  ],"objectWriteTraceId": "2",
  "properties": {
    "price": "400.00",
    "quantity": "10",
    "name": "Item 6"
    }
  };
  
   hslineitems::SimplePublicObject response = check hubSpotLineItems->/crm/v3/objects/line_items.post(payload);
}
```
#### Step 4 : Run the Ballerina application

```bash
bal run
```

# Examples

The `Ballerina HubSpot CRM Lineitems Connector` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/module-ballerinax-hubspot.crm.object.lineitems/tree/main/examples/), covering the following use cases:

1. [Customer Order fulfillment](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems/tree/main/examples/customer-order-fulfillment) - Manage customer orders in a warehouse system
2. [Inventory management](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems/tree/main/examples/inventory-management) - Manage inventory for an operational deal in an E-commerce platform
