// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/io;
import ballerina/oauth2;
import ballerinax/hubspot.crm.obj.lineitems as hslineitems;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

string batchId = "";
string[] batchitemIds = []; // Array to store batch item IDs

hslineitems:OAuth2RefreshTokenGrantConfig auth = {
    clientId,
    clientSecret,
    refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};

final hslineitems:Client hsLineItems = check new ({auth});

public function main() returns error? {
    //Step 1: Create a Batch of Products for an Order
    hslineitems:BatchInputSimplePublicObjectInputForCreate batch_payload = {
        "inputs": [
            {
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
                ],
                "objectWriteTraceId": "1",
                "properties": {
                    "price": "55000.00",
                    "quantity": "1",
                    "name": "Dining Table"
                }
            },
            {
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
                ],
                "objectWriteTraceId": "2",
                "properties": {
                    "price": "12000.00",
                    "quantity": "3",
                    "name": "Office Chair"
                }
            },
            {
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
                ],
                "objectWriteTraceId": "3",
                "properties": {
                    "price": "75000.00",
                    "quantity": "1",
                    "name": "Sofa"
                }
            },
            {
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
                ],
                "objectWriteTraceId": "4",
                "properties": {
                    "price": "8500.00",
                    "quantity": "2",
                    "name": "Casual Chair"
                }
            },
            {
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
                ],
                "objectWriteTraceId": "5",
                "properties": {
                    "price": "5000.00",
                    "quantity": "3",
                    "name": "Kids Chair"
                }
            }
        ]
    };
    hslineitems:BatchResponseSimplePublicObject response = check hsLineItems->/batch/create.post(payload = batch_payload);
    io:println("Batch of new line items added successfully");

    foreach var result in response.results {
        batchitemIds.push(result.id);
    }

    //Step 2:After creating the batch, the warehouse manager verifies its contents to ensure accuracy.
    foreach string batchId in batchitemIds {
        hslineitems:BatchResponseSimplePublicObject batchitems_response = check hsLineItems->/batch/read.post(
            payload = {
                "propertiesWithHistory": [
                    "name"
                ],
                "inputs": [
                    {
                        "id": batchId
                    }
                ],
                "properties": [
                    "quantity"
                ]
            }
        );
        io:println("Line items in the batch with ID: ", batchitems_response.results[0].id, " is verified successfully");
    }

    //Step 3: The warehouse manager searches for items in the order to update the stock levels.
    hslineitems:CollectionResponseWithTotalSimplePublicObjectForwardPaging searchitems_response = check hsLineItems->/search.post(
        payload = {
            "query": "Chair",
            "limit": 5,

            "sorts": [
                "price"
            ],
            "properties": [
                "quantity"
            ]
        }
    );
    io:println("Items in the inventory with the name 'Chair' are searched successfully");
    io:println("Total number of items found: ", searchitems_response.total);

    //Step 4: Update item quantities as per customer request before proceeding with the order.
    foreach string batchId in batchitemIds {
        hslineitems:BatchInputSimplePublicObjectBatchInput update_payload = {
            "inputs": [
                {
                    "id": batchId,
                    "properties": {
                        "quantity": "2"
                    }
                }
            ]
        };
        hslineitems:BatchResponseSimplePublicObject update_response = check hsLineItems->/batch/update.post(payload = update_payload);
        io:println("Item with ID: ", update_response.results[0].id, " updated successfully");
    }

    //Step 5: Delete the batch of items from the inventory after the order is fulfilled.
    foreach string batchId in batchitemIds {
        error? delete_response = check hsLineItems->/batch/archive.post(
            payload = {
                "inputs": [
                    {
                        "id": batchId
                    }
                ]

            }
        );
        if delete_response is error {
            io:println(string `Error occurred while deleting item with ID: ${batchId} - ${delete_response.message()}`);
            return;
        }
        io:println(": Item with ID: ", batchId, " deleted successfully");
    }

}
