*** Settings ***
Library           RequestsLibrary
Library           JSONLibrary
Library           Collections
Library           String
Library           json
Resource          ../configuration/api_suite_variables.robot

*** Keywords ***
Get All Breeds
    [Arguments]    ${params}=${None}  ${headers}=${AUTH_HEADERS}
    ${response}=    GET  ${BASE_URL}/breeds   headers=${headers}  params=${params}  expected_status=Anything
    RETURN    ${response}

Search For Images
    [Arguments]    ${params}=${None}  ${headers}=${AUTH_HEADERS}
    ${response}=    GET  ${BASE_URL}/images/search   headers=${headers}    params=${params}  expected_status=Anything
    RETURN    ${response}

Create A Vote
    [Arguments]    ${image_id}    ${value}=1    ${sub_id}=automation-test  ${headers}=${AUTH_HEADERS}
    ${body}=    Create Dictionary    image_id=${image_id}    value=${value}    sub_id=${sub_id}
    ${response}=    POST  ${BASE_URL}/votes    json=${body}    headers=${headers}  expected_status=Anything
    RETURN    ${response}

Get All Votes
    [Arguments]    ${headers}=${AUTH_HEADERS}
    ${response}=    GET  ${BASE_URL}/votes    headers=${headers}  expected_status=Anything
    RETURN    ${response}
    
Get Vote by ID
    [Arguments]    ${vote_id}  ${headers}=${AUTH_HEADERS}
    ${response}=    GET  ${BASE_URL}/votes/${vote_id}    headers=${headers}  expected_status=Anything
    RETURN    ${response}

Delete A Vote
    [Arguments]    ${vote_id}  ${headers}=${AUTH_HEADERS}
    ${response}=    DELETE  ${BASE_URL}/votes/${vote_id}    headers=${headers}  expected_status=Anything
    RETURN    ${response}