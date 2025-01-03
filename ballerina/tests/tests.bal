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
import ballerina/io;
import ballerina/oauth2;
import ballerina/http;
// import ballerina/os;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string serviceUrl = "https://api.hubapi.com/crm/v3/objects/line_items";

OAuth2RefreshTokenGrantConfig auth = {
       clientId: clientId,
       clientSecret: clientSecret,
       refreshToken: refreshToken,
       credentialBearer: oauth2:POST_BODY_BEARER // this line should be added in to when you are going to create auth object.
   };

ConnectionConfig config = {auth};
final Client hubspot = check new Client(config, serviceUrl);





// create line of items

@test:Config {
    groups: ["unit_tests"],
    enable:false
}

isolated function testPostLineofItems() returns error? {
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
    "price": "4000.00",
    "quantity": "8",
    "name": "Item 7"
  }
  
}
    );
    io:println(response);

}


// get line of items
@test:Config {
    groups: ["unit_tests"],
    enable:false
}

isolated function testGetLineofItems() returns error? {
    CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = check hubspot->/.get(
    );
    io:println(response);   
    }



// get line item by id
@test:Config {
    groups: ["unit_tests"],
    enable:false
}

isolated function testGetlineItem() returns error? {
    SimplePublicObjectWithAssociations response = check hubspot->/["27063341718"].get();
    io:println(response);   
}


// update line item by id
@test:Config {
    groups: ["unit_tests"],
    enable:false
}

isolated function testupdateProperties() returns error? {
    SimplePublicObject response = check hubspot->/["27063341718"].patch(
        payload = {
            "objectWriteTraceId": "2",
  "properties": {
    "price": "154.00",
    "quantity": "1",
    "name": "Updated line item"
  }
        });
    io:println(response);   
}

// Archive a line item
@test:Config {
    groups: ["unit_tests"],
    enable:false
}

isolated function testDeleteLineItem() returns error? {
    http:Response response = check hubspot->/["27101276519"].delete();
    io:println(response);   
}

// Archive a batch of line items
@test:Config {
    groups: ["unit_tests"],
    enable:false
}

isolated function testArchivebatchofLineItem() returns error? {
    http:Response response = check hubspot->/batch/archive.post(
        payload ={
            "inputs": [
                {
                    "id": "26757940030"
                }
            ]

        }
    );
    io:println(response);   
}




// Create a batch of line items
@test:Config {
    groups: ["unit_tests"],
    enable:false
}

isolated function testCreatebatchofLineItems() returns error? {
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
        "name": "Item 5"
      }
    }
  ]
}
    );
    io:println(response);
    

}


// Read a batch of line items
@test:Config {
    groups: ["unit_tests"],
    enable:false
}

isolated function testReadbatchofLineItems() returns error? {
    BatchResponseSimplePublicObject response = check hubspot->/batch/read.post(
        payload = {
    "propertiesWithHistory": [
    "name"
  ],
  
  "inputs": [
    {
      "id": "27078953355"
    }
  ],
  "properties": [
    "quantity"
  ]
}
    );
    io:println(response);
    

}

// Update a batch of line items
@test:Config {
    groups: ["unit_tests"],
    enable:false
}

isolated function testUpdatebatchofLineItems() returns error? {
    BatchResponseSimplePublicObject response = check hubspot->/batch/update.post(
        payload = {
  "inputs": [
    {
      "id": "27078953355",
      "properties": {
        "price": "450.00",
        "quantity": "1",
        "name": "Updated Item 4"
      }
    }
  ]
}
    );
    io:println(response);
    

}

// Upsert a batch of line items
// Have to sanitize as this doesn't work #skipped
@test:Config {
    groups: ["unit_tests"],
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
    io:println(response);
    

}



// Search for batch of line items
@test:Config {
    groups: ["unit_tests"],
    enable:false
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
    io:println(response);
    

}

