<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="./common/api/WNSearch.jsp" %>
<%@ include file="./common/api/Encrypt.jsp" %>
<% request.setCharacterEncoding("UTF-8");%>
<%@ page import ="java.net.InetAddress"%>
<%
    
    //실시간 검색어 화면 출력 여부 체크
    boolean isRealTimeKeyword = false;
    //오타 후 추천 검색어 화면 출력 여부 체크
    boolean useSuggestedQuery = true;
    String suggestQuery = "";

    //디버깅 보기 설정
    boolean isDebug = false;

    int TOTALVIEWCOUNT = 3;    //통합검색시 출력건수
    HashMap<String, Integer> TOTALVIEWCOUNT_MAP = new HashMap<String, Integer>() {
        {
        	put("appr", 10); put("apprMig", 10); put("board", 10); put("user", 3); 
        }
    };
    int COLLECTIONVIEWCOUNT = 10;    //더보기시 출력건수

	String START_DATE = "2000-01-01";	// 기본 시작일

	// 결과 시작 넘버
    int startCount = 		parseInt(getCheckReqXSS(request, "startCount", "0"), 0);	//시작 번호
    String query = 			getCheckReqXSS(request, "query", "");						//검색어
    String collection = 	getCheckReqXSS(request, "collection", "ALL");			    //컬렉션이름
    String rt = 			getCheckReqXSS(request, "rt", "");							//결과내 재검색 체크필드
    String rt2 = 			getCheckReqXSS(request, "rt2", "");							//결과내 재검색 체크필드
	String reQuery = 		getCheckReqXSS(request, "reQuery", "");					    //결과내 재검색 체크필드
    String realQuery = 		getCheckReqXSS(request, "realQuery", "");				    //결과내 검색어
    String sort = 			getCheckReqXSS(request, "sort", "DATE");					//정렬필드 
    String range = 			getCheckReqXSS(request, "range", "A");						//기간관련필드
    String startDate = 		getCheckReqXSS(request, "startDate", START_DATE);		    //시작날짜
    String endDate = 		getCheckReqXSS(request, "endDate", getCurrentDate());		//끝날짜
	String writer = 		getCheckReqXSS(request, "writer", "");						//작성자
	String searchField = 	getCheckReqXSS(request, "searchField", "ALL");			    //검색필드
	String categoryQueryW = getCheckReqXSS(request, "categoryQueryW", "");		//카테고리쿼리
	String categoryQueryD = getCheckReqXSS(request, "categoryQueryD", "");		//카테고리쿼리
	String collectionQueryW = getCheckReqXSS(request, "collectionQueryW", "");		//컬렉션쿼리
	String collectionQueryD = getCheckReqXSS(request, "collectionQueryD", "");		//컬렉션쿼리

	
	String prefix 		= getCheckReqXSS2(request, "prefix", "");					//prefix 쿼리
	String filter 		= getCheckReqXSS2(request, "filter", "");					//filter 쿼리
	String apprType 	= getCheckReqXSS(request, "apprType", "appr");			//전자결재 문서구분
	
	String UR_Code 		= getCheckReqXSS(request, "UR_Code", "");					//유저코드
	String DN_ID 		= getCheckReqXSS(request, "DN_ID", "");						//도메인아이디
	String DN_Code 		= getCheckReqXSS(request, "DN_Code", "");					//도메인코드
	String GR_Code 		= getCheckReqXSS(request, "GR_Code", "");					//그룹코드
	String DEPTID 		= getCheckReqXSS(request, "DEPTID", "");					//부서코드
	String docType 		= getCheckReqXSS(request, "docType", "1");
 
    String token = 			getCheckReqXSS(request, "token", "");                       //유저코드 암호화 파라미터
    String tokenExcept = 	getCheckReqXSS(request, "tokenExcept", "");;
    
    String tokenCheck = 	getCheckReqXSS(request, "tokenCheck", "1");
    String jsonError = "";
	
	// 차후 %검색 오류걸릴 경우 referer참고해서 예외처리하는 부분
	String referer = request.getHeader("referer");
	if (referer != null && referer.indexOf("search") == -1)
		query = java.net.URLDecoder.decode(query, "UTF-8"); 
		
	// 도메인 
	String doMain = "https://searchdev.e-hoban.co.kr"; //호반그룹 통합 그룹웨어(개발) domain
	//String doMain = "https://search.ihoban.co.kr"; //호반그룹 통합 그룹웨어(운영) domain

	/*InetAddress local;
	local = InetAddress.getLocalHost();
	String ip = local.getHostAddress();

	//개발
	if(ip.equals("172.17.208.26")){
		doMain = "http://searchdev.e-hoban.co.kr";
	// 로컬
	}else if(ip.equals("127.0.0.1") || ip.equals("0:0:0:0:0:0:0:1")){
		doMain = "http://searchdev.e-hoban.co.kr";
	// 운영
	}else {
		doMain = "https://search.ihoban.co.kr";
	}*/
	   
    int totalCount = 0;
    String userId = "";
    String [] deptidArray = null; //참고-deptid가 여러개로 넘어올 때 담을 배열
    Map<String, String> prefixMap = new HashMap<String,String>();

    
    // jwt 토큰 복호화
	// warr : 임시확인용 주석처리
 /*	if ( UR_Code.equals("") ) { 
			//임시확인용 토큰
		token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2ODI0ODg5NTYwOTgsImV4cCI6MTY4MjQ4OTU1NjA5OCwiZW1wIjoic3VwZXJhZG1pbiJ9.m_HRrWUFHZxeKLdmgOCPjbGwDPjubitRW5L5zp-KrSg";
		Map<String,Object> retMap = new HashMap<>();
		try  {	
			retMap = Encrypt.getTokenFromJwtString("ghqksrmfnq01!@#$", token);
		} catch ( Exception e ) {
		} finally { }
		if ( retMap == null  || retMap.size() == 0 || retMap.containsKey("result")) { 
			out.println("잘못된 접근입니다. 그룹웨어에 로그인 후 다시 검색을 시도하세요."); 
			return ;
		}
		
		long exp = (long) retMap.get("exp");
		userId = (String) retMap.get("emp"); 
    
		long nowTime = System.currentTimeMillis ();
		
    }  */
    
	// 권한처리
    if (userId.length() > 0) {
    	prefixMap.put("appr", "<AUTHORITY_C:contains:" + userId + " | " + DEPTID + ">|<AUTHORITY_W:contains:" + userId + " | " + DEPTID + ">");
    	prefixMap.put("apprMig", "<AUTHORITY_C:contains:" + userId + " | " + DEPTID + ">|<AUTHORITY_W:contains:" + userId + " | " + DEPTID + ">");
		prefixMap.put("board", "<AUTH_USER_CODE:contains:" + userId + ">");
    }else{
		prefixMap.put("appr", "");
		prefixMap.put("apprMig", "");
		prefixMap.put("board", "");
	}
    
 	// CCINFO prefix 처리
 	if (prefix.length() > 0) {
 		prefixMap.put("appr",  prefixMap.get("appr") + " " + prefix);
 		prefixMap.put("apprMig",  prefixMap.get("apprMig") + " " + prefix);
 	}
 	
	// 문서 종류 prefix 설정
 	// 1(전체), ..., 17(기타)
 	String[] docTypeListIdx = docType.split(","); 
 	String[] docTypeList = {"전체","pdf","xls|xlsx","doc|docx","ppt|pptx","jpg|jpeg","hwp","gif","zip","txt","msg","html","dwg","png","tif","bmp","기타"};
 	String etc = "<FILE_EXTENTION:contains:!pdf> <FILE_EXTENTION:contains:!xls> <FILE_EXTENTION:contains:!xlsx> <FILE_EXTENTION:contains:!doc> <FILE_EXTENTION:contains:!docx> <FILE_EXTENTION:contains:!ppt> <FILE_EXTENTION:contains:!pptx> <FILE_EXTENTION:contains:!jpg> <FILE_EXTENTION:contains:!jpeg> <FILE_EXTENTION:contains:!hwp> <FILE_EXTENTION:contains:!gif> <FILE_EXTENTION:contains:!zip> <FILE_EXTENTION:contains:!txt> <FILE_EXTENTION:contains:!msg> <FILE_EXTENTION:contains:!html> <FILE_EXTENTION:contains:!dwg> <FILE_EXTENTION:contains:!png> <FILE_EXTENTION:contains:!tif> <FILE_EXTENTION:contains:!bmp>";

 	String[] docImg = {"file_all","file_pdf","file_xls","file_doc","file_ppt","file_jpg","file_hwp","file_gif","file_zip","file_txt","file_msg","file_html","file_dwg","file_png","file_tif","file_bmp","file_etc"};
 	
 	String filePrefix = "";
 	
 	if (!docType.equals("") && !docType.equals("1")) {
 		for (int i=0; i < docTypeListIdx.length; i++) {
 			if (docTypeListIdx[i].equals("17")){
 				break;
 			}
 			
 			if (i != 0) {
 				filePrefix += "|";
 			}
 			
 			filePrefix += "<FILE_EXTENTION:contains:" + docTypeList[Integer.parseInt(docTypeListIdx[i]) - 1] +">";
 		}
 		if (docType.contains("17")){ // 기타 문서 처리
 			String etc_tmp = etc;
 			
 			for (int i=0; i < docTypeListIdx.length - 1; i++) {
 				String[] docTypeTemp = docTypeList[Integer.parseInt(docTypeListIdx[i]) - 1].split("\\|");
 				
 				for (int j = 0; j < docTypeTemp.length; j++) {
 					etc_tmp = etc_tmp.replaceAll("<FILE_EXTENTION:contains:!" + docTypeTemp[j] +">", "");
 				}
 			}
 			
 			filePrefix = "(" + etc_tmp + ")";
 			if (!filter.contains("<FILE_EXTENTION:gte: >")){
 				filter += "<FILE_EXTENTION:gte: >";
 			}
 		} 
 	} else if (docType.equals("1")) {
 		filter = filter.replaceAll("<FILE_EXTENTION:gte: >", "");
 	}
 	
 	if (filePrefix.length() > 0) {
 		prefixMap.put("appr",  prefixMap.get("appr") + " (" + filePrefix + ")");
 		prefixMap.put("apprMig",  prefixMap.get("apprMig") + " (" + filePrefix + ")");
 		prefixMap.put("board", prefixMap.get("board") + " (" + filePrefix + ")");
 	}

   
    String[] searchFields = null;

    String[] collections = null;
    String[] THIS_COLLECTIONS = null;
    
    //if (apprType.equals("mig")){
    //	THIS_COLLECTIONS = COLLECTIONS_MIG;
	//} else {
	//	THIS_COLLECTIONS = COLLECTIONS;
	//}
    
    //if(collection.equals("ALL")) { //통합검색인 경우
    //	collections = THIS_COLLECTIONS;
    //} else {                        //개별검색인 경우
    //    collections = new String[] { collection };
    //}
    
    THIS_COLLECTIONS = apprType.equals("mig") ? COLLECTIONS_MIG : COLLECTIONS;      
    collections = collection.equals("ALL") ? THIS_COLLECTIONS : new String[] { collection };
    
	if (reQuery.equals("1")) {
		realQuery = query + " " + realQuery;
	} else if (!reQuery.equals("2")) {
		realQuery = query;
	}

    WNSearch wnsearch = new WNSearch(isDebug, false, collections, searchFields, apprType);

    int viewResultCount = COLLECTIONVIEWCOUNT;
    boolean isTotalSearch = false;
    if ( collection.equals("ALL") ||  collection.equals("") )
        isTotalSearch = true;

    String prefixForLog = "";
    String filterForLog = "";
    for (int i = 0; i < collections.length; i++) { //공영빈
    	try{
    		
	        //출력건수
	        wnsearch.setCollectionInfoValue(collections[i], PAGE_INFO, startCount+","+viewResultCount);
	
	        //검색어가 없으면 DATE_RANGE 로 전체 데이터 출력
	        if (collections[i].equals("user")) {
	        	wnsearch.setCollectionInfoValue(collections[i], SORT_FIELD, "USER_NAME/ASC");
	        } else if (!query.equals("") ) {
	        	if("SUBJECT".equals(sort)){
	        		wnsearch.setCollectionInfoValue(collections[i], SORT_FIELD, sort + "/ASC");
	        	} else {
	        		wnsearch.setCollectionInfoValue(collections[i], SORT_FIELD, sort + "/DESC");
	        	}
	        } else {
	              wnsearch.setCollectionInfoValue(collections[i], DATE_RANGE, START_DATE.replaceAll("[.]","/") + ",2030/12/31,-");
	              wnsearch.setCollectionInfoValue(collections[i], SORT_FIELD, "DATE/DESC");
	        }
	
	        //searchField 값이 있으면 설정, 없으면 기본검색필드
	        if (searchField.length() > 0 && searchField.indexOf("ALL") == -1 ) {
				wnsearch.setCollectionInfoValue(collections[i], SEARCH_FIELD, searchField);
	        }
	
	  		// prefix 처리
	   		if(prefixMap.get(collections[i]) != null && !prefixMap.get(collections[i]).isEmpty()){
	   			wnsearch.setCollectionInfoValue(collections[i], EXQUERY_FIELD, prefixMap.get(collections[i]));
	   			prefixForLog += collections[i] + ":" + prefixMap.get(collections[i]) + ",";
	   		}
	   		
	   		// filter 처리
	   		if (filter.length() > 0 && !collections[i].equals("user")) {
	   			wnsearch.setCollectionInfoValue(collections[i], FILTER_OPERATION, filter);
	   		}
	             
	
	        //기간 설정 , 날짜가 모두 있을때
	        if (!startDate.equals("")  && !endDate.equals("") ) {
	             wnsearch.setCollectionInfoValue(collections[i], DATE_RANGE, startDate.replaceAll("[.]","/") + "," + endDate.replaceAll("[.]","/") + ",-");
	       	}
    	}catch(Exception e){
    		System.err.print(e);
    	}    
       	
		if(collections[i].equals("user")){			
        wnsearch.setCollectionInfoValue(collections[i], DATE_RANGE, "1970/01/01,2030/12/31,-");
		}
		
		if(collectionQueryW.length() > 0 || collectionQueryD.length() > 0){
			String[] collectionQueryWList = collectionQueryW.split("\\|");
			String[] collectionQueryDList = collectionQueryD.split("\\|");
			
			String collectionQuery = "";
			
			if (collectionQueryWList.length > 1) collectionQuery = "<" + collectionQueryWList[0] + ":contains:" + collectionQueryWList[1] + "> ";
			if (collectionQueryDList.length > 1) collectionQuery = "<" + collectionQueryDList[0] + ":contains:" + collectionQueryDList[1] + ">";
			collectionQuery = collectionQuery.trim();
			
			//wnsearch.setCollectionInfoValue(collections[i], COLLECTION_QUERY, "<" + collectionQueryW.split("|")[0] + ":contains:" + collectionQueryW.split("|")[1] + "> <" + collectionQueryD.split("|")[0] + ":contains:" + collectionQueryD.split("|")[1] + ">");
			wnsearch.setCollectionInfoValue(collections[i], COLLECTION_QUERY, collectionQuery);
		}
		
		/* if(categoryQueryW.length() > 0 || categoryQueryD.length() > 0){
			wnsearch.setCollectionInfoValue(collections[i], CATEGORY_QUERY, categoryQueryW + "," + categoryQueryD);
		}*/
    }
      // 쿼리로그에 prefix query, filter query 정보 남기기
    if(prefixForLog.length() > 0) {
    	prefixForLog = "[prefix] " + prefixForLog.substring(0, prefixForLog.length()-1);
    }
    if(filter.length() > 0) {
    	filterForLog = "[filter] " + filter;
    }

    wnsearch.search(realQuery, isRealTimeKeyword, CONNECTION_CLOSE, useSuggestedQuery, new String[] {prefixForLog, filterForLog, ""}, apprType);

     // 디버그 메시지 출력
    String debugMsg = wnsearch.printDebug() != null ? wnsearch.printDebug().trim() : "";
    if ( !debugMsg.trim().equals("")) {
         out.println(debugMsg);
    }
    
    // 맨 위에 표출되는 컬렉션일 경우 적용되는 div class가 다름, 첫번째인지 확인용
    String firstCollection = "";

     // 전체건수 구하기
    if ( collection.equals("ALL") ) {
        for (int i = 0; i < collections.length; i++) {
           int tempCnt = wnsearch.getResultTotalCount(collections[i]);
   			totalCount += tempCnt;
   			if(tempCnt > 0 && firstCollection.length() == 0){
   				firstCollection = collections[i];
   			}
        }
    } else {
      //개별건수 구하기
        totalCount = wnsearch.getResultTotalCount(collection);
    }

    String thisCollection = "";
    if(useSuggestedQuery) {
       suggestQuery = wnsearch.suggestedQuery;
    }
    
	// XSS처리 : 스크립트 내 getMyKeyword시 호출될 변수 따로 선언, 검색을 위해 getCheckReqXSS에서 처리되지 않은 특수문자들 처리
  	String myKeyword = query;
  	myKeyword = myKeyword.replaceAll("#","﻿&#35;");
  	myKeyword = myKeyword.replaceAll("﻿&","﻿﻿&amp;amp;");
  	myKeyword = myKeyword.replaceAll("\"","﻿&amp;quot;");
  	myKeyword = myKeyword.replaceAll("\\(","﻿&#40;");
  	myKeyword = myKeyword.replaceAll("\\)","﻿&#41;");
    
    /* System.out.println("THIS_COLLECTIONS : "+Arrays.toString(THIS_COLLECTIONS));
    System.out.println("collections : "+Arrays.toString(collections));
    
	System.out.println(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(System.currentTimeMillis()));
    System.out.println("[query] : " + query);
	System.out.println("[prefix] : " + prefixForLog);
	System.out.println("[filter] : " + filter);
	System.out.println("[searchField] : " + searchField);
	System.out.println();  */
	
	Map<String, Integer> writerMap = getCategoryResult("CREATOR_NAME", collections, collection, wnsearch);
	Map<String, Integer> depMap = getCategoryResult("CREATOR_DEPT", collections, collection, wnsearch);
	
	// String[] portalCollections = {"appr","apprMig", "board", "user"};

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>호반그룹 그룹웨어 통합검색</title>
<link rel="stylesheet" type="text/css" href="css/search.css" >
<link rel="stylesheet" type="text/css" href="css/jquery-ui.css" >
<link rel="stylesheet" type="text/css" href="css/datepicker.css" >
<link rel="stylesheet" type="text/css" href="ark/css/ark.css" media="screen" >
<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="js/script.js"></script>
<script type="text/javascript" src="js/jquery-ui.min.js"></script>
<script type="text/javascript" src="ark/js/beta.fix.js"></script>
<script type="text/javascript" src="ark/js/ark.js"></script>
<script type="text/javascript" src="js/datepicker.js"></script>
<script type="text/javascript" src="js/search.js"></script>
<script type="text/javascript" src="js/hmac-sha256.js"></script>
<script type="text/javascript" src="js/enc-base64-min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	
	// 토큰 유효 체크
	// checkTokenExcept(); 

	// 인기 검색어
    getPopkeyword();
    
    // 상세검색 검색범위 체크박스
    registerSearchDetailCheckBox();
    
    // 문서종류 체크박스
    docPickCheckBox();
    
	// 내가 찾은 검색어
	getMyKeyword("<%=myKeyword%>", <%=totalCount%>);
	
	// 관심 키워드
	getSavedKeyword();
	
	// apprType 라디오박스 변환
	apprTypeChange();

	// 체크한 문서
	var docTypeArr = $("#docType").val().split(",");
	for(var i = 0; i < docTypeArr.length; i++){
		$("#check" + docTypeArr[i]).attr("checked", true);
	}
	
	$("#startDate").datepicker({
			
			dateFormat: 'yy-mm-dd' //달력 날짜 형태
		    ,showOtherMonths: true //빈 공간에 현재월의 앞뒤월의 날짜를 표시
		    ,showMonthAfterYear:true // 월- 년 순서가아닌 년도 - 월 순서
		    ,changeYear: true //option값 년 선택 가능
		    ,changeMonth: true //option값  월 선택 가능                
		    //,showOn: "both" //button:버튼을 표시하고,버튼을 눌러야만 달력 표시 ^ both:버튼을 표시하고,버튼을 누르거나 input을 클릭하면 달력 표시  
		    //,buttonImageOnly: true //버튼 이미지만 깔끔하게 보이게함
		    //,buttonText: "선택" //버튼 호버 텍스트              
		    ,yearSuffix: "년 " //달력의 년도 부분 뒤 텍스트
		    ,monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 텍스트
		    ,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 Tooltip
		    ,dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'] //달력의 요일 텍스트
		    ,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'] //달력의 요일 Tooltip
		   	,closeText: '닫기' // 닫기 버튼 텍스트 변경
		    ,currentText: '오늘' // 오늘 텍스트 변경
		    ,showButtonPanel: true
		    ,todayHighlight : false
			
	});
	$("#endDate").datepicker({

			dateFormat: 'yy-mm-dd' //달력 날짜 형태
		    ,showOtherMonths: true //빈 공간에 현재월의 앞뒤월의 날짜를 표시
		    ,showMonthAfterYear:true // 월- 년 순서가아닌 년도 - 월 순서
		    ,changeYear: true //option값 년 선택 가능
		    ,changeMonth: true //option값  월 선택 가능                
		    //,showOn: "both" //button:버튼을 표시하고,버튼을 눌러야만 달력 표시 ^ both:버튼을 표시하고,버튼을 누르거나 input을 클릭하면 달력 표시  
		    //,buttonImageOnly: true //버튼 이미지만 깔끔하게 보이게함
		    //,buttonText: "선택" //버튼 호버 텍스트              
		    ,yearSuffix: "년 " //달력의 년도 부분 뒤 텍스트
		    ,monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 텍스트
		    ,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 Tooltip
		    ,dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'] //달력의 요일 텍스트
		    ,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'] //달력의 요일 Tooltip 
		   	,closeText: '닫기' // 닫기 버튼 텍스트 변경
		    ,currentText: '오늘' // 오늘 텍스트 변경
		    ,showButtonPanel: true
		    ,todayHighlight : false

	});
	
	$("#query").keypress(function(event) {
		return event.keyCode == 13 ? doSearch() : false ;
	});
	console.log(document.search);
});

// 토큰 유효 체크
//function checkTokenExcept() {
//	if(document.search.tokenExcept.value === "expired"){		
//		alert("토큰이 만료되었거나, 유효하지 않습니다.");
//		window.location.href='https://';
//	}
//}

function getPopkeyword() {

	var target		= "popword";
	var range		= "D";
	//var collection  = "_ALL_";
	var collection  = "total";
    var datatype   = "text";
	$.ajax({
	  type: "POST",
	  url: "./popword/popword.jsp",
	  dataType: datatype,
	  data: { "target" : target, "range" : range, "collection" : collection , "datatype" : datatype },
	  success: function(text) {
     text = trim(text);
     var xml = $.parseXML(text);
		var str = "<p class='search_word_title'>인기검색어</p>";
		str += "<div class='search_word'>";

		$(xml).find("Query").each(function(){
			str += "	<a href='#' class='search_word_link'onclick=\"javascript:doKeyword('" + $(this).text() + "');\">" + $(this).text() + "</a>";
			str += "</div>";
		});

		$("#search_word_wrap").html(str);
	  }
	});

}

function helpSearch(){
	document.getElementById("layer_popup").style.display = 'block';
	document.getElementById("layer_popup_overlay").style.display = 'block';
}

function helpClose(){
	document.getElementById("layer_popup").style.display = 'none';
	document.getElementById("layer_popup_overlay").style.display = 'none';
}

function saveKeyword(){
	document.getElementById("kw_add_popup").style.display = 'block';
	document.getElementById("saveKeywordBtn").setAttribute("onClick", "saveKeywordClose();");
	//팝업 활성화시 +버튼이 -버튼으로 바뀌는 기능: 퍼블 이미지 제공시 설정
	//document.getElementById("saveKeywordBtn").setAttribute("src", "images/ico_del.png");
}

function saveKeywordClose(){
	document.getElementById("kw_add_popup").style.display = 'none';
	document.getElementById("saveKeywordBtn").setAttribute("onClick", "saveKeyword();");
	//document.getElementById("saveKeywordBtn").setAttribute("src", "images/ico_add.png");
}

function doCollection(coll) {
	
	var searchForm = document.search;
	
	searchForm.apprType.value = "appr";
	searchForm.collection.value = coll;
	searchForm.reQuery.value = "2";
	searchForm.categoryQueryW.value = "";
	searchForm.categoryQueryD.value = "";
	searchForm.submit();
}

//페이징
function doPaging(count) {
	var searchForm = document.search;
	searchForm.startCount.value = count;
	searchForm.reQuery.value = "2";
	searchForm.submit();
}

//페이징
function goPaging() {
	var searchForm = document.search;
	var inputPageNo = searchForm.input_gopage.value;
	searchForm.startCount.value = (inputPageNo-1) * 10;
	searchForm.reQuery.value = "2";
	searchForm.submit();
}

//Replace All
function replaceAll(str, orgStr, repStr) {
	return str.split(orgStr).join(repStr);
}

function pressCheck() {
	if (event.keyCode == 13)
		return doSearch();
	//else
		//return false;
	// return event.keyCode == 13 ? doSearch() : true;
}
</script>
</head>
<body>
 <form name="search" id="search" action="<%=request.getRequestURI()%>" method="post">
 <div class="wrap">
  <div class="header_wrap">
		<input type="hidden" name="startCount" value="0">
		<input type="hidden" name="sort" value="<%=sort%>">
		<input type="hidden" name="categoryQueryW" value="<%=categoryQueryW%>">
		<input type="hidden" name="categoryQueryD" value="<%=categoryQueryD%>">		
		<input type="hidden" name="collectionQueryW" value="<%=collectionQueryW%>">
		<input type="hidden" name="collectionQueryD" value="<%=collectionQueryD%>">		
		<input type="hidden" name="collection" id="collection" value="<%=collection%>">
		<input type="hidden" name="range" value="<%=range%>">
		<input type="hidden" name="searchField" value="<%=searchField%>">
		
		<input type="hidden" name="prefix" value="<%=prefix%>">
		<input type="hidden" name="filter" value="<%=filter%>">
		
		<input type="hidden" name="reQuery" />
		<input type="hidden" name="realQuery" value="<%=realQuery%>" />
		
		<input type="hidden" name="UR_Code" value="<%=userId%>" />
		<input type="hidden" name="DN_Code" value="<%=DN_Code%>" />
		<input type="hidden" name="DEPTID" value="<%=DEPTID%>" />
		
		<input type="hidden" name="apprType" value="<%=apprType%>" />
		
		<input type="hidden" name="startDate" value="<%=startDate%>"/>
		<input type="hidden" name="endDate" value="<%=endDate%>"/>
		<input type="hidden" id="docType" name="docType" value="<%=docType%>"/>
      <div class="fix_wrap">
        <div class="fix_conts">
          <!-- Header 시작 -->
          <div class="header_search">
            <div class="white_window">
              <h1 class="h_search">
                <a href="/" class="logo_header_search"></a>
              </h1>
              <span class="white_window_box">
                <select style="" class="white_window_select" id="searchSelect">
	                <option value="ALL" <%=searchField.indexOf("ALL") > -1 ? "selected" : ""%>>전체</option>
					<option value="SUBJECT" <%=searchField.indexOf("SUBJECT") > -1 ? "selected" : ""%>>제목</option>
					<option value="BODYCONTEXTS" <%=searchField.indexOf("BODYCONTENTS") > -1 ? "selected" : ""%>>내용</option>
					<option value="CREATOR_NAME" <%=searchField.indexOf("CREATOR_NAME") > -1 ? "selected" : ""%>>작성자</option>
                </select>
               <input class="white_input_text" type="text" name="query" id="query" value="<%=query%>" onKeypress="javascript:pressCheck((event), this);" autocomplete="off" style="ime-mode:auto" />
				<a href="#" onClick="javascript:doSearch();" title="검색"><span class="search_button"></span></a>                 
              </span>
            </div>
            <div class="white_window_check"><input type="checkbox" name="reChk" id="reChk" onClick="checkReSearch();"/>결과내 재검색 </div>
            <div id="ark"> 
            <!-- 
           	<div class="auto_text"><strong>자동 추천 기능</strong>을 사용해 보세요.<br>검색어 입력시 자동으로 관련어를 추천합니다.</div>
			<div class="auto_btn_wrap"><a href="#" class="auto_btn">기능끄기</a></div> 
             -->
            </div>
            
			<!--  
			<div class="nuttop">
			  <div class="auto">
				  <ul class="recomm">
						<li><a href="#"><strong class="tx_key">이</strong>력사항</a></li>
						<li><a href="#"><strong class="tx_key">이</strong>용</a></li>
						<li><a href="#"><strong class="tx_key">이</strong>내</a></li>
						<li><a href="#"><strong class="tx_key">이</strong>상</a></li>
						<li><a href="#">상<strong class="tx_key">이</strong></a></li>
						<li><a href="#">높<strong class="tx_key">이</strong></a></li>
				  </ul>
				  <div class="auto_text"><strong>자동 추천 기능</strong>을 사용해 보세요.<br>검색어 입력시 자동으로 관련어를 추천합니다.</div>
				  <div class="auto_btn_wrap"><a href="#" class="auto_btn">기능끄기</a></div>
			  </div>
			</div>
			-->
          </div>
          <!-- Header 끝 -->
          <!-- 컨텐츠영역시작 -->
          <div class="layout">
            <div class="container">
              <div class="content_sf">
                <div class="sub" id="pTag">
                  <div class="sub_l_search01">
                    <!-- lnb 시작 -->
                    <h2 class="lt_search">
                      <span class="txt_ltit_search">통합검색</span>
                    </h2>
                    <!-- 트리 시작 -->
                    <div id="divOpenBoardLevel"></div>
                    <div class="tree_search">
											<div class="search_list01">
                        <a href="#" class="search_list_close">
                          <span class="list_text_<%=collection.equals("ALL") ? "on" : "off" %>">전체</span>
                        </a>
                      </div>
                      <div class="search_list01">
                        <a href="#" class="search_list_open">
                          <span class="list_text_off">시스템구분</span>
                        </a>
                      </div>
					<div class="search_list02">
					<%
						System.out.println(apprType);
						for(int i = 0; i < THIS_COLLECTIONS.length; i++) {
							String systemName = wnsearch.getCollectionKorName(THIS_COLLECTIONS[i]);
							int thisTotalCount = wnsearch.getResultTotalCount(THIS_COLLECTIONS[i]);
							System.out.println(THIS_COLLECTIONS[i] + "\t\t" + systemName);
							if(thisTotalCount < 0) thisTotalCount = 0; 
					%>
						<a href="#" onclick="javascript:doCollection('<%=THIS_COLLECTIONS[i] %>')"><span><img src="images/ico_bbar.gif"> <%=systemName%> (<%=thisTotalCount %>)</span></a>
					<%	} %>
					</div>
					
					<!-- 작성자명 -->					
<%					if(!writerMap.isEmpty()) { %>
					<div class="search_list01">
						<a href="javascript:void(0);" class="search_list_close">
							<span class="list_text_off">작성자명</span>
						</a>
					</div>
					<div class="search_list02">
<%						
                         // 좌측 메뉴(작성자명) 최대 값 5개씩만 보여주기
						final int MAX_CATEGORY_VIEW = 5;

						if(writerMap.size() > MAX_CATEGORY_VIEW) {
							PriorityQueue<Object[]> list = new PriorityQueue<>((o1, o2) -> -1 * Integer.compare(Integer.valueOf(o1[1].toString()), Integer.valueOf(o2[1].toString())));
							for( String key : writerMap.keySet() )
								list.add(new Object[] {key, writerMap.get(key)});
							
							for(int i = 0 ; i < MAX_CATEGORY_VIEW; i++){
								Object[] o = list.poll();
								String key = o[0].toString();
								%>
						<a href="#" onClick="javascript:doCollectionQueryW('CREATOR_NAME|<%=key.toString().split(";")[0]%>');">
								<%				if(categoryQueryW.length() > 0){	
													String[] categoryQueryWs = categoryQueryW.split("\\|");
													if(categoryQueryWs[1].equals(key)){ %>
									<span class="list_text_on">
								<%					} else { %>
									<span>
								<%					}
												} else { %>
									<span>
								<%				}%>
									<img src="images/ico_bbar.gif" /><%=key.toString().split(";")[0]%> (<%=numberFormat(writerMap.get(key))%>)</span>
						</a>
								<%
							}
						}
						else {
							for( String key : writerMap.keySet() ) {
%>
						<a href="#" onClick="javascript:doCollectionQueryW('CREATOR_NAME|<%=key.toString().split(";")[0]%>');">
<%												if(categoryQueryW.length() > 0){	
													String[] categoryQueryWs = categoryQueryW.split("\\|");
													if(categoryQueryWs[1].equals(key)){ %>
									<span class="list_text_on">
<%													} else { %>
									<span>
<%													}
												}else{ %>
									<span>
<%												}%>
								<img src="images/ico_bbar.gif" /><%=key.toString().split(";")[0]%> (<%=numberFormat(writerMap.get(key))%>)</span>
						</a>
<%							}
						}
						%>												
					</div>
<%					} %>

					<!-- 부서명 -->	
					<%if(!depMap.isEmpty()) { %>	
					<div class="search_list01">
						<a href="javascript:void(0);" class="search_list_close">
						<span class="list_text_off">부서명</span>
						</a>
					</div>
						<div class="search_list02">
						
<%						// 좌측 메뉴(부서명) 최대 값 5개씩만 보여주기		
						final int MAX_CATEGORY_VIEW = 5;

						if(depMap.size() > MAX_CATEGORY_VIEW) {
							PriorityQueue<Object[]> list = new PriorityQueue<>((o1, o2) -> -1 * Integer.compare(Integer.valueOf(o1[1].toString()), Integer.valueOf(o2[1].toString())));
							for( String key : depMap.keySet() )
								list.add(new Object[] {key, depMap.get(key)});
							
							for(int i = 0 ; i < MAX_CATEGORY_VIEW; i++){
								Object[] o = list.poll();
								String key = o[0].toString();
								%>
						<a href="#" onClick="javascript:doCollectionQueryD('CREATOR_DEPT|<%=key.toString().split(";")[0]%>');">
								<%				if(categoryQueryD.length() > 0){	
													String[] categoryQueryDs = categoryQueryD.split("\\|");
													if(categoryQueryDs[1].equals(key)){ %>
									<span class="list_text_on">
								<%					} else { %>
									<span>
								<%					}
												} else { %>
									<span>
								<%				}%>
									<img src="images/ico_bbar.gif" /><%=key.toString().split(";")[0]%> (<%=numberFormat(depMap.get(key))%>)</span>
						</a>
								<%
							}
						}
						else {
								for( String key : depMap.keySet() ){ %>
							<a href="#" onClick="javascript:doCollectionQueryD('CREATOR_DEPT|<%=key.toString().split(";")[0]%>');">
<%												if(categoryQueryD.length() > 0){	
													String[] categoryQueryDs = categoryQueryD.split("\\|");
													if(categoryQueryDs[1].equals(key)){ %>
										<span class="list_text_on">
<%													}else{ %>
										<span>
<%													}
												} else { %>
									<span>
<%												}%>
								<img src="images/ico_bbar.gif" /><%=key.toString().split(";")[0]%> (<%=numberFormat(depMap.get(key))%>)</span>
							</a>
<%										}
						}%>	
						</div>
<%					} %>
				</div>
			</div>
                  <!-- 트리 끝 -->
                  <p class="space"></p>
                  <!-- lnb 끝 -->
                  
                  <div class="sub_c" id="cTag">
                    <div class="con_in">
                      <div class="sc_title01">검색어 <span class="search_text">'<%=query%>'</span>에 대하여 <strong>[총 <%=numberFormat(totalCount)%>건]</strong> 통합검색 결과입니다. 
					  <a href="javascript:fnShow('DivLayer100');" class="btn_detail_search">
                          <span>상세검색</span>
                        </a>
                        <div class="search_radio_box">
                          <span class="search_radio">
							<input type="radio" name="search_radio01" value="RANK" onclick="doSorting(this.value);" <%=sort.equals("RANK") ? "checked" : ""%>/> 정확도순 
						  </span>
                          <span class="search_radio">
							<input type="radio" name="search_radio01" value="DATE" onclick="doSorting(this.value);" <%=sort.equals("DATE") ? "checked" : ""%>/> 날짜순 
						  </span>
                          <span class="search_radio">
							<input type="radio" name="search_radio01" value="SUBJECT" onclick="doSorting(this.value);" <%=sort.equals("SUBJECT") ? "checked" : ""%>/> 제목순 
						  </span>
                        </div>
                        
                        <div class="search_detail_box" id="DivLayer100" style="display:none;">
                          <div class="search_date">
                            <div class="search_date_txt">
                              <span>검색기간</span>
                            </div>
                            <div class="search_date_select">
                              <span class="date_radio"><input type="radio" <%=range.equals("A") ? "checked" : ""%> onClick="javascript:setDate('A');" name="date_radio01" />전체 </span>
                              <span class="date_radio"><input type="radio" <%=range.equals("D") ? "checked" : ""%> onClick="javascript:setDate('D');" name="date_radio01" />1일 </span>
							  <span class="date_radio"><input type="radio" <%=range.equals("W") ? "checked" : ""%> onClick="javascript:setDate('W');" name="date_radio01" />1주 </span>
							  <span class="date_radio"><input type="radio" <%=range.equals("M") ? "checked" : ""%> onClick="javascript:setDate('M');" name="date_radio01" />1개월 </span>
				              <span class="date_radio">
								<input type="radio" <%=range.equals("undefined") ? "checked" : ""%> onClick="javascript:changeDatepickerValue('enable');" name="date_radio01" /> 사용자정의 
									<span class="calendar_box">
										<input type="text" name="startDate" id="startDate" value="<%=startDate%>" readonly="true" class="search_date_input"/>
									</span> ~ 
									<span class="calendar_box">
										<input type="text" name="endDate" id="endDate" value="<%=endDate%>" readonly="true" class="search_date_input" />
									</span>
								</span>
							</div>
						</div>    
							                           
                          <div class="search_area">
                            <div class="search_area_txt">
                              <span>검색범위</span>
                            </div>
                            <div class="search_checkbox_box">
								<span class="search_checkbox"><input type="checkbox" <%=searchField.indexOf("ALL") > -1 ? "checked" : ""%> value="ALL" id="checkAll"/>전체 </span>
								<span class="search_checkbox"><input type="checkbox" <%=searchField.indexOf("SUBJECT") > -1 ? "checked" : ""%> name="searchFields" value="SUBJECT"/>제목 </span>
								<span class="search_checkbox"><input type="checkbox" <%=searchField.indexOf("BODYCONTENTS") > -1 ? "checked" : ""%> name="searchFields" value="BODYCONTENTS"/>본문 </span>
								<span class="search_checkbox"><input type="checkbox" <%=searchField.indexOf("CREATOR_NAME") > -1 ? "checked" : ""%> name="searchFields" value="CREATOR_NAME"/>작성자 </span>
								<div class="search_input_box">
									<span class="search_input">부서명 <input type="text" name="prefix_input" id="prefix_dep"/></span>
									<span class="search_input">작성자 <input type="text" name="prefix_input" id="prefix_writer"/></span>
									<!--  <span class="search_input">수신/참조/결재자 <input type="text" name="prefix_input" id="prefix_etc"/></span>-->
                              </div>
                            </div>
                          </div>
                          <div class="search_start">
			                       <a href="#" onClick="javascript:doSearch();" title="상세검색">
			                       	<span>검색</span>
			                       </a>
			              </div>
                        </div>
                      </div>
                      
					<% if (totalCount >= 0) { %>
						<%@ include file="./result/result_appr.jsp" %>
						<%@ include file="./result/result_board.jsp" %>					
						<%@ include file="./result/result_user.jsp" %>
				
				<!-- paginate -->
						<% if (!collection.equals("ALL") && totalCount > TOTALVIEWCOUNT) { %>
						<div class="paginate"> <%=wnsearch.getPageLinks(startCount , totalCount, 10, 10)%> </div>
						<% } %>
				<!-- //paginate -->

					<% } else { %>
						<div class="search_n_result_wrap">
				        	<p class="search_n_result_txt"><span class="search_n_result_img"></span>
							<strong class="tx_keyword">'<%=query%>'</strong>에 대한 검색 결과가 없습니다.<br /><span class="search_n_result_txt2">다른 검색어로 검색해 보시기 바랍니다.</span></p>
				         </div>
		         	<% }%>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <!-- 컨텐츠영역끝 -->
      	</div>      	
      </div>
			<!-- TOP버튼 -->
			<div id="MovTop" class="onlPsc">
				<a href="javascript:;">
					<s></s>
					<span>TOP</span>
				</a>
			</div>		
    </form>
  </body>
</html>
<%
	if ( wnsearch != null ) {
		wnsearch.closeServer();
	}
%>
<%!
public static Map<String, Integer> getCategoryResult(String groupfieldName, String[] collections, String collection, WNSearch wnsearch){
	Map<String, Integer> categoryMap = new TreeMap<String, Integer>();
	if(collection.equals("ALL")){
		for (int i = 0; i < collections.length; i++) {
			
			int depth1 = wnsearch.getCategoryCount(collections[i], groupfieldName, 1);
			for(int j=0; j<depth1; j++){
				String categoryName = wnsearch.getCategoryName(collections[i], groupfieldName, 1, j);
				int categoryCnt = wnsearch.getDocumentCountInCategory(collections[i], groupfieldName, 1, j);

				if(("null").equalsIgnoreCase(categoryName) || categoryName.length() <= 0){
					continue;
				}
				
				if(categoryMap.containsKey(categoryName)){
					categoryMap.put(categoryName, categoryMap.get(categoryName) + categoryCnt);
				}else{
					categoryMap.put(categoryName, categoryCnt);
				}
			}
		}		
	}else{
		int depth1 = wnsearch.getCategoryCount(collection, groupfieldName, 1);
		for(int j=0; j<depth1; j++){
			String categoryName = wnsearch.getCategoryName(collection, groupfieldName, 1, j);
			int categoryCnt = wnsearch.getDocumentCountInCategory(collection, groupfieldName, 1, j);

			if(("null").equalsIgnoreCase(categoryName) || categoryName.length() <= 0){
				continue;
			}
			
			if(categoryMap.containsKey(categoryName)){
				categoryMap.put(categoryName, categoryMap.get(categoryName) + categoryCnt);
			}else{
				categoryMap.put(categoryName, categoryCnt);
			}
		}
	}
	return categoryMap;
}

public static int getTotalPage(int totalCount, int bundleCount){
	int lastPage = 0;
	if(totalCount % bundleCount == 0){
		lastPage = totalCount / bundleCount;
	}else{
		lastPage = (totalCount / bundleCount) + 1;
	}
	return lastPage;
}
%>