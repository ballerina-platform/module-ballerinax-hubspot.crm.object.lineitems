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

import ballerina/io;
import ballerina/oauth2;
import ballerinax/hubspot.crm.obj.lineitems as hslineitems;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
string lineItemId = "";

hslineitems:OAuth2RefreshTokenGrantConfig auth = {
    clientId,
    clientSecret,
    refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};

final hslineitems:Client hsLineItems = check new ({auth});

public function main() returns error? {
    // Step 1:  Add New Lineitems to an Inventory deal
    hslineitems:SimplePublicObjectInputForCreate lineItem = {
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
            "price": "2400.00",
            "quantity": "5",
            "name": "Wired Keyboard"
        }
    };

    hslineitems:SimplePublicObject lineitem_response = check hsLineItems->/.post(payload = lineItem);
    lineItemId = lineitem_response.id;
    io:println("Line item created successfully. Line item id: " + lineItemId);

    // Step 2: Retrieve the existing products in the inventory deal
    hslineitems:CollectionResponseSimplePublicObjectWithAssociationsForwardPaging items_response = check hsLineItems->/.get();
    io:println("Line items retrieved successfully. Line items: ", items_response.results);

    // Step 3: Update Product Information Based on Operational Needs
    hslineitems:SimplePublicObject update_response = check hsLineItems->/[lineItemId].patch(
        payload = {
            "objectWriteTraceId": "2",
            "properties": {
                "price": "2700.00",
                "quantity": "5",
                "name": "Wired Keyboard"
            }
        }
    );
    io:println("Line item updated successfully. Line item id: " + update_response.id);

    // Step 4: Check if a particular product exists by checking with its id
    hslineitems:SimplePublicObjectWithAssociations readitem_response = check hsLineItems->/[lineItemId].get();
    io:println("Product already exists. Details: ", readitem_response);

    // Step 5: Add a batch of new products
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
                    "price": "5500.00",
                    "quantity": "1",
                    "name": "Gaming headphone"
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
                    "price": "400.00",
                    "quantity": "3",
                    "name": "Wireless mouse"
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
                    "price": "25000.00",
                    "quantity": "1",
                    "name": "Play station"
                }
            }
        ]
    };
    hslineitems:BatchResponseSimplePublicObject response = check hsLineItems->/batch/create.post(payload = batch_payload);
    io:println("Batch of new line items added successfully");
}
