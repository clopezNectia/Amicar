<?xml version="1.0" encoding="UTF-8"?>
<CustomApplication xmlns="http://soap.sforce.com/2006/04/metadata">
    <actionOverrides>
        <actionName>Tab</actionName>
        <content>P_gina_de_inicio_predeterminada1</content>
        <formFactor>Large</formFactor>
        <skipRecordTypeSelect>false</skipRecordTypeSelect>
        <type>Flexipage</type>
        <pageOrSobjectType>standard-home</pageOrSobjectType>
    </actionOverrides>
    <brand>
        <headerColor>#FF5722</headerColor>
        <logo>Illustrations_Overview_Elige2x</logo>
        <logoVersion>1</logoVersion>
        <shouldOverrideOrgTheme>false</shouldOverrideOrgTheme>
    </brand>
    <description>Maneja rápidamente los leads que se generen en la web para convertirlos en visitas a piso.</description>
    <formFactors>Large</formFactors>
    <isNavAutoTempTabsDisabled>false</isNavAutoTempTabsDisabled>
    <isNavPersonalizationDisabled>true</isNavPersonalizationDisabled>
    <label>Leads Canales Digitales</label>
    <navType>Standard</navType>
    <profileActionOverrides>
        <actionName>View</actionName>
        <content>Account_Record_Page</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>Account</pageOrSobjectType>
        <recordType>PersonAccount.PersonAccount</recordType>
        <type>Flexipage</type>
        <profile>Admin</profile>
    </profileActionOverrides>
    <profileActionOverrides>
        <actionName>View</actionName>
        <content>Account_Record_Page</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>Account</pageOrSobjectType>
        <recordType>PersonAccount.PersonAccount</recordType>
        <type>Flexipage</type>
        <profile>MarketingProfile</profile>
    </profileActionOverrides>
    <setupExperience>all</setupExperience>
    <tabs>standard-home</tabs>
    <tabs>standard-Lead</tabs>
    <tabs>standard-report</tabs>
    <tabs>standard-Dashboard</tabs>
    <uiType>Lightning</uiType>
    <utilityBar>Lead_Generation_UtilityBar</utilityBar>
</CustomApplication>
