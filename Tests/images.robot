*** Settings ***
Resource          ../resources/api_assertion_keywords.robot
Resource          ../resources/api_endpoint_keywords.robot
Test Tags         images

*** Test Cases ***
Search For A Random Image
    [Documentation]    Performs a basic image search and validates the response.
    [Tags]    positive    smoke
    ${params}=    Create Dictionary    limit=1
    ${response}=    Search For Images    params=${params}
    Response Status Code Should Be    ${response}    200
    Response Body Should Be Non-Empty        ${response}

Search For Images By Breed
    [Documentation]    Searches for an image of a specific breed (Abyssinian) and verifies the breed ID.
    [Tags]    positive
    ${params}=    Create Dictionary    limit=1    breed_ids=abys
    ${response}=    Search For Images    params=${params}
    Response Status Code Should Be    ${response}    200
    Response Body Should Be Non-Empty        ${response}
    ${breed_id}  Get Value From Json    ${response.json()}   $..breeds[0].id
    Should Be Equal As Strings    ${breed_id}[0]    abys    msg=Image returned was not for the correct breed.

Search For Images By Breed "FORCED FAILURE"
    [Documentation]    Searches for an image of a specific breed (Abyssinian) and verifies the breed ID.
    [Tags]    positive
    ${params}=    Create Dictionary    limit=1    breed_ids=abys
    ${response}=    Search For Images    params=${params}
    Response Status Code Should Be    ${response}    200
    Response Body Should Be Non-Empty        ${response}
    ${breed_id}  Get Value From Json    ${response.json()}   $..breeds[0].id
    Should Be Equal As Strings    ${breed_id}[0]    fail    msg=Image returned was not for the correct breed.

Validate Image Search Schema
    [Documentation]    Performs an image search and validates the JSON schema.
    [Tags]    positive    smoke    schema
    ${params}=    Create Dictionary    limit=1
    ${response}=    Search For Images    params=${params}
    Response Status Code Should Be    ${response}    200
    Validate Response Against Schema        ${response}    images_search_schema.json

Search For Image With Invalid Breed ID
    [Documentation]    Searches for an image with a breed ID that does not exist and expects an empty list.
    [Tags]    negative
    ${params}=    Create Dictionary    limit=1    breed_ids=invalid-breed-id
    ${response}=    Search For Images    params=${params}
    Response Status Code Should Be    ${response}    200
    Should Be Empty    ${response.json()}    msg=Expected an empty list for an invalid breed search.