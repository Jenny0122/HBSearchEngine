<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="./common/api/WNSearch.jsp" %>
<%@ include file="./common/api/Encrypt.jsp" %>
<% request.setCharacterEncoding("UTF-8");%><%
    
    //실시간 검색어 화면 출력 여부 체크
    boolean isRealTimeKeyword = false;
    //오타 후 추천 검색어 화면 출력 여부 체크
    boolean useSuggestedQuery = true;
    String suggestQuery = "";

    //디버깅 보기 설정
    boolean isDebug = false;

    int TOTALVIEWCOUNT = 3;    //통합검색시 출력건수
    int COLLECTIONVIEWCOUNT = 10;    //더보기시 출력건수

	String START_DATE = "2000.01.01";	// 기본 시작일

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
	
	String UR_Code 		= getCheckReqXSS(request, "UR_Code", "");					//유저코드
	String DN_ID 		= getCheckReqXSS(request, "DN_ID", "");						//도메인아이디
	String DN_Code 		= getCheckReqXSS(request, "DN_Code", "");					//도메인코드
	String GR_Code 		= getCheckReqXSS(request, "GR_Code", "");					//그룹코드
	String DEPTID 		= getCheckReqXSS(request, "DEPTID", "");					//부서코드
	String DEPT_NAME 		= getCheckReqXSS(request, "DEPT_NAME", "");					//부서코드
 
    String token = 			getCheckReqXSS(request, "token", "");                       //유저코드 암호화 파라미터
    String tokenExcept = 	getCheckReqXSS(request, "tokenExcept", "");;
    
    String tokenCheck = 	getCheckReqXSS(request, "tokenCheck", "1");
    String jsonError = "";
    
	String strOperation  = "" ;												//operation 조건 필드
    String exquery = "" ;													//exquery 조건 필드
    String apprEx = "" ;													//appr exquery 조건 필드
    String apprMigEx = "" ;													//apprMig exquery 조건 필드
	
	// 차후 %검색 오류걸릴 경우 referer참고해서 예외처리하는 부분
	String referer = request.getHeader("referer");
	if (referer != null){
		if (referer.indexOf("search") == -1) {
			query = java.net.URLDecoder.decode(query, "UTF-8"); 
		}
	}
		
	// 도메인 
	// String doMain = "https://gw2.youngone.com"; //영원무역 그룹웨어 prd

   
    int totalCount = 0;
    String [] deptidArray = null; //참고-deptid가 여러개로 넘어올 때 담을 배열
	Map<String, String> prefixMap = new HashMap<String,String>();

    
    // jwt 토큰 복호화
	// warr : 임시확인용 주석처리
 	if ( UR_Code.equals("") ) { 
			//임시확인용 토큰
			//token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2ODI0ODg5NTYwOTgsImV4cCI6MTY4MjQ4OTU1NjA5OCwiZW1wIjoic3VwZXJhZG1pbiJ9.m_HRrWUFHZxeKLdmgOCPjbGwDPjubitRW5L5zp-KrSg";
		Map<String,Object> retMap = new HashMap<>();
		try  {	
			retMap = Encrypts.getTokenFromJwtString("duddnjsandur01!@#$",token);
		} catch ( Exception e ) {

		}
		if ( retMap == null  || retMap.size() == 0 || retMap.containsKey("result")) { 
			out.println("잘못된 접근입니다. 그룹웨어에 로그인 후 다시 검색을 시도하세요."); 
			return ;
		}
		
		long exp = (long) retMap.get("exp");
		userId = (String) retMap.get("emp"); 
    
		long nowTime = System.currentTimeMillis ();
		
		if ( nowTime > exp ) {
			out.println("Timeout. 그룹웨어에 로그인 후 다시 검색을 시도하세요." + exp + " :: " + nowTime); 
			return ;
		}
		if ( userId == null || "".equals(userId)  ) {
			out.println(userId);
			out.println("잘못된 접근입니다. 그룹웨어에 로그인 후 다시 검색을 시도하세요."+ retMap.get("emp")); 
			return ;
		} 
		} else {
			userId = UR_Code;
		}
    }
    
    // 유저 apprEx 설정
    if(!uid.equals("") && uid != null){
    	apprEx += "<ApprAuth:contains:" + uid + ">";
    	apprMigEx += "<ApprAuth:contains:" + uid + ">";
    }
    
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
	
   	String [] apprExArray = apprEx.split(" ");
   	String [] apprMigExArray = apprMigEx.split(" ");
   
    String[] searchFields = null;

	// 상세검색 검색 필드 설정이 되었을때
    if (!searchField.equals("")) {
		// 작성자
		if (!writer.equals("")) {
			exquery = "<WRITER:" + writer + ">";
		}
	} else {
		searchField = "ALL";
	}
	
	// 문서 종류 prefix 설정
	// 1(전체), ..., 17(기타)
	String[] docTypeListIdx = docType.split(","); 
	String[] docTypeList = {"전체","pdf","xls","doc","ppt","jpg","hwp","gif","zip","txt","msg","html","dwg","png","tif","bmp","기타"};
	String etc = "<FileType:contains:!pdf> <FileType:contains:!xls> <FileType:contains:!doc> <FileType:contains:!ppt> <FileType:contains:!jpg> <FileType:contains:!hwp> <FileType:contains:!gif> <FileType:contains:!zip> <FileType:contains:!txt> <FileType:contains:!msg> <FileType:contains:!html> <FileType:contains:!dwg> <FileType:contains:!png> <FileType:contains:!tif> <FileType:contains:!bmp>";
	
	String[] docImg = {"file_all","file_pdf","file_xls","file_doc","file_ppt","file_jpg","file_hwp","file_gif","file_zip","file_txt","file_msg","file_html","file_dwg","file_png","file_tif","file_bmp","file_etc"};
	String prefix = "";
	if (!docType.equals("") && !docType.equals("1")) {
		if (!exquery.equals("")) {
    		exquery += " ";
    	}
		
		for (int i=0; i < docTypeListIdx.length; i++) {
			if (docTypeListIdx[i].equals("17")){
				break;
			}
			
			if (i != 0) {
				exquery += "|";
			}
			
			exquery += "<FileType:contains:" + docTypeList[Integer.parseInt(docTypeListIdx[i]) - 1] +">";
		}
		if (docType.contains("17")){ // 기타 문서 처리
			String etc_tmp = etc;
			
			for (int i=0; i < docTypeListIdx.length - 1; i++) {
				etc_tmp = etc_tmp.replaceAll("!" + docTypeList[Integer.parseInt(docTypeListIdx[i]) - 1], docTypeList[Integer.parseInt(docTypeListIdx[i]) - 1]);
			}
			
			exquery += "|(" + etc_tmp + ")";
		} 
	}
	prefix = exquery;

    String[] collections = null;
	String[] THIS_COLLECTIONS = null;

	 if (apprType.equals("mig")){
    	THIS_COLLECTIONS = COLLECTIONS_MIG;
	} else {
		THIS_COLLECTIONS = COLLECTIONS;
	}

	
    if(collection.equals("ALL")) { //통합검색인 경우
        collections = THIS_COLLECTIONS;
    } else {                        //개별검색인 경우
        collections = new String[] { collection };
    }

	if (reQuery.equals("1")) {
		realQuery = query + " " + realQuery;
	} else if (!reQuery.equals("2")) {
		realQuery = query;
	}

    WNSearch wnsearch = new WNSearch(isDebug, false, collections, searchFields, apprType);

    int viewResultCount = COLLECTIONVIEWCOUNT;
    if ( collection.equals("ALL") ||  collection.equals("") )
        viewResultCount = TOTALVIEWCOUNT;

    for (int i = 0; i < collections.length; i++) {
    	try{
        //출력건수
        wnsearch.setCollectionInfoValue(collections[i], PAGE_INFO, startCount+","+viewResultCount);

        //검색어가 없으면 DATE_RANGE 로 전체 데이터 출력
        if (collections[i].equals("user")) {
        	wnsearch.setCollectionInfoValue(collections[i], SORT_FIELD, "JOB_POSITION_SORTKEY/ASC,USER_NAME_KO/ASC");
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
        if (searchField.length() > 0 && searchField.indexOf("ALL") == -1 && !collections[i].equals("user")) {
			wnsearch.setCollectionInfoValue(collections[i], SEARCH_FIELD, searchField);
		}

        //operation 설정
        if (!strOperation.equals("")) {
			wnsearch.setCollectionInfoValue(collections[i], FILTER_OPERATION, strOperation);
		}
        
        if(collections[i].equals("appr")){
        	if (exquery != ""){
        		exquery += " ";
        	}
        	
        	//exquery += apprEx;
           	if(teamCheck.equals("permission")){
           		exquery += apprExArray[0];
        		exquery += " ";
           		exquery += apprExArray[1];
           	} else {
           		exquery += apprExArray[1];
           		exquery += " <Permissiontype:contains:Team_Permission>";
           	}
        	
        } else if(collections[i].equals("apprMig")){
        	exquery = "";
        	exquery = prefix;
        	
        	exquery += apprMigExArray[0];
    		//exquery += " ";
       		//exquery += apprMigExArray[1];
        	
        } else {
			exquery = "";
			exquery = prefix;
        }
        
        if(uid.equals("superadmin")){ // 관리자 계정 
        	exquery = "";
        }
        
        //System.out.println(collections[i] + " : " + exquery);
		
        /*
        * exquery 설정
        */
        if (!exquery.equals("")) {
			wnsearch.setCollectionInfoValue(collections[i], EXQUERY_FIELD, exquery);
		}

        //기간 설정 , 날짜가 모두 있을때
        if (!startDate.equals("")  && !endDate.equals("") ) {
             wnsearch.setCollectionInfoValue(collections[i], DATE_RANGE, startDate.replaceAll("[.]","/") + "," + endDate.replaceAll("[.]","/") + ",-");
        }
    	}catch(Exception e){
    		//System.err.print(e);
    	}
    };

    wnsearch.search(realQuery, isRealTimeKeyword, CONNECTION_CLOSE, useSuggestedQuery);

     // 디버그 메시지 출력
    String debugMsg = wnsearch.printDebug() != null ? wnsearch.printDebug().trim() : "";
    if ( !debugMsg.trim().equals("")) {
         out.println(debugMsg);
    }

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
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>통합검색</title>
<link rel="stylesheet" type="text/css" href="search.css" >
<link rel="stylesheet" type="text/css" href="css/datepicker.css" >
<link rel="stylesheet" type="text/css" href="ark/css/ark.css" media="screen" >
<script type="text/javascript" src="jquery-1.12.4.min.js"></script>
<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="script.js"></script>
<script type="text/javascript" src="js/jquery-ui.min.js"></script>
<script type="text/javascript" src="ark/js/beta.fix.js"></script>
<script type="text/javascript" src="ark/js/ark.js"></script>
<script type="text/javascript" src="js/datepicker.js"></script>
<script type="text/javascript" src="js/search.js"></script><!--  검색관련 js -->
<script type="text/javascript" src="js/hmac-sha256.js"></script>
<script type="text/javascript" src="js/enc-base64-min.js"></script>
<script type="text/javascript">
<!--
$(document).ready(function() {
	
	// 토큰 유효 체크
	checkTokenExcept(); 

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
		    ,dayNamesMin: ['SUN','MON','TUE','WED','THR','FRI','SAT'] //달력의 요일 텍스트
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
		    ,dayNamesMin: ['SUN','MON','TUE','WED','THR','FRI','SAT'] //달력의 요일 텍스트
		    ,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'] //달력의 요일 Tooltip 
		   	,closeText: '닫기' // 닫기 버튼 텍스트 변경
		    ,currentText: '오늘' // 오늘 텍스트 변경
		    ,showButtonPanel: true
		    ,todayHighlight : false

	});	
	
});

// 토큰 유효 체크
function checkTokenExcept() {
	if(document.search.tokenExcept.value === "expired"){		
		alert("토큰이 만료되었거나, 유효하지 않습니다.");
		window.location.href='https://portal.doosanenc.com';
	}
}

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
     text = trim(tex33333333333333t);
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

\home\appservice\sf1-v5\collection
//-->
</script>
</head>
<body>
    <form>
      <div class="fix_wrap">
        <div class="fix_conts">
          <!-- Header 시작 -->
          <div class="header_search">
            <div class="white_window">
              <h1 class="h_search">
                <a href="#" class="logo_header_search"></a>
              </h1>
              <span class="white_window_box">
                <select style="" class="white_window_select">
                  <option>전체</option>
                  <option>제목</option>
                  <option>내용</option>
                  <option>작성자</option>
                </select>
                <input class="white_input_text" type="text">
                <a href="#">
                  <span class="search_button"></span>
                </a>
              </span>
            </div>
            <div class="white_window_check">
              <input type="checkbox" />결과내 재검색
            </div>
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
                          <span class="list_text_on">전체</span>
                        </a>
                      </div>
                      <div class="search_list01">
                        <a href="#" class="search_list_open">
                          <span class="list_text_off">시스템구분</span>
                        </a>
                      </div>
                      <div class="search_list02">
                        <a href="#">
                          <span><img src="Images/ico_bbar.gif" />전자결재 (33) </span>
                        </a>
                        <a href="#">
                          <span><img src="Images/ico_bbar.gif" />게시판 (4) </span>
                        </a>
                        <a href="#">
                          <span><img src="Images/ico_bbar.gif" />문서관리 (6) </span>
                        </a>
                        <a href="#">
                          <span><img src="Images/ico_bbar.gif" />임직원정보 (0) </span>
                        </a>
                      </div>
                      <div class="search_list01">
                        <a href="#" class="search_list_close"><span class="list_text_off">작성자명</span></a>
                      </div>
                      <div class="search_list02">
                        <a href="#"><span><img src="Images/ico_bbar.gif" />김성민 (5) </span></a>
                        <a href="#"><span><img src="Images/ico_bbar.gif" />최시진 (1) </span></a>
                        <a href="#"><span><img src="Images/ico_bbar.gif" />오민정 (0) </span></a>
                      </div>
                      <div class="search_list01">
                        <a href="#" class="search_list_close"><span class="list_text_off">부서명</span></a>
                      </div>
                      <div class="search_list02">
                        <a href="#"><span><img src="Images/ico_bbar.gif" />영업기획팀 (33) </span></a>
                        <a href="#"><span><img src="Images/ico_bbar.gif" />영업팀 (4) </span></a>
                        <a href="#"><span><img src="Images/ico_bbar.gif" />연구1팀 (7) </span></a>
                        <a href="#"><span><img src="Images/ico_bbar.gif" />연구2팀 (8) </span></a>
                        <a href="#"><span><img src="Images/ico_bbar.gif" />기획관리팀 (11) </span></a>
                      </div>
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
                              <span class="date_radio"><input type="radio" name="date_radio01" />사용자 정의 <span class="calendar_box">
                                <input type="text" class="search_date_input" onclick="javascript:fnShow('DivLayer110');" />
                                <div class="LaryeCalenderPop" id="DivLayer110" style="display:none; z-index:30;">
                                    <table border="0" cellpadding="0" cellspacing="1" bgcolor="#939393" align="" bordercolor="#6e7882">
                                      <tbody>
                                        <tr>
                                          <td>
                                            <table width="170px" cellpadding="0" cellspacing="1" border="0" bgcolor="#FFFFFF" style="padding:5px 7px 7px 7px;">
                                              <tbody>
                                                <tr>
                                                  <td valign="top">
                                                    <table width="100%" cellpadding="3" cellspacing="1" border="0">
                                                      <tbody>
                                                        <tr>
                                                          <td align="center">
                                                            <a href="#">
                                                              <img src="images/btn_prev_cal.gif" alt="이전년" title="이전년" class="img_align">
                                                            </a>
                                                            <span class="cal_month">2011년</span>
                                                            <a href="#">
                                                              <img src="images/btn_next_cal.gif" alt="다음년" title="다음년" class="img_align">
                                                            </a>
                                                          </td>
                                                          <td align="center">
                                                            <a href="#">
                                                              <img src="images/btn_prev_cal.gif" alt="이전달" title="이전달" class="img_align">
                                                            </a>
                                                            <span class="cal_month">10월</span>
                                                            <a href="#">
                                                              <img src="images/btn_next_cal.gif" alt="다음달" title="다음달" class="img_align">
                                                            </a>
                                                          </td>
                                                        </tr>
                                                      </tbody>
                                                    </table>
                                                    <table class="cal_body" cellpadding="3" cellspacing="1" border="0" bgcolor="#d7d7d7">
                                                      <tbody>
                                                        <tr>
                                                          <td class="w_day">
                                                            <img src="images/day1.gif" alt="일요일" title="일요일">
                                                          </td>
                                                          <td class="w_day">
                                                            <img src="images/day2.gif" alt="월요일" title="월요일">
                                                          </td>
                                                          <td class="w_day">
                                                            <img src="images/day3.gif" alt="화요일" title="화요일">
                                                          </td>
                                                          <td class="w_day">
                                                            <img src="images/day4.gif" alt="수요일" title="수요일">
                                                          </td>
                                                          <td class="w_day">
                                                            <img src="images/day5.gif" alt="목요일" title="목요일">
                                                          </td>
                                                          <td class="w_day">
                                                            <img src="images/day6.gif" alt="금요일" title="금요일">
                                                          </td>
                                                          <td class="w_day">
                                                            <img src="images/day7.gif" alt="토요일" title="토요일">
                                                          </td>
                                                        </tr>
                                                        <tr>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="notmonth" href="javascript:return false;">25</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="notmonth" href="javascript:return false;">26</a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="notmonth" href="javascript:return false;">27</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="notmonth" href="javascript:return false;">28</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="notmonth" href="javascript:return false;">29</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="notmonth" href="javascript:return false;">30</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">
                                                              <span class="txt_sat">1</span>
                                                            </a>
                                                          </td>
                                                        </tr>
                                                        <tr>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">
                                                              <span class="txt_sun">2</span>
                                                            </a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">3</a>
                                                          </td>
                                                          <td class="s_day" onmouseover="this.className='srow_on_a'" onmouseout="this.className='srow_off'">
                                                            <a class="ttday" href="javascript:return false;">
                                                              <span class="txt_today">4</span>
                                                            </a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">5</a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">6</a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">7</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">
                                                              <span class="txt_sat">8</span>
                                                            </a>
                                                          </td>
                                                        </tr>
                                                        <tr>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">
                                                              <span class="txt_sun">9</span>
                                                            </a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">10</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">11</a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">12</a>
                                                          </td>
                                                          <td class="t_day" onmouseover="this.className='trow_on_a'" onmouseout="this.className='trow_off'">
                                                            <a class="stylecal" href="javascript:return false;">13</a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">14</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">
                                                              <span class="txt_sat">15</span>
                                                            </a>
                                                          </td>
                                                        </tr>
                                                        <tr>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">
                                                              <span class="txt_sun">16</span>
                                                            </a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">17</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">18</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">19</a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">20</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">21</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">
                                                              <span class="txt_sat">22</span>
                                                            </a>
                                                          </td>
                                                        </tr>
                                                        <tr>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">
                                                              <span class="txt_sun">23</span>
                                                            </a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">24</a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">25</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">26</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">27</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">28</a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">
                                                              <span class="txt_sat">29</span>
                                                            </a>
                                                          </td>
                                                        </tr>
                                                        <tr>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">
                                                              <span class="txt_sun">30</span>
                                                            </a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">31</a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="notmonth" href="javascript:return false;">1</a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="notmonth" href="javascript:return false;">2</a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="notmonth" href="javascript:return false;">3</a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="notmonth" href="javascript:return false;">4</a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="notmonth" href="javascript:return false;">5</a>
                                                          </td>
                                                        </tr>
                                                      </tbody>
                                                    </table>
                                                    <table width="100%" cellpadding="2" cellspacing="1" border="0" bgcolor="#d7d7d7">
                                                      <tbody>
                                                        <tr>
                                                          <td align="center" bgcolor="#FFFFFF" colspan="7">
                                                            <a class="gotoday" href="#">오늘로 이동 &gt;</a>
                                                          </td>
                                                        </tr>
                                                      </tbody>
                                                    </table>
                                                  </td>
                                                </tr>
                                              </tbody>
                                            </table>
                                          </td>
                                        </tr>
                                      </tbody>
                                    </table>
                                  </div>
                                </span> ~ <span class="calendar_box">
                                  <input type="text" class="search_date_input" onclick="javascript:fnShow('DivLayer120');" />
                                  <div class="LaryeCalenderPop" id="DivLayer120" style="display:none; z-index:30;">
                                    <table border="0" cellpadding="0" cellspacing="1" bgcolor="#939393" align="" bordercolor="#6e7882">
                                      <tbody>
                                        <tr>
                                          <td>
                                            <table width="170px" cellpadding="0" cellspacing="1" border="0" bgcolor="#FFFFFF" style="padding:5px 7px 7px 7px;">
                                              <tbody>
                                                <tr>
                                                  <td valign="top">
                                                    <table width="100%" cellpadding="3" cellspacing="1" border="0">
                                                      <tbody>
                                                        <tr>
                                                          <td align="center">
                                                            <a href="#">
                                                              <img src="images/btn_prev_cal.gif" alt="이전년" title="이전년" class="img_align">
                                                            </a>
                                                            <span class="cal_month">2011년</span>
                                                            <a href="#">
                                                              <img src="images/btn_next_cal.gif" alt="다음년" title="다음년" class="img_align">
                                                            </a>
                                                          </td>
                                                          <td align="center">
                                                            <a href="#">
                                                              <img src="images/btn_prev_cal.gif" alt="이전달" title="이전달" class="img_align">
                                                            </a>
                                                            <span class="cal_month">10월</span>
                                                            <a href="#">
                                                              <img src="images/btn_next_cal.gif" alt="다음달" title="다음달" class="img_align">
                                                            </a>
                                                          </td>
                                                        </tr>
                                                      </tbody>
                                                    </table>
                                                    <table class="cal_body" cellpadding="3" cellspacing="1" border="0" bgcolor="#d7d7d7">
                                                      <tbody>
                                                        <tr>
                                                          <td class="w_day">
                                                            <img src="images/day1.gif" alt="일요일" title="일요일">
                                                          </td>
                                                          <td class="w_day">
                                                            <img src="images/day2.gif" alt="월요일" title="월요일">
                                                          </td>
                                                          <td class="w_day">
                                                            <img src="images/day3.gif" alt="화요일" title="화요일">
                                                          </td>
                                                          <td class="w_day">
                                                            <img src="images/day4.gif" alt="수요일" title="수요일">
                                                          </td>
                                                          <td class="w_day">
                                                            <img src="images/day5.gif" alt="목요일" title="목요일">
                                                          </td>
                                                          <td class="w_day">
                                                            <img src="images/day6.gif" alt="금요일" title="금요일">
                                                          </td>
                                                          <td class="w_day">
                                                            <img src="images/day7.gif" alt="토요일" title="토요일">
                                                          </td>
                                                        </tr>
                                                        <tr>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="notmonth" href="javascript:return false;">25</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="notmonth" href="javascript:return false;">26</a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="notmonth" href="javascript:return false;">27</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="notmonth" href="javascript:return false;">28</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="notmonth" href="javascript:return false;">29</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="notmonth" href="javascript:return false;">30</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">
                                                              <span class="txt_sat">1</span>
                                                            </a>
                                                          </td>
                                                        </tr>
                                                        <tr>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">
                                                              <span class="txt_sun">2</span>
                                                            </a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">3</a>
                                                          </td>
                                                          <td class="s_day" onmouseover="this.className='srow_on_a'" onmouseout="this.className='srow_off'">
                                                            <a class="ttday" href="javascript:return false;">
                                                              <span class="txt_today">4</span>
                                                            </a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">5</a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">6</a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">7</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">
                                                              <span class="txt_sat">8</span>
                                                            </a>
                                                          </td>
                                                        </tr>
                                                        <tr>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">
                                                              <span class="txt_sun">9</span>
                                                            </a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">10</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">11</a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">12</a>
                                                          </td>
                                                          <td class="t_day" onmouseover="this.className='trow_on_a'" onmouseout="this.className='trow_off'">
                                                            <a class="stylecal" href="javascript:return false;">13</a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">14</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">
                                                              <span class="txt_sat">15</span>
                                                            </a>
                                                          </td>
                                                        </tr>
                                                        <tr>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">
                                                              <span class="txt_sun">16</span>
                                                            </a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">17</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">18</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">19</a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">20</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">21</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">
                                                              <span class="txt_sat">22</span>
                                                            </a>
                                                          </td>
                                                        </tr>
                                                        <tr>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">
                                                              <span class="txt_sun">23</span>
                                                            </a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">24</a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">25</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">26</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">27</a>
                                                          </td>
                                                          <td class="row_off" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">28</a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">
                                                              <span class="txt_sat">29</span>
                                                            </a>
                                                          </td>
                                                        </tr>
                                                        <tr>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">
                                                              <span class="txt_sun">30</span>
                                                            </a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="stylecal" href="javascript:return false;">31</a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="notmonth" href="javascript:return false;">1</a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="notmonth" href="javascript:return false;">2</a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="notmonth" href="javascript:return false;">3</a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="notmonth" href="javascript:return false;">4</a>
                                                          </td>
                                                          <td class="c_day" onmouseover="this.className='row_on_a'" onmouseout="this.className='row_off'">
                                                            <a class="notmonth" href="javascript:return false;">5</a>
                                                          </td>
                                                        </tr>
                                                      </tbody>
                                                    </table>
                                                    <table width="100%" cellpadding="2" cellspacing="1" border="0" bgcolor="#d7d7d7">
                                                      <tbody>
                                                        <tr>
                                                          <td align="center" bgcolor="#FFFFFF" colspan="7">
                                                            <a class="gotoday" href="#">오늘로 이동 &gt;</a>
                                                          </td>
                                                        </tr>
                                                      </tbody>
                                                    </table>
                                                  </td>
                                                </tr>
                                              </tbody>
                                            </table>
                                          </td>
                                        </tr>
                                      </tbody>
                                    </table>
                                  </div>
                                </span>
                              </span>
                            </div>
                          </div>
                          <div class="search_area">
                            <div class="search_area_txt">
                              <span>검색범위</span>
                            </div>
                            <div class="search_checkbox_box">
                              <span class="search_checkbox">
                                <input type="checkbox" />전체 </span>
                              <span class="search_checkbox">
                                <input type="checkbox" />제목 </span>
                              <span class="search_checkbox">
                                <input type="checkbox" />본문 </span>
                              <span class="search_checkbox">
                                <input type="checkbox" />첨부 </span>
                              <div class="search_input_box">
                                <span class="search_input">부서명 <input type="text" />
                                </span>
                                <span class="search_input">작성자 <input type="text" />
                                </span>
                                <span class="search_input">수신/참조/결재자 <input type="text" />
                                </span>
                              </div>
                            </div>
                          </div>
                          <div class="search_start">
                            <a href="#">
                              <span>검색</span>
                            </a>
                          </div>
                        </div>
                      </div>
                      <div class="section_search_box">
                        <div class="section_search01">
                          <div class="cont_title">
                            <div class="cont_title_l"></div>
                            <h2 class="sc_title02">전자결재 <span class="sc_number">(총 33건) </span></h2>
														<div class="search_radio_box">
		                          <span class="search_radio">
		                            <input type="radio" name="search_radio02" checked="checked">완료문서
															</span>
		                          <span class="search_radio">
		                            <input type="radio" name="search_radio02">이관문서
															</span>
		                        </div>
                            <div class="cont_title_r"></div>
                          </div>
                          <ul class="dic">
                            <li class="dic_100 dic_aside">
                              <dl>
                                <dt class="title_area">
                                  <a href="#"><strong class="hl"> 기안 </strong>테스트 문서</a>
																	<div class="title_info">
	                                  <p class="title_area_name"><span>김민서</span><span>인사팀</span><span>완료문서</span></p>
																		<span class="title_accuracy">[ 정확도 : 0.22 ]</span>
																	</div>
                                </dt>
                                <dd class="txt_inline">[기안일시: 2022-02-12] [완료일시: 2022-02-12]</dd>
                                <dd class="explain">
                                  <strong class="hl">기안</strong> 관련 테스트 문서관련 테스트 문서관련 테스트 문서관련 테스트 문서관련 테스트 문서관련 테스트 문서관련 테스트 문서관련 테스트 문서관련 테스트 문서관련 테스트 문서관련 테스트 문서관련 테스트 문서관련 테스트 문서관련 테스트 문서관련 테스트 문서
                                </dd>
                                <dd class="filein"><a href="#">첨부파일 : 계약서 양식.doc <img src="images/ico_doc.gif" alt=""></a></dd>
                              </dl>
                            </li>
                            <li class="dic_100 dic_aside">
                              <dl>
                                <dt class="title_area">
                                  <a href="#">
                                    <strong class="hl">기안</strong>지 가이드</a>
																		<div class="title_info">
		                                  <p class="title_area_name"><span>최민정</span><span>협업팀</span><span>완료문서</span></p>
																			<span class="title_accuracy">[ 정확도 : 0.22 ]</span>
																		</div>
                                </dt>
                                <dd class="txt_inline">[기안일시:20111219][완료일시:20111219]</dd>
                                <dd class="explain">
                                  <strong class="hl">기안</strong>지 작성 가이드 안내
                                </dd>
                                <dd class="filein"><a href="#">첨부파일 : 계약서 양식.pdf <img src="images/ico_pdf.gif" alt=""></a></dd>
                              </dl>
                            </li>
														<li class="dic_100 dic_aside">
                              <dl>
                                <dt class="title_area">
                                  <a href="#">
                                    <strong class="hl">기안</strong>상신여부 표시 기능 보완</a>
																		<div class="title_info">
		                                  <p class="title_area_name"><span>오민정</span><span>기획관리팀</span><span>완료문서</span></p>
																			<span class="title_accuracy">[ 정확도 : 0.22 ]</span>
																		</div>
                                </dt>
                                <dd class="txt_inline">[기안일시:20111219][완료일시:20111219]</dd>
                                <dd class="explain">
                                  상신여부 표시 기능 보완
                                </dd>
                                <dd class="filein"><a href="#">첨부파일 : 계약서 양식.xls <img src="images/ico_xls.gif" alt=""></a></dd>
                              </dl>
                            </li>
                          </ul>
                          <div class="section_more">
                            <a class="go_more" href="search_sub.html">검색 결과 더보기 </a>
                          </div>
                        </div>
                        <div class="section_search02">
                          <div class="cont_title">
                            <div class="cont_title_l"></div>
                            <h2 class="sc_title02">게시판 <span class="sc_number">(총 4건) </span>
                            </h2>
                            <div class="cont_title_r"></div>
                          </div>
													<ul class="dic dic_board">
                            <li class="dic_100 dic_aside">
															<a href="#" class="dic_img" style="background:url('images/sample.jpg') no-repeat center, url('images/noimg.gif') no-repeat center; background-size:80px auto, auto;"></a>
                              <dl>
                                <dt class="title_area">
                                  <a href="#"><strong class="hl"> 기안 </strong>지 테스트</a>
																	<div class="title_info">
	                                  <p class="title_area_name"><span>슈퍼관리자</span><span>영업팀</span></p>
																		<span class="title_accuracy">[ 정확도 : 0.07 ]</span>
																	</div>
                                </dt>
                                <dd class="txt_inline">[등록일: 2022-02-12] [폴더명: 자유게시판]</dd>
                                <dd class="explain">
                                  ...<strong class="hl">기안</strong>지 결재<strong class="hl">기안</strong>슈퍼관리자 11/03 11:25 팀원 슈퍼관리자 작성문서 영업팀 문서번호 영업팀슈퍼관리자 11/03 11:25 팀원 슈퍼관리자 작성문서 영업팀 문서번호 영업팀슈퍼관리자 11/03 11:25 팀원 슈퍼관리자 작성문서 영업팀 문서번호 영업팀슈퍼관리자 11/03 11:25 팀원 슈퍼관리자 작성문서 영업팀 문서번호 영업팀
                                </dd>
                                <dd class="filein"><a href="#">첨부파일 : 계약서 양식.xls <img src="images/ico_xls.gif" alt=""></a></dd>
                              </dl>
                            </li>
                            <li class="dic_100 dic_aside">
								<a href="#" class="dic_img" style="background:url('images/sample.jpg') no-repeat center, url('images/noimg.gif') no-repeat center; background-size:80px auto, auto;"></a>
                              <dl>
                                <dt class="title_area">
                                  <a href="#">신입사원 MS교육 지원 요청의 건</a>
									<div class="title_info">
		                                <p class="title_area_name"><span>최영</span><span>제안팀</span></p>
											<span class="title_accuracy">[ 정확도 : 0.04 ]</span>
									</div>
                                </dt>
								<dd class="txt_inline">[등록일: 2022-02-12] [폴더명: 자유게시판]</dd>
                                <dd class="explain">
                                  ...<strong class="hl">기안</strong>지 결재<strong class="hl">기안</strong>슈퍼관리자 11/03 11:25 팀원 슈퍼관리자 작성문서 영업팀 문서번호 영업팀슈퍼관리자 11/03 11:25 팀원 슈퍼관리자 작성문서 영업팀 문서번호 영업팀슈퍼관리자 11/03 11:25 팀원 슈퍼관리자 작성문서 영업팀 문서번호 영업팀슈퍼관리자 11/03 11:25 팀원 슈퍼관리자 작성문서 영업팀 문서번호 영업팀
                                </dd>
                                <dd class="filein"><a href="#">첨부파일 : 계약서 양식.xls <img src="images/ico_xls.gif" alt=""></a></dd>
                              </dl>
                            </li>
							<li class="dic_100 dic_aside">
							<a href="#" class="dic_img" style="background:url('images/sample.jpg') no-repeat center, url('images/noimg.gif') no-repeat center; background-size:80px auto, auto;"></a>
                              <dl>
                                <dt class="title_area">
                                    <a href="#">프로젝트 수행 절차 - 소스반출 프로세스</a>
									<div class="title_info">
		                                <p class="title_area_name"><span>슈퍼관리자</span><span>시스템관리자</span></p>
										<span class="title_accuracy">[ 정확도 : 0.03 ]</span>
									</div>
                                </dt>
								<dd class="txt_inline">[등록일: 2022-02-12] [폴더명: 자유게시판]</dd>
                                <dd class="explain">
                                  ...각 프로젝트 담당 PL ② 방법 : 전자결재 "자료반출 신청서" 작성결재시 내용 : 결재선 -> 결재: 담당PM(합의), 팀장, 본부장 <strong class="hl">기안</strong>지 결재<strong class="hl">기안</strong>슈퍼관리자 11/03 11:25 팀원 슈퍼관리자 작성문서 영업팀 문서번호 영업팀슈퍼관리자 11/03 11:25 팀원 슈퍼관리자 작성문서 영업팀 문서번호 영업팀슈퍼관리자 11/03 11:25 팀원 슈퍼관리자 작성문서 영업팀 문서번호 영업팀슈퍼관리자 11/03 11:25 팀원 슈퍼관리자 작성문서 영업팀 문서번호 영업팀
                                </dd>
                                <dd class="filein"><a href="#">첨부파일 : 계약서 양식.xls <img src="images/ico_xls.gif" alt=""></a></dd>
                              </dl>
                            </li>
                          </ul>
                          <div class="section_more">
                            <a class="go_more" href="#">검색 결과 더보기 </a>
                          </div>
                        </div>
                        <div class="section_search02">
                            <div class="cont_title">
                            <div class="cont_title_l"></div>
                            <h2 class="sc_title02">문서관리 <span class="sc_number">(총 6건) </span>
                            </h2>
                            <div class="cont_title_r"></div>
                            </div>
							<ul class="dic dic_board">
                            <li class="dic_100 dic_aside">
								<a href="#" class="dic_img" style="background:url('images/sample.jpg') no-repeat center, url('images/noimg.gif') no-repeat center; background-size:80px auto, auto;"></a>
                                <dl>
                                <dt class="title_area">
                                    <a href="#"><strong class="hl"> 기안 </strong>지 테스트</a>
									<div class="title_info">
	                                <p class="title_area_name"><span>슈퍼관리자</span><span>영업팀</span></p>
									<span class="title_accuracy">[ 정확도 : 0.07 ]</span>
									</div>
                                </dt>
                                <dd class="txt_inline">[등록일: 2022-02-12] [폴더명: 자유게시판]</dd>
                                <dd class="explain">
                                  ...<strong class="hl">기안</strong>지 결재<strong class="hl">기안</strong>슈퍼관리자 11/03 11:25 팀원 슈퍼관리자 작성문서 영업팀 문서번호 영업팀슈퍼관리자 11/03 11:25 팀원 슈퍼관리자 작성문서 영업팀 문서번호 영업팀슈퍼관리자 11/03 11:25 팀원 슈퍼관리자 작성문서 영업팀 문서번호 영업팀슈퍼관리자 11/03 11:25 팀원 슈퍼관리자 작성문서 영업팀 문서번호 영업팀
                                </dd>
                                <dd class="filein"><a href="#">첨부파일 : 계약서 양식.xls <img src="images/ico_xls.gif" alt=""></a></dd>
                              </dl>
                            </li>
                            <li class="dic_100 dic_aside">
															<a href="#" class="dic_img" style="background:url('images/sample.jpg') no-repeat center, url('images/noimg.gif') no-repeat center; background-size:80px auto, auto;"></a>
                              <dl>
                                <dt class="title_area">
                                  <a href="#">신입사원 MS교육 지원 요청의 건</a>
																		<div class="title_info">
		                                  <p class="title_area_name"><span>최영</span><span>제안팀</span></p>
																			<span class="title_accuracy">[ 정확도 : 0.04 ]</span>
																		</div>
                                </dt>
																<dd class="txt_inline">[등록일: 2022-02-12] [폴더명: 자유게시판]</dd>
                                <dd class="explain">
                                  ...<strong class="hl">기안</strong>지 결재<strong class="hl">기안</strong>슈퍼관리자 11/03 11:25 팀원 슈퍼관리자 작성문서 영업팀 문서번호 영업팀슈퍼관리자 11/03 11:25 팀원 슈퍼관리자 작성문서 영업팀 문서번호 영업팀슈퍼관리자 11/03 11:25 팀원 슈퍼관리자 작성문서 영업팀 문서번호 영업팀슈퍼관리자 11/03 11:25 팀원 슈퍼관리자 작성문서 영업팀 문서번호 영업팀
                                </dd>
                                <dd class="filein"><a href="#">첨부파일 : 계약서 양식.xls <img src="images/ico_xls.gif" alt=""></a></dd>
                              </dl>
                            </li>
														<li class="dic_100 dic_aside">
															<a href="#" class="dic_img" style="background:url('images/sample.jpg') no-repeat center, url('images/noimg.gif') no-repeat center; background-size:80px auto, auto;"></a>
                              <dl>
                                <dt class="title_area">
                                  <a href="#">프로젝트 수행 절차 - 소스반출 프로세스</a>
																		<div class="title_info">
		                                  <p class="title_area_name"><span>슈퍼관리자</span><span>시스템관리자</span></p>
																			<span class="title_accuracy">[ 정확도 : 0.03 ]</span>
																		</div>
                                </dt>
																<dd class="txt_inline">[등록일: 2022-02-12] [폴더명: 자유게시판]</dd>
                                <dd class="explain">
                                  ...각 프로젝트 담당 PL ② 방법 : 전자결재 "자료반출 신청서" 작성결재시 내용 : 결재선 -> 결재: 담당PM(합의), 팀장, 본부장 <strong class="hl">기안</strong>지 결재<strong class="hl">기안</strong>슈퍼관리자 11/03 11:25 팀원 슈퍼관리자 작성문서 영업팀 문서번호 영업팀슈퍼관리자 11/03 11:25 팀원 슈퍼관리자 작성문서 영업팀 문서번호 영업팀슈퍼관리자 11/03 11:25 팀원 슈퍼관리자 작성문서 영업팀 문서번호 영업팀슈퍼관리자 11/03 11:25 팀원 슈퍼관리자 작성문서 영업팀 문서번호 영업팀
                                </dd>
                                <dd class="filein"><a href="#">첨부파일 : 계약서 양식.xls <img src="images/ico_xls.gif" alt=""></a></dd>
                              </dl>
                            </li>
                          </ul>
                          <div class="section_more">
                            <a class="go_more" href="#">검색 결과 더보기 </a>
                          </div>
                        </div>
                        <!--  
                        <div class="section_search_right">
                          <div class="search_text_box">
                            <p class="search_text_title">내가 찾은 검색어</p>
                            <ul class="search_text_list">
                              <li>
                                <a href="#">
                                  <img src="images/list01.gif" />정보 </a>
                              </li>
                              <li>
                                <a href="#">
                                  <img src="images/list02.gif" />IT정보관리 </a>
                              </li>
                              <li>
                                <a href="#">
                                  <img src="images/list03.gif" />문서관리 시스템 </a>
                              </li>
                              <li>
                                <a href="#">
                                  <img src="images/list04.gif" />정보관리 </a>
                              </li>
                              <li>
                                <a href="#">
                                  <img src="images/list05.gif" />경비결재 시스템 </a>
                              </li>
                            </ul>
                          </div>
                        </div>
                        --> 
                      </div>`
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
