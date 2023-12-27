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
	
	//var searchForm = document.search;


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
		startDate = getAddDay(currentDate, -31);
	} else {
		startDate = "2000-01-01";
		endDate = toDate;
	}

	if (range != "A" && startDate != "" ) {
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

	//$("#range").val(range);
	//searchForm.range.value = range;
	//searchForm.startDate[0].value = startDate;
	//searchForm.endDate[0].value = endDate;
	//$("#startDate").val(startDate);
	//$("#endDate").val(endDate);
	
	$("input[name=range]").val(range);
	$("input[name=startDate]").val(startDate);
	$("input[name=endDate]").val(endDate);
		
	//changeDatepickerValue('disable')
}

function changeDatepickerValue(value) {
	$("input[name=startDate]").datepicker(value)
	$("input[name=endDate]").datepicker(value)
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
			searchForm.reQuery.value = "2";
			searchForm.submit();
		} else if ($("#apprType_mig").is(":checked")) {
			//$("#apprType_appr").attr("checked", false);
			searchForm.apprType.value = "mig";
			coll = replaceAll(coll,"appr","apprMig");
			searchForm.collection.value = coll;
			searchForm.reQuery.value = "2";
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
	searchForm.collection.value = "ALL";
	searchForm.collectionQueryW.value = collectionQueryW;
	searchForm.collectionQueryD.value = '';
	searchForm.reQuery.value = "2";
	searchForm.submit();
}

// 컬렉션검색
function doCollectionQueryD(collectionQueryD) {
	var searchForm = document.search;
	searchForm.collection.value = "ALL";
	searchForm.collectionQueryD.value = collectionQueryD;
	searchForm.collectionQueryW.value = '';
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
	searchForm.reQuery.value = null;
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

// 컬렉션별 검색
function doCollection(coll) {
	var searchForm = document.search;
	searchForm.apprType.value = "appr";
	searchForm.collection.value = coll;
	searchForm.reQuery.value = "2";
	searchForm.categoryQueryW.value = "";
	searchForm.categoryQueryD.value = "";
	searchForm.collectionQueryW.value = "";
	searchForm.collectionQueryD.value = "";
	searchForm.submit();
}

// 엔터 체크
function pressCheck(event) {
	return event.key == 'Enter' ? doSearch() : event.key;
}

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


