*** Settings ***
Library           RequestsLibrary
Library           JSONLibrary
Library           Collections
Library           String
Library           json 
Library           JSONSchemaLibrary    ${CURDIR}/schemas
Resource          ../configuration/api_suite_variables.robot

*** Keywords ***
Get All Breeds
    [Arguments]    ${params}=${None}
    ${response}=    GET  ${BASE_URL}/breeds   headers=${HEADERS}  params=${params}
    Log    Response: ${response.json()}
    RETURN    ${response}

Search For Images
    [Arguments]    ${params}=${None}
    ${response}=    GET  ${BASE_URL}/images/search   headers=${AUTH_HEADERS}    params=${params}
    Log    Response: ${response.json()}
    RETURN    ${response}

Create A Vote
    [Arguments]    ${image_id}    ${value}=1    ${sub_id}=automation-test
    ${body}=    Create Dictionary    image_id=${image_id}    value=${value}    sub_id=${sub_id}
    ${response}=    POST  ${BASE_URL}/votes    json=${body}    headers=${AUTH_HEADERS}
    Log    Response: ${response.json()}
    RETURN    ${response}

Get All Votes
    ${response}=    GET  ${BASE_URL}/votes    headers=${AUTH_HEADERS}
    Log    Response: ${response.json()}  console=true  formatter=repr
    RETURN    ${response}

Delete A Vote
    [Arguments]    ${vote_id}
    ${response}=    DELETE  ${BASE_URL}/votes/${vote_id}    headers=${AUTH_HEADERS}
    Log    Response: ${response.json()}  console=true  formatter=repr
    RETURN    ${response}

Response Status Code Should Be
    [Arguments]    ${response}    ${expected_status}
    Should Be Equal As Strings    ${response.status_code}    ${expected_status}    msg=Expected status code ${expected_status} but got ${response.status_code}.

Response Body Should Be Non-Empty
    [Arguments]    ${response}
    Should Not Be Empty    ${response.json()}    msg=Response body is empty, but it should not be.

Validate Response Against Schema
    [Arguments]    ${response}    ${schema_name}
        JSONLibrary.Validate Json by Schema    ${response.json()}    ${schema_name}
