*** Settings ***
Library           RequestsLibrary
Library           JSONLibrary
Library           Collections
Library           String
Library           json
Resource          ../configuration/api_suite_variables.robot
Resource          api_endpoint_keywords.robot
Resource          api_assertion_keywords.robot
Resource          api_common_keywords.robot

*** Variables ***
${RESPONSE_CREATE_VOTE}
${RESPONSE_GET_VOTE_BY_ID}

*** Keywords ***
I create a vote 
    ${response_post}=    Create A Vote    ${IMAGE_ID_TO_VOTE}
    Response Status Code Should Be    ${response_post}    201
    Should Be Equal As Strings    ${response_post.json()['message']}    SUCCESS
    Set Test Variable    ${CREATED_VOTE_ID}    ${response_post.json()['id']}
    Set Test Variable    ${RESPONSE_CREATE_VOTE}  ${response_post}

I get vote by ID
    ${response_get_id}  Get Vote By ID    ${CREATED_VOTE_ID}
    Response Status Code Should Be    ${response_get_id}    200
    Set Test Variable    ${RESPONSE_GET_VOTE_BY_ID}  ${response_get_id}

ID: "${CREATED_VOTE_ID}" should exist
    ${id}  Get Value From Json    ${RESPONSE_GET_VOTE_BY_ID.json()}  $.id
    Should Be Equal As Integers   ${id}[0]  ${CREATED_VOTE_ID}
