// // Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com).
// //
// // WSO2 LLC. licenses this file to you under the Apache License,
// // Version 2.0 (the "License"); you may not use this file except
// // in compliance with the License.
// // You may obtain a copy of the License at
// //
// // http://www.apache.org/licenses/LICENSE-2.0
// //
// // Unless required by applicable law or agreed to in writing,
// // software distributed under the License is distributed on an
// // "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// // KIND, either express or implied.  See the License for the
// // specific language governing permissions and limitations
// // under the License.



// import ballerina/test;
// import ballerina/io;
// import ballerina/oauth2;
// import ballerina/os;

// configurable string clientId = os:getEnv("CLIENT_ID");
// configurable string clientSecret = os:getEnv("CLIENT_SECRET");
// configurable string refreshToken = os:getEnv("REFRESH_TOKEN");
// configurable string serviceUrl = "https://api.hubapi.com";

// OAuth2RefreshTokenGrantConfig auth = {
//        clientId: clientId,
//        clientSecret: clientSecret,
//        refreshToken: refreshToken,
//        credentialBearer: oauth2:POST_BODY_BEARER // this line should be added in to when you are going to create auth object.
//    };

// ConnectionConfig config = {auth};
// final Client hubspot = check new Client(config, serviceUrl);





// // @test:Config {
// //     groups: ["unit_tests", "integration_tests"]
// // }
// // isolated function testGetCrmV3ObjectsLineItems() returns error? {
// //     // Mock headers and queries
// //     map<string|string[]> headers = {
// //         "Authorization": "Bearer mockAccessToken"
// //     };

// //     GetCrmV3ObjectsLine_items_getpageQueries queries = {
// //         properties: ["property1", "property2"],
// //         associations: ["association1"],
// //         propertiesWithHistory: ["history1"]
// //     };

// //     // Call the client function
// //     CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = check hubspot->/crm/v3/objects/line_items(headers, queries);

// //     // Assertions to validate the response
// //     test:assertTrue(response["data"] !is ());
// //     // test:assertTrue(response.errors is ());

    
// // }


// @test:Config {
//     groups: ["unit_tests", "integration_tests"]
// }

// isolated function testPostLineofItems() returns error? {
//     SimplePublicObject response = check hubspot->/crm/v3/objects/line_items.post(
//         payload = {

//     "associations": [
//     {
//         "types": [
//         {
//           "associationCategory": "HUBSPOT_DEFINED",
//           "associationTypeId": 20
//         }
//       ],
//       "to": {
//         "id": "3"
//       }
      
//     }
//   ],"objectWriteTraceId": "2",
//   "properties": {
//     "price": "100.00",
//     "quantity": "1",
//     "name": "New standalone line item"
//   }
  
// }
//     );
//     io:println(response);
    

// }