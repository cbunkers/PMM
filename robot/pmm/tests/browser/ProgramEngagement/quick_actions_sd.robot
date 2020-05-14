*** Settings ***

Resource       robot/pmm/resources/pmm.robot
Library        cumulusci.robotframework.PageObjects
...            robot/pmm/resources/pmm.py
...            robot/pmm/resources/ProgramEngagementPageObject.py
...            robot/pmm/resources/ServiceDeliveryPageObject.py
Suite Setup     Run Keywords
...             Open Test Browser
...             Setup Test Data
Suite Teardown  Delete Records and Close Browser

*** Keywords ***
Setup Test Data
    &{program} =                API Create Program
    Store Session Record        Program__c                      &{program}[Id]
    Set suite variable          &{program}
    &{contact} =                API Create Contact
    Set suite variable          &{contact}
    &{program_engagement} =     API Create Program Engagement   &{Program}[Id]      &{contact}[Id]
    Set suite variable          &{program_engagement}
    &{service} =                API Create Service              &{Program}[Id]
    Set suite variable          &{service}
    ${today} =                  Get Current Date                result_format=%Y-%m-%d
    Set suite variable          ${today}
    ${quantity} =               Generate Random String    2     [NUMBERS]
    Set suite variable          ${quantity}

*** Test Cases ***
Create a new service delivery using quick action
     Go To Page                  Details              ProgramEngagement__c                   object_id=&{program_engagement}[Id]
     page should contain         &{program_engagement}[Name]
     click quick action button   Create New Service Delivery
     Load Page Object            NewServiceDelivery  ServiceDelivery__c
     verify current page title   Create New Service Delivery
     populate modal form         Client=&{contact}[FirstName] &{contact}[LastName]
     ...                         Service=&{service}[Name]
     ...                         Quantity=${quantity}
     Click Modal button          Save
     Wait Until Modal Is Closed
     current page should be      Details              ProgramEngagement__c
     Load Related List           Service Deliveries
     click new related record link  &{contact}[FirstName] &{contact}[LastName] ${today}: &{service}[Name]
     verify details             Service Delivery Name   contains    &{contact}[FirstName] &{contact}[LastName] ${today}: &{service}[Name]
     ${servicedelivery_id} =    Save Current Record ID For Deletion     ServiceDelivery__c
     ${service_id} =            Save Current Record ID For Deletion     Service__c
     ${programengagement_id} =  Save Current Record ID For Deletion     ProgramEngagement__c
