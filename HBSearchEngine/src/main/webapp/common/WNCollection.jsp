<%@ page pageEncoding = "UTF-8" %>
<%@ include file="./api/WNDefine.jsp" %>
<%!

	//운영
	//static String SEARCH_IP="10.20.20.126";
	//static String MANAGER_IP="10.20.20.126";
	//개발
	static String SEARCH_IP="172.17.208.26";
	static String MANAGER_IP="172.17.208.26";
	
	//반영
	//static public String SEARCH_IP="127.0.0.1";
	//static public String MANAGER_IP="127.0.0.1"; 
	static int SEARCH_PORT=7000;
	static int MANAGER_PORT=7800;

	public String[] COLLECTIONS = new String[]{"appr","board","user"}; //,"document"
	public String[] COLLECTIONS_MIG = new String[]{"apprMig","board","user"};
	public String[] COLLECTIONS_NAME = new String[]{"appr","board","user"}; //,"document"
	public String[] COLLECTIONS_NAME_MIG = new String[]{"apprMig","board","user"};
	public String[] MERGE_COLLECTIONS = new String[]{""};
	public class WNCollection{
	public String[][] MERGE_COLLECTION_INFO = null;
	public String[][] COLLECTION_INFO = null;

		
	public	WNCollection(String apprType){
			
			if (apprType.equals("appr")){
				COLLECTION_INFO = null;
				COLLECTION_INFO = new String[][]
				{
					{
						"appr", // set index name
			 			"appr", // set collection name
			 			"0,3",  // set pageinfo (start,count)
			 			"1,1,0,0,0", // set query analyzer (useKMA,isCase,useOriginal,useSynonym, duplcated detection)
			 			"RANK/DESC,DATE/DESC",  // set sort field (field,order) multi sort '/'
			 			"basic,rpfmo,100",  // set sort field (field,order) multi sort '/'
			 			"SUBJECT,CREATOR_NAME,CREATOR_DEPT,SRCH_NAME,FILE_NAME,FILE_CONTENTS",// set search field
			 			"DOCID,DATE,PROCESS_ID,FORM_INST_ID,FORM_PREFIX,FORM_NAME,SUBJECT,DOC_NUMBER,ENT_CODE,CREATOR_ID,CREATOR_NAME,CREATOR_DEPT_ID,CREATOR_DEPT,SRCH_NAME,SRCH_ID,INITIATED_DATE,COMPLETED_DATE,BODYCONTENTS,ATTACH_FILE_INFO,END_DATE,DOC_URL,ACL_TYPE_C,AUTHORITY_C,ACL_TYPE_W,AUTHORITY_W,FILE_NAME,FILE_EXTENTION,FILE_MESSAGE_ID,FILE_CONTENTS,ALIAS", // set document field
			 			"", // set date range
			 			"", // set rank range
			 			"", // set prefix query, example: <fieldname:contains:value1>|<fieldname:contains:value2>/1,  (fieldname:contains:value) and ' ', or '|', not '!' / operator (AND:1, OR:0)
			 			"", // set collection query (<fieldname:contains:value^weight | value^weight>/option...) and ' ', or '|'
			 			"", // set boost query (<fieldname:contains:value> | <field3:contains:value>...) and ' ', or '|'
			 			"", // set filter operation (<fieldname:operator:value>)
			 			"", // set groupby field(field, count)
			 			"", // set sort field group(field/order,field/order,...)
			 			"", // set categoryBoost(fieldname,matchType,boostID,boostKeyword)
			 			"CREATOR_NAME:1|CREATOR_DEPT:1", // set categoryGroupBy (fieldname:value)
			 			"", // set categoryQuery (fieldname:value)
			 			"", // set property group (fieldname,min,max, groupcount)
			 			"FORM_PREFIX,FORM_NAME,DOC_NUMBER,INITIATED_DATE,COMPLETED_DATE,ATTACH_FILE_INFO,END_DATE,ACL_TYPE_C,AUTHORITY_C,ACL_TYPE_W,AUTHORITY_W,FILE_EXTENTION,ALIAS", // use check prefix query filed
			 			"DATE,SUBJECT,FILE_EXTENTION,ALIAS", // set use check fast access field
			 			"", // set multigroupby field
			 			"", // set auth query (Auth Target Field, Auth Collection, Auth Reference Field, Authority Query)
			 			"", // set Duplicate Detection Criterion Field, RANK/DESC,DATE/DESC
			 			"전자결재" // collection display name
		 			},
					{
						"board", // set index name
						"board", // set collection name
						"0,3",  // set pageinfo (start,count)
						"1,1,0,0,0", // set query analyzer (useKMA,isCase,useOriginal,useSynonym, duplcated detection)
						"RANK/DESC,DATE/DESC",  // set sort field (field,order) multi sort '/'
						"basic,rpfmo,100",  // set sort field (field,order) multi sort '/'
						"SUBJECT,SUMMERYBODYCONTENTS,CREATOR_DEPT,CREATOR_NAME,COMPANY_NAME",// set search field
			 			"DOCID,DATE,MESSAGE_ID,MSG_OPEN_URL,FOLDER_ID,FOLDER_NAME,FOLDER_PATH_NAME,FOLDER_FULLPATH_NAME,SUBJECT,SUMMERYBODYCONTENTS/120,BODYCONTENTS,FILE_INFO,REGIST_DATE,EXPIRED_DATE,CREATOR_CODE,CREATOR_NAME,CREATOR_LEVEL,CREATOR_POSITION,CREATOR_DEPT,COMPANY_NAME,COMPANY_CODE,FILE_ID,SAVE_TYPE,FILE_NAME,FILE_PHYSICAL_PATH,FILE_DOWNLOAD_URL,AUTH_USER_ID,AUTH_USER_CODE,AUTH_EMP_NO,ALIAS", // set document field
			 			"", // set date range
						"", // set rank range
						"", // set prefix query, example: <fieldname:contains:value1>|<fieldname:contains:value2>/1,  (fieldname:contains:value) and ' ', or '|', not '!' / operator (AND:1, OR:0)
						"", // set collection query (<fieldname:contains:value^weight | value^weight>/option...) and ' ', or '|'
						"", // set boost query (<fieldname:contains:value> | <field3:contains:value>...) and ' ', or '|'
						"", // set filter operation (<fieldname:operator:value>)
						"", // set groupby field(field, count)
						"", // set sort field group(field/order,field/order,...)
						"", // set categoryBoost(fieldname,matchType,boostID,boostKeyword)
						"CREATOR_NAME:1|CREATOR_DEPT:1", // set categoryGroupBy (fieldname:value)
						"", // set categoryQuery (fieldname:value)
						"", // set property group (fieldname,min,max, groupcount)
						"PREFIX_CREATOR_DEPT,PREFIX_CREATOR_NAME,COMPANY_CODE,AUTH_USER_CODE,ALIAS", // use check prefix query filed
						"DATE,SUBJECT,REGIST_DATE,EXPIRED_DATE,CREATOR_NAME,CREATOR_DEPT,ALIAS", // set use check fast access field
						"", // set multigroupby field
						"", // set auth query (Auth Target Field, Auth Collection, Auth Reference Field, Authority Query)
						"", // set Duplicate Detection Criterion Field, RANK/DESC,DATE/DESC
						"게시판" // collection display name
						}
			         ,
					{
			 			"user", // set index name
			 			"user", // set collection name
			 			"0,3",  // set pageinfo (start,count)
			 			"1,1,0,0,0", // set query analyzer (useKMA,isCase,useOriginal,useSynonym, duplcated detection)
			 			"RANK/DESC,DATE/DESC",  // set sort field (field,order) multi sort '/'
			 			"basic,rpfmo,100",  // set sort field (field,order) multi sort '/'
			 			"DEPT_NAME,USER_NAME",// set search field
			 			"DOCID,DATE,USER_CODE,COMPANY_CODE,DEPT_CODE,COMPANY_NAME,DEPT_NAME,USER_NAME,JOB_POSITION_NAME,JOB_TITLE_NAME,JOB_LEVEL_NAME,CHARGE_BUSINESS,LINK_URL,MAIL_ADDRESS,PHONE_NUMBER_INTER,MOBILE,USE_YN,PHOTO_PATH,ALIAS", // set document field
			 			"", // set date range
			 			"", // set rank range
			 			"", // set prefix query, example: <fieldname:contains:value1>|<fieldname:contains:value2>/1,  (fieldname:contains:value) and ' ', or '|', not '!' / operator (AND:1, OR:0)
			 			"", // set collection query (<fieldname:contains:value^weight | value^weight>/option...) and ' ', or '|'
			 			"", // set boost query (<fieldname:contains:value> | <field3:contains:value>...) and ' ', or '|'
			 			"", // set filter operation (<fieldname:operator:value>)
			 			"", // set groupby field(field, count)
			 			"", // set sort field group(field/order,field/order,...)
			 			"", // set categoryBoost(fieldname,matchType,boostID,boostKeyword)
			 			"", // set categoryGroupBy (fieldname:value)
			 			"", // set categoryQuery (fieldname:value)
			 			"", // set property group (fieldname,min,max, groupcount)
			 			"PREFIX_DEPT_NAME,PREFIX_USER_NAME,JOB_POSITION_NAME,JOB_TITLE_NAME,JOB_LEVEL_NAME,ALIAS", // use check prefix query filed
			 			"USER_NAME,ALIAS", // set use check fast access field
			 			"", // set multigroupby field
			 			"", // set auth query (Auth Target Field, Auth Collection, Auth Reference Field, Authority Query)
			 			"", // set Duplicate Detection Criterion Field, RANK/DESC,DATE/DESC
			 			"임직원정보" // collection display name
			 		}
			 	};
			} else if (apprType.equals("mig")) {
				COLLECTION_INFO = null;
				COLLECTION_INFO = new String[][]
				{
					{
						"apprMig", // set index name
			 			"apprMig", // set collection name
			 			"0,3",  // set pageinfo (start,count)
			 			"1,1,0,0,0", // set query analyzer (useKMA,isCase,useOriginal,useSynonym, duplcated detection)
			 			"RANK/DESC,DATE/DESC",  // set sort field (field,order) multi sort '/'
			 			"basic,rpfmo,100",  // set sort field (field,order) multi sort '/'
			 			"SUBJECT,CREATOR_NAME,CREATOR_DEPT,SRCH_NAME,FILE_NAME,FILE_CONTENTS",// set search field
			 			"DOCID,DATE,PROCESS_ID,FORM_INST_ID,FORM_PREFIX,FORM_NAME,SUBJECT,DOC_NUMBER,ENT_CODE,CREATOR_ID,CREATOR_NAME,CREATOR_DEPT_ID,CREATOR_DEPT,SRCH_NAME,SRCH_ID,INITIATED_DATE,COMPLETED_DATE,BODYCONTENTS,ATTACH_FILE_INFO,END_DATE,DOC_URL,ACL_TYPE_C,AUTHORITY_C,ACL_TYPE_W,AUTHORITY_W,FILE_NAME,FILE_EXTENTION,FILE_MESSAGE_ID,FILE_CONTENTS,ALIAS", // set document field
			 			"", // set date range
			 			"", // set rank range
			 			"", // set prefix query, example: <fieldname:contains:value1>|<fieldname:contains:value2>/1,  (fieldname:contains:value) and ' ', or '|', not '!' / operator (AND:1, OR:0)
			 			"", // set collection query (<fieldname:contains:value^weight | value^weight>/option...) and ' ', or '|'
			 			"", // set boost query (<fieldname:contains:value> | <field3:contains:value>...) and ' ', or '|'
			 			"", // set filter operation (<fieldname:operator:value>)
			 			"", // set groupby field(field, count)
			 			"", // set sort field group(field/order,field/order,...)
			 			"", // set categoryBoost(fieldname,matchType,boostID,boostKeyword)
			 			"CREATOR_NAME:1|CREATOR_DEPT:1", // set categoryGroupBy (fieldname:value)
			 			"", // set categoryQuery (fieldname:value)
			 			"", // set property group (fieldname,min,max, groupcount)
			 			"FORM_PREFIX,FORM_NAME,DOC_NUMBER,INITIATED_DATE,COMPLETED_DATE,ATTACH_FILE_INFO,END_DATE,ACL_TYPE_C,AUTHORITY_C,ACL_TYPE_W,AUTHORITY_W,FILE_EXTENTION,ALIAS", // use check prefix query filed
			 			"DATE,PROCESS_ID,SUBJECT,FILE_EXTENTION,ALIAS", // set use check fast access field
			 			"", // set multigroupby field
			 			"", // set auth query (Auth Target Field, Auth Collection, Auth Reference Field, Authority Query)
			 			"", // set Duplicate Detection Criterion Field, RANK/DESC,DATE/DESC
			 			"전자결재" // collection display name
		 			},
					{
						"board", // set index name
						"board", // set collection name
						"0,3",  // set pageinfo (start,count)
						"1,1,0,0,0", // set query analyzer (useKMA,isCase,useOriginal,useSynonym, duplcated detection)
						"RANK/DESC,DATE/DESC",  // set sort field (field,order) multi sort '/'
						"basic,rpfmo,100",  // set sort field (field,order) multi sort '/'
						"SUBJECT,SUMMERYBODYCONTENTS,CREATOR_DEPT,CREATOR_NAME,COMPANY_NAME",// set search field
			 			"DOCID,DATE,MESSAGE_ID,MSG_OPEN_URL,FOLDER_ID,FOLDER_NAME,FOLDER_PATH_NAME,FOLDER_FULLPATH_NAME,SUBJECT,SUMMERYBODYCONTENTS/120,BODYCONTENTS,FILE_INFO,REGIST_DATE,EXPIRED_DATE,CREATOR_CODE,CREATOR_NAME,CREATOR_LEVEL,CREATOR_POSITION,CREATOR_DEPT,COMPANY_NAME,COMPANY_CODE,FILE_ID,SAVE_TYPE,FILE_NAME,FILE_PHYSICAL_PATH,FILE_DOWNLOAD_URL,AUTH_USER_ID,AUTH_USER_CODE,AUTH_EMP_NO,ALIAS", // set document field
			 			"", // set date range
						"", // set rank range
						"", // set prefix query, example: <fieldname:contains:value1>|<fieldname:contains:value2>/1,  (fieldname:contains:value) and ' ', or '|', not '!' / operator (AND:1, OR:0)
						"", // set collection query (<fieldname:contains:value^weight | value^weight>/option...) and ' ', or '|'
						"", // set boost query (<fieldname:contains:value> | <field3:contains:value>...) and ' ', or '|'
						"", // set filter operation (<fieldname:operator:value>)
						"", // set groupby field(field, count)
						"", // set sort field group(field/order,field/order,...)
						"", // set categoryBoost(fieldname,matchType,boostID,boostKeyword)
						"CREATOR_NAME:1|CREATOR_DEPT:1", // set categoryGroupBy (fieldname:value)
						"", // set categoryQuery (fieldname:value)
						"", // set property group (fieldname,min,max, groupcount)
						"PREFIX_CREATOR_DEPT,PREFIX_CREATOR_NAME,COMPANY_CODE,AUTH_USER_CODE,ALIAS", // use check prefix query filed
						"DATE,SUBJECT,REGIST_DATE,EXPIRED_DATE,CREATOR_NAME,CREATOR_DEPT,ALIAS", // set use check fast access field
						"", // set multigroupby field
						"", // set auth query (Auth Target Field, Auth Collection, Auth Reference Field, Authority Query)
						"", // set Duplicate Detection Criterion Field, RANK/DESC,DATE/DESC
						"게시판" // collection display name
						}
			         ,
					{
		        	 	"user", // set index name
			 			"user", // set collection name
			 			"0,3",  // set pageinfo (start,count)
			 			"1,1,0,0,0", // set query analyzer (useKMA,isCase,useOriginal,useSynonym, duplcated detection)
			 			"RANK/DESC,DATE/DESC",  // set sort field (field,order) multi sort '/'
			 			"basic,rpfmo,100",  // set sort field (field,order) multi sort '/'
			 			"DEPT_NAME,USER_NAME",// set search field
			 			"DOCID,DATE,USER_CODE,COMPANY_CODE,DEPT_CODE,COMPANY_NAME,DEPT_NAME,USER_NAME,JOB_POSITION_NAME,JOB_TITLE_NAME,JOB_LEVEL_NAME,CHARGE_BUSINESS,LINK_URL,MAIL_ADDRESS,PHONE_NUMBER_INTER,MOBILE,USE_YN,PHOTO_PATH,ALIAS", // set document field
			 			"", // set date range
			 			"", // set rank range
			 			"", // set prefix query, example: <fieldname:contains:value1>|<fieldname:contains:value2>/1,  (fieldname:contains:value) and ' ', or '|', not '!' / operator (AND:1, OR:0)
			 			"", // set collection query (<fieldname:contains:value^weight | value^weight>/option...) and ' ', or '|'
			 			"", // set boost query (<fieldname:contains:value> | <field3:contains:value>...) and ' ', or '|'
			 			"", // set filter operation (<fieldname:operator:value>)
			 			"", // set groupby field(field, count)
			 			"", // set sort field group(field/order,field/order,...)
			 			"", // set categoryBoost(fieldname,matchType,boostID,boostKeyword)
			 			"", // set categoryGroupBy (fieldname:value)
			 			"", // set categoryQuery (fieldname:value)
			 			"", // set property group (fieldname,min,max, groupcount)
			 			"PREFIX_DEPT_NAME,PREFIX_USER_NAME,JOB_POSITION_NAME,JOB_TITLE_NAME,JOB_LEVEL_NAME,ALIAS", // use check prefix query filed
			 			"USER_NAME,ALIAS", // set use check fast access field
			 			"", // set multigroupby field
			 			"", // set auth query (Auth Target Field, Auth Collection, Auth Reference Field, Authority Query)
			 			"", // set Duplicate Detection Criterion Field, RANK/DESC,DATE/DESC
			 			"임직원정보" // collection display name
			 		}
			 	};
			}
		}
				
		
		
	public	WNCollection(){
			COLLECTION_INFO = new String[][]
			{
				{
					"appr", // set index name
		 			"appr", // set collection name
		 			"0,3",  // set pageinfo (start,count)
		 			"1,1,0,0,0", // set query analyzer (useKMA,isCase,useOriginal,useSynonym, duplcated detection)
		 			"RANK/DESC,DATE/DESC",  // set sort field (field,order) multi sort '/'
		 			"basic,rpfmo,100",  // set sort field (field,order) multi sort '/'
		 			"SUBJECT,CREATOR_NAME,CREATOR_DEPT,SRCH_NAME,FILE_NAME,FILE_CONTENTS",// set search field
		 			"DOCID,DATE,PROCESS_ID,FORM_INST_ID,FORM_PREFIX,FORM_NAME,SUBJECT,DOC_NUMBER,ENT_CODE,CREATOR_ID,CREATOR_NAME,CREATOR_DEPT_ID,CREATOR_DEPT,SRCH_NAME,SRCH_ID,INITIATED_DATE,COMPLETED_DATE,BODYCONTENTS,ATTACH_FILE_INFO,END_DATE,DOC_URL,ACL_TYPE_C,AUTHORITY_C,ACL_TYPE_W,AUTHORITY_W,FILE_NAME,FILE_EXTENTION,FILE_MESSAGE_ID,FILE_CONTENTS,ALIAS", // set document field
		 			"", // set date range
		 			"", // set rank range
		 			"", // set prefix query, example: <fieldname:contains:value1>|<fieldname:contains:value2>/1,  (fieldname:contains:value) and ' ', or '|', not '!' / operator (AND:1, OR:0)
		 			"", // set collection query (<fieldname:contains:value^weight | value^weight>/option...) and ' ', or '|'
		 			"", // set boost query (<fieldname:contains:value> | <field3:contains:value>...) and ' ', or '|'
		 			"", // set filter operation (<fieldname:operator:value>)
		 			"", // set groupby field(field, count)
		 			"", // set sort field group(field/order,field/order,...)
		 			"", // set categoryBoost(fieldname,matchType,boostID,boostKeyword)
		 			"CREATOR_NAME:1|CREATOR_DEPT:1", // set categoryGroupBy (fieldname:value)
		 			"", // set categoryQuery (fieldname:value)
		 			"", // set property group (fieldname,min,max, groupcount)
		 			"FORM_PREFIX,FORM_NAME,DOC_NUMBER,INITIATED_DATE,COMPLETED_DATE,ATTACH_FILE_INFO,END_DATE,ACL_TYPE_C,AUTHORITY_C,ACL_TYPE_W,AUTHORITY_W,FILE_EXTENTION,ALIAS", // use check prefix query filed
		 			"DATE,SUBJECT,FILE_EXTENTION,ALIAS", // set use check fast access field
		 			"", // set multigroupby field
		 			"", // set auth query (Auth Target Field, Auth Collection, Auth Reference Field, Authority Query)
		 			"", // set Duplicate Detection Criterion Field, RANK/DESC,DATE/DESC
		 			"전자결재" // collection display name
	 			},
				{
					"apprMig", // set index name
		 			"apprMig", // set collection name
		 			"0,3",  // set pageinfo (start,count)
		 			"1,1,0,0,0", // set query analyzer (useKMA,isCase,useOriginal,useSynonym, duplcated detection)
		 			"RANK/DESC,DATE/DESC",  // set sort field (field,order) multi sort '/'
		 			"basic,rpfmo,100",  // set sort field (field,order) multi sort '/'
		 			"SUBJECT,CREATOR_NAME,CREATOR_DEPT,SRCH_NAME,FILE_NAME,FILE_CONTENTS",// set search field
		 			"DOCID,DATE,PROCESS_ID,FORM_INST_ID,FORM_PREFIX,FORM_NAME,SUBJECT,DOC_NUMBER,ENT_CODE,CREATOR_ID,CREATOR_NAME,CREATOR_DEPT_ID,CREATOR_DEPT,SRCH_NAME,SRCH_ID,INITIATED_DATE,COMPLETED_DATE,BODYCONTENTS,ATTACH_FILE_INFO,END_DATE,DOC_URL,ACL_TYPE_C,AUTHORITY_C,ACL_TYPE_W,AUTHORITY_W,FILE_NAME,FILE_EXTENTION,FILE_MESSAGE_ID,FILE_CONTENTS,ALIAS", // set document field
		 			"", // set date range
		 			"", // set rank range
		 			"", // set prefix query, example: <fieldname:contains:value1>|<fieldname:contains:value2>/1,  (fieldname:contains:value) and ' ', or '|', not '!' / operator (AND:1, OR:0)
		 			"", // set collection query (<fieldname:contains:value^weight | value^weight>/option...) and ' ', or '|'
		 			"", // set boost query (<fieldname:contains:value> | <field3:contains:value>...) and ' ', or '|'
		 			"", // set filter operation (<fieldname:operator:value>)
		 			"", // set groupby field(field, count)
		 			"", // set sort field group(field/order,field/order,...)
		 			"", // set categoryBoost(fieldname,matchType,boostID,boostKeyword)
		 			"CREATOR_NAME:1|CREATOR_DEPT:1", // set categoryGroupBy (fieldname:value)
		 			"", // set categoryQuery (fieldname:value)
		 			"", // set property group (fieldname,min,max, groupcount)
		 			"FORM_PREFIX,FORM_NAME,DOC_NUMBER,INITIATED_DATE,COMPLETED_DATE,ATTACH_FILE_INFO,END_DATE,ACL_TYPE_C,AUTHORITY_C,ACL_TYPE_W,AUTHORITY_W,FILE_EXTENTION,ALIAS", // use check prefix query filed
		 			"DATE,PROCESS_ID,SUBJECT,FILE_EXTENTION,ALIAS", // set use check fast access field
		 			"", // set multigroupby field
		 			"", // set auth query (Auth Target Field, Auth Collection, Auth Reference Field, Authority Query)
		 			"", // set Duplicate Detection Criterion Field, RANK/DESC,DATE/DESC
		 			"전자결재" // collection display name
	 			},
				{
					"board", // set index name
					"board", // set collection name
					"0,3",  // set pageinfo (start,count)
					"1,1,0,0,0", // set query analyzer (useKMA,isCase,useOriginal,useSynonym, duplcated detection)
					"RANK/DESC,DATE/DESC",  // set sort field (field,order) multi sort '/'
					"basic,rpfmo,100",  // set sort field (field,order) multi sort '/'
					"SUBJECT,SUMMERYBODYCONTENTS,CREATOR_DEPT,CREATOR_NAME,COMPANY_NAME",// set search field
		 			"DOCID,DATE,MESSAGE_ID,MSG_OPEN_URL,FOLDER_ID,FOLDER_NAME,FOLDER_PATH_NAME,FOLDER_FULLPATH_NAME,SUBJECT,SUMMERYBODYCONTENTS/120,BODYCONTENTS,FILE_INFO,REGIST_DATE,EXPIRED_DATE,CREATOR_CODE,CREATOR_NAME,CREATOR_LEVEL,CREATOR_POSITION,CREATOR_DEPT,COMPANY_NAME,COMPANY_CODE,FILE_ID,SAVE_TYPE,FILE_NAME,FILE_PHYSICAL_PATH,FILE_DOWNLOAD_URL,AUTH_USER_ID,AUTH_USER_CODE,AUTH_EMP_NO,ALIAS", // set document field
		 			"", // set date range
					"", // set rank range
					"", // set prefix query, example: <fieldname:contains:value1>|<fieldname:contains:value2>/1,  (fieldname:contains:value) and ' ', or '|', not '!' / operator (AND:1, OR:0)
					"", // set collection query (<fieldname:contains:value^weight | value^weight>/option...) and ' ', or '|'
					"", // set boost query (<fieldname:contains:value> | <field3:contains:value>...) and ' ', or '|'
					"", // set filter operation (<fieldname:operator:value>)
					"", // set groupby field(field, count)
					"", // set sort field group(field/order,field/order,...)
					"", // set categoryBoost(fieldname,matchType,boostID,boostKeyword)
					"CREATOR_NAME:1|CREATOR_DEPT:1", // set categoryGroupBy (fieldname:value)
					"", // set categoryQuery (fieldname:value)
					"", // set property group (fieldname,min,max, groupcount)
					"PREFIX_CREATOR_DEPT,PREFIX_CREATOR_NAME,COMPANY_CODE,AUTH_USER_CODE,ALIAS", // use check prefix query filed
					"DATE,SUBJECT,REGIST_DATE,EXPIRED_DATE,CREATOR_NAME,CREATOR_DEPT,ALIAS", // set use check fast access field
					"", // set multigroupby field
					"", // set auth query (Auth Target Field, Auth Collection, Auth Reference Field, Authority Query)
					"", // set Duplicate Detection Criterion Field, RANK/DESC,DATE/DESC
					"게시판" // collection display name
					}
		         ,
				{
		 			"user", // set index name
		 			"user", // set collection name
		 			"0,3",  // set pageinfo (start,count)
		 			"1,1,0,0,0", // set query analyzer (useKMA,isCase,useOriginal,useSynonym, duplcated detection)
		 			"RANK/DESC,DATE/DESC",  // set sort field (field,order) ./multi sort '/'
		 			"basic,rpfmo,100",  // set sort field (field,order) multi sort '/'
		 			"DEPT_NAME,USER_NAME",// set search field
		 			"DOCID,DATE,USER_CODE,COMPANY_CODE,DEPT_CODE,COMPANY_NAME,DEPT_NAME,USER_NAME,JOB_POSITION_NAME,JOB_TITLE_NAME,JOB_LEVEL_NAME,CHARGE_BUSINESS,LINK_URL,MAIL_ADDRESS,PHONE_NUMBER_INTER,MOBILE,USE_YN,PHOTO_PATH,ALIAS", // set document field
		 			"", // set date range
		 			"", // set rank range
		 			"", // set prefix query, example: <fieldname:contains:value1>|<fieldname:contains:value2>/1,  (fieldname:contains:value) and ' ', or '|', not '!' / operator (AND:1, OR:0)
		 			"", // set collection query (<fieldname:contains:value^weight | value^weight>/option...) and ' ', or '|'
		 			"", // set boost query (<fieldname:contains:value> | <field3:contains:value>...) and ' ', or '|'
		 			"", // set filter operation (<fieldname:operator:value>)
		 			"", // set groupby field(field, count)
		 			"", // set sort field group(field/order,field/order,...)
		 			"", // set categoryBoost(fieldname,matchType,boostID,boostKeyword)
		 			"", // set categoryGroupBy (fieldname:value)
		 			"", // set categoryQuery (fieldname:value)
		 			"", // set property group (fieldname,min,max, groupcount)
		 			"PREFIX_DEPT_NAME,PREFIX_USER_NAME,JOB_POSITION_NAME,JOB_TITLE_NAME,JOB_LEVEL_NAME,ALIAS", // use check prefix query filed
		 			"USER_NAME,ALIAS", // set use check fast access field
		 			"", // set multigroupby field
		 			"", // set auth query (Auth Target Field, Auth Collection, Auth Reference Field, Authority Query)
		 			"", // set Duplicate Detection Criterion Field, RANK/DESC,DATE/DESC
		 			"임직원정보" // collection display name
		 		}

		 	};
		}
	}
%>