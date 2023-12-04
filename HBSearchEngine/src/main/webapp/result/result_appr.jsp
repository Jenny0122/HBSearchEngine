<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import ="org.json.simple.parser.JSONParser"%><%
/*
* subject: appr 페이지
* @original author: SearchTool
*/

	if (apprType.equals("appr")){
		thisCollection = "appr";
	} else if (apprType.equals("mig")) {
		thisCollection = "apprMig";
	} else{
		thisCollection = "appr";
	}


	if (collection.equals("ALL") || collection.equals(thisCollection)) {
		int count = wnsearch.getResultCount(thisCollection);
		int thisTotalCount = wnsearch.getResultTotalCount(thisCollection);


		if ( thisTotalCount >= 0) {
			if(collection.equals("ALL")){
%>
				<div class="section_search02">
<%
			}else{
%>
				<div class="section_search01">
<%	
			}				
%>
				<div class="cont_title">
				<h2 class="sc_title02"><%=wnsearch.getCollectionKorName(thisCollection)%> <span class="sc_number">
					(총 <%=numberFormat(thisTotalCount)%>건)
				</span></h2>
				 <div class="search_radio_box">
					<span class="search_radio"><input type="radio" name="search_radio02" id="apprType_appr" <%= apprType.equals("appr") ? "checked=\"checked\"" : "" %>>완료문서</span>
					<span class="search_radio"><input type="radio" name="search_radio02" id="apprType_mig" <%= apprType.equals("mig") ? "checked=\"checked\"" : "" %>>이관문서</span>
				</div> 		
			</div>


<%			if(thisTotalCount < 1){ %>
				<div class="search_n_result_wrap" id="result_<%=thisCollection%>">
		        	<p class="search_n_result_txt"><span class="search_n_result_img"></span>
					<strong class="tx_keyword">'<%=query%>'</strong>에 대한 검색 결과가 없습니다.<br /><span class="search_n_result_txt2">다른 검색어로 검색해 보시기 바랍니다.</span></p>					
		      	</div>				
				
<%			} else{ %>
				<ul class="dic" id="result_<%=thisCollection%>">
			<%
			
			
			for(int idx = 0; idx < count; idx ++) {
				String DOCID 				=	wnsearch.getField(thisCollection,"DOCID",				idx,false); 
				String DATE 				=	wnsearch.getField(thisCollection,"DATE",				idx,false);
				String PROCESS_ID 			=	wnsearch.getField(thisCollection,"PROCESS_ID",				idx,false); 		
				String FORM_INST_ID 		=	wnsearch.getField(thisCollection,"FORM_INST_ID",				idx,false); 		
				String FORM_PREFIX 			=	wnsearch.getField(thisCollection,"FORM_PREFIX",				idx,false); 		
				String FORM_NAME 			=	wnsearch.getField(thisCollection,"FORM_NAME",				idx,false); 		
				String SUBJECT 				=	wnsearch.getField(thisCollection,"SUBJECT",				idx,false); 			
				String DOC_NUMBER 			=	wnsearch.getField(thisCollection,"DOC_NUMBER",				idx,false); 			
				String ENT_CODE 			=	wnsearch.getField(thisCollection,"ENT_CODE",				idx,false); 			
				String CREATOR_ID 			=	wnsearch.getField(thisCollection,"CREATOR_ID",				idx,false); 		
				String CREATOR_NAME 		=	wnsearch.getField(thisCollection,"CREATOR_NAME",				idx,false); 	
				String CREATOR_DEPT_ID 		=	wnsearch.getField(thisCollection,"CREATOR_DEPT_ID",				idx,false); 	
				String CREATOR_DEPT 		=	wnsearch.getField(thisCollection,"CREATOR_DEPT",				idx,false); 	
				String SRCH_NAME 			=	wnsearch.getField(thisCollection,"SRCH_NAME",				idx,false); 			
				String SRCH_ID 				=	wnsearch.getField(thisCollection,"SRCH_ID",				idx,false); 			
				String INITIATED_DATE 		=	wnsearch.getField(thisCollection,"INITIATED_DATE",				idx,false); 	
				String COMPLETED_DATE 		=	wnsearch.getField(thisCollection,"COMPLETED_DATE",				idx,false); 	
				String BODYCONTENTS 		=	wnsearch.getField(thisCollection,"BODYCONTENTS",				idx,false); 		
				String END_DATE 			=	wnsearch.getField(thisCollection,"END_DATE",				idx,false); 		
				String DOC_URL 				=	wnsearch.getField(thisCollection,"DOC_URL",				idx,false); 			
				String ATTACH_FILE_INFO 	=	wnsearch.getField(thisCollection,"ATTACH_FILE_INFO",				idx,false); 			
				String FILE_NAME 			=	wnsearch.getField(thisCollection,"FILE_NAME",				idx,false); 			
				String FILE_EXTENTION 		=	wnsearch.getField(thisCollection,"FILE_EXTENTION",				idx,false); 			
				String FILE_MESSAGE_ID 		=	wnsearch.getField(thisCollection,"FILE_MESSAGE_ID",				idx,false); 			
				String FILE_CONTENTS 		=	wnsearch.getField(thisCollection,"FILE_CONTENTS",				idx,false); 
				Double RANK					= 	Double.parseDouble(wnsearch.getField(thisCollection,"RANK",idx,false));
				String ALIAS                =   wnsearch.getField(thisCollection,"ALIAS",				idx,false);				
				
				
				SUBJECT 					= 	wnsearch.getKeywordHl(SUBJECT,"<strong class='hl'>","</strong>");
				BODYCONTENTS 				= 	wnsearch.getKeywordHl(BODYCONTENTS,"<strong class='hl'>","</strong>");
				FILE_NAME 					= 	wnsearch.getKeywordHl(FILE_NAME,"<strong class='hl'>","</strong>");
				CREATOR_NAME				= 	wnsearch.getKeywordHl(CREATOR_NAME,"<strong class='hl'>","</strong>");
				
				DOC_URL						= 	doMain + DOC_URL;
				if (apprType.equals("mig")) {DOC_URL = DOC_URL + "&forminstanceID=" + PROCESS_ID + "&formPrefix=WF_MIGRATION";}
				DOC_URL						=	"javascript:openLink('" + DOC_URL + "',1080,600);";
				
				INITIATED_DATE = INITIATED_DATE.substring(0, 10).replaceFirst("(\\d{4})(\\d{2})(\\d{2}).*", "$1-$2-$3");
				COMPLETED_DATE = COMPLETED_DATE.substring(0, 10).replaceFirst("(\\d{4})(\\d{2})(\\d{2}).*", "$1-$2-$3");
				

				String[] fileNameArr = FILE_NAME.split("\\|\\|");
				String[] fileExtentionArr = FILE_EXTENTION.split("\\|\\|");
				
				String[] creatornameArr = CREATOR_NAME.split(";");
				String[] creatordepArr = CREATOR_DEPT.split(";");
				
				/*String viewBODYCONTENTS = "";
				try {
					JSONParser parser = new JSONParser();
					JSONObject json = (JSONObject)parser.parse(BODYCONTENTS);	

					for (Object sss : json.keySet()){
						viewBODYCONTENTS =  viewBODYCONTENTS + " " + nvl((String) json.get(sss.toString()),"");
					}
				} catch ( Exception  e ) {
					BODYCONTENTS = "";
				} */

%>
				<li class="dic_100 dic_aside">
					<dl>
						<dt class="title_area" data-docid="<%=PROCESS_ID%>">
							<a href="<%=DOC_URL%>"><%=SUBJECT%></a>
							<div class="title_info">
								<p class="title_area_name">
									<span><%=creatornameArr[0]%></span><%if(CREATOR_DEPT.length() > 0) { %><span><%=creatordepArr[0]%></span><%}%>
									</p>
									<span class="title_accuracy">[ 정확도 : <%=(RANK*1/100)%> ]</span>
							</div>
						</dt>
						<dd class="txt_inline">[기안일시: <%=INITIATED_DATE%>] [완료일시: <%=COMPLETED_DATE%>]</dd>
						<!--  <dd class="explain"><%=BODYCONTENTS%></dd>-->
						<%if(!"".equals(fileNameArr[0])){ 
							int fileCnt = fileNameArr.length;%>
						<dd class="filein">
							<%for(int i=0; i<fileCnt; i++) {
								String fileName = fileNameArr[i];
								String fileExtention = fileExtentionArr[i].toLowerCase();%>
	
								<a>첨부파일 : <%= fileName %></a>
	
							<%}%>
						</dd>
						<%}%>
					</dl>
				</li>
				<% } %>
			</ul>
		<% } %>
		<% if ( collection.equals("ALL") && thisTotalCount > TOTALVIEWCOUNT_MAP.get(thisCollection) ) { %>
				<div class="section_more" id="moreresult_<%=thisCollection%>"><a href="#none" onClick="javascript:doCollection('<%=thisCollection%>');"> 검색 결과 더보기 </a></div>
		<% } %>
			</div>
		<%}} %>
