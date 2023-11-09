<%@ page contentType="text/html; charset=UTF-8"%><%
/*
* subject: sample_terms 페이지
* @original author: SearchTool
*/
	
	if (apprType.equals("appr")){
		thisCollection = "appr";
	} else if (apprType.equals("mig")) {
		thisCollection = "apprMig";
	}

	if (collection.equals("ALL") || collection.equals(thisCollection)) {
		int count = wnsearch.getResultCount(thisCollection);
		int thisTotalCount = wnsearch.getResultTotalCount(thisCollection);
		if ( thisTotalCount >= 0) {			
%>
			<div class="section_search01">
			<div class="cont_title">
				<h2 class="sc_title02"><%=wnsearch.getCollectionNameLanguage(thisCollection,LanguageCode)%> <span class="sc_number">
				(총 <%=numberFormat(thisTotalCount)%>건) 
				
				</span></h2>
				<div class="search_radio_box">
					<span class="search_radio"><input type="radio" name="search_radio02" id="apprType_appr" <%= apprType.equals("appr") ? "checked=\"checked\"" : "" %>> 완료문서</span>
					<span class="search_radio"><input type="radio" name="search_radio02" id="apprType_mig" <%= apprType.equals("mig") ? "checked=\"checked\"" : "" %>> 이관문서 </span>
				</div>
			</div>
			
<%			if(thisTotalCount < 1) { %>
				<div class="search_n_result_wrap" id="result_<%=thisCollection%>">
		        	<p class="search_n_result_txt"><span class="search_n_result_img"></span>
					<strong class="tx_keyword">'<%=query%>'</strong>에 대한 검색 결과가 없습니다.<br /><span class="search_n_result_txt2">다른 검색어로 검색해 보시기 바랍니다.</span></p>
		      	</div>
<%			} else { %>
			<ul class="dic" id="result_<%= thisCollection%>">
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
				String INITIATOR_ID 		=	wnsearch.getField(thisCollection,"INITIATOR_ID",				idx,false); 		
				String INITIATOR_NAME 		=	wnsearch.getField(thisCollection,"INITIATOR_NAME",				idx,false); 	
				String INITIATOR_UNIT_ID 	=	wnsearch.getField(thisCollection,"INITIATOR_UNIT_ID",				idx,false); 	
				String INITIATOR_UNIT_NAME 	=	wnsearch.getField(thisCollection,"INITIATOR_UNIT_NAME",				idx,false); 	
				String SRCH_NAME 			=	wnsearch.getField(thisCollection,"SRCH_NAME",				idx,false); 			
				String SRCH_ID 				=	wnsearch.getField(thisCollection,"SRCH_ID",				idx,false); 			
				String INITIATED_DATE 		=	wnsearch.getField(thisCollection,"INITIATED_DATE",				idx,false); 	
				String COMPLETED_DATE 		=	wnsearch.getField(thisCollection,"COMPLETED_DATE",				idx,false); 	
				String BODYCONTEXT 			=	wnsearch.getField(thisCollection,"SUMMERYBODYCONTENTS",				idx,false); 		
				String END_DATE 			=	wnsearch.getField(thisCollection,"END_DATE",				idx,false); 		
				String DOC_URL 				=	wnsearch.getField(thisCollection,"DOC_URL",				idx,false); 			
				String ATTACH_FILE_INFO 	=	wnsearch.getField(thisCollection,"ATTACH_FILE_INFO",				idx,false); 			
				String FILE_LOCATION 		=	wnsearch.getField(thisCollection,"FILE_LOCATION",				idx,false); 			
				String FILE_EXTENTION 		=	wnsearch.getField(thisCollection,"FILE_EXTENTION",				idx,false); 			
				String FILE_MESSAGE_ID 		=	wnsearch.getField(thisCollection,"FILE_MESSAGE_ID",				idx,false); 			
				String FILE_CONTENTS 		=	wnsearch.getField(thisCollection,"FILE_CONTENTS",				idx,false); 			
				String ALIAS                =   wnsearch.getField(thisCollection,"ALIAS",				idx,false);				
				
				
				SUBJECT 					= 	wnsearch.getKeywordHl(SUBJECT,"<strong class='hl'>","</strong>");
				BODYCONTEXT 				= 	wnsearch.getKeywordHl(BODYCONTEXT,"<strong class='hl'>","</strong>");
				INITIATOR_NAME				= 	wnsearch.getKeywordHl(CREATOR_NAME,"<strong class='hl'>","</strong>");
				
				DOC_URL						= 	doMain + DOC_URL;
				if (apprType.equals("mig")) {DOC_URL = DOC_URL + "&forminstanceID=" + PROCESS_ID + "&formPrefix=WF_MIGRATION";}
				DOC_URL						=	"javascript:openLink('" + DOC_URL + "',1080,600);";
				
				/* INITIATED_DATE		= calTimezoneCode(INITIATED_DATE, TimeZoneCode, "yyyy-MM-dd");
				COMPLETED_DATE		= calTimezoneCode(COMPLETED_DATE, TimeZoneCode, "yyyy-MM-dd");  */
				
				/* String apprStr = "";
				if (apprType.equals("appr")){
					if (LanguageCode.equals("ko")){
						apprStr = "완료문서";
					} else if (LanguageCode.equals("en")){
						apprStr = "완료문서en";
					}
				} else if (apprType.equals("mig")) {
					if (LanguageCode.equals("ko")){
						apprStr = "이관문서";
					} else if (LanguageCode.equals("en")){
						apprStr = "이관문서en";
					}
				} */
				
				String[] fileExtentionArr = FILE_EXTENTION.split("\\|\\|");
%>
				<li class="dic_100 dic_aside">
					<dl>
						<dt class="title_area" data-docid="<%=PROCESS_ID%>">
							<a href="<%=DOC_URL%>"><%=SUBJECT%></a>
							<div class="title_info">
								<p class="title_area_name">
								<span><%=CREATOR_NAME%></span><%if(CREATOR_DEPT.length() > 0) { %><span><%=CREATOR_DEPT%></span><%}%>
								</p>
							</div>
						</dt>
						<dd class="txt_inline">[기안일시: <%=INITIATED_DATE%>] [완료일시: <%=COMPLETED_DATE%>]</dd>
						<dd class="explain"><%=BODYCONTEXT%></dd>

						<dd class="filein"><a>첨부파일 : </a>
									
						<% for(int i = 0; i < fileCnt; i++) {
							String fileExtention = fileExtentionArr[i].toLowerCase();
						%>

							<!-- <a><%= fileName %></a> -->

							<% if(checkExtentionIcon(fileExtention)) { %>
							<img width="10" height="10" src="images/files/data_<%= fileExtention %>.gif" alt="">
							<% }
						} %>
						</dd>
					<% } %>
					</dl>
				</li>
			<% } %>
			</ul>
		<% } %>
		<% if ( collection.equals("ALL") && thisTotalCount > TOTALVIEWCOUNT_MAP.get(thisCollection) ) { %>
				<div class="moreresult" id="moreresult_<%=thisCollection%>"><a href="#none" onClick="javascript:doCollection('<%=thisCollection%>');"> 더보기 </a></div>
		<% } %>
			</div>
	<% } %>
