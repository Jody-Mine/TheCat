*** Settings ***
Resource          ../resources/api_assertion_keywords.robot
Resource          ../resources/api_endpoint_keywords.robot
Resource          ../resources/api_assertion_keywords.robot
Resource          ../resources/api_common_keywords.robot
Test Tags         breeds

*** Test Cases ***
Get All Breeds And Verify Response
    [Documentation]    Fetches all breeds and validates the response is a non-empty list.
    [Tags]    positive    smoke
    ${response}=    Get All Breeds
    Response Status Code Should Be    ${response}    200
    Response Body Should Be Non-Empty       ${response}

Get Breeds With Pagination
    [Documentation]    Fetches breeds with a limit of 5 and verifies the count.
    [Tags]    positive
    ${params}=    Create Dictionary    limit=5
    ${response}=    Get All Breeds    params=${params}
    Response Status Code Should Be    ${response}    200
    ${count}=    Get Length    ${response.json()}
    Should Be Equal As Integers    ${count}    5    msg=Expected 5 breeds but got ${count}.

Validate Breeds Schema
    [Documentation]    Fetches 3 breeds and validates the JSON schema of the response.
    [Tags]    positive    smoke    schema
    ${params}=    Create Dictionary    limit=3
    ${response}=    Get All Breeds    params=${params}
    Response Status Code Should Be    ${response}    200
    Validate Response Against Schema        ${response}    breeds_schema.json