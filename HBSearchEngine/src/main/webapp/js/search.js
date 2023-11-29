// 팝업 호출
function openLink( url, width, height ) {
	window.open(url,'_blank','location=no, toolbar=no, menubar=no, status=no, scrollbars=no, resizable=yes, width=' + width + ', height=' + height);
}

// 인기검색어, 내가찾은 검색어
function doKeyword(query) {
	var searchForm = document.search;
	searchForm.startCount.value = "0";
	searchForm.query.value = query;
	searchForm.collection.value = "ALL";
	searchForm.sort.value = "RANK";
	searchForm.query.value = query;
	doSearch();
}

// 쿠키값 조회
function getCookie(c_name) {
	var i, x, y, cookies = document.cookie.split(";");
	for (i = 0; i < cookies.length; i++) {
		x = cookies[i].substr(0, cookies[i].indexOf("="));
		y = cookies[i].substr(cookies[i].indexOf("=") + 1);
		x = x.replace(/^\s+|\s+$/g, "");

		if (x == c_name) {
			return unescape(y);
		}
	}
}

// 쿠키값 설정
function setCookie(c_name, value, exdays) {
	var exdate = new Date();
	exdate.setDate(exdate.getDate() + exdays);
	var c_value = escape(value) + ((exdays == null) ? "" : "; expires=" + exdate.toUTCString());
	document.cookie = c_name + "=" + c_value;
}

// 내가 찾은 검색어 조회
function getMyKeyword(keyword, totCount) {
	var MYKEYWORD_COUNT = 6; //내가 찾은 검색어 갯수 + 1
	var myKeyword = getCookie("mykeyword");
	if (myKeyword == null) {
		myKeyword = "";
	}

	var myKeywords = myKeyword.split("^%");

	if (totCount > 0 && keyword.trim().length > 0) {
		var existsKeyword = false;
		
		//저장될 현 검색어의 특수문자 재치환
		keyword = replaceAll(keyword,'&amp;quot;','"');
		keyword = replaceAll(keyword,'&#40;','(');
		keyword = replaceAll(keyword,'&#41;',')');
		keyword = replaceAll(keyword,'&#35;','#');
		keyword = replaceAll(keyword,'﻿&amp;amp;','&');
		
		for (var i = 0; i < myKeywords.length; i++) {
			if (myKeywords[i] == keyword) {
				existsKeyword = true;
				break;
			}
		}

		if (!existsKeyword) {
			myKeywords.push(keyword);
			if (myKeywords.length == MYKEYWORD_COUNT) {
				myKeywords = myKeywords.slice(1, MYKEYWORD_COUNT);
			}
		}
		
		var exdays = 365;
		var c_name = "mykeyword";
		var value = myKeywords.join("^%");
		
		var exdate=new Date();
		exdate.setDate(exdate.getDate() + exdays);
		var c_value=escape(value) + ((exdays==null) ? "" : "; expires="+exdate.toUTCString());
		document.cookie=c_name + "=" + c_value;
		//setCookie("mykeyword", myKeywords.join("^%"), 365);
	}

	showMyKeyword(myKeywords.reverse());
}


// 내가 찾은 검색어 삭제
function removeMyKeyword(keyword) {
	var myKeyword = getCookie("mykeyword");
	if (myKeyword == null) {
		myKeyword = "";
	}

	var myKeywords = myKeyword.split("^%");

	var i = 0;
	while (i < myKeywords.length) {
		if (myKeywords[i] == keyword) {
			myKeywords.splice(i, 1);
		} else {
			i++;
		}
	}

	setCookie("mykeyword", myKeywords.join("^%"), 365);

	showMyKeyword(myKeywords);
}

// 내가 찾은 검색어 
function showMyKeyword(myKeywords) {
	var str = "<p class='search_text_title'>내가 찾은 검색어</p>";
	str += "<ul class='search_text_list'>";
	for( var i = 0; i < myKeywords.length; i++) {
		if( myKeywords[i] == "") continue;
		str += "<li><a href='#none' onClick=\"javascript:doKeyword('"+myKeywords[i]+"');\"><img src='images/list0" + (i+1) +".gif'/>"+myKeywords[i]+"</a></li>";
	}
	str += '</ul>';
	$("#mykeyword").html(str);
}

// 관심 키워드 조회
function getSavedKeyword() {
	/*var SAVED_COUNT = 6; //검색어 갯수 + 1*/
	var savedKeyword = getCookie("savedkeyword");
	if (savedKeyword == null) {
		savedKeyword = "";
	}

	var savedKeywords = savedKeyword.split("^%");
	showSavedKeyword(savedKeywords);
}


// 관심 키워드 삭제
function removeSavedKeyword(keyword) {
	var savedKeyword = getCookie("savedkeyword");
	if (savedKeyword == null) {
		savedKeyword = "";
	}

	var savedKeywords = savedKeyword.split("^%");

	var i = 0;
	while (i < savedKeywords.length) {
		if (savedKeywords[i] == keyword) {
			savedKeywords.splice(i, 1);
		} else {
			i++;
		}
	}
	
	setCookie("savedkeyword", savedKeywords.join("^%"), 365);

	showSavedKeyword(savedKeywords);
}

// 관심 키워드
function showSavedKeyword(savedKeywords) {
	var searchForm = document.search;
	var str = "";
	var str2 = "";
	
	for (var i = 0; i < savedKeywords.length; i++) {
		if (savedKeywords[i] == "") continue;

		str += "<li class=\"searchkey\"><a href=\"#none\" onClick=\"javascript:doKeyword('" + savedKeywords[i] + "');\">" + savedKeywords[i] + "</a> <a href=\"#\" class=\"btn_del\"><img src=\"images/ico_del.gif\" onClick=\"removeSavedKeyword('" + savedKeywords[i] + "');\" alt=\"\" /></a></li>";
		str2 += "<li><input type=\"text\" class=\"kw_add_input\" name=\"savefields\" value=\"" + savedKeywords[i] + "\"></li>";
	}
	
	if (str==""){
		str += "<li class=\"searchkey\"><font color=\"#7d7d7d\">저장된 키워드가 없습니다.</font></li>";
	}
	str2 += "<li><input type=\"text\" class=\"kw_add_input\" name=\"savefields\"></li>"
	
	$("#savedkeyword").html(str);
	$("#savekeyword").html(str2);
}

function addSavedKeyword(){
	var savedKeywords = [];
	
	$("input[name='savefields']").each(function(){
		var temp = $(this).val();
		if (temp!="" || temp != null) {
			savedKeywords.push(temp);
		}
	});
	
	setCookie("savedkeyword", savedKeywords.join("^%"), 365);
	showSavedKeyword(savedKeywords);
}

// 상세검색 체크박스 변경 이벤트
function registerSearchDetailCheckBox(){
	if($("#checkAll").is(":checked")){
		$("input:checkbox[name='searchFields']").attr("checked", true);
	}
	
	$("#checkAll").click(function(){
		if($(this).is(":checked")){
			//$("input:checkbox[name=searchFields]").prop("checked", true);
			$("input:checkbox[name=searchFields]").attr("checked", true);
        }else{
			//$("input:checkbox[name=searchFields]").prop("checked", false);
        	$("input:checkbox[name=searchFields]").attr("checked", false);
        }
	});
	
	$("#checkAll").change(function(){
		if($(this).is(":checked")){ 
			//$("input:checkbox[name=searchFields]").prop("checked", true);
			$("input:checkbox[name='searchFields']").attr("checked", true);
		}else{ 
			//$("input:checkbox[name=searchFields]").prop("checked", false);
			$("input:checkbox[name='searchFields']").attr("checked", false);
		}
	});  
	
	$("input:checkbox[name='searchFields']").change(function(){
		if($("input:checkbox[name='searchFields']:checked").length == 3){
			//$("#checkAll").prop("checked", true);
			$("#checkAll").attr("checked", true);
		}else{
			//$("#checkAll").prop("checked", false);
			$("#checkAll").attr("checked", false);
		}
	});  

}

// 문서종류 체크박스 변경 이벤트
function docPickCheckBox(){
	if($("#check1").is(":checked")){
		for (i = 2; i < 18; i++) {
			$("#check" + i).attr("checked", false);
		}
	}
	
	$("#check1").change(function(){
		var searchForm = document.search;
		if($(this).is(":checked")){
			for (i = 2; i < 18; i++) {
				$("#check" + i).attr("checked", false);
			}
			searchForm.reQuery.value = "2";
			searchForm.docType.value = "1";
			searchForm.submit();
        }
	});
	
	$("input:checkbox[name='input_check']").change(function(){
		var searchForm = document.search;
		if($("input:checkbox[name='input_check']:checked").length == 16){
			$("#check1").attr("checked", true);
			for (i = 2; i < 18; i++) {
				$("#check" + i).attr("checked", false);
			}
			searchForm.reQuery.value = "2";
			searchForm.docType.value = "1";
			searchForm.submit();
		}else{
			$("#check1").attr("checked", false);
			var gSize = new Array();
			$("input[name=input_check]:checked").each(function() {
				if(gSize == ""){
					gSize.push($(this).val());
				} else {
					gSize.push($(this).val());
				}
			});
			searchForm.reQuery.value = "2";
			searchForm.docType.value = gSize;
			searchForm.submit();
		}
	});  
	
}

// 오타 조회
function getSpell(query) {
	$.ajax({
		type: "POST",
		url: "./popword/popword.jsp?target=spell&charset=",
		dataType: "xml",
		data: { "query": query },
		success: function(xml) {
			if (parseInt($(xml).find("Return").text()) > 0) {
				var str = "<div class=\"resultall\">";

				$(xml).find("Data").each(function() {
					if ($(xml).find("Word").text() != "0" && $(xml).find("Word").text() != query) {
						str += "<span>이것을 찾으셨나요? </span><a href=\"#none\" onClick=\"javascript:doKeyword('" + $(xml).find("Word").text() + "');\">" + $(xml).find("Word").text() + "</a>";
					}
				});

				str += "</div>";

				$("#spell").html(str);
			}
		}
	});

	return true;
}

// calendar 설정
var dateNames = ['년', '월'];
var dayNames = ['일', '월', '화','수', '목', '금','토'];
var calutil = {
	fncSearch: function(obj) {
		alert("검색");
	}
}
calutil.compareDate = function(inputName, val, isKeyIn) {
	var inputId = inputName;
	if ($(inputId).length < 1) {
		inputId = '#' + inputName;
	}

	var input = $(inputId);

	if (!input.is('[from]') && !input.is('[to]')) {
		return;
	}

	var fromId = input.attr('from');
	if ($(fromId).length < 1) {
		fromId = "#" + fromId;
	}

	var toId = input.attr('to');
	if ($(toId).length < 1) {
		toId = "#" + toId;
	}

	var from = $(fromId);
	var to = $(toId);

	if (from.val() === '' || to.val() === '') {
		return;
	}

	if (!dateDiv.checkDatePeriod(from.val(), to.val())) {
		if (inputId == fromId) {
			alert('종료일 보다 큽니다.');
		} else {
			alert('시작일 보다 작습니다.');
		}
		input.val('');
		if (isKeyIn) {
			input.select();
			return;
		} else {
			dateDiv.calenda(inputName, calutil.compareDate);
			return;
		}
	}
};

// 기간 설정
function setDate(range) {
	var startDate = "";
	var endDate = "";

	var currentDate = new Date()
	var year = currentDate.getFullYear();
	var month = currentDate.getMonth() + 1;
	var day = currentDate.getDate();

	if (parseInt(month) < 10) {
		month = "0" + month;
	}

	if (parseInt(day) < 10) {
		day = "0" + day;
	}

	var toDate = year + "-" + month + "-" + day;

	// 기간 버튼 초기화
	for (i = 1; i < 7; i++) {
		$("#ran" + i).attr("class", "");
	}

	// 기간 버튼 이미지 선택
	if (range == "D") {
		startDate = getAddDay(currentDate, -0);
	} else if (range == "W") {
		startDate = getAddDay(currentDate, -6);
	} else if (range == "M") {
		startDate = getAddDay(currentDate, -29);
	} else if (range == "6M") {
		startDate = getAddDay(currentDate, -181);
	} else if (range == "12M") {
		startDate = getAddDay(currentDate, -364);
	} else {
		startDate = "2000-01-01";
		endDate = toDate;
	}

	if (range != "A" && startDate != "") {
		year = startDate.getFullYear();
		month = startDate.getMonth() + 1;
		day = startDate.getDate();

		if (parseInt(month) < 10) {
			month = "0" + month;
		}

		if (parseInt(day) < 10) {
			day = "0" + day;
		}

		startDate = year + "-" + month + "-" + day;
		endDate = toDate;
	}

	$("#range").val(range);
	$("#startDate").val(startDate);
	$("#endDate").val(endDate);
	
	//changeDatepickerValue('disable')
}

function changeDatepickerValue(value) {
	$("#startDate").datepicker(value)
	$("#endDate").datepicker(value)
}

function datePick() {
	// 기간 버튼 초기화
	for (i = 1; i < 6; i++) {
		$("#ran" + i).attr("class", "");
	}

	$("#ran6").attr("class", "selected");

	$("#range").val('H');
}

// 날짜 계산
function getAddDay(targetDate, dayPrefix) {
	var newDate = new Date();
	var processTime = targetDate.getTime() + (parseInt(dayPrefix) * 24 * 60 * 60 * 1000);
	newDate.setTime(processTime);
	return newDate;
}

// 전자결재 완료-이관 상태 전환
function apprTypeChange() {
	var searchForm = document.search;
	var coll = searchForm.collection.value;
	
	$("input:radio[name='search_radio02']").change(function(){
		if($("#apprType_appr").is(":checked")){
			//$("#apprType_mig").attr("checked", false);
			searchForm.apprType.value = "appr";
			coll = replaceAll(coll,"apprMig","appr");
			searchForm.collection.value = coll;
			searchForm.submit();
		} else if ($("#apprType_mig").is(":checked")) {
			//$("#apprType_appr").attr("checked", false);
			searchForm.apprType.value = "mig";
			coll = replaceAll(coll,"appr","apprMig");
			searchForm.collection.value = coll;
			searchForm.submit();
		}
	});  
}
// 카테고리검색
function doCategoryQueryW(categoryQueryW) {
	var searchForm = document.search;
	searchForm.categoryQueryW.value = categoryQueryW;
	searchForm.reQuery.value = "2";
	searchForm.submit();
	
	
}

// 카테고리검색
function doCategoryQueryD(categoryQueryD) {
	var searchForm = document.search;
	searchForm.categoryQueryD.value = categoryQueryD;
	searchForm.reQuery.value = "2";
	searchForm.submit();
}

// 컬렉션검색
function doCollectionQueryW(collectionQueryW) {
	var searchForm = document.search;
	searchForm.collectionQueryW.value = collectionQueryW;
	searchForm.reQuery.value = "2";
	searchForm.submit();
}

// 컬렉션검색
function doCollectionQueryD(collectionQueryD) {
	var searchForm = document.search;
	searchForm.collectionQueryD.value = collectionQueryD;
	searchForm.reQuery.value = "2";
	searchForm.submit();
}

// 정렬
function doSorting(sort) {
	var searchForm = document.search;
	searchForm.sort.value = sort;
	searchForm.reQuery.value = "2";
	searchForm.submit();
}

// 문서종류 검색
function filterFile() {
	var searchForm = document.search;
	
	// 첨부파일 검색용
	var gSize = new Array();
	var checked = $('#check1').is(':checked');
	if (checked) {
		gSize == ["1"];
	} else {
		$("input[name=input_check]:checked").each(function() {
			
			if(gSize == ""){
				gSize.push($(this).val());
			} else {
				gSize.push($(this).val());
			}
		});
	}
	
	
	searchForm.reQuery.value = "2";
	searchForm.docType.value = gSize;
	searchForm.submit();
}

// 검색
function doSearch() {
		var searchForm = document.search; 

	if (searchForm.query.value == "") {
		alert("검색어를 입력하세요.");
		searchForm.query.focus();
		return;
	}
	
	searchForm.collection.value = "ALL";
	//searchForm.startDate.value = "";
	//searchForm.endDate.value = "";
	searchForm.startCount.value = 0;
	searchForm.categoryQueryW.value = "";
	searchForm.categoryQueryD.value = "";
	searchForm.collectionQueryW.value = "";
	searchForm.collectionQueryD.value = "";
	
	if(document.getElementById("reChk").checked == false || searchForm.reQuery.value == "2"){ //재검색 아닌경우 apprType 초기화
		searchForm.apprType.value = "appr";	
	}
	
	var str = "";
	$("input:checkbox[name='searchFields']").each(function(index){
		if($(this).is(":checked")){
			if(index == 0) str = $(this).val();
			else str = str + "," + $(this).val()
        }
		
		if($("#checkAll").is(":checked")){
			str = "ALL";
		}
	});  
	
	/*상세검색 작성자, 부서명 필터쿼리 적용 확인*/
	var filterArray = new Array();
	var filter = "";
	$("input[name='filter_input']").each(function(){
		var str = $(this).val().trim();
		var id = $(this).attr("id");
		if(str.trim().length > 0){
			switch (id) {
				case "filter_dep" : 
					filterArray.push("<CREATOR_DEPT:substring:"+str+">");					
					break;
				case "filter_writer" : 
					filterArray.push("<CREATOR_NAME:substring:"+str+">");					
					break;
				/* TODO : ccinfo 필터쿼리로 진행시 확인 */
				/*case "filter_ccinfo" : 
					if (LanguageCode == "ko"){
						filterArray.push("<APPR_CCINFO_KO:substring:"+str+">");
					} else if (LanguageCode == "en"){
						filterArray.push("<APPR_CCINFO_EN:substring:"+str+">");
					}
					break;*/
			}
			filter = replaceAll(filterArray.toString(),","," ");
		}
	});
	
	
	var prefixArray = new Array();
	var prefix = "";
	$("input[name='prefix_input']").each(function(){
		var str = $(this).val().trim();
		var id = $(this).attr("id");
		
		if(str.trim().length > 0){
			switch (id) {
				case "prefix_dep" : 
					prefixArray.push("<PREFIX_CREATOR_DEPT:contains:" + str + ">");
					break;
				case "prefix_writer" : 
					prefixArray.push("<PREFIX_CREATOR_NAME:contains:" + str + ">");
					break;
				case "prefix_etc" : 
					prefixArray.push("<PREFIX_APPR_CCINFO:contains:" + str + ">");
					break;
			}
			//prefix = prefixArray.toString().replaceAll(","," ");
			prefix = replaceAll(prefixArray.toString(),","," ");
		}
		
	});
		
	searchForm.prefix.value = prefix;
	searchForm.searchField.value = str;
	searchForm.sort.value = "RANK";
	searchForm.submit();
}

// 검색
function doSearch_bak() {
	var searchForm = document.search;
	
	if (searchForm.query.value == "") {
		alert("검색어를 입력하세요.");
		searchForm.query.focus();
		return;
	}
	
	if ($("#startDate").val() != "" || $("#endDate").val() != "") {
		var currentDate = new Date();
		var startDate = $("#startDate").val();
		var endDate = $("#endDate").val();
		
		if (startDate == "") {
			alert("시작일을 입력하세요.");			
			$("#startDate").focus();
			return;
		}

		if (endDate == "") {
			alert("종료일을 입력하세요.");
			$("#endDate").focus();
			return;
		}

		if (!compareStringNum(startDate, endDate, "-")) {
			alert("기간이 올바르지 않습니다. 시작일이 종료일보다 작거나 같도록 하세요.");
			$("#startDate").focus();
			return;
		}
		
		var checkDate = getAddDay(new Date(endDate), -366);
		console.log(endDate)
		console.log(checkDate)
		console.log(startDate)
		console.log(checkDate > new Date(startDate))

		if (checkDate > new Date(startDate)) {
			$("#startDate").focus();
			return;
		}
	}
	
	if(document.getElementById("reChk").checked == false || searchForm.reQuery.value == "2"){ //재검색 아닌경우 apprType 초기화
		searchForm.apprType.value = "appr";	
	
	// 검색영역 세팅
	var str = "";
	$("input:checkbox[name='searchFields']").each(function(index){
		if($(this).is(":checked")){
			if(index == 0) str = $(this).val();
			else str = str + "," + $(this).val()
        }
		
		if($("#checkAll").is(":checked")){
			str = "ALL";
		}
	});
	
	/*상세검색 작성자, 부서명 필터쿼리 적용 확인*/
	var filterArray = new Array();
	var filter = "";
	$("input[name='filter_input']").each(function(){
		var str = $(this).val().trim();
		var id = $(this).attr("id");
		if(str.trim().length > 0){
			switch (id) {
				case "filter_dep" : 
					filterArray.push("<CREATOR_DEPT:substring:"+str+">");					
					break;
				case "filter_writer" : 
					filterArray.push("<CREATOR_NAME:substring:"+str+">");					
					break;
				/* TODO : ccinfo 필터쿼리로 진행시 확인 */
				/*case "filter_ccinfo" : 
					if (LanguageCode == "ko"){
						filterArray.push("<APPR_CCINFO_KO:substring:"+str+">");
					} else if (LanguageCode == "en"){
						filterArray.push("<APPR_CCINFO_EN:substring:"+str+">");
					}
					break;*/
			}
			filter = replaceAll(filterArray.toString(),","," ");
		}
	});
	
	/*프리픽스 쿼리 적용되는 곳 있을 경우 확인, 활성화*/
	/*TODO : 상세검색 프리픽스 쿼리로 진행시 확인, search.jsp의 prefix처리부분도 확인해줘야 함*/
	var prefixArray = new Array();
	var prefix = "";
	$("input[name='prefix_input']").each(function(){
		var str = $(this).val().trim();
		var id = $(this).attr("id");
		
		if(str.trim().length > 0){
			switch (id) {
				/*case "prefix_dep" : 
					if (LanguageCode == "ko"){
						prefixArray.push("<CREATOR_DEPT_KO:contains:"+str+">");
					} else if (LanguageCode == "en"){
						prefixArray.push("<CREATOR_DEPT_EN:contains:"+str+">");
					}
					break;
				case "prefix_writer" : 
					if (LanguageCode == "ko"){
						prefixArray.push("<CREATOR_NAME_KO:contains:"+str+">");
					} else if (LanguageCode == "en"){
						prefixArray.push("<CREATOR_NAME_EN:contains:"+str+">");
					}
					break;*/
				case "prefix_ccinfo" : 
					prefixArray.push("<PREFIX_APPR_CCINFO:contains:"+str+">");					
					break;
			}
			prefix = replaceAll(prefixArray.toString(),","," ");
		}
	});
	
	// 첨부파일 검색용
	var gSize = new Array();
	$("input[name=input_check]:checked").each(function() {
		var checked = $('#check1').is(':checked');
		
		if(gSize == ""){
			gSize.push($(this).val());
		} else {
			gSize.push($(this).val());
		}
	});
	
	if(searchForm.query.value.length < 2){
		return;
	}
	
	/* 타임존 코드에 따라 선택 시간과 실제 검색조건이 될 시간을 다르게 처리함 
	  기존 타임존 표출용 코드를 reverse로 적용
	var startDate = $('#startDate').val();
	var endDate = $('#endDate').val();
	var timeformat = "yyyy-MM-dd";	
	startDate = timezoneReverse(startDate, TimeZoneCode, timeformat);
	endDate = timezoneReverse(endDate, TimeZoneCode, timeformat);*/
	
	/*필터쿼리 적용 확인*/
	searchForm.filter.value = filter;
	/*프리픽스쿼리 적용 확인*/
	searchForm.prefix.value = prefix;
	searchForm.collection.value = $('#collection').val(); // or "ALL"
	searchForm.startDate.value = startDate;
	searchForm.endDate.value = endDate;
	searchForm.range.value = $('#range').val();
	searchForm.startCount.value = 0;
	searchForm.searchField.value = str;
	searchForm.sort.value = "DATE";
	searchForm.docType.value = gSize;
	searchForm.submit();
	console.log(12)
}

// 컬렉션별 검색
function doCollection(coll) {
	var searchForm = document.search;
	searchForm.apprType.value = "appr";
	searchForm.collection.value = coll;
	searchForm.reQuery.value = "2";
	searchForm.categoryQueryW.value = "";
	searchForm.categoryQueryD.value = "";
	searchForm.submit();
}

// 엔터 체크
/*	
function pressCheck() {
	if (event.keyCode == 13) {
		return doSearch();
	} else {
		return false;
	}
}
*/

var temp_query = "";

// 결과내 재검색
function checkReSearch() {
	var searchForm = document.search;
	var query = searchForm.query;
	var reQuery = searchForm.reQuery;

	if (document.getElementById("reChk").checked == true) {
		temp_query = query.value;
		reQuery.value = "1";
		query.value = "";
		query.focus();
	} else {
		query.value = trim(temp_query);
		reQuery.value = "";
		temp_query = "";
	}
}

// 페이징
function doPaging(count) {
	var searchForm = document.search;
	searchForm.startCount.value = count;
	searchForm.reQuery.value = "2";
	searchForm.submit();
}

// 페이징
function goPaging() {
	var searchForm = document.search;
	var inputPageNo = searchForm.input_gopage.value;
	searchForm.startCount.value = (inputPageNo-1) * 10;
	searchForm.reQuery.value = "2";
	searchForm.submit();
}

// 기간 적용
function doRange() {
	var searchForm = document.search;

	if ($("#startDate").val() != "" || $("#endDate").val() != "") {
		if ($("#startDate").val() == "") {
			alert("시작일을 입력하세요.");
			$("#startDate").focus();
			return;
		}

		if ($("#endDate").val() == "") {
			alert("종료일을 입력하세요.");
			$("#endDate").focus();
			return;
		}

		if (!compareStringNum($("#startDate").val(), $("#endDate").val(), ".")) {
			alert("기간이 올바르지 않습니다. 시작일이 종료일보다 작거나 같도록 하세요.");
			$("#startDate").focus();
			return;
		}
	}

	searchForm.startDate.value = $("#startDate").val();
	searchForm.endDate.value = $("#endDate").val();
	searchForm.range.value = $("#range").val();
	searchForm.reQuery.value = "2";
	searchForm.submit();
}

// 영역
function doSearchField(field) {
	var searchForm = document.search;
	searchForm.searchField.value = field;
	searchForm.reQuery.value = "2";
	searchForm.submit();
}

// 문자열 숫자 비교
function compareStringNum(str1, str2, repStr) {
	var num1 = parseInt(replaceAll(str1, repStr, ""));
	var num2 = parseInt(replaceAll(str2, repStr, ""));

	if (num1 > num2) {
		return false;
	} else {
		return true;
	}
}

// Replace All
function replaceAll(str, orgStr, repStr) {
	return str.split(orgStr).join(repStr);
}

// 공백 제거
function trim(str) {
	return str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
}

// 문서종류 선택 ( 전체 체크박스 )
function docPickAll() {
	for (i = 2; i < 18; i++) {
		$("#check" + i).attr("checked", false);
	}
}

// 문서종류 선택
function docPick() {
	$("#check1").attr("checked", false);
}

// 검색어 초기화
function doCollectionClear(coll) {
	var searchForm = document.search;
	
	var currentDate = new Date();
	var year = currentDate.getFullYear();
	var month = currentDate.getMonth() + 1;
	var day = currentDate.getDate();

	if (parseInt(month) < 10) {
		month = "0" + month;
	}

	if (parseInt(day) < 10) {
		day = "0" + day;
	}

	var toDate = year + "-" + month + "-" + day;
	
	searchForm.collection.value = coll;
	searchForm.reQuery.value = "2";
	searchForm.startDate.value = searchForm.startDate.value;
	searchForm.endDate.value = toDate;
	searchForm.range.value = "A";
	searchForm.docType.value = "1";
	searchForm.query.value = "";
	searchForm.realQuery.value = "";
	searchForm.filter.value = "";
	searchForm.prefix.value = "";
	searchForm.searchField.value = "ALL";
	//doSearch();
	
	searchForm.submit();
	
}

function hideSection(coll) {
	var target = '#result_' + coll;
	var target2 = '#moreresult_' + coll;
	if ($(target).is(":visible")) {
		$(target).hide();
		$(target2).hide();
	} else {
	  	$(target).show();
	  	$(target2).show();
	}
	
}




/*
//영원무역: 타임존 적용 js -> search.jsp 하단에 java로 재작성함

/* timezonecode 적용 거꾸로 하는 함수 (기간검색 시 적용하는 용도) */
/*
var timezonelist = {
	"TIMEZO0001": "09:00:00","TIMEZO0002": "09:00:00","TIMEZO0003": "09:00:00","TIMEZO0004": "09:00:00","TIMEZO0005": "08:00:00",
	"TIMEZO0006": "08:00:00","TIMEZO0007": "08:00:00","TIMEZO0008": "08:00:00","TIMEZO0009": "08:00:00","TIMEZO0010": "07:00:00",
	"TIMEZO0011": "07:00:00","TIMEZO0012": "07:00:00","TIMEZO0013": "07:00:00","TIMEZO0014": "07:00:00","TIMEZO0015": "07:00:00",
	"TIMEZO0016": "07:00:00","TIMEZO0017": "07:00:00","TIMEZO0018": "07:00:00","TIMEZO0019": "06:00:00","TIMEZO0020": "06:00:00",
	"TIMEZO0021": "06:00:00","TIMEZO0022": "06:00:00","TIMEZO0023": "05:30:00","TIMEZO0024": "05:00:00","TIMEZO0025": "05:00:00",
	"TIMEZO0026": "05:00:00","TIMEZO0027": "05:00:00","TIMEZO0028": "05:00:00","TIMEZO0029": "04:30:00","TIMEZO0030": "04:00:00",
	"TIMEZO0031": "04:00:00","TIMEZO0032": "04:00:00","TIMEZO0033": "03:30:00","TIMEZO0034": "03:30:00","TIMEZO0035": "03:15:00",
	"TIMEZO0036": "03:00:00","TIMEZO0037": "03:00:00","TIMEZO0038": "03:00:00","TIMEZO0039": "02:30:00","TIMEZO0040": "02:00:00",
	"TIMEZO0041": "02:00:00","TIMEZO0042": "01:00:00","TIMEZO0043": "01:00:00","TIMEZO0044": "01:00:00","TIMEZO0045": "01:00:00",
	"TIMEZO0046": "01:00:00","TIMEZO0047": "01:00:00","TIMEZO0048": "00:00:00","TIMEZO0049": "00:00:00","TIMEZO0050": "00:00:00",
	"TIMEZO0051": "-00:30:00","TIMEZO0052": "-00:30:00","TIMEZO0053": "-01:00:00","TIMEZO0054": "-01:00:00","TIMEZO0055": "-01:00:00",
	"TIMEZO0056": "-01:00:00","TIMEZO0057": "-01:00:00","TIMEZO0058": "-02:00:00","TIMEZO0059": "-03:00:00","TIMEZO0060": "-03:00:00",
	"TIMEZO0061": "-03:00:00","TIMEZO0062": "-03:00:00","TIMEZO0063": "-04:00:00","TIMEZO0064": "10:00:00","TIMEZO0065": "10:00:00",
	"TIMEZO0066": "11:00:00","TIMEZO0067": "11:00:00","TIMEZO0068": "12:00:00","TIMEZO0069": "12:00:00","TIMEZO0070": "12:00:00",
	"TIMEZO0071": "12:00:00","TIMEZO0072": "12:00:00","TIMEZO0073": "12:30:00","TIMEZO0074": "13:00:00","TIMEZO0075": "13:00:00",
	"TIMEZO0076": "13:00:00","TIMEZO0077": "13:00:00","TIMEZO0078": "13:00:00","TIMEZO0079": "13:30:00","TIMEZO0080": "14:00:00",
	"TIMEZO0081": "14:00:00","TIMEZO0082": "14:00:00","TIMEZO0083": "15:00:00","TIMEZO0084": "15:00:00","TIMEZO0085": "15:00:00",
	"TIMEZO0086": "15:00:00","TIMEZO0087": "16:00:00","TIMEZO0088": "16:00:00","TIMEZO0089": "16:00:00","TIMEZO0090": "17:00:00",
	"TIMEZO0091": "17:00:00","TIMEZO0092": "18:00:00","TIMEZO0093": "19:00:00","TIMEZO0094": "20:00:00","TIMEZO0095": "20:00:00",
	"TIMEZO0096": "21:00:00"
}
	
function timezoneReverse(pServerTime, pTimeZoneCode, pLocalFormat) {
	var l_InputYear, l_InputMonth, l_InputDay, l_InputHH, l_InputMM, l_InputSS;
	var l_TimeZone, l_ZoneHH, l_ZoneMM, l_ZoneSS, l_Minus, l_UR_TimeZone;
	var l_StringDate, l_StringTime, l_DateFormat = "", l_DateFormatCount;
	var l_ReturnString = "";

	if (pServerTime =="" ||pServerTime ==null || pServerTime == undefined) return "";

	l_DateFormatCount = pServerTime.length;
	
	if (pServerTime.indexOf(" ") == -1) {
	    if (pServerTime.length == 10) {
	        pServerTime += " 00:00:00";
	    } else if (pServerTime.length === 8 && pServerTime.indexOf('-')===-1) {
			pServerTime = pServerTime.substring(0,4)+"-"+pServerTime.substring(4,6)+"-"+pServerTime.substring(6) + " 00:00:00";
		} else {
	        return pServerTime;
	    }
	} 
	
	l_StringDate = pServerTime.split(' ')[0]
	l_StringTime = pServerTime.split(' ')[1]
	
	if (l_StringDate.indexOf(".") > -1) { l_DateFormat = "."; }
	if (l_StringDate.indexOf("-") > -1) { l_DateFormat = "-"; }
	if (l_StringDate.indexOf("/") > -1) { l_DateFormat = "/"; }
	
	if (l_DateFormat == "") {
	    return pServerTime;
	}
	l_StringDate = l_StringDate.replace(/-/g, "")
	l_StringDate = l_StringDate.replace(/\./g, "")
	l_StringDate = l_StringDate.replace(/\//g, "")
	l_StringTime = l_StringTime.replace(/:/g, "")
	
	if (l_StringDate.length != 8 || l_StringTime.length < 4) {
	    return pServerTime;
	}
	
	l_StringTime = CFN_PadRight(l_StringTime, 6, "0");
	
	l_InputYear = l_StringDate.substring(0, 4);
	l_InputMonth = l_StringDate.substring(4, 6) - 1;
	l_InputDay = l_StringDate.substring(6, 8);
	l_InputHH = l_StringTime.substring(0, 2);
	l_InputMM = l_StringTime.substring(2, 4);
	l_InputSS = l_StringTime.substring(4, 6);
	
	var l_InputDate = new Date(l_InputYear, l_InputMonth, l_InputDay, l_InputHH, l_InputMM, l_InputSS);
	if (l_InputDate.getFullYear() != l_InputYear || l_InputDate.getMonth() != l_InputMonth || l_InputDate.getDate() != l_InputDay ||
	    l_InputDate.getHours() != l_InputHH || l_InputDate.getMinutes() != l_InputMM || l_InputDate.getSeconds() != l_InputSS) {
	    return pServerTime;
	}
	
	
	l_UR_TimeZone = timezonelist[pTimeZoneCode];
	
	l_Minus = l_UR_TimeZone.substring(0, 1);
	l_TimeZone = l_UR_TimeZone.replace("-", "").replace(":", "").replace(":", "");
	l_ZoneHH = l_TimeZone.substring(0, 2);
	l_ZoneMM = l_TimeZone.substring(2, 4);
	l_ZoneSS = l_TimeZone.substring(4, 6);

	var l_TimeZoneTime = (parseInt(l_ZoneHH, 10) * 3600000) + (parseInt(l_ZoneMM, 10) * 60000) + (parseInt(l_ZoneSS, 10) * 1000)

	if (l_Minus == "-") {
	    l_InputDate.setTime(l_InputDate.getTime() - l_TimeZoneTime);
	} else {
	    l_InputDate.setTime(l_InputDate.getTime() + l_TimeZoneTime);
	}
	
	if (pLocalFormat == undefined || pLocalFormat == "") {
	    pLocalFormat = "yyyy-MM-dd HH:mm:ss";
	    l_ReturnString = pLocalFormat
	    .replace("yyyy", CFN_PadLeft(l_InputDate.getFullYear(), 4, "0"))
	    .replace("MM", CFN_PadLeft(l_InputDate.getMonth() + 1, 2, "0"))
	    .replace("dd", CFN_PadLeft(l_InputDate.getDate(), 2, "0"))
	    .replace("HH", CFN_PadLeft(l_InputDate.getHours(), 2, "0"))
	    .replace("mm", CFN_PadLeft(l_InputDate.getMinutes(), 2, "0"))
	    .replace("ss", CFN_PadLeft(l_InputDate.getSeconds(), 2, "0"));
	    l_ReturnString = l_ReturnString.substr(0, l_DateFormatCount);
	}
	else
	{
	    l_ReturnString = pLocalFormat
	    .replace("yyyy", CFN_PadLeft(l_InputDate.getFullYear(), 4, "0"))
	    .replace("MM", CFN_PadLeft(l_InputDate.getMonth() + 1, 2, "0"))
	    .replace("dd", CFN_PadLeft(l_InputDate.getDate(), 2, "0"))
	    .replace("HH", CFN_PadLeft(l_InputDate.getHours(), 2, "0"))
	    .replace("mm", CFN_PadLeft(l_InputDate.getMinutes(), 2, "0"))
	    .replace("ss", CFN_PadLeft(l_InputDate.getSeconds(), 2, "0"));
	}
	return l_ReturnString;
}

function CFN_PadLeft(pString, pCount, pPadChar) {
	var l_PadString = '';
	pString = pString.toString();

	if (pString.length < pCount) {
		for (var i = 0; i < pCount - pString.length; i++) {
			l_PadString += pPadChar;
		}
	}
	return l_PadString + pString;
}


function CFN_PadRight(pString, pCount, pPadChar) {
	var l_PadString = '';
	pString = pString.toString();

	if (pString.length < pCount) {
		for (var i = 0; i < pCount - pString.length; i++) {
			l_PadString += pPadChar;
		}
	}
	return pString + l_PadString;
}

*/
//타임존 스크립트 함수 실행 (원본)
//예) item.RegistDate = 2023.04.18 15:19:17 (등록일)
//타임존 코드 파라미터 TIMEZO0048
//함수 사용 (item은 게시글 리스트의 반복문의 item)
//CFN_TransLocalTime(item.RegistDate, "TIMEZO0048");
/*
var timezonelist = {
	"TIMEZO0001": "-09:00:00",
	"TIMEZO0002": "-09:00:00",
	"TIMEZO0003": "-09:00:00",
	"TIMEZO0004": "-09:00:00",
	"TIMEZO0005": "-08:00:00",
	"TIMEZO0006": "-08:00:00",
	"TIMEZO0007": "-08:00:00",
	"TIMEZO0008": "-08:00:00",
	"TIMEZO0009": "-08:00:00",
	"TIMEZO0010": "-07:00:00",
	"TIMEZO0011": "-07:00:00",
	"TIMEZO0012": "-07:00:00",
	"TIMEZO0013": "-07:00:00",
	"TIMEZO0014": "-07:00:00",
	"TIMEZO0015": "-07:00:00",
	"TIMEZO0016": "-07:00:00",
	"TIMEZO0017": "-07:00:00",
	"TIMEZO0018": "-07:00:00",
	"TIMEZO0019": "-06:00:00",
	"TIMEZO0020": "-06:00:00",
	"TIMEZO0021": "-06:00:00",
	"TIMEZO0022": "-06:00:00",
	"TIMEZO0023": "-05:30:00",
	"TIMEZO0024": "-05:00:00",
	"TIMEZO0025": "-05:00:00",
	"TIMEZO0026": "-05:00:00",
	"TIMEZO0027": "-05:00:00",
	"TIMEZO0028": "-05:00:00",
	"TIMEZO0029": "-04:30:00",
	"TIMEZO0030": "-04:00:00",
	"TIMEZO0031": "-04:00:00",
	"TIMEZO0032": "-04:00:00",
	"TIMEZO0033": "-03:30:00",
	"TIMEZO0034": "-03:30:00",
	"TIMEZO0035": "-03:15:00",
	"TIMEZO0036": "-03:00:00",
	"TIMEZO0037": "-03:00:00",
	"TIMEZO0038": "-03:00:00",
	"TIMEZO0039": "-02:30:00",
	"TIMEZO0040": "-02:00:00",
	"TIMEZO0041": "-02:00:00",
	"TIMEZO0042": "-01:00:00",
	"TIMEZO0043": "-01:00:00",
	"TIMEZO0044": "-01:00:00",
	"TIMEZO0045": "-01:00:00",
	"TIMEZO0046": "-01:00:00",
	"TIMEZO0047": "-01:00:00",
	"TIMEZO0048": "00:00:00",
	"TIMEZO0049": "00:00:00",
	"TIMEZO0050": "00:00:00",
	"TIMEZO0051": "00:30:00",
	"TIMEZO0052": "00:30:00",
	"TIMEZO0053": "01:00:00",
	"TIMEZO0054": "01:00:00",
	"TIMEZO0055": "01:00:00",
	"TIMEZO0056": "01:00:00",
	"TIMEZO0057": "01:00:00",
	"TIMEZO0058": "02:00:00",
	"TIMEZO0059": "03:00:00",
	"TIMEZO0060": "03:00:00",
	"TIMEZO0061": "03:00:00",
	"TIMEZO0062": "03:00:00",
	"TIMEZO0063": "04:00:00",
	"TIMEZO0064": "-10:00:00",
	"TIMEZO0065": "-10:00:00",
	"TIMEZO0066": "-11:00:00",
	"TIMEZO0067": "-11:00:00",
	"TIMEZO0068": "-12:00:00",
	"TIMEZO0069": "-12:00:00",
	"TIMEZO0070": "-12:00:00",
	"TIMEZO0071": "-12:00:00",
	"TIMEZO0072": "-12:00:00",
	"TIMEZO0073": "-12:30:00",
	"TIMEZO0074": "-13:00:00",
	"TIMEZO0075": "-13:00:00",
	"TIMEZO0076": "-13:00:00",
	"TIMEZO0077": "-13:00:00",
	"TIMEZO0078": "-13:00:00",
	"TIMEZO0079": "-13:30:00",
	"TIMEZO0080": "-14:00:00",
	"TIMEZO0081": "-14:00:00",
	"TIMEZO0082": "-14:00:00",
	"TIMEZO0083": "-15:00:00",
	"TIMEZO0084": "-15:00:00",
	"TIMEZO0085": "-15:00:00",
	"TIMEZO0086": "-15:00:00",
	"TIMEZO0087": "-16:00:00",
	"TIMEZO0088": "-16:00:00",
	"TIMEZO0089": "-16:00:00",
	"TIMEZO0090": "-17:00:00",
	"TIMEZO0091": "-17:00:00",
	"TIMEZO0092": "-18:00:00",
	"TIMEZO0093": "-19:00:00",
	"TIMEZO0094": "-20:00:00",
	"TIMEZO0095": "-20:00:00",
	"TIMEZO0096": "-21:00:00"
}
	
function CFN_TransLocalTime(pServerTime, pTimeZoneCode, pLocalFormat) {
	var l_InputYear, l_InputMonth, l_InputDay, l_InputHH, l_InputMM, l_InputSS;
	var l_TimeZone, l_ZoneHH, l_ZoneMM, l_ZoneSS, l_Minus, l_UR_TimeZone;
	var l_StringDate, l_StringTime, l_DateFormat = "", l_DateFormatCount;
	var l_ReturnString = "";

	if (pServerTime =="" ||pServerTime ==null || pServerTime == undefined) return "";

	l_DateFormatCount = pServerTime.length;
	
	if (pServerTime.indexOf(" ") == -1) {
	    if (pServerTime.length == 10) {
	        pServerTime += " 00:00:00";
	    } else if (pServerTime.length === 8 && pServerTime.indexOf('-')===-1) {
			pServerTime = pServerTime.substring(0,4)+"-"+pServerTime.substring(4,6)+"-"+pServerTime.substring(6) + " 00:00:00";
		} else {
	        return pServerTime;
	    }
	} 
	
	l_StringDate = pServerTime.split(' ')[0]
	l_StringTime = pServerTime.split(' ')[1]
	
	if (l_StringDate.indexOf(".") > -1) { l_DateFormat = "."; }
	if (l_StringDate.indexOf("-") > -1) { l_DateFormat = "-"; }
	if (l_StringDate.indexOf("/") > -1) { l_DateFormat = "/"; }
	
	if (l_DateFormat == "") {
	    return pServerTime;
	}
	l_StringDate = l_StringDate.replace(/-/g, "")
	l_StringDate = l_StringDate.replace(/\./g, "")
	l_StringDate = l_StringDate.replace(/\//g, "")
	l_StringTime = l_StringTime.replace(/:/g, "")
	
	if (l_StringDate.length != 8 || l_StringTime.length < 4) {
	    return pServerTime;
	}
	
	l_StringTime = CFN_PadRight(l_StringTime, 6, "0");
	
	l_InputYear = l_StringDate.substring(0, 4);
	l_InputMonth = l_StringDate.substring(4, 6) - 1;
	l_InputDay = l_StringDate.substring(6, 8);
	l_InputHH = l_StringTime.substring(0, 2);
	l_InputMM = l_StringTime.substring(2, 4);
	l_InputSS = l_StringTime.substring(4, 6);
	
	var l_InputDate = new Date(l_InputYear, l_InputMonth, l_InputDay, l_InputHH, l_InputMM, l_InputSS);
	if (l_InputDate.getFullYear() != l_InputYear || l_InputDate.getMonth() != l_InputMonth || l_InputDate.getDate() != l_InputDay ||
	    l_InputDate.getHours() != l_InputHH || l_InputDate.getMinutes() != l_InputMM || l_InputDate.getSeconds() != l_InputSS) {
	    return pServerTime;
	}
	
	
	l_UR_TimeZone = timezonelist[pTimeZoneCode];
	
	l_Minus = l_UR_TimeZone.substring(0, 1);
	l_TimeZone = l_UR_TimeZone.replace("-", "").replace(":", "").replace(":", "");
	l_ZoneHH = l_TimeZone.substring(0, 2);
	l_ZoneMM = l_TimeZone.substring(2, 4);
	l_ZoneSS = l_TimeZone.substring(4, 6);

	var l_TimeZoneTime = (parseInt(l_ZoneHH, 10) * 3600000) + (parseInt(l_ZoneMM, 10) * 60000) + (parseInt(l_ZoneSS, 10) * 1000)

	if (l_Minus == "-") {
	    l_InputDate.setTime(l_InputDate.getTime() - l_TimeZoneTime);
	} else {
	    l_InputDate.setTime(l_InputDate.getTime() + l_TimeZoneTime);
	}
	
	if (pLocalFormat == undefined || pLocalFormat == "") {

	    pLocalFormat = "yyyy-MM-dd HH:mm:ss";
	    l_ReturnString = pLocalFormat
	    .replace("yyyy", CFN_PadLeft(l_InputDate.getFullYear(), 4, "0"))
	    .replace("MM", CFN_PadLeft(l_InputDate.getMonth() + 1, 2, "0"))
	    .replace("dd", CFN_PadLeft(l_InputDate.getDate(), 2, "0"))
	    .replace("HH", CFN_PadLeft(l_InputDate.getHours(), 2, "0"))
	    .replace("mm", CFN_PadLeft(l_InputDate.getMinutes(), 2, "0"))
	    .replace("ss", CFN_PadLeft(l_InputDate.getSeconds(), 2, "0"));
	    l_ReturnString = l_ReturnString.substr(0, l_DateFormatCount);
	}
	else
	{
	    l_ReturnString = pLocalFormat
	    .replace("yyyy", CFN_PadLeft(l_InputDate.getFullYear(), 4, "0"))
	    .replace("MM", CFN_PadLeft(l_InputDate.getMonth() + 1, 2, "0"))
	    .replace("dd", CFN_PadLeft(l_InputDate.getDate(), 2, "0"))
	    .replace("HH", CFN_PadLeft(l_InputDate.getHours(), 2, "0"))
	    .replace("mm", CFN_PadLeft(l_InputDate.getMinutes(), 2, "0"))
	    .replace("ss", CFN_PadLeft(l_InputDate.getSeconds(), 2, "0"));
	}
	console.log(l_ReturnString)
	return l_ReturnString;
*/
}
