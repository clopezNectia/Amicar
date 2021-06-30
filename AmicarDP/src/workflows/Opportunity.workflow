<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Reunirse con Jefe de Ventas a configurar propuesta de negocio a cliente antes de su visita</fullName>
        <active>true</active>
        <description>ISCHANGED(OwnerId),
        ISBLANK(PRIORVALUE(OwnerId)),
        ISPICKVAL(StageName ,&apos;Pre evaluación&apos;)							
							)</description>
        <formula>AND (          ISCHANGED(OwnerId),         ISPICKVAL(StageName ,&apos;Preparación de propuesta&apos;)							 							)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Tarea de Preevalución</fullName>
        <actions>
            <name>Ingresar_a_cliente_a_portal_a_preevaluar</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>ISCHANGED(OwnerId),
        ISBLANK(PRIORVALUE(OwnerId)),
        ISPICKVAL(StageName ,&apos;Pre evaluación&apos;)							
							)</description>
        <formula>AND (          ISCHANGED(OwnerId),         ISPICKVAL(StageName ,&apos;Pre evaluación&apos;)							 							)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Tarea de Preparación Propuesta</fullName>
        <actions>
            <name>Reunirse_con_Jefe_de_Ventas_a_configurar_propuesta_de_negocio_a_cliente</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>ISCHANGED(OwnerId),
        ISBLANK(PRIORVALUE(OwnerId)),
        ISPICKVAL(StageName ,&apos;Pre evaluación&apos;)							
							)</description>
        <formula>AND (          ISPICKVAL(StageName ,&apos;Preparación de propuesta&apos;)							 							)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Ingresar_a_cliente_a_portal_a_preevaluar</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Ingresar a cliente a portal a preevaluar</subject>
    </tasks>
    <tasks>
        <fullName>Reunirse_con_Jefe_de_Ventas_a_configurar_propuesta_de_negocio_a_cliente</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.Ultima_cuota__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Reunirse con Jefe de Ventas a configurar propuesta de negocio a cliente</subject>
    </tasks>
</Workflow>
