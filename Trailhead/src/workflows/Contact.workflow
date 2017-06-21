<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Contact_DOB</fullName>
        <description>To update custom birthday field for WAM</description>
        <field>Birthdate</field>
        <formula>DATE(
IF(
  LEN (Birthday_MM_DD__c) = 10,
  VALUE(MID(Birthday_MM_DD__c, 7, 4)),
  1904
),
VALUE(MID(Birthday_MM_DD__c, 1, 2)),
VALUE(MID(Birthday_MM_DD__c, 4, 2)))</formula>
        <name>Contact DOB</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WAM_Update_Mobile</fullName>
        <description>WAMCRM : Update Mobile</description>
        <field>MobilePhone</field>
        <formula>IF(CONTAINS(MobilePhone, &quot;+&quot;), MobilePhone, $Setup.WAM_CustomSetting__c.Default_Country_Code__c +&apos; &apos;+ TRIM(MobilePhone))</formula>
        <name>WAM - Update Mobile</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WAM_Update_Phone</fullName>
        <description>WAMCRM: update phone number</description>
        <field>Phone</field>
        <formula>IF(CONTAINS(Phone, &quot;+&quot;), Phone, $Setup.WAM_CustomSetting__c.Default_Country_Code__c +&apos; &apos;+ TRIM(Phone))</formula>
        <name>WAM - Update Phone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WAM - Populate Mobile Number</fullName>
        <actions>
            <name>WAM_Update_Mobile</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>WAM Distributor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.MobilePhone</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>WAMCRM: 
Prepends Mobile number with country code</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WAM - Populate Phone Number</fullName>
        <actions>
            <name>WAM_Update_Phone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>WAM Distributor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Phone</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>WAMCRM: 
Prepends Phone number with country code</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
