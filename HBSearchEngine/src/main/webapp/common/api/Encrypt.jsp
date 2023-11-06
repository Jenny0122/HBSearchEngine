
<%
request.setCharacterEncoding("UTF-8");
%>
<%@ page
	import="java.util.*
	,io.jsonwebtoken.Jwts
	,io.jsonwebtoken.Claims
	,io.jsonwebtoken.SignatureAlgorithm
	,io.jsonwebtoken.SignatureException
	,java.io.UnsupportedEncodingException
	,java.security.GeneralSecurityException
	,java.security.Key
	,java.security.NoSuchAlgorithmException
	,javax.crypto.Cipher
	,javax.crypto.spec.IvParameterSpec
	,javax.crypto.spec.SecretKeySpec
	,org.apache.commons.codec.binary.Base64"%>
<%!public static class Encrypts {

		/**
		 * TOKEN 키를 이용하여 데이터를 가져옵니다.
		 * 
		 * @param encKey
		 *            사용자가 호출한 암호화키
		 * @param jwtTokenString
		 *            암화화된 토큰키
		 * @return 암호화된 jwt 형식의 데이터 token
		 */
		public static Map<String, Object> getTokenFromJwtString(String encKey, String jwtTokenString)
				throws InterruptedException {
			Map<String, Object> retMap = new HashMap<>();
			try {
				Claims claims = Jwts.parser()
									.setSigningKey(encKey.getBytes())
									.parseClaimsJws(jwtTokenString)
									.getBody();

				retMap = claims;
			} catch (SignatureException e) {
				retMap.put("result", "KEY ERROR");
			}
			return retMap;
		}
	}%>