<cfscript>
	getBean('userDevice').checkSchema();
	dbUtility.setTable("tsettings").addColumn(column="sendAuthCodeScript",dataType="longtext");
	dbUtility.setTable("tclassextendattributes").addColumn(column="adminonly",dataType="integer");
</cfscript>