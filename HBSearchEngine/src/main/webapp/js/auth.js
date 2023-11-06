/*
Subject : Token 복호화 
Method : decodeToken
Param : token(토큰), secretKey(SecretKey)
Description : 암호화된 Token을 복호화

방식
- JWT 방식 암호화

암호화 키
- enTksrjsTjf2022

토큰 만료 시간
- 3분(셋팅값 : 180000)

*/
function decodeToken(token,secretKey) {

    var jsonPayload = "INVALID";
    var signiture = token.split('.')[2];

    if (CheckTokenValidation(token,secretKey)) {
        var base64Url = token.split('.')[1];
        var base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
        jsonPayload = decodeURIComponent(atob(base64).split('').map(function (c) {
            return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
        }).join(''));
    }


    return jsonPayload;
}

//Token 유효성 체크
function CheckTokenValidation(token, secretKey) {
    var data = token.split('.')[0] + "." + token.split('.')[1];
    var signiture = token.split('.')[2];

    data = CryptoJS.HmacSHA256(data, secretKey);
    data = base64url(data);

    if (data == signiture) return true;
    
    return false;
}

function base64url(source) {
    // Encode in classical base64
    encodedSource = CryptoJS.enc.Base64.stringify(source);

    // Remove padding equal characters
    encodedSource = encodedSource.replace(/=+$/, '');

    // Replace characters according to base64url specifications
    encodedSource = encodedSource.replace(/\+/g, '-');
    encodedSource = encodedSource.replace(/\//g, '_');

    return encodedSource;
}

function btnEnc_onClick() {
    var emp = $("#txtEmpNo").val();
    var key = $("#txtSecretKey").val();
    var token = GetEncryptToken(emp, key);
    $("#txtToken").val(token);
}

function getToken() {
	//var token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NjgwNTQ1MjA1ODMsImV4cCI6MTY2ODA1NDU4MDU4MywiZW1wIjoiMSJ9.ft5QXNoR0q3t0f8iXuJffAiBwOWzK3F7swxlnzBT8AQ";
	var token = $("#uid").val();
    //var key = "enTksrjsTjf2022";
    var key = "2";
    var searchForm = document.search;

    var decode = decodeToken(token, key);

    if (decode == "INVALID") {
        //$("#txtResult").val("유효하지 않은 Token");
        //alert("유효하지 않은 Token");
    }
    else {
        var payload = JSON.parse(decode);

        var now = Date.now();
        if (now > payload.iat && now < payload.exp) {
            //$("#uid").val(payload.emp);
            searchForm.uid.value = payload.emp;
        }
        else {  //토큰 시간 만료
            //$("#txtResult").val("토큰 시간 만료");
        	//alert("토큰 시간 만료");
        }
    }

    searchForm.uid.value = "superadmin";
    searchForm.submit();
}