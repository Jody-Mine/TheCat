*** Settings ***
Library           RequestsLibrary
Library           JSONLibrary
Library           Collections
Library           String
Library           json

*** Keywords ***
Response Status Code Should Be
    [Arguments]    ${response}    ${expected_status}
    Should Be Equal As Strings    ${response.status_code}    ${expected_status}    msg=Expected status code ${expected_status} but got ${response.status_code}.

Response Reason Message Should Be
    [Arguments]    ${response}    ${expected_reason}
    Should Be Equal As Strings    ${response.reason}    ${expected_reason}    msg=Expected Reason ${expected_reason} but got ${response.reason}.

Response Body Should Be Non-Empty
    [Arguments]    ${response}
    Should Not Be Empty    ${response.json()}    msg=Response body is empty, but it should not be.

Validate Response Against Schema
    [Arguments]    ${response}    ${schema_file}
        ${schema_name}  Load Json From File    ${EXECDIR}${/}resources${/}schemas${/}${schema_file}
        JSONLibrary.Validate Json by Schema    ${response.json()}    ${schema_name}
