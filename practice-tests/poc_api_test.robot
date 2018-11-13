
*** Settings ***
Library           BuiltIn
Library           OperatingSystem
Library           RequestsLibrary


Suite Setup    Precondition
Suite Teardown    Postcondition

*** Variables ***
${endpoint}      https://api.tmsandbox.co.nz/v1/Categories/6327/Details.json?catalogue=false
${expectedscenario1}     "Name":"Carbon credits"
${expectedscenario2}     "CanRelist":true
${expectedscenario3}      Promotions
${expectedscenario4}      "Name":"Gallery"
${expectedscenario5}      2x larger image in desktop site search results

*** Test Cases ***

Validate Name should contain 'Carbon Credits'
    Given I Invoke get api endpoint
    And I Check the Response Header
    And I Check the Response Message
    And I Check the Response Code
    And I Convert json to string
    Then I Validate that it throws the correct status code(HTTP 200)
    And I Verify that the result contains "Name":"Carbon credits"

Validate that CanRelist should be tagged as true
    Given I Invoke get api endpoint
    And I Check the Response Header
    And I Check the Response Message
    And I Check the Response Code
    And I Convert json to string
    Then I Validate that it throws the correct status code(HTTP 200)
    And I Verify that the result contains "CanRelist":true

Validate that the Promotions element with Name = "Gallery" has a Description that contains the text "2x larger image"
    Given I Invoke get api endpoint
    And I Check the Response Header
    And I Check the Response Message
    And I Check the Response Code
    And I Convert json to string
    Then I Validate that it throws the correct status code(HTTP 200)
    And I Verify that the result contains Promotions
    And I Verify that the result contains "Name":"Gallery"
    And I Verify that the result contains 2x larger image in desktop site search results

*** Keyword ***
Precondition
    log to console     Start of testing

Postcondition
    delete all sessions

I Invoke get api endpoint
    Create Session  google  ${endpoint}
    ${resp}=    set variable
    ${resp}=  Get Request  google    /    allow_redirects=${true}    #data=${data}   # headers=${headers}
    Set suite variable    ${resp}
    ${statuscode}=    Log    ${resp.status_code}
    ${headers}=    Log    ${resp.headers}
    ${responsemessage}=    Log    ${resp.content}
    ${json} =  Set Variable  ${resp.json()}

I Check the Response Header
     Log    ${resp.headers}

I Check the Response Message
     Log    ${resp.content}

I Check the Response Code
     Log    ${resp.status_code}

I Convert json to string
     ${json} =  Set Variable  ${resp.json()}
     Log    ${resp.headers}
     Log    ${resp.content}
     ${body123}=    set variable    ${resp.content}
     Log     ${body123}
     Create file    ${EXECDIR}\\resources\\service_data\\test_data\\txt\\bodycontent.json    ${body123}

I Convert string to json
     ${json} =  Set Variable  ${resp.json()}
     Log    ${resp.headers}
     Log Many    ${resp.content}
     Log    ${resp.json}
     ${body123}=    set variable    ${resp.content}
     Log     ${body123}
     Create file    ${EXECDIR}\\resources\\service_data\\test_data\\txt\\bodycontent.json    ${body123}

I Validate that it throws the correct status code(HTTP 200)
     Should Be Equal As Strings  ${resp.status_code}  200

I Verify that the result contains "Name":"Carbon credits"
    Should contain    ${resp.content}    ${expectedscenario1}

I Verify that the result contains "CanRelist":true
    Should contain    ${resp.content}    ${expectedscenario2}

I Verify that the result contains Promotions
    Should contain    ${resp.content}    ${expectedscenario3}

I Verify that the result contains "Name":"Gallery"
    Should contain    ${resp.content}    ${expectedscenario4}

I Verify that the result contains 2x larger image in desktop site search results
    Should contain    ${resp.content}    ${expectedscenario5}
