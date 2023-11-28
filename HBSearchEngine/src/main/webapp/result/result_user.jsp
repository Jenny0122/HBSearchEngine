<%@ page contentType="text/html; charset=UTF-8"%><%
/*
* subject: user 페이지
* @original author: SearchTool
*/
	thisCollection = "user";
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
				String DOCID				=	wnsearch.getField(thisCollection,"DOCID",					idx,false);
				String DATE				    =	wnsearch.getField(thisCollection,"DATE",					idx,false);
				String USER_CODE			=	wnsearch.getField(thisCollection,"USER_CODE",				idx,false);
				String COMPANY_CODE			=	wnsearch.getField(thisCollection,"COMPANY_CODE",			idx,false);
				String DEPT_CODE			=	wnsearch.getField(thisCollection,"DEPT_CODE",				idx,false);
				String COMPANY_NAME			=	wnsearch.getField(thisCollection,"COMPANY_NAME",			idx,false);
				String CREATOR_DEPT			=	wnsearch.getField(thisCollection,"CREATOR_DEPT",			idx,false);
				String CREATOR_NAME			=	wnsearch.getField(thisCollection,"CREATOR_NAME",			idx,false);
				String JOB_POSITION_NAME	=	wnsearch.getField(thisCollection,"JOB_POSITION_NAME",		idx,false);
				String JOB_TITLE_NAME		=	wnsearch.getField(thisCollection,"JOB_TITLE_NAME",			idx,false);
				String JOB_LEVEL_NAME		=	wnsearch.getField(thisCollection,"JOB_LEVEL_NAME",			idx,false);
				String CHARGE_BUSINESS		=	wnsearch.getField(thisCollection,"CHARGE_BUSINESS",			idx,false);
				String LINK_URL				=	wnsearch.getField(thisCollection,"LINK_URL",				idx,false);
				String MAIL_ADDRESS			=	wnsearch.getField(thisCollection,"MAIL_ADDRESS",			idx,false);
				String PHONE_NUMBER_INTER	=	wnsearch.getField(thisCollection,"PHONE_NUMBER_INTER",		idx,false);
				String MOBILE				=	wnsearch.getField(thisCollection,"MOBILE",					idx,false);
				String USE_YN				=	wnsearch.getField(thisCollection,"USE_YN",					idx,false);
				String PHOTO_PATH			=	wnsearch.getField(thisCollection,"PHOTO_PATH",				idx,false);
				String ALIAS				=	wnsearch.getField(thisCollection,"ALIAS",					idx,false);
				Double RANK					= 	Double.parseDouble(wnsearch.getField(thisCollection,"RANK",idx,false));
												
				CREATOR_NAME 					= wnsearch.getKeywordHl(CREATOR_NAME,"<strong class='hl'>","</strong>");
				CREATOR_DEPT 					= wnsearch.getKeywordHl(CREATOR_DEPT,"<strong class='hl'>","</strong>");
				JOB_POSITION_NAME			= wnsearch.getKeywordHl(JOB_POSITION_NAME,"<strong class='hl'>","</strong>");
				CHARGE_BUSINESS				= wnsearch.getKeywordHl(CHARGE_BUSINESS,"<strong class='hl'>","</strong>");
				
				
				// String USER_INFO_URL		= 	doMain + "/covicore/control/callMyInfo.do?userID=" + USER_CODE;
				// USER_INFO_URL				=	"javascript:openLink('" + USER_INFO_URL + "',810,410);";
			
				LINK_URL = doMain + LINK_URL;
				LINK_URL = "javascript:openLink('" + LINK_URL + "',790,800);";
%>
						<li class="dic_100 dic_aside">
							<dl>
								<dt class="title_area">
									<a href="<%=LINK_URL%>"><%=CREATOR_NAME%></a>
									<div class="title_info">
										<p class="title_area_name">
										<span><%=COMPANY_NAME%></span>
<%										if(CREATOR_DEPT.length() > 0){ %>								
											<span><%=CREATOR_DEPT%></span><%}%>								
										</p>
										<span class="title_accuracy">[ 정확도 : <%=(RANK*1/100)%> ]</span>
									</div>
								</dt>
								<dd class="txt_inline">[직급:<%=JOB_POSITION_NAME%>] [담당업무:<%=CHARGE_BUSINESS%>]</dd>
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
