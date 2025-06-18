*** Settings ***
Resource          ../resources/api_keywords.robot
Test Teardown     Run Keyword And Ignore Error    Cleanup Vote
Test Tags         votes

*** Variables ***
${IMAGE_ID_TO_VOTE}    # Will be set in setup
${CREATED_VOTE_ID}     # Will be set during test

*** Keywords ***
Setup Test With A Random Image
    ${params}=    Create Dictionary    limit=1
    ${response}=    Search For Images    params=${params}
    Response Status Code Should Be    ${response}    200
    ${json}=    To JSON    ${response.content}
    Set Suite Variable    ${IMAGE_ID_TO_VOTE}    ${json[0]['id']}
    Log To Console    \nVoting on image ID: ${IMAGE_ID_TO_VOTE}

Cleanup Vote
    [Documentation]    Deletes the vote created during the test run to ensure idempotency.
    Run Keyword If    '${CREATED_VOTE_ID}' != '${EMPTY}'    Delete A Vote    ${CREATED_VOTE_ID}
    Log To Console    Cleaned up vote ID: ${CREATED_VOTE_ID}

*** Test Cases ***
Create And Get Vote Workflow
    [Documentation]    A full workflow: create a vote, then retrieve all votes and verify it exists.
    [Tags]    positive    smoke    workflow
    [Setup]    Setup Test With A Random Image

    # Step 1: Create a vote
    ${response_post}=    Create A Vote    ${IMAGE_ID_TO_VOTE}
    Response Status Code Should Be    ${response_post}    201
    ${json_post}=    To JSON    ${response_post.content}
    Should Be Equal As Strings    ${json_post['message']}    SUCCESS
    Set Test Variable    ${CREATED_VOTE_ID}    ${json_post['id']}

    # Step 2: Get all votes and find the one we created
    ${response_get}=    Get All Votes
    Response Status Code Should Be    ${response_get}    200
    Response Body Should Be Non-Empty        ${response_get}
    ${all_votes}=    To JSON    ${response_get.content}
    ${vote_found}=    Evaluate    any(vote['id'] == ${CREATED_VOTE_ID} for vote in $all_votes)
    Should Be True    ${vote_found}    msg=Could not find the created vote in the GET /votes list.

Validate Get Votes Schema
    [Documentation]    Verifies the schema for the GET /votes endpoint.
    [Tags]    positive    smoke    schema
    ${response}=    Get All Votes
    Response Status Code Should Be    ${response}    200
    Run Keyword If    ${response.json()}    Validate Response List Against Schema    ${response}    votes_schema.json

Attempt To Create Vote For Non-Existent Image
    [Documentation]    Tries to create a vote with an invalid image_id, expecting a 400 error.
    [Tags]    negative
    ${response}=    Run Keyword And Expect Error    *    Create A Vote    non-existent-image-id
    Should Contain    ${response}    400 Bad Request    msg=Expected a 400 Bad Request for voting on a non-existent image.

Attempt To Get Votes Without API Key
    [Documentation]    Tries to get votes without providing an API key, expecting a 401 error.
    [Tags]    negative
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    Run Keyword And Expect Error    *    GET On Session    thecatapi    /votes    headers=${headers}
    Should Contain    ${response}    401 Unauthorized    msg=Expected a 401 Unauthorized error when getting votes without an API key.