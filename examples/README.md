# Examples

The `ballerinax/hubspot.crm.object.lineitems` connector provides practical examples illustrating usage in various scenarios. Explore these

1. [Customer Order fulfillment](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems/tree/main/examples/customer-order-fulfillment) - Manage customer orders in a warehouse system
2. [Inventory management](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.lineitems/tree/main/examples/inventory-management) - Manage inventory for an operational deal in an E-commerce platform

## Prerequisites

1. Generate hubspot credentials to authenticate the connector as described in the [setup guide](../README.md).

2. For each example, create a `Config.toml` file with the related configuration. Here's an example of how your `Config.toml `file should look:
    ```toml
    clientId = "<Client ID>"
    clientSecret = "<Client Secret>"
    refreshToken = "<Access Token>"
    ```

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
