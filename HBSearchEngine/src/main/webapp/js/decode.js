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

function btnDec_onClick(t) {
    var token = t;
    var key = "enTksrjsTjf2022";

    var decode = decodeToken(token, key);

    if (decode == "INVALID") {
        //$("#txtResult").val("유효하지 않은 Token");
    	alert("유효하지 않은 Token");
    }
    else {
        var payload = JSON.parse(decode);

        var now = Date.now();
        if (now > payload.iat && now < payload.exp) {
            //$("#txtResult").val("접속 ID = " + payload.emp);
			return payload.emp;
        }
        else {  //토큰 시간 만료
            //$("#txtResult").val("토큰 시간 만료");
    		alert("Token 시간 만료");
        }
    }

}