
*** Settings ***

Library    QForce
Resource   ../Resources/common.resource

#Test Setup       User Based Login         #Once before each test


*** Test Cases ***

Verify_automatic_sharing_of_Account_Opportunity_Interaction_and_Interaction_Summary_for_the_role: London – Private Office_TC015
    [Tags]    module_a

TC_TC015

    [Tags]     module_b

