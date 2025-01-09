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

import ballerina/os;
import ballerina/http;
import ballerina/oauth2;
import ballerina/test;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
configurable string serviceUrl = isLiveServer ? "https://api.hubapi.com/crm/v3/objects/line_items" : "http://localhost:9090";

OAuth2RefreshTokenGrantConfig auth = {
    clientId: clientId,
    clientSecret: clientSecret,
    refreshToken: refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER // this line should be added in to when you are going to create auth object.
};

final Client hsLineItems = check new ({auth});

final string testName = "Line Item 01";
final string testPrice = "4000.00";
final string testQuantity = "3";
final string testUpdatedPrice = "4500.00";
final string testUpdatedQuantity = "4";
final string testUpdatedName = "Updated Line Item 01";
final string testDeal_id = "31232284502";
string lineitem_id = "";
string batch_id = "";

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetLineofItems() returns error? {
    CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = check hsLineItems->/.get(
    );
    test:assertTrue(response?.results != []);
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testPostLineofItems() returns error? {
    SimplePublicObject response = check hsLineItems->/.post(
        payload = {
            "associations": [
                {
                    "types": [
                        {
                            "associationCategory": "HUBSPOT_DEFINED",
                            "associationTypeId": 20
                        }
                    ],
                    "to": {
                        "id": testDeal_id
                    }

                }
            ],
            "objectWriteTraceId": "2",
            "properties": {
                "price": testPrice,
                "quantity": testQuantity,
                "name": testName
            }
        }
    );
    test:assertTrue(response?.id != "");
    lineitem_id = response.id;
}

@test:Config {
    groups: ["live_tests"],
    dependsOn: [testPostLineofItems]
}
function testGetlineItemByID() returns error? {
    SimplePublicObjectWithAssociations response = check hsLineItems->/[lineitem_id].get();
    test:assertTrue(response?.id == lineitem_id);
}

@test:Config {
    groups: ["live_tests"],
    dependsOn: [testGetlineItemByID]
}
function testUpdateLineItemProperties() returns error? {
    SimplePublicObject response = check hsLineItems->/[lineitem_id].patch(
        payload = {
            "objectWriteTraceId": "2",
            "properties": {
                "price": testUpdatedPrice,
                "quantity": testUpdatedQuantity,
                "name": testUpdatedName
            }
        }
    );
    test:assertTrue(response?.id == lineitem_id);
    test:assertTrue(response?.properties["price"] == testUpdatedPrice);
}

@test:Config {
    groups: ["live_tests"],
    dependsOn: [testUpdateLineItemProperties]
}
function testDeleteLineItem() returns error? {
    http:Response response = check hsLineItems->/[lineitem_id].delete();
    test:assertTrue(response.statusCode == 204);
}

@test:Config {
    groups: ["live_tests"]
}
function testCreateBatchofLineItems() returns error? {
    BatchResponseSimplePublicObject response = check hsLineItems->/batch/create.post(
        payload = {

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
                                "id": testDeal_id
                            }
                        }
                    ],
                    "objectWriteTraceId": "1",
                    "properties": {
                        "price": testPrice,
                        "quantity": testQuantity,
                        "name": testName
                    }
                }
            ]
        }
    );
    test:assertTrue(response?.results != [], "Line items not found");
    batch_id = response.results[0].id;
}

@test:Config {
    groups: ["live_tests"],
    dependsOn: [testCreateBatchofLineItems]
}
function testReadBatchLineItems() returns error? {
    BatchResponseSimplePublicObject response = check hsLineItems->/batch/read.post(
        payload = {
            "propertiesWithHistory": [
                "name"
            ],
            "inputs": [
                {
                    "id": batch_id
                }
            ],
            "properties": [
                "quantity"
            ]
        }
    );
    test:assertTrue(response?.results[0].id == batch_id);
}

@test:Config {
    groups: ["live_tests"],
    dependsOn: [testReadBatchLineItems]
}
function testUpdateBatchLineItems() returns error? {
    BatchResponseSimplePublicObject response = check hsLineItems->/batch/update.post(
        payload = {
            "inputs": [
                {
                    "id": batch_id,
                    "properties": {
                        "price": testUpdatedPrice,
                        "quantity": testUpdatedQuantity,
                        "name": testUpdatedName
                    }
                }
            ]
        }
    );
    test:assertTrue(response?.results != []);
    test:assertTrue(response.results[0].properties["price"] == testUpdatedPrice);
}

@test:Config {
    groups: ["mock_tests"],
    enable: !isLiveServer
}
isolated function testUpsertBatchLineItems() returns error? {
    BatchInputSimplePublicObjectBatchInputUpsert payload = {
        "inputs": [
            {
                "idProperty": "hs_object_id",
                "objectWriteTraceId": "1",
                "id": "27078953355",
                "properties": {
                    "additionalprop1": "string",
                    "additionalprop2": "string",
                    "additionalprop3": "string"
                }
            }
        ]
    };
    BatchResponseSimplePublicUpsertObject response = check hsLineItems->/batch/upsert.post(payload);
    test:assertTrue(response?.results != []);
}

@test:Config {
    groups: ["live_tests"]
}
isolated function testSearchBatchofLineItems() returns error? {
    CollectionResponseWithTotalSimplePublicObjectForwardPaging response = check hsLineItems->/search.post(
        payload = {
            "query": "Item",
            "limit": 5,

            "sorts": [
                "price"
            ],
            "properties": [
                "quantity"
            ]
        }
    );
    test:assertTrue(response?.results != []);
}

@test:Config {
    groups: ["live_tests"],
    dependsOn: [testUpdateBatchLineItems]
}
function testArchiveBatchLineItems() returns error? {
    http:Response response = check hsLineItems->/batch/archive.post(
        payload = {
            "inputs": [
                {
                    "id": batch_id
                }
            ]

        }
    );
    test:assertTrue(response.statusCode == 204);
}

