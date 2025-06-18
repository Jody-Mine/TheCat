*** Settings ***
Library           RequestsLibrary
Library           JSONLibrary
Library           Collections
Library           String
Library           json
Resource          ../configuration/api_suite_variables.robot
Resource          api_endpoint_keywords.robot
Resource          api_assertion_keywords.robot

*** Keywords ***
Setup Test With A Random Image
    ${params}=    Create Dictionary    limit=1
    ${response}=    Search For Images    params=${params}
    Response Status Code Should Be    ${response}    200
    Set Suite Variable    ${IMAGE_ID_TO_VOTE}    ${response.json()[0]['id']}
    Log To Console    \nVoting on image ID: ${IMAGE_ID_TO_VOTE}

Cleanup Vote
    [Documentation]    Deletes the vote created during the test run to ensure idempotency.
    Run Keyword If    '${CREATED_VOTE_ID}' != '${EMPTY}'    Delete A Vote    ${CREATED_VOTE_ID}
    Log To Console    Cleaned up vote ID: ${CREATED_VOTE_ID}