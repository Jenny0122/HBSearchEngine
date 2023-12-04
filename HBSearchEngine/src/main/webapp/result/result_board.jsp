<%@ page contentType="text/html; charset=UTF-8"%><%
/*
* subject: sample_terms 페이지
* @original author: SearchTool
*/
	thisCollection = "board";
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
					<div class="cont_title_l"></div>
					<h2 class="sc_title02"><%=wnsearch.getCollectionKorName(thisCollection)%> <span class="sc_number">
					(총 <%=numberFormat(thisTotalCount)%>건)
					</span></h2>
				</div>

<%			if(thisTotalCount < 1){ %>
				<div class="search_n_result_wrap" id="result_<%=thisCollection%>">
		        	<p class="search_n_result_txt"><span class="search_n_result_img"></span>
					<strong class="tx_keyword">'<%=query%>'</strong>에 대한 검색 결과가 없습니다.<br /><span class="search_n_result_txt2">다른 검색어로 검색해 보시기 바랍니다.</span></p>
		      	</div>
			
<%			}else{ %>

			<ul class="dic" id="result_<%=thisCollection%>">
<%
			for(int idx = 0; idx < count; idx ++) {
				String DOCID				=	wnsearch.getField(thisCollection,"DOCID",				idx,false);
				String DATE					=	wnsearch.getField(thisCollection,"DATE",				idx,false);
				String MESSAGE_ID			=	wnsearch.getField(thisCollection,"MESSAGE_ID",			idx,false);
				String MSG_OPEN_URL			=	wnsearch.getField(thisCollection,"MSG_OPEN_URL",		idx,false);
				String FOLDER_ID			=	wnsearch.getField(thisCollection,"FOLDER_ID",			idx,false);
				String FOLDER_NAME			=	wnsearch.getField(thisCollection,"FOLDER_NAME",			idx,false);
				String FOLDER_PATH_NAME		=	wnsearch.getField(thisCollection,"FOLDER_PATH_NAME",	idx,false);	
				String FOLDER_FULLPATH_NAME =	wnsearch.getField(thisCollection,"FOLDER_FULLPATH_NAME",idx,false);
				String SUBJECT				=	wnsearch.getField(thisCollection,"SUBJECT",				idx,false);
				String SUMMERYBODYCONTENTS	=	wnsearch.getField(thisCollection,"SUMMERYBODYCONTENTS",	idx,false);
				String BODYCONTENTS			=	wnsearch.getField(thisCollection,"BODYCONTENTS",		idx,false);
				String FILE_INFO			=	wnsearch.getField(thisCollection,"FILE_INFO",			idx,false);
				String REGIST_DATE			=	wnsearch.getField(thisCollection,"REGIST_DATE",			idx,false);
				String EXPIRED_DATE			=	wnsearch.getField(thisCollection,"EXPIRED_DATE",		idx,false);
				String CREATOR_CODE			=	wnsearch.getField(thisCollection,"CREATOR_CODE",		idx,false);
				String CREATOR_NAME			=	wnsearch.getField(thisCollection,"CREATOR_NAME",		idx,false);	
				String CREATOR_LEVEL		=	wnsearch.getField(thisCollection,"CREATOR_LEVEL",		idx,false);
				String CREATOR_POSITION		=	wnsearch.getField(thisCollection,"CREATOR_POSITION",	idx,false);
				String CREATOR_DEPT			=	wnsearch.getField(thisCollection,"CREATOR_DEPT",		idx,false);
				String COMPANY_NAME			=	wnsearch.getField(thisCollection,"COMPANY_NAME",		idx,false);
				String COMPANY_CODE			=	wnsearch.getField(thisCollection,"COMPANY_CODE",		idx,false);
				String FILE_ID				=	wnsearch.getField(thisCollection,"FILE_ID",				idx,false);
				String SAVE_TYPE			=	wnsearch.getField(thisCollection,"SAVE_TYPE",				idx,false);
				String FILE_NAME			=	wnsearch.getField(thisCollection,"FILE_NAME",			idx,false);
				String FILE_WEB_PATH		=	wnsearch.getField(thisCollection,"FILE_WEB_PATH",		idx,false);
				String FILE_PHYSICAL_PATH	=	wnsearch.getField(thisCollection,"FILE_PHYSICAL_PATH",	idx,false);
				String FILE_DOWNLOAD_URL	=	wnsearch.getField(thisCollection,"FILE_DOWNLOAD_URL",	idx,false);
				String FILE_CONTENTS 		=	wnsearch.getField(thisCollection,"FILE_CONTENTS",		idx,false); 
				String ALIAS				=	wnsearch.getField(thisCollection,"ALIAS",				idx,false);
				Double RANK					=	Double.parseDouble(wnsearch.getField(thisCollection,"RANK",idx,false));				
							
				SUBJECT 					= 	wnsearch.getKeywordHl(SUBJECT,"<strong class='hl'>","</strong>");
				SUBJECT 					=	SUBJECT	.replaceAll("&nbsp;", " ")
														.replaceAll("&amp;", "&")
														.replaceAll("&lt;", "<")
														.replaceAll("&gt;", ">")
														.replaceAll("&quot;", "\"")
														.replaceAll("&#035;", "#")
														.replaceAll("&#039;", "\'");
				
				SUMMERYBODYCONTENTS 		= 	wnsearch.getKeywordHl(SUMMERYBODYCONTENTS,"<strong class='hl'>","</strong>");
				FILE_NAME 					= 	wnsearch.getKeywordHl(FILE_NAME,"<strong class='hl'>","</strong>");
				CREATOR_NAME				= 	wnsearch.getKeywordHl(CREATOR_NAME,"<strong class='hl'>","</strong>");
				
				MSG_OPEN_URL				= 	doMain + MSG_OPEN_URL;
				MSG_OPEN_URL				=	"javascript:openLink('" + MSG_OPEN_URL + "',1080,600);";
				
				// REGIST_DATE		= calTimezoneCode(REGIST_DATE.substring(0, 8), TimeZoneCode, "yyyy-MM-dd");
				// EXPIRED_DATE	= calTimezoneCode(EXPIRED_DATE.substring(0, 8), TimeZoneCode, "yyyy-MM-dd");
				
				String[] fileNameArr = FILE_NAME.split("\\|\\|");
%>
				<li class="dic_100 dic_aside">
					<dl>
						<dt class="title_area">
							<a href="<%=MSG_OPEN_URL%>"><%=SUBJECT%></a>
							<div class="title_info">
								<p class="title_area_name"><span><%=CREATOR_NAME%></span><%if(CREATOR_DEPT.length() > 0){ %><span><%=CREATOR_DEPT%></span><%}%></p>
								<span class="title_accuracy">[ 정확도 : <%=(RANK*1/100)%> ]</span>

						</dt>
						<dd class="txt_inline">[등록일 : <%=REGIST_DATE%>] [게시판명: <%=FOLDER_NAME%>]</dd>
						<dd class="explain"><%=SUMMERYBODYCONTENTS%></dd>
						
						<%if(!"".equals(fileNameArr[0])){ 
						int fileCnt = fileNameArr.length; %>
						
						<dd class="filein">
							<%for(int i=0; i<fileCnt; i++) {
								String fileName = fileNameArr[i];%>
	
								<a><%= fileName %></a>
	
							<%}%>
						</dd>
					<% } %>
					</dl>
				</li>
			<% } %>
			</ul>
		<%	} %>
	<% if ( collection.equals("ALL") && thisTotalCount > TOTALVIEWCOUNT_MAP.get(thisCollection) ) { %>
				<div class="section_more" id="moreresult_<%=thisCollection%>"><a href="#none" onClick="javascript:doCollection('<%=thisCollection%>');"> 검색 결과 더보기 </a></div>
		<% } %>
			</div>
		<%}} %>
		
		