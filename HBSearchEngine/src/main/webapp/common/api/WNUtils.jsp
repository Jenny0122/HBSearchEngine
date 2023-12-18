<%@page import="java.io.IOException"%>
<%@ page import="java.text.DecimalFormat,
                 java.text.FieldPosition,
                 java.io.UnsupportedEncodingException,
                 java.text.*,
				 javax.xml.parsers.*,
				 org.w3c.dom.*,
				 org.xml.sax.SAXException,
                 java.util.*,
                 java.io.FileNotFoundException,
                 java.io.FileReader,
                 javax.script.Compilable,
				 javax.script.CompiledScript,
				 javax.script.Invocable,
				 javax.script.ScriptEngine,
				 javax.script.ScriptEngineManager,
				 javax.script.ScriptException,
				 javax.script.ScriptEngineFactory"%><%!
/**              
 *  file: WNUtils.jsp
 *  subject: ê²ì êµ¬íì íìí ì¼ë° ë©ìëë¥¼ êµ¬ííë¤.
 *  ------------------------------------------------------------------------
 *  @original author: KoreaWISEnut
 *  @edit author: KoreaWISEnut
 *  @update date 2006.12.03
 *  ------------------------------------------------------------------------
 */
    /*
    *	ë¬¸ìì ê´ë ¨ ì¤ì 
    */
    final static String ENCODE_ORI = "EUC-KR";
    final static String ENCODE_NEW = "UTF-8";

	/**
     * ë¬¸ì ë°°ì´ ê°ì ê²ìíì¬ í¤ ê°ì ë¦¬í´
     * @param fieldName
     * @param value
     * @param operation
     * @return
     */
    private int findArrayValue(String find, String[] arr) {
        int findKey = -1;
        for (int i = 0; i < arr.length; i++) {
            if (find.equals(arr[i])){
                findKey = i;
                break;
            }
        }
        return findKey;
    }

    /**
     *
     * @param s
     * @param findStr
     * @param replaceStr
     * @return
     */
    public static String replace(String s, String findStr, String replaceStr){
        int   pos;
        int   index = 0;

        while ((pos = s.indexOf(findStr, index)) >= 0) {
            s = s.substring(0, pos) + replaceStr + s.substring(pos + findStr.length());
            index = pos + replaceStr.length();
        }

        return s;
    }

    /**
     *
     * @param s
     * @return
     */
    public static String trimDuplecateSpace(String s){
        StringBuffer sb = new StringBuffer();
        for(int i=0; i<s.length(); i++){
            char c = s.charAt(i);
            if(i < s.length()-1) {
                if( c == ' ' && s.charAt(i+1)==' '){
                    continue;
                }
            }
            sb.append(c);
        }
        return sb.toString().trim();
    }

    public static String parseDate(String input, String inFormat, String outFormat) {
        String retStr = "";
        Date date = null;
        SimpleDateFormat formatter = null;
        try {
            date = (new SimpleDateFormat(inFormat)).parse(input.trim());
        } catch (ParseException e) {
            e.printStackTrace();
        }
        formatter = new SimpleDateFormat(outFormat);
        retStr = formatter.format(date);
        return retStr;
    }

    public static String getCurrentDate() {
        java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat
                ("yyyy-MM-dd", java.util.Locale.KOREA);
        return dateFormat.format(new java.util.Date());
    }

    /**
     *
     * @param strNum
     * @param def
     * @return
     */
    public static int parseInt(String strNum, int def){
        if(strNum == null) return def;
        try{
            return Integer.parseInt(strNum);
        }catch(Exception e){
            return def;
        }
    }

    /**
     * Stringì ê°ì´ nullì¼ ê²½ì° ""ë¡ ë³ííì¬ ë¦¬í´íë¤.
     * @param temp
     * @return
     */
    public static String checkNull(String temp) {
        if (temp != null) {
            temp = temp.trim();
        } else {
            temp = "";
        }
        return temp;
    }

    /**
     * 1ì°¨ì ë°°ì´ì ê°ì¤ nullì¸ ê°ì ""ë¡ ë³ííì¬ ë¦¬í´íë¤.
     * @param temp
     * @return
     */
    public static String[] checkNull(String[] temp){
        for(int i=0; i<temp.length; i++) {
            temp[i] = checkNull(temp[i]);
        }
        return temp;
    }

    /**
     * 2ì°¨ì ë°°ì´ì ê°ì¤ nullì¸ ê°ì ""ë¡ ë³ííì¬ ë¦¬í´íë¤.
     * @param temp
     * @return
     */
    public static String[][] checkNull(String[][] temp) {
        for(int i=0; i<temp.length; i++) {
            temp[i][0] = checkNull(temp[i][0]);
            temp[i][1] = checkNull(temp[i][1]);
        }
        return temp;
    }

    /**
     * ì¤í¸ë§ì format ì ë§ê² ë³íì íë¤.
     * convertFormat("1", "00") return "01" ë¡ ìë ¥ ê°ì ë¦¬í´íë¤.
     * @param inputStr
     * @param format
     * @return String
     */
    public static String convertFormat(String inputStr, String format){
        int _input = Integer.parseInt(inputStr);
        StringBuffer result = new StringBuffer();
        DecimalFormat df = new DecimalFormat(format);
        df.format( _input, result, new FieldPosition(1) );
        return result.toString();
    }

    /**
     *
     * @param str
     * @param outFormat
     * @return
     */
    public static String numberFormat(String str, String outFormat) {
        return new DecimalFormat(outFormat).format(str);
    }

	/**
     *
     * @param str
     * @return
     */
    public static String numberFormat(int num) {
		return NumberFormat.getNumberInstance().format(num);
    }

    /**
     *
     * @param str
     * @param oriEncode
     * @param newEncode
     * @return
     */
    public static String encoding(String str, String oriEncode, String newEncode) {
        str = checkNull(str);
        if(str.length() > 0) {
            try {
                str = new String(str.getBytes(oriEncode), newEncode);
            } catch (UnsupportedEncodingException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
        return str;
    }


    /**
     * êµ¬ë¶ìë¥¼ ê°ì§ê³  ìë ë¬¸ìì´ì êµ¬ë¶ìë¥¼ ê¸°ì¤ì¼ë¡ ëëì´ì£¼ë ë©ìë
     * @param splittee êµ¬ë¶ìë¥¼ ê°ì§ ë¬¸ìì´
     * @param splitChar êµ¬ë¶ì
     * @return
     */
    public static String[] split(String splittee, String splitChar){
        String taRetVal[] = null;
        StringTokenizer toTokenizer = null;
        int tnTokenCnt = 0;

        try {
            toTokenizer = new StringTokenizer(splittee, splitChar);
            tnTokenCnt = toTokenizer.countTokens();
            taRetVal = new String[tnTokenCnt];

            for(int i=0; i<tnTokenCnt; i++) {
                if(toTokenizer.hasMoreTokens())	taRetVal[i] = toTokenizer.nextToken();
            }
        } catch (Exception e) {
            taRetVal = new String[0];
        }
        return taRetVal ;
    }

    /**
     * String ì ë°ì UTF-8 ë²ìë´ ë¬¸ìê° ì´ëê²½ì° ê³µë°±(0x0020) ì¼ë¡ ì¹í
     * @param str
     * @return String
     */
    public static String validate(String str) {
        StringBuffer buf = new StringBuffer();

        char ch;
        for(int i=0; i < str.length(); i++) {
            ch = str.charAt(i);
            if(Character.isLetterOrDigit(ch)) {
            } else {
                if(Character.isWhitespace(ch)) {
                } else {
                    if(Character.isISOControl(ch)) {
                        // UTF-8 ìì ì§ìíì§ ìë ë¬¸ì ì ê±°
                        ch = (char)0x0020;
                    }
                }
            }

            buf.append(ch);
        }

        return buf.toString();
    }

    /**
     * request nullì²´í¬
     **/
    public String getCheckReq(javax.servlet.http.HttpServletRequest req, String parameter, String default_value) {
        String req_value = (req.getParameter(parameter) == null ||  req.getParameter(parameter).equals("")) ? default_value : req.getParameter(parameter);
        return req_value;
    }

    /**
     * request Array nullì²´í¬
     **/
    public String[] getCheckReqs(javax.servlet.http.HttpServletRequest req, String parameter, String[] default_value) {
        String[] req_value = req.getParameterValues(parameter);
        String[] tmp = null;
        int c = 0;
        if(req_value!=null) {
            tmp = new String[req_value.length];
            for(int i=0; i<req_value.length; i++) {
                tmp[c] = req_value[i];
                c++;
            }
        }
        req_value = req.getParameterValues(parameter)!=null ? tmp : default_value;
        return req_value;
    }

	public String replaceURL(String base, String url, String param, String value) {

		String sURL = "";
		if ( url != null && !url.equals("")) {
			if ( url.indexOf(param) < 0 )
				url = url + "&" + param + "=" + value;

			String [] params = url.split("&");
			for ( int idx=0; idx < params.length; idx++ ) {
				if ( params[idx].indexOf(param) >= 0 ) {
					params[idx] = param + "=" + value;
				}

				sURL = sURL + params[idx] ;

				if ( idx + 1 < params.length)
					sURL = sURL + "&" ;

			}

		} else {
				sURL = param + "=" + value;
		}

		sURL = base + "?" + sURL;


		return sURL;

	}

    /**
     * nullì²´í¬
     **/
    public String nvl(String parameter, String default_value) {
        String req_value = parameter !=null ? parameter:default_value;
        return req_value;
    }

    /**
     * request nullì²´í¬, uncoding
     **/
    public String getCheckReqUnocode(javax.servlet.http.HttpServletRequest req, String parameter, String default_value) {
        String req_value = req.getParameter(parameter)!=null ? encoding(req.getParameter(parameter), ENCODE_ORI, ENCODE_NEW):default_value;
        return req_value;
    }

    /**
     * request Array nullì²´í¬, uncoding
     **/
    public String[] getCheckReqsUnocode(javax.servlet.http.HttpServletRequest req, String parameter, String[] default_value) {
        String[] req_value = req.getParameterValues(parameter);
        String[] tmp = null;
        int c = 0;
        if(req_value!=null) {
            tmp = new String[req_value.length];
            for(int i=0; i<req_value.length; i++) {
                tmp[c] = encoding(req_value[i], ENCODE_ORI, ENCODE_NEW);
                c++;
            }
        }
        req_value = req.getParameterValues(parameter)!=null ? tmp : default_value;
        return req_value;
    }

	/**
     * ì¸ê¸°ê²ìì´
     **/
	public String getPopKeyword() {
		String url ="http://127.0.0.1:7800/sample/normal/popword/popword.jsp?target=popword&range=D&collection=total";
		NodeList list = null;
		int count=0;
		String easy="0";
		StringBuffer sb = new StringBuffer();
		
		try {
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance(); //DOM parser factory ìì±
			factory.setIgnoringElementContentWhitespace(true); 
			DocumentBuilder builder = factory.newDocumentBuilder(); //DOM parser ìì±
			Document document = builder.parse(url); //xml ë¬¸ì íì±
			Element eRoot = document.getDocumentElement(); 
			NodeList data = eRoot.getElementsByTagName("Data");
			Element element = (Element) data.item(0);
			list = eRoot.getElementsByTagName("Query");
			count = list.getLength();

			if(list != null){
				for(int i=0; i	< count; i++){
					Element eQuery = (Element)list.item(i);
					String popQuery = eQuery.getTextContent();

					sb.append("<li class=\"ranking\">");
					sb.append("	<ul>");
					sb.append("		<li class=\"ranktxt\"><img src=\"images/"+ eQuery.getAttribute("id")+".gif\" alt=\"\" /> <a href=\"#none\" onclick=\"javascript:doKeyword('" + eQuery.getTextContent() + "');\">" + eQuery.getTextContent() + "</a></li>");
					sb.append("		<li class=\"rankico\">");
					
					if (eQuery.getAttribute("updown") == "U") {
						sb.append("<img src=\"images/ico_up.gif\" alt=\"ìì¹\" />");
					} else if (eQuery.getAttribute("updown") == "D") {
						sb.append("<img src=\"images/ico_down.gif\" alt=\"íë½\" />");
					} else if (eQuery.getAttribute("updown") == "N") {
						sb.append("<img src=\"images/ico_new.gif\" alt=\"ì ê·\" />");
					} else if (eQuery.getAttribute("updown") == "C") {
						sb.append("-");
					}
					
					if(eQuery.getAttribute("count").equals("-1")){
						easy = "0";
					} else {
						easy = eQuery.getAttribute("count");
					}
					
					sb.append("		</li>");
					sb.append("		<li class=\"rankstep\">" + easy + "</li>");
					sb.append("		");
					sb.append("	</ul>");
					sb.append("</li>");
				}
			}
			
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} 

		return sb.toString();
	}

	/**
	 * ë¬¸ìì ê¸¸ì´ë¥¼ ì§ì ë ê¸¸ì´ë§í¼ ìë¼ì ë°ííë í¨ì<br>
	 * íê¸ê³¼ ìë¬¸,ì«ìì ë°ë¼ì ê¸¸ì´ë¥¼ ë¤ë¥´ê² ê³ì°íë¤.
	 * @param str ë³íí  ë¬¸ìì´<br>
	 * byteLength ë¬¸ìì´ì ê¸¸ì´
	 * @return rtStr ì§ì ë ê¸¸ì´ë¡ ìì ë ë¬¸ìì´ì ë°ííë¤.
	 */
	public static String getSubString(String str, int byteLength) {
		if (str==null) {
			return "";
		}

		StringBuffer rtStr = new StringBuffer();

		rtStr.append(str.substring(0,getLengthInString(str,byteLength)));

		if(rtStr.length() != str.length()) {
			rtStr.append("...");
		}

		return rtStr.toString();
	}


	/**
	 * ë¬¸ìì ê¸¸ì´ë¥¼ íê¸ 2ì ìë¬¸,ì«ìë¥¼ 1ìë¡ ê³ì°íì¬<br>
	 * ë¬¸ìì´ì ê¸¸ì´ë¥¼ ë°ííë í¨ì
	 * @param str ë³íí  ë¬¸ìì´<br>
	 * byteLength ë¬¸ìì´ì ê¸¸ì´
	 * @return int ë¬¸ìì´ì ê¸¸ì´
	 */
	public static int getLengthInString(String str, int byteLength)
	{
		int length = str.length();
		int retLength = 0;
		int tempSize = 0;
		int asc;

		for(int i = 1; i<=length; i++) {
			asc = (int)str.charAt(i-1);
			
			if(asc > 127) {
				if ( byteLength > tempSize ) {
					tempSize += 2;
					retLength++;
				}
			} else {
				if ( byteLength > tempSize ) {
					tempSize++;
					retLength++;
				}
			}
		}

		return retLength;
	}
 
    /**
     * request XSS ì²ë¦¬
     **/
    public String getCheckReqXSS(javax.servlet.http.HttpServletRequest req, String parameter, String default_value) {
        String req_value = (req.getParameter(parameter) == null ||  req.getParameter(parameter).equals("")) ? default_value : req.getParameter(parameter);
        req_value = req_value.replaceAll("</?[a-zA-Z][0-9a-zA-Zê°-\uD7A3ã±-ã=/\"\'%;:,._()\\-# ]+>","");
        req_value = req_value.replaceAll(">","");
        req_value = req_value.replaceAll(">","");
        return req_value;
    }
    
    /**
     * request XSS 처리
     **/
    public String getCheckReqXSS2(javax.servlet.http.HttpServletRequest req, String parameter, String default_value) {
        String req_value = (req.getParameter(parameter) == null ||  req.getParameter(parameter).equals("")) ? default_value : req.getParameter(parameter);
        return req_value;
    }
    
%>