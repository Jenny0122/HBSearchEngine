<%@ page contentType="text/html; charset=UTF-8"%><%
/*
* subject: sample_terms 페이지
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
				<h2 class="sc_title02"><%=wnsearch.getCollectionNameLanguage(thisCollection,LanguageCode)%> <span class="sc_number">
				(총 <%=numberFormat(thisTotalCount)%>건)
				<% } %>
				</span></h2>			
			</div>

<%			if(thisTotalCount < 1){ %>
				<div class="search_n_result_wrap" id="result_<%=thisCollection%>">
		        	<p class="search_n_result_txt"><span class="search_n_result_img"></span>
					<strong class="tx_keyword">'<%=query%>'</strong>에 대한 검색 결과가 없습니다.<br /><span class="search_n_result_txt2">다른 검색어로 검색해 보시기 바랍니다.</span></p>					
		      	</div>
			
<%			}else{ %>
				<div id="result_<%=thisCollection%>">
<%
			for(int idx = 0; idx < count; idx ++) {
				String DOCID				=	wnsearch.getField(thisCollection,"DOCID",					idx,false);
				String DATE				    =	wnsearch.getField(thisCollection,"DATE",					idx,false);
				String USER_CODE			=	wnsearch.getField(thisCollection,"USER_CODE",				idx,false);
				String COMPANY_CODE			=	wnsearch.getField(thisCollection,"COMPANY_CODE",			idx,false);
				String DEPT_CODE			=	wnsearch.getField(thisCollection,"DEPT_CODE",				idx,false);
				String COMPANY_NAME			=	wnsearch.getField(thisCollection,"COMPANY_NAME",			idx,false);
				String DEPT_NAME			=	wnsearch.getField(thisCollection,"DEPT_NAME",				idx,false);
				String USER_NAME			=	wnsearch.getField(thisCollection,"USER_NAME",				idx,false);
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
												
				USER_NAME 					= wnsearch.getKeywordHl(USER_NAME,"<strong class='hl'>","</strong>");
				DEPT_NAME 					= wnsearch.getKeywordHl(DEPT_NAME,"<strong class='hl'>","</strong>");
				
				PHOTO_URL			= doMain + PHOTO_URL;
				String USER_INFO_URL		= 	doMain + "/covicore/control/callMyInfo.do?userID=" + USER_CODE;
				USER_INFO_URL				=	"javascript:openLink('" + USER_INFO_URL + "',810,410);";
%>
			<div class="resultstyle_user">
				<ul class="auto_user">
					<li>
						<a href="<%=USER_INFO_URL%>" class="auto_user_link">
							<span class="auto_user_img">
							<% if (PHOTO_PATH.equals("/prd/stor") || PHOTO_PATH.equals("/devp/stor")) { %>
							<img src="images/no_profile.png" alt="">
							<% } else { %>
							<img src="<%=PHOTO_URL%>" onerror='this.src="images/no_profile.png";'alt="">
							<% } %>
							</span>
							<span class="user_link_c">
								<span class="tx_name"><%=USER_NAME%>(<%=JOB_POSITION_NAME%>)</span>
								<span class="tx_team"><%=DEPT_NAME%></span>
							</span>
							<span class="user_link_c">
								<span class="tx_tel"><%=PHONE_NUMBER_INTER%></span>
								<span class="tx_phone"><%=MOBILE%></span>
							</span>
							<span class="user_link_c">
								<span class="tx_mail"><%=MAIL_ADDRESS%></span>
							</span>
						</a>
					</li>
				</ul>
			</div>
 <%
			}
%>
			</div>
<%
			}
			if ( collection.equals("ALL") && thisTotalCount > TOTALVIEWCOUNT_MAP.get(thisCollection) ) {
%>
				<div class="moreresult" id="moreresult_<%=thisCollection%>"><a href="#none" onClick="javascript:doCollection('<%=thisCollection%>');">더보기</a></div>
<%
			}
		}
	}
%>