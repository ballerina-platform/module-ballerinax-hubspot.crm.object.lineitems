# Running Tests

## Prerequisites
You need an Access token from HubSpot developer account.

To do this, refer to [Ballerina HubSpot LineItems Connector](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems/blob/main/ballerina/Module.md).

## Running Tests

There are two test environments for running the HubSpot LineItems connector tests. The default test environment is the mock server for HubSpot API. The other test environment is the actual HubSpot API. 

You can run the tests in either of these environments and each has its own compatible set of tests.

 Test Groups | Environment                                       
-------------|---------------------------------------------------
 mock_tests  | Mock server for HubSpot API (Defualt Environment) 
 live_tests  | HubSpot API                                       

## Running Tests in the Mock Server

To execute the tests on the mock server, ensure that the `IS_LIVE_SERVER` environment variable is either set to `false` or unset before initiating the tests. 

This environment variable can be configured within the `Config.toml` file located in the tests directory or specified as an environmental variable.

#### Using a Config.toml File

Create a `Config.toml` file in the tests directory and the following content:

```toml
isLiveServer = false
```

#### Using Environment Variables

Alternatively, you can set your authentication credentials as environment variables:
If you are using linux or mac, you can use following method:
```bash
   export IS_LIVE_SERVER=false
```
If you are using Windows you can use following method:
```bash
   setx IS_LIVE_SERVER false
```
Then, run the following command to run the tests:

```bash
   ./gradlew clean test
```

## Running Tests Against HubSpot Live API

#### Using a Config.toml File

Create a `Config.toml` file in the tests directory and add your authentication credentials as

```toml
   clientId = <Your Client Id>
   clientSecret = <Your Client Secret>
   refreshToken = <Your Refresh Token>
   isLiveServer = true
```

#### Using Environment Variables

Alternatively, you can set your authentication credentials as environment variables:
If you are using linux or mac, you can use following method:
```bash
   export IS_LIVE_SERVER=true
   export CLIENT_ID="<Your Client Id>"
   export CLIENT_SECRET="<Your Client Secret>"
   export REFRESH_TOKEN="<Your Refresh Token>"
```

If you are using Windows you can use following method:
```bash
   setx IS_LIVE_SERVER true
   setx CLIENT_ID  <Your Client Id>
   setx CLIENT_SECRET  <Your Client Secret>
   setx REFRESH_TOKEN  <Your Refresh Token>
```
Then, run the following command to run the tests:

```bash
   ./gradlew clean test 
```