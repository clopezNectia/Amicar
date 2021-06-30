<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Estado_Aceptado_jefe_de_ventas</fullName>
        <description>Estado cambia a  &quot;Aceptado jefe de ventas&quot;</description>
        <field>Status</field>
        <literalValue>Aceptado jefe de ventas</literalValue>
        <name>Estado Aceptado jefe de ventas</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Estado_a_pendiente_de_aprobacion</fullName>
        <field>Status</field>
        <literalValue>Pendiente Aprobación</literalValue>
        <name>Estado a pendiente de aprobacion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Nueva propuesta a cliente</fullName>
        <actions>
            <name>Simula_nueva_propuesta_a_cliente</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Status,&apos;Borrador&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Válida con jefe de ventas stock</fullName>
        <actions>
            <name>V_lida_con_jefe_de_ventas_stock_descuentos_precios</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Status,&apos;Presentado jefe de ventas&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Simula_nueva_propuesta_a_cliente</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Quote.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Simula nueva propuesta a cliente</subject>
    </tasks>
    <tasks>
        <fullName>V_lida_con_jefe_de_ventas_stock_descuentos_precios</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>30</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.Ultima_cuota__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Válida con jefe de ventas stock, descuentos, precios.</subject>
    </tasks>
</Workflow>
