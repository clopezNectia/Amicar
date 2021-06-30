<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Informa_Docu_OK_Leads</fullName>
        <description>Informa a Luciana (o usuario designado) que se ha actualizado el campos documentos_ok del objeto Leads</description>
        <field>documentacion_ok__c</field>
        <literalValue>1</literalValue>
        <name>Informa_Docu_OK_Leads</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Leds_casilla_Marketing_Cloud_true</fullName>
        <field>Filtro_Marketing_Cloud__c</field>
        <literalValue>1</literalValue>
        <name>Leds casilla Marketing Cloud true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Marca Casilla Marketing Cloud</fullName>
        <actions>
            <name>Leds_casilla_Marketing_Cloud_true</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Email</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.channel__c</field>
            <operation>contains</operation>
            <value>Destacame,amicar</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
