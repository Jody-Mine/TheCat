*** Settings ***
Resource          ../resources/api_bdd_keywords.robot
Resource          ../resources/api_common_keywords.robot
Test Teardown     Run Keyword And Ignore Error    Cleanup Vote
Test Tags         votes

*** Test Cases ***
Create And Get Vote Workflow
    [Documentation]    A full workflow: create a vote, then retrieve all votes and verify it exists.
    [Tags]    positive    smoke    workflow  bdd
    [Setup]    Setup Test With A Random Image

    Given I Create A Vote
    When I Get Vote By ID
    Then ID: "${CREATED_VOTE_ID}" should exist



