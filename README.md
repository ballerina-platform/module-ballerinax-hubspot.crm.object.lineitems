# Ballerina Ballerina HubSpot CRM Lineitems Connector connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems/actions/workflows/ci.yml)
[![Trivy](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems/actions/workflows/trivy-scan.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems/actions/workflows/trivy-scan.yml)
[![GraalVM Check](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems/actions/workflows/build-with-bal-test-graalvm.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems/actions/workflows/build-with-bal-test-graalvm.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems/commits/master)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/hubspot.crm.object.lineitems.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%hubspot.crm.object.lineitems)

# Overview

[HubSpot](https://www.hubspot.com/our-story) is an AI-powered customer relationship management (CRM) platform. 

The `ballerinax/hubspot.crm.object.lineitems`  offers APIs to connect and interact with the [HubSpot CRM-Object Lineitems API](https://developers.hubspot.com/docs/guides/api/crm/objects/line-items) endpoints, specifically based on the [HubSpot REST API](https://developers.hubspot.com/docs/reference/api/overview).

# Setup guide


You need a [HubSpot developer account](https://developers.hubspot.com/get-started) with an [app](https://developers.hubspot.com/docs/guides/apps/public-apps/overview) to use HubSpot connectors.
To obtain an authentication token for your HubSpot developer account, you can use OAuth for public apps. 

Below is a step-by-step guide for both methods:

### Using OAuth for Public Apps:

#### Step 01 : Create Developer Account
* If you have an account already go to the [Hubspot account portal](https://app.hubspot.com/myaccounts-beta)
* If you don't have a developer account, register for a free Hubspot developer account.[(click here)](https://app.hubspot.com/signup-hubspot/developers?_ga=2.207749649.2047916093.1734412948-232493525.1734412948&step=landing_page)

#### Step 02 : Create a [Developer test account](https://developers.hubspot.com/beta-docs/getting-started/account-types#developer-test-accounts):
Within app developer accounts, you can create developer test accounts to test apps and integrations without affecting any real HubSpot data.

Note: These accounts are only for development and testing purposes. In production you should not use Developer Test Accounts.

1. Go to Test Account section from the left sidebar.

   ![Hubspot Developer Portal](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems/main/docs/setup/resources/test_acc_1.png)


2. Click Create developer test account.

   ![Hubspot Developer Test Account](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems/main/docs/setup/resources/test_acc_2.png)

3. Create developer test account by providing a name

#### Step 03 : Create a HubSpot App:

  * In your developer account, navigate to the [Apps](https://app.hubspot.com/developer/48567544/applications) section.
Click on `Create App` and provide the necessary details, including the app name and description to create a Hubspot developer App.
![create app](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems/main/docs/setup/resources/create_app_1.png)

#### Step 04 : Initiate the OAuth Flow:

* Move to the auth tab in the created app and set the permissions there ![alt text](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems/main/docs/setup/resources/image.png)

*  This direct users to HubSpot's authorisation URL with the following query parameters:

`client_id`: Your app's Client ID.

`redirect_uri`: The URL users will be redirected to after granting access.

`scope`: A space-separated list of scopes your app is requesting.


#### Step 05: Scope selection: 

* Go to the [crm.objects.line-items API reference](https://developers.hubspot.com/docs/reference/api/crm/objects/line-items) and there you will see the scope has defined below way![Scope selection](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems/main/docs/setup/resources/image-1.png)

* Now come back to your Auth page and add the relevant scopes using the `Add new scope` button ![alt text](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems/main/docs/setup/resources/image-2.png)

#### Step 06: Add redirect URL
Add your Redirect URL in the relevant section. You can also use `localhost` addresses for localhost development purposes. ![redirect url](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems/main/docs/setup/resources/image-3.png)

#### Step 07 (For localhost redirect url): Activate ballerina service
* If you are using a 'localhost' redirect url, make sure to have a listener running at the relevant port before executing the next step.
* Use the following ballerina code and run it locally on your computer using `bal run` to activate the service. 

``` bash
import ballerina/http;
import ballerina/io;


service / on new http:Listener(9090) {
   resource function get .(http:Caller caller, http:Request req) returns error? {
       // Extract the "code" query parameter from the URL
       string? code = req.getQueryParamValue("code");


       if code is string {
           // Log the received code
           io:println("Authorization code received: " + code);
           // Respond to the client with the received code
           check caller->respond("Received code: " + code);
       } else {
           // Respond with an error message if no code is found
           check caller->respond("Authorization code not found.");
       }
   }
}
```

#### Step 08: Copy the sample installation URL and paste it on a web browser. ![image-3](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems/main/docs/setup/resources/image-3.png)

* Browser pop the HubSpost account and ask where to install the App then select your developer test account 
* You will receive a code from there and it will be displayed on the browser


#### Step 09: Get the Refresh & Access tokens
Run the following curl command. Replace the `<YOUR_CLIENT_ID>`, `<YOUR_REDIRECT_URI`> and `<YOUR_CLIENT_SECRET>` with your specific value. Use the code you received in the above step 8 as the `<CODE>`.

``` bash
curl --request POST \
  --url https://api.hubapi.com/oauth/v1/token \
  --header 'content-type: application/x-www-form-urlencoded' \
  --data 'grant_type=authorization_code&code=<code>&redirect_uri=http://localhost:9090&client_id=<client_id>&client_secret=<client_secret>'
```
* Then execute this in terminal. This command will return the access token necessary for API calls.

   ```json
   {
     "token_type": "bearer",
     "refresh_token": "<Refresh Token>",
     "access_token": "<Access Token>",
     "expires_in": 1800
   }
   ```

Store the access token securely for use in your application.


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

# Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`hubspot.crm.object.lineitems` package](https://central.ballerina.io/ballerinax/hubspot.crm.object.lineitems/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
