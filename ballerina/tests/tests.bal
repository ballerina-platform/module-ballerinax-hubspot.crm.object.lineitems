// Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com).
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



import ballerina/test;
import ballerina/oauth2;
import ballerina/http;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string serviceUrl = "https://api.hubapi.com/crm/v3/objects/line_items";

//test variables
string lineitem_id = "";
string batch_id = "";

OAuth2RefreshTokenGrantConfig auth = {
       clientId: clientId,
       clientSecret: clientSecret,
       refreshToken: refreshToken,
       credentialBearer: oauth2:POST_BODY_BEARER // this line should be added in to when you are going to create auth object.
   };

ConnectionConfig config = {auth};
final Client hubspot = check new Client(config, serviceUrl);


// get all line of items
@test:Config {
    groups: ["unit_tests"]
}
isolated function testGetLineofItems() returns error? {
    CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = check hubspot->/.get(
    );
    test:assertTrue(response?.results != [], "Line items not found"); 
    }


// create line of items
@test:Config {
    groups: ["unit_tests"]
}
function testPostLineofItems() returns error? {
    SimplePublicObject response = check hubspot->/.post(
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
        "id": "31232284502"
      }
      
    }
  ],"objectWriteTraceId": "2",
  "properties": {
    "price": "400.00",
    "quantity": "8",
    "name": "Item 7"
  }
}
    ); 
    test:assertTrue(response?.id != "","Line item creation failed");
    test:assertEquals(response?.properties["name"] , "Item 7", "Name mismatched");
    test:assertEquals(response?.properties["price"] , "400.00", "Price mismatched");
    test:assertEquals(response?.properties["quantity"] , "8", "Quantity mismatched");
    
    lineitem_id = response.id;
}


// get line item by id
@test:Config {
    groups: ["unit_tests"],
    dependsOn: [testPostLineofItems]
}
function testGetlineItem() returns error? {
    SimplePublicObjectWithAssociations response = check hubspot->/[lineitem_id].get();
    test:assertTrue(response?.id == lineitem_id, "Line item not found");   
}


// update line item by id
@test:Config {
    groups: ["unit_tests"],
    dependsOn: [testGetlineItem]
}
function testUpdateProperties() returns error? {
    SimplePublicObject response = check hubspot->/[lineitem_id].patch(
        payload = {
            "objectWriteTraceId": "2",
  "properties": {
    "price": "154.00",
    "quantity": "1",
    "name": "Updated line item"
  }
        });
    test:assertTrue(response?.id == lineitem_id, "Line item not found");
    test:assertEquals(response?.properties["name"] , "Updated line item", "Name mismatched");
    test:assertEquals(response?.properties["price"] , "154.00", "Price mismatched");
    test:assertEquals(response?.properties["quantity"] , "1", "Quantity mismatched");   
}


// Archive a line item
@test:Config {
    groups: ["unit_tests"],
    dependsOn: [testUpdateProperties]
}
function testDeleteLineItem() returns error? {
    http:Response response = check hubspot->/[lineitem_id].delete();
    test:assertTrue(response.statusCode == 204);   
}


// Create a batch of line items
@test:Config {
    groups: ["unit_tests"]
}
function testCreatebatchofLineItems() returns error? {
    BatchResponseSimplePublicObject response = check hubspot->/batch/create.post(
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
            "id": "31232284502"
          }
        }
      ],
      "objectWriteTraceId": "1",
      "properties": {
        "price": "400.00",
        "quantity": "1",
        "name": "Item 6"
      }
    }
  ]
}
    );
    test:assertEquals(response?.status , "COMPLETE", "Batch creation failed");
    test:assertTrue(response?.results != [], "Line items not found");
    test:assertEquals(response?.results[0].properties["name"] , "Item 6", "Name mismatched");
    test:assertEquals(response?.results[0].properties["price"] , "400.00", "Price mismatched");
    test:assertEquals(response?.results[0].properties["quantity"] , "1", "Quantity mismatched");
    batch_id = response.results[0].id;
}


// Read a batch of line items
@test:Config {
    groups: ["unit_tests"],
    dependsOn: [testCreatebatchofLineItems]
}
function testReadbatchofLineItems() returns error? {
    BatchResponseSimplePublicObject response = check hubspot->/batch/read.post(
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
    test:assertTrue(response?.results[0].id == batch_id, "Batch not found");
}


// Update a batch of line items
@test:Config {
    groups: ["unit_tests"],
    dependsOn: [testReadbatchofLineItems]
}
function testUpdatebatchofLineItems() returns error? {
    BatchResponseSimplePublicObject response = check hubspot->/batch/update.post(
        payload = {
  "inputs": [
    {
      "id": batch_id,
      "properties": {
        "price": "450.00",
        "quantity": "1",
        "name": "Updated Item 4"
      }
    }
  ]
}
    );
    test:assertTrue(response?.results[0].id == batch_id, "Batch not found");
    test:assertEquals(response?.results[0].properties["name"] , "Updated Item 4", "Name mismatched");
    test:assertEquals(response?.results[0].properties["price"] , "450.00", "Price mismatched");
    test:assertEquals(response?.results[0].properties["quantity"] , "1", "Quantity mismatched");
}


// Upsert a batch of line items
// Have to sanitize as this doesn't work #skipped
@test:Config {
    groups: ["unit_tests"],
    dependsOn: [testUpdatebatchofLineItems],
    enable:false
}
isolated function testUpsertbatchofLineItems() returns error? {
    BatchResponseSimplePublicUpsertObject|BatchResponseSimplePublicUpsertObjectWithErrors response = check hubspot->/batch/upsert.post(
        payload = {
  inputs: [
    {
      "idProperty": "string",
      "objectWriteTraceId": "string",
      "id": "string",
      "properties": {
        "currency":"rupees"
        }
    }
  ]
}
    );
    test:assertTrue(response?.results != [], "Line items not found");
}


// Search for batch of line items
@test:Config {
    groups: ["unit_tests"]
}

isolated function testSearchBatchofLineItems() returns error? {
    CollectionResponseWithTotalSimplePublicObjectForwardPaging response = check hubspot->/search.post(
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
    test:assertTrue(response?.total != 0, "Line items not found");
}


// Archive a batch of line items
@test:Config {
    groups: ["unit_tests"],
    dependsOn: [testUpdatebatchofLineItems]
}
function testArchivebatchofLineItem() returns error? {
    http:Response response = check hubspot->/batch/archive.post(
        payload ={
            "inputs": [
                {
                    "id": batch_id
                }
            ]

        }
    );
    test:assertTrue(response.statusCode == 204);   
}

