*** Settings ***
Resource          ../resources/api_assertion_keywords.robot
Resource          ../resources/api_endpoint_keywords.robot
Resource          ../resources/api_assertion_keywords.robot
Resource          ../resources/api_common_keywords.robot
Test Teardown     Run Keyword And Ignore Error    Cleanup Vote
Test Tags         votes

*** Test Cases ***
Create And Get Vote Workflow
    [Documentation]    A full workflow: create a vote, then retrieve all votes and verify it exists.
    [Tags]    positive    smoke    workflow
    [Setup]    Setup Test With A Random Image

    # Step 1: Create a vote
    ${response_post}=    Create A Vote    ${IMAGE_ID_TO_VOTE}
    Response Status Code Should Be    ${response_post}    201
    Should Be Equal As Strings    ${response_post.json()['message']}    SUCCESS
    Set Test Variable    ${CREATED_VOTE_ID}    ${response_post.json()['id']}
    log  VOTE_ID::${CREATED_VOTE_ID}  console=true
    log  POST:::  console=true
    log  ${response_post.json()}  console=true  formatter=repr

    # Step 2: Get vote by id and find the one we created
    ${response_get_id}  Get Vote By ID    ${CREATED_VOTE_ID}
    Response Status Code Should Be    ${response_get_id}    200
    log  ${\n}RESPONSE::  console=true
    log  ${response_get_id.json()}  console=true  formatter=repr
    ${id}  Get Value From Json    ${response_get_id.json()}  $.id
    Should Be Equal As Integers   ${id}[0]  ${CREATED_VOTE_ID}

Validate Get Votes Schema
    [Documentation]    Verifies the schema for the GET /votes endpoint.
    [Tags]    positive    smoke    schema
    ${response}=    Get All Votes
    Response Status Code Should Be    ${response}    200
    log  ${response.json()}  console=true
    Run Keyword If    ${response.json()}   Validate Response Against Schema  ${response.json()}  votes_schema.json

Attempt To Create Vote EMPTY params
    [Documentation]    Tries to create a vote with an invalid image_id, expecting a 400 error.
    [Tags]    negative
    ${response}=    Create A Vote    ${EMPTY}
    Response Status Code Should Be    ${response}  400
    Response Reason Message Should Be    ${response}  Bad Request

Attempt To Get Votes Without API Key
    [Documentation]    Tries to get votes without providing an API key, expecting a 401 error.
    [Tags]    negative
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    Get All Votes    headers=${headers}
    Response Status Code Should Be    ${response}  401
    Response Reason Message Should Be    ${response}  Unauthorized

