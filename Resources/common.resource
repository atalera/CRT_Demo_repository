*** Settings ***
Library    QForce
Library    DateTime
Library    Collections


*** Variables ***
${CONFIG_FILE}    ../config/config.yaml
${DATA_FILE}      ../data/testdata.yaml
&{URLS}    
...    lpodev=${lpodev_login_url}
...    qa=${qa_login_url}
...    sit=${sit_login_url}

${FO_User1}=      anuk@gmail.com
${FO_User2}=     anuradha.ma@gmail.comy
${FO_User3}=     anu12@gmail.com

${FO_pwd}=   Welcome@123


*** Keywords ***
Initialize Test
    OpenBrowser    about:blank    chrome 
    Load Test Data
    Open Application URL
End suite
    Close All Browsers


Load Test Data
    ${data}=    load_yaml    ${DATA_FILE}
    Set Suite Variable    ${data}
    
Open Application URL
    # GoTo    ${config['url']}                #${lpodev_login_url}
    Go To    ${URLS}[${config['env']}]
    
Login With Valid User
  
    IF    '${config['env']}' == 'lpodev'
        TypeText    Username    ${lpodev_username}    clear=True
    ELSE IF    '${config['env']}' == 'qa'
        TypeText    Username    ${qa_username}    clear=True
    ELSE IF    '${config['env']}' == 'sit'
        TypeText    Username    ${sit_username}    clear=True
    END

    IF    '${config['env']}' == 'sit'
        TypeSecret   Password    ${sit_password}    clear=True
    ELSE       
        TypeSecret   Password    ${password}    clear=True
    END

    LogScreenshot    filename=entered_username_password.png
    ClickText    Log In to Sandbox
    # VerifyText    Home

User Based Login
  
    IF    '${config['env']}' == 'lpodev'
        IF    '${config['user']}' == 'Front Office User'
            TypeText    Username    ${lpodev_username}    clear=True
        ELSE IF    '${config['user']}' == 'Operation User'
            TypeText    Username    ${lpodev_username}    clear=True
        ELSE IF    '${config['user']}' == 'Compliance User'
            TypeText    Username    ${lpodev_username}    clear=True
        ELSE IF    '${config['user']}' == 'Admin'
            TypeText    Username    ${lpodev_username}    clear=True
        END
    ELSE IF    '${config['env']}' == 'qa'
        IF    '${config['user']}' == 'Front Office User 1'
            TypeText    Username    ${FO_User1}      clear=True
        ELSE IF    '${config['user']}' == 'Front Office User 2'
            TypeText    Username    ${FO_User2}      clear=True
        ELSE IF    '${config['user']}' == 'Front Office User 3'
            TypeText    Username    ${FO_User3}      clear=True
        ELSE IF    '${config['user']}' == 'Operation User'
            TypeText    Username    ${qa_op_username}    clear=True
        ELSE IF    '${config['user']}' == 'Compliance User'
            TypeText    Username    ${qa_comp_username}    clear=True
        ELSE IF    '${config['user']}' == 'Admin'
            TypeText    Username    ${qa_username}    clear=True
        END
    ELSE IF    '${config['env']}' == 'sit'
        IF    '${config['user']}' == 'Front Office User'
            TypeText    Username    ${sit_fo_username}    clear=True
        ELSE IF    '${config['user']}' == 'Operation User'
            TypeText    Username    ${qa_op_username}    clear=True
        ELSE IF    '${config['user']}' == 'Compliance User'
            TypeText    Username    ${qa_comp_username}    clear=True
        ELSE IF    '${config['user']}' == 'Admin'
            TypeText    Username    ${qa_username}    clear=True
        END    
    END

    ${current_username}=    GetInputValue    Username


    IF    '${config['user']}' == 'Admin'
        TypeSecret   Password    ${password}    clear=True
    ELSE IF    '${current_username}' == '${FO_User1}' or '${current_username}' == '${FO_User2}' or '${current_username}' == '${FO_User3}' 
        TypeSecret   Password   ${FO_pwd}    clear=True
    ELSE IF    '${config['env']}' == 'sit'
        TypeSecret   Password    ${sit_password}    clear=True
    ELSE       
        TypeSecret   Password    ${prof_password}    clear=True
    END

    
    LogScreenshot    filename=entered_username_password.png
    ClickText    Log In to Sandbox
    # VerifyText    Home
    IF    '${config['env']}' == 'lpodev'
        IF    '${config['user']}' == 'Admin'
            VerifyText    Sandbox (LPODev)
        ELSE
            VerifyText    Sandbox: LPODev
        END
    ELSE IF    '${config['env']}' == 'qa'
        IF    '${config['user']}' == 'Admin'
            VerifyText    Sandbox (QA)
        ELSE
            VerifyText    Sandbox: QA
        END
    ELSE IF    '${config['env']}' == 'sit'
        IF    '${config['user']}' == 'Admin'
            VerifyText    Sandbox (SIT)
        ELSE
            VerifyText    Sandbox: SIT
        END
    END

User Based Login As
    [Arguments]    ${user_role}
    Set To Dictionary    ${config}    user    ${user_role}
    Set Suite Variable    ${config}
    User Based Login

User Based Logout From Application
    [Arguments]    ${user_role}
    IF    '${user_role}' == 'Admin'
        ClickText    Show menu
        ClickText    Logout
    ELSE
        ClickText    Log out
    END
    VerifyText    Salesforce login
    LogScreenshot    filename=loggedout.png

Verify Successful Login
    # VerifyText    RATHBONES
    IF    '${config['env']}' == 'lpodev'
        IF    '${config['user']}' == 'Admin'
            VerifyText    Sandbox (LPODev)
        ELSE
            VerifyText    Sandbox: LPODev
        END
    ELSE IF    '${config['env']}' == 'qa'
        IF    '${config['user']}' == 'Admin'
            VerifyText    Sandbox (QA)
        ELSE
            VerifyText    Sandbox: QA
        END
    ELSE IF    '${config['env']}' == 'sit'
        IF    '${config['user']}' == 'Admin'
            VerifyText    Sandbox (SIT)
        ELSE
            VerifyText    Sandbox: SIT
        END
    END
    
Logout From Application
    
    IF    '${config['user']}' == 'Admin'
        ClickText    Show menu
        ClickText    Logout
    ELSE
        ClickText    Log out
    END
    VerifyText    Salesforce login
    LogScreenshot    filename=loggedout.png
        
Login With Invalid User
    ${user}=    Set Variable    ${data['invalid_user']}
    Type Text    Username    ${user['username']}    clear=True
    Type Text    Password    ${user['password']}    clear=True
    ClickText    Log In to Sandbox

Verify Login Failed
    VerifyText    Error

Open Application
    [Arguments]    ${app_name}    ${verification_text}=${app_name}
    LaunchApp      ${app_name}
    VerifyText     ${verification_text}

Close Tabs
    ClickWhile    Close    element=True
    # ClickText    Close        partial_match=True

Verify Field Editability
    [Arguments]    ${field_name}    ${expected_status}    ${anchor}=1
    Run Keyword And Continue On Failure    VerifyInputStatus    ${field_name}    ${expected_status}    ${anchor}

Verify Navigation Menu Options
    ClickText    Show Navigation Menu
    @{texts}=    Create List    Clients    Leads    Opportunities    Home

    FOR    ${text}    IN    @{texts}
        Log    ${text}
        Run Keyword And Continue On Failure    VerifyText    ${text}
    END

    LogScreenshot    filename=rim_navigation_options.png
    ClickText    Show Navigation Menu

Verify Search Textbox
    Run Keyword And Continue On Failure    VerifyItem    Search    tag=button

*** Keywords ***
Generate Start And End Dates
    [Documentation]    Generates start and end date in formar 31 Dec 2026. Start Date is today's Date and End Date is + 12 Days.
    ${today}=           Get Current Date    result_format=%d-%m-%Y

    ${start_date}=      Get Current Date    result_format=%d %b %Y

    ${end_date}=        Add Time To Date    ${today}    12 days
    ...                 date_format=%d-%m-%Y    result_format=%d %b %Y

    Log    Start Date: ${start_date}
    Log    End Date: ${end_date}

    RETURN    ${start_date}    ${end_date}

