<%@ page import="java.util.*,java.io.IOException,javax.servlet.jsp.JspWriter,QueryAPI530.Search"%><%@ include file="./WNUtils.jsp"%><%!
/**
*  file: WNCommon.jsp
*  subject: Search Formula-1 API Wrapper í´ëì¤
*  ------------------------------------------------------------------------
*  @original author: WISEnut
*  @edit author: WISEnut
*  @update date 2012.04.24
*  ------------------------------------------------------------------------
*/
public class WNCommon {
   private Search search = null;
   private JspWriter out = null;
   boolean isDebug = false;

   /**
    * SF-1 Search í´ëì¤ ê°ì²´ë¥¼ ìì±íë WNCommonì ìì±ì í¨ìì´ë¤.
    */
   public WNCommon() {
       this.search = new Search();
   }

   /**
    * WNCommon ì¤ë²ë¡ë©(overloading) í¨ìì´ë¤.
    * WNCommonì ë¨ëì¼ë¡ ì¬ì©í  ê²½ì° debug ì¬ì©ì ë¬´ë¥¼ ì§ì í  ì ìë¤.
    * @param out
    * @param isDubug
    */
   public WNCommon(JspWriter out, boolean isDubug) {
       this.search = new Search();
       this.out = out;
       this.isDebug = isDubug;
   }

   /**
    * ê²ì ì§ì í¤ìëì ì§ìë ì¶ë ¥ì ì¬ì©ë  ë¬¸ìì§í©ì ì íë¤.
    * v4.x í¸í methodì´ë¯ë¡ COMMON_OR_WHEN_NORESULTì ì§ì íì§ ìëë¤.
    * @param query
    * @param charSet
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    * @deprecated  As of v4.x, replaced by
    * {@link #setCommonQuery(String,String,int)}
    */
   public int setCommonQuery(String query, String charSet) {
       int ret = 0;
       ret = search.w3SetCodePage(charSet);
       ret = search.w3SetQueryLog(1);
       ret = search.w3SetTraceLog(0);
       ret = search.w3SetCommonQuery(query, 0);
       return ret;
   }

    /**
    * ê²ì ì§ì UIDì ì§ìë ì¶ë ¥ì ì¬ì©ë  ë¬¸ìì§í©ì ì íë¤.
    * @param charSet
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int setUidQuery(String charSet) {
       int ret = 0;
       ret = search.w3SetCodePage(charSet);
       ret = search.w3SetQueryLog(0);
       return ret;
   }

   /**
    * ê²ì ì§ì í¤ìëì ì§ìë ì¶ë ¥ì ì¬ì©ë  ë¬¸ìì§í©ì ì íë¤.
    * @param query
    * @param charSet
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int setCommonQuery(String query, String charSet, int useOrResult, boolean useSuggestedQuery) {
       int ret = 0;
       ret = search.w3SetCodePage(charSet);
       ret = search.w3SetQueryLog(1);
       ret = search.w3SetTraceLog(0);
       ret = search.w3SetCommonQuery(query, useOrResult);
       if(useSuggestedQuery) {
           ret = search.w3SetSpellCorrectionQuery(query, 0);
       }
       return ret;
   }

   /**
    * setCommonQueryì ì¤ë²ë¡ë©(overloading) í¨ìë¡
    * sessionì ë³´ë¥¼ ë¶ê°ê¸°ë¥ì¼ë¡ ì¬ì©í  ì ìë¤.
    * v4.x í¸í methodì´ë¯ë¡ COMMON_OR_WHEN_NORESULTì ì§ì íì§ ìëë¤.
    * @param query
    * @param charSet
    * @param logInfo
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    * @deprecated  As of v4.x, replaced by
    * {@link #setCommonQuery(String,String,String[],int)}
    */
   public int setCommonQuery(String query, String charSet, String[] logInfo) {
       int ret = 0;
       if (logInfo != null && logInfo.length > 2) {
           ret = search.w3SetSessionInfo(logInfo[0], logInfo[1], logInfo[2]);
       }
       setCommonQuery(query, charSet);
       return ret;
   }


   /**
    * setCommonQueryì ì¤ë²ë¡ë©(overloading) í¨ìë¡
    * sessionì ë³´ë¥¼ ë¶ê°ê¸°ë¥ì¼ë¡ ì¬ì©í  ì ìë¤.
    * @param query
    * @param charSet
    * @param logInfo
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int setCommonQuery(String query, String charSet, int useOrResult, String[] logInfo) {
       int ret = 0;
       if (logInfo != null && logInfo.length > 2) {
           ret = search.w3SetSessionInfo(logInfo[0], logInfo[1], logInfo[2]);
       }
       ret = search.w3SetCodePage(charSet);
       ret = search.w3SetQueryLog(1);
       ret = search.w3SetCommonQuery(query, useOrResult);
       return ret;
   }

   /**
    * setCommonQueryì ì¤ë²ë¡ë©(overloading) í¨ìë¡
    * sessionì ë³´ë¥¼ ë¶ê°ê¸°ë¥ì¼ë¡ ì¬ì©í  ì ìë¤.
    * @param query
    * @param charSet
    * @param logInfo
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int setCommonQuery(String query, String charSet, int useOrResult, boolean useSuggestedQuery, String[] logInfo) {
       int ret = 0;
       if (logInfo != null && logInfo.length > 2) {
           ret = search.w3SetSessionInfo(logInfo[0], logInfo[1], logInfo[2]);
       }
       ret = search.w3SetCodePage(charSet);
       ret = search.w3SetQueryLog(1);
       //ret = search.w3SetTraceLog(0);
       ret = search.w3SetCommonQuery(query, useOrResult);
       if(useSuggestedQuery) {
           ret = search.w3SetSpellCorrectionQuery(query, 0);
       }
       return ret;
   }

   /**
    * ì»¬ë ì ë³ë¡ ê²ìì´ ì§ì 
    * @param collectionName
    * @param query
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int setCollectionQuery(String collectionName, String query) {
       return search.w3SetCollectionQuery(collectionName, query);
   }


   /**
    * ì»¬ë ì ë³ë¡ boost query ì§ì 
    * @param collectionName
    * @param boost query
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int setBoostQuery(String collectionName, String query) {
       int idx = query.lastIndexOf("/");
       int option = Integer.parseInt(query.substring(idx, query.length()));
       return search.w3SetBoostQuery(collectionName, query, option);
   }

   /**
    * ì»¬ë ì ë³ë¡ boost query ì§ì 
    * @param collectionName
    * @param boost query
    * @param option 0,1,2
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int setBoostQuery(String collectionName, String query, int option) {
       return search.w3SetBoostQuery(collectionName, query, option);
   }

   /**
    * ê²ìíê³ ì íë ì»¬ë ìì UIDë¥¼ ì¤ì íë¤.
    * @param collectionName
    * @param values
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int setUid(String collectionName, String[] values,
           String searcherId) {
       int ret = 0;
       for (int i = 0; i < values.length; i++) {
           long uid = 0L;
           try {
               uid = Long.parseLong(values[i]);
           } catch (NumberFormatException e) {
               return -1;
           }
           ret = search.w3AddUid(collectionName, uid, searcherId);
       }
       return ret;
   }

   /**
    * ê²ìëì ì»¬ë ì, ì¸ì´ë¶ìê¸° ì¬ì©ì ë¬´, ëìë¬¸ì êµ¬ë¶ì ë¬´ë¥¼ ì¤ì íë¤.
    * v4.x í¸í methodì´ë¯ë¡ USEORIGINAL, USESYNONYMì ì§ì íì§ ìëë¤.
    * @param collectionName
    * @param useKma
    * @param isCase
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    * @deprecated  As of v4.5, replaced by
    * {@link #addCollection(String,int,int,int,int,int)}
    */
   public int addCollection(String collectionName, int useKma, int isCase) {
       int ret = 0;
       ret = search.w3AddCollection(collectionName);
        //USEMA, ISCASE, USEORIGINAL, USESYNONYM
       ret = search.w3SetQueryAnalyzer(collectionName, useKma, isCase, 1,1);
       ret = search.w3SetDuplicateDetection(collectionName);
       //systemOut("[w3AddCollection] "+collectionName);
       return ret;
   }

   /**
    * ê²ìëì ì»¬ë ì, ì¸ì´ë¶ìê¸° ì¬ì©ì ë¬´, ëìë¬¸ì êµ¬ë¶ì ë¬´ë¥¼ ì¤ì íë¤.
    * @param collectionName
    * @param useKma
    * @param isCase
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int addCollection(String collectionName, int useKma, int isCase,
           int useOriginal, int useSynonym, int duplicateDectection) {
       int ret = 0;
       ret = search.w3AddCollection(collectionName);
       //USEMA, ISCASE, USEORIGINAL, USESYNONYM
       ret = search.w3SetQueryAnalyzer(collectionName, useKma, isCase, useOriginal, useSynonym);
       //systemOut("[w3AddCollection] "+collectionName);
       if(duplicateDectection == 1) {
           ret = search.w3SetDuplicateDetection(collectionName);
       }
       return ret;
   }

   /**
    * ì¶ì ì»¬ë ì ì¶ê°
    * v4.x í¸í methodì´ë¯ë¡ USEORIGINAL, USESYNONYMì ì§ì íì§ ìëë¤.
    * @param aliasName ì¤ì í ë³ì¹­ ì»¬ë ìëª
    * @param collectionName ì¤ì  ì»¬ë ì
    * @param useKma
    * @param isCase
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    * @deprecated  As of v4.5, replaced by
    * {@link #addAliasCollection(String,String,int,int,int,int,int)}
    */
   public int addAliasCollection(String aliasName, String collectionName,
           int useKma, int isCase) {
       int ret = 0;
       ret = search.w3AddAliasCollection(aliasName, collectionName);
       ret = search.w3SetQueryAnalyzer(aliasName, useKma, isCase, 1, 1);
       ret = search.w3SetDuplicateDetection(aliasName);
       return ret;
   }

   /**
    * ì¶ì ì»¬ë ì ì¶ê°
    * @param aliasName ì¤ì í ë³ì¹­ ì»¬ë ìëª
    * @param collectionName ì¤ì  ì»¬ë ì
    * @param useKma
    * @param isCase
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int addAliasCollection(String aliasName, String collectionName,
           int useKma, int isCase, int useOriginal, int useSynonym, int duplicateDectection) {
       int ret = 0;
       ret = search.w3AddAliasCollection(aliasName, collectionName);
       ret = search.w3SetQueryAnalyzer(aliasName, useKma, isCase,
               useOriginal, useSynonym);
       if(duplicateDectection == 1) {
           ret = search.w3SetDuplicateDetection(aliasName);
       }
       return ret;
   }

   /**
    * ê²ìê¸° ì°ê²°
    * @param ip
    * @param port
    * @param timeOut
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int getConnection(String ip, int port, int timeOut) {
       int ret = search.w3ConnectServer(ip, port, timeOut);
       return ret;
   }

   /**
    * í´ë¹ ì»¬ë ìì ê²ì ëì íëë¥¼ ì¬ë¬ ê°ë¥¼ ì¤ì íë¤.
    * v4.x í¸í methodì´ë¯ë¡ fieldscoreë¥¼ ì§ì íì§ ìëë¤.
    * @param collectionName
    * @param fields
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    * @deprecated  As of v4.5, replaced by
    * {@link #setSearchField(String,String)}
    **/
   public int addSearchField(String collectionName, String[] fields) {
       int ret = 0;
       for (int i = 0; i < fields.length; i++) {
           ret = search.w3AddSearchField(collectionName, fields[i]);
           systemOut("[w3AddSearchField] " + collectionName + " / "
                   + fields[i]);
       }
       return ret;
   }

    /**
    * ê²ì íëë³ ë­í¹ ì¤ì½ì´(score)ë¥¼ ì¤ì íë¤.
    * @param collectionName
    * @param fields TITLE,CONTENT
    * @param rankScores 100,30
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int addSearchFieldScore(String collectionName, String[] fields, int[] rankScores) {
       int ret = 0;
       for (int i = 0; i < fields.length; i++) {
           ret = search.w3AddSearchFieldScore(collectionName, fields[i], rankScores[i]);
           systemOut("[w3AddSearchFieldScore] " + collectionName + " / "+ fields[i] + "/" + rankScores[i]);
       }
       return ret;
   }

   /**
    * í´ë¹ ì»¬ë ìì ê²ì ëì íëë¥¼ ì¬ë¬ ê°ë¥¼ ì¤ì íë¤.
    * @param collectionName
    * @param fields TITLE/100,CONTENT/30
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int setSearchField(String collectionName, String fields) {
       int ret = 0;
       String[] searchFieldTemp = split(fields, ","); //TITLE/100,CONTENT/30
       for (int i = 0; i < searchFieldTemp.length; i++) {
           String[] searchField = split(searchFieldTemp[i], "/");
           if (searchField != null && searchField.length > 0) {
               ret = search.w3AddSearchField(collectionName,
                       searchField[0]);
               systemOut("[w3AddSearchField] " + collectionName + " / "+ searchField[0]);
           }
       }
       ret = search.w3SetSearchFieldScore(collectionName, fields);
       systemOut("[w3AddSearchField] " + collectionName + " / " + fields);
       return ret;
   }



   /**
    * ê²ìê²°ê³¼ì ì ë ¬íëë¥¼ ì¤ì íë¤.
    * v4.x í¸í method
    * @param collectionName
    * @param sortField
    * @param sortOrder
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    * @deprecated  As of v4.5, replaced by
    * {@link #setSortField(String,String)}
    */
   public int addSortField(String collectionName, String sortField, int sortOrder) {
       int ret = 0;
       ret = search.w3AddSortField(collectionName, sortField, sortOrder);
       systemOut("[w3AddSortField] " + collectionName + " / " + sortField);
       return ret;
   }

   /**
    * ê²ìê²°ê³¼ì ì ë ¬íëë¥¼ ì¤ì íë¤.
    * @param collectionName
    * @param sortValue
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int setSortField(String collectionName, String sortValue) {
       int ret = 0;
       ret = search.w3SetSortField(collectionName, sortValue);
       systemOut("[w3SetSortField] " + collectionName + " / " + sortValue);
       return ret;
   }

   /**
    * ê²ìê²°ê³¼ RANKINGì ì¤ì íë¤. SF-1 v5.0 ì ê· ì¶ê° method.
    * @param collectionName
    * @param method ë­í¹ ë©ìë( basic, custom, BM25 )
    * @param option
       - p( proximity )
       - r( field weight )
       - k( multi keyword factor )
       - f( frequency )
       - m( morpheme )
       - o( offset )
       - l( length )
    * @param maxcount Ranking íê¸°ì MAX ê°. (ì) %ë¡ íê¸°í  ì 100
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
   */
   public int setRanking(String collectionName, String method, String option, int maxcount) {
       return search.w3SetRanking(collectionName, method, option, maxcount);
   }

   /**
   * ê²ìí ê²°ê³¼ ë­í¬ê°ì ëí ë²ìë¥¼ ì§ì 
   * @param collectionName Collection ì´ë¦
   * @param minRank ìµì ë­í¹ ê°
   * @param maxRank ìµë ë­í¹ ê°
   * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
   */
   public int setRankRange(String collectionName, int minRank, int maxRank) {
       return search.w3SetRankRange(collectionName, minRank, maxRank);

   }

   /**
    *
    * @param collectionName
    * @param fieldNameValues
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int setPrefixQuery(String collectionName,
           String fieldNameValues) {
       //valueê°ì /ê° ìì ì ìì¼ë¯ë¡ >/ë¡ ì°¾ìì queryì ì°ì°ìë¥¼ ë¶ë¦¬íë¤.
       fieldNameValues = fieldNameValues.trim();
       int index = fieldNameValues.lastIndexOf("/");
       String prefixQuery = "";
       int operator = 1;
       if(index != -1) {
           prefixQuery = fieldNameValues.substring(0, index);
           String temp = fieldNameValues.substring(index+1, fieldNameValues.length());
           temp = temp.trim();
           operator = Integer.parseInt(temp);
       }else{
           prefixQuery = fieldNameValues.trim();
       }
       int ret = search.w3SetPrefixQuery(collectionName, prefixQuery, operator);
       systemOut("[w3SetPrefixQuery]" + fieldNameValues);
       return ret;
   }

   /**
    *
    * @param collectionName
    * @param fieldNameValues
    * @return  ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int setFilterOperation(String collectionName, String fieldNameValues) {
       int ret = search.w3SetFilterQuery(collectionName, fieldNameValues);
       systemOut("[w3SetFilterQuery]" + fieldNameValues);
       return ret;
   }

   /**
    *
    * @param collectionName
    * @param fieldNameValues
    * @return  ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int setFilterQuery(String collectionName, String fieldNameValues) {
       int ret = search.w3SetFilterQuery(collectionName, fieldNameValues);
       systemOut("[w3SetFilterQuery]" + fieldNameValues);
       return ret;
   }

   /**
   * setResultFieldìì ì§ì í ê²°ê³¼ íëë¤ì ê°ì ì»ë í¨ìì´ë¤.
   * v4.x í¸í methodì´ë¤. displaylengthë¥¼ ì§ì íì§ ìì¼ë¯ë¡ ì£¼ìí´ì¼íë¤.
   * @param collectionName
   * @param fields
   * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
   * @deprecated  As of v4.5, replaced by
   * {@link #setResultField(String,String)}
   */
   public int setResultField(String collectionName, String[] fields) {
       int ret = 0;
       for(int i=0; i< fields.length; i++) {
           ret = search.w3AddDocumentField(collectionName, fields[i], 0);
           systemOut("[w3AddDocumentField] " + collectionName + " / " + fields[i]);
       }
       return ret;
   }

   /**
    * setResultFieldìì ì§ì í ê²°ê³¼ íëë¤ì ê°ì ì»ë í¨ìì´ë¤.
    * @param collectionName
    * @param fields
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int setResultField(String collectionName, String fields) {
       int ret = 0;
       ret = search.w3SetDocumentField(collectionName, fields);
       systemOut("[w3SetDocumentField] " + collectionName + " / " + fields);
       return ret;
   }

   /**
    * í´ë¹ ì»¬ë ìì ëª ë²ì§¸ ê²ì ê²°ê³¼ë¶í° ëª ê°ë¥¼
    * ê°ì ¸ì¬ ê²ì¸ì§ë¥¼ ì§ì íê³  íì´ë¼ì´í¸ ê¸°ë¥ê³¼ ìì½ê¸°ë¥ì ì§ì íë í¨ìì´ë¤.
    * ê²ì API v3.5ììë w3SetHighlightì íë¼ë¯¸í°ê° 2ê°ì´ì§ë§ v3.7ììë 3ê°ì´ë¤.
    * @param collName
    * @param highlight
    * @param startPos
    * @param resultCnt
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int setPageInfo(String collName, int highlight, int startPos,
           int resultCnt) {
       int ret = 0;
       if (highlight == 1) { //OFF, ON
           ret = search.w3SetHighlight(collName, 0, 1);
       } else if (highlight == 2) { //ON , OFF
           ret = search.w3SetHighlight(collName, 1, 0);
       } else if (highlight == 3) { //ON, ON
           ret = search.w3SetHighlight(collName, 1, 1);
       } else {//OFF, OFF
           ret = search.w3SetHighlight(collName, 0, 0);
       }
       // íì´ì§, ê¸°ë³¸ì ë ¬ ì¤ì 
       ret = search.w3SetPageInfo(collName, startPos, resultCnt);

       return ret;
   }

   /**
    * ê²ìí ê²°ê³¼ ë ì§/ìê° ë²ìë¥¼ ì§ì íê³ 
    * ììë ì§ì ì¢ë£ë ì§ì íìì´ YYYY/MM/DDê° ìëë¼ë©´
    * ë³ê²½í  ë¬¸ìë¥¼ ì¸ìë¡ ì§ì íë¤.
    * @param collectionName
    * @param startDate
    * @param endDate
    * @param replaceChr
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int setDateRange(String collectionName, String startDate,
           String endDate, String replaceChr) {
       // ë ì§ ì¡°ê±´ ì¸í
       int ret = 0;
       if (!startDate.equals("") && !endDate.equals("")) {
           startDate = replace(startDate, replaceChr, "/");
           endDate = replace(endDate, replaceChr, "/");
           ret = search.w3SetDateRange(collectionName, startDate, endDate);
       }
       return ret;
   }

   /**
    *
    * @param collectionName
    * @param field
    * @param matchType
    * @param boostID
    * @param boostKeyword
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int setBoostCategory(String collectionName,
           String field, String matchType, String boostKeyword) {
       return search.w3SetBoostCategory(collectionName, field, matchType, boostKeyword);
   }
	
   /**
    * ê²ìê²°ê³¼ìì ì¤ë³µë¬¸ì ì ë ¬ ê¸°ì¤ì ì¤ì íë¤.
    * @param collectionName Collection ëª
     * @param categoryGroup Category ê·¸ë£¹ì ë³´
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int addDuplicateDetectionCriterionField(String collection, String field, int nOrder) {        	
   	int ret = -1;
   	ret = search.w3AddDuplicateDetectionCriterionField(collection, field, nOrder);
       return ret;
   }
   
   
   /**
    * ê²ìê²°ê³¼ìì ì¤ë³µë¬¸ì ì ë ¬ ê¸°ì¤ì ì¤ì íë¤.
    * @param collectionName Collection ëª
     * @param categoryGroup Category ê·¸ë£¹ì ë³´
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int setDuplicateDetectionCriterionField(String collection, String fieldList ) {        	
   	int ret = -1;
   	ret = search.w3SetDuplicateDetectionCriterionField(collection, fieldList);
       return ret;
   }
   
   /**
    * ê²ìê²°ê³¼ í¨í·ì ì¹´íê³ ë¦¬ ì§ì  ì»¬ë ìì ì¹´íê³ ë¦¬ íëìì Depthë³ Categoryì ë¦¬ì¤í¸ë¥¼ í¬í¨ìí¨ë¤.
    * @param collectionName Collection ëª
     * @param categoryGroup Category ê·¸ë£¹ì ë³´
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int addCategoryGroupBy(String collectionName, String[] categoryGroup) {        	
   	int ret = -1;
       int length = categoryGroup.length;
       for(int i=0; i < length; i++) {
      		String[] dataFields = split(categoryGroup[i], ":");
			if(dataFields.length == 2){
				//depthList depthì listë¥¼ ì½¤ë§(:) ë¡ êµ¬ë¶íì¬ ìë ¥
				ret = search.w3AddCategoryGroupBy(collectionName, dataFields[0], dataFields[1]);
			}
       }
       return ret;
   }

    /**
    * ì íí ì»¬ë ì ë´ì ì í ì¹´íê³ ë¦¬ íëì ê°ì¼ë¡ ê²ìê²°ê³¼ë¥¼ íí°ë§ íë¤.
    * í¹ì ë¤ë¥¸ ì¿¼ë¦¬ìì´ ë³¸ì¿¼ë¦¬ë¥¼ ì¤ííë©´ í´ë¹ ì¹´íê³ ë¦¬ì ê°ì ë§¤ì¹ëë ë¬¸ìë¥¼ ì¶ë ¥íë¤.
    * @param collectionName Collection ëª
    * @param categoryQuery
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int addCategoryQuery(String collectionName, String[] categoryQuery) {
  		int ret = -1;
       int length = categoryQuery.length;
       for(int i=0; i < length; i++) {
      	String[] dataFields = split(categoryQuery[i], "|");
			if(dataFields.length == 2){
				ret = search.w3AddCategoryQuery(collectionName, dataFields[0], dataFields[1]);
			}
       }
       return ret;
   }

   /**
    * w3SetCategoryGroupByë¥¼ íµí´ í¨í·ì í¬í¨ë í´ë¹ collection-field-depthë¥¼ keyë¡ íë
     * ì¹´íê³ ë¦¬ì ì´ ê°ìë¥¼ ë°í
    * @param collectionName ê²ì ëì collectionëª
     * @param fieldName Category Field ëª
     * @param depth íì¬ ê·¸ë£¹ííì¬ ë³´ê³ ì íë depth
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int getCategoryCount(String collectionName, String field, int depth) {
       return search.w3GetCategoryCount(collectionName, field, depth);
   }

   /**
    * w3SetCategoryGroupByë¥¼ íµí´ í¨í·ì í¬í¨ë í´ë¹ collection-field-depthë¥¼ keyë¡ íë
     * ì¹´íê³ ë¦¬ ì¤ categoryIdxë²ì§¸ì ìì í ì¹´íê³ ë¦¬ ì´ë¦ì ë°í
    * @param collectionName ê²ì ëì collectionëª
     * @param fieldName Category Field ëª
     * @param depth íì¬ ê·¸ë£¹ííì¬ ë³´ê³ ì íë depth
     * @param idx í´ë¹ ì»¬ë ì-ì¹´íê³ ë¦¬-Depthì í´ë¹íë ì¹´íê³ ë¦¬ ê²°ê³¼ì ì¸ë±ì¤
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public String getCategoryName(String collectionName, String field, int depth, int idx){
       return search.w3GetCategoryName(collectionName, field, depth, idx);
   }

    /**
    * w3SetCategoryGroupByë¥¼ íµí´ í¨í·ì í¬í¨ë í´ë¹ collection-field-depthë¥¼ keyë¡ íë ì¹´íê³ ë¦¬ ì¤
     * categoryIdxë²ì§¸ì ì¹´íê³ ë¦¬ìì ëª ê°ì ë¬¸ìê° í¬í¨ëì´ìëì§(ê²ì ê²°ê³¼ë´ìì)ë¥¼ ë°í
    * @param collectionName ê²ì ëì collectionëª
     * @param fieldName Category Field ëª
     * @param depth íì¬ ê·¸ë£¹ííì¬ ë³´ê³ ì íë depth
     * @param idx í´ë¹ ì»¬ë ì-ì¹´íê³ ë¦¬-Depthì í´ë¹íë ì¹´íê³ ë¦¬ ê²°ê³¼ì ì¸ë±ì¤
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int getDocumentCountInCategory(String collectionName, String field, int depth, int idx){
       return search.w3GetDocumentCountInCategory(collectionName, field, depth, idx);
   }

   /**
   * í¹ì  íëì ê°ì ê¸°ì¤ì¼ë¡ ë²ì ë³ë¡ ê·¸ë£¹ì ë§ë¤ê±°ë, ì´ íë ê°ì´ í¹ì  ë²ìì ìíë ë ì½ëë§ ì¶ì¶
   * @ collectionName
   * @ field
   * @ min
   * @ max
   * @ groupCount
   */
   public int setPropertyGroup(String collectionName, String field, int min, int max, int groupCount) {
       int ret = 0;
       ret = search.w3SetPropertyGroup(collectionName, field, min, max, groupCount);
       return ret;
   }

   /**
    * v3.7ììë 2ê°ì ì ë¬ì¸ì v4.0ììë 3ê°ì ì ë¬ì¸ì
    * @param collectionName
    * @param field
    * @param docCount
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int setGroupBy(String collectionName, String field, int docCount) {
       int ret = 0;
       ret = search.w3SetGroupBy(collectionName, field, docCount);
       return ret;
   }

   /**
     * ë¨ìí ìµì¢ ê²°ê³¼ìì í¹ì  íë(ë¤)ê°ì ê·¸ë£¹íë ê²°ê³¼ë¥¼ ì»ì´ì¤ê¸° ìí  ë ì¬ì©
     * @param collectionName ì»¬ë ìëª
     * @param fieldName ê·¸ë£¹íí  íëëª
     * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int addMultiGroupBy(String collectionName, String fields) {
       int ret = 0;
       String[] field = split(fields, ",");
       int length = field.length;
       for(int i = 0; i < length; i++ ) {
           ret = search.w3AddMultiGroupBy(collectionName, field[i]);
       }
       return ret ;
   }

   public int setMultiGroupBy (String collectionName, String fields) {
       return search.w3SetMultiGroupBy(collectionName, fields);
   }

   /**
     * ë©í° ê·¸ë£¹ë°ì´ë ê²°ê³¼ë¥¼ ë°í
     * @param collectionName ì»¬ë ìëª
     * @param fieldName ê·¸ë£¹íí  íëëª
     * @return ì±ê³µ ì í´ë¹ ì»¬ë ì ê²°ê³¼ìì ì¸ìë¡ ì£¼ì´ì§ íëì ê·¸ë£¹í ê²°ê³¼ ë¬¸ìì´ì ë°ííë©°, ìë¬ ë°ìì ë¹ ë¬¸ìì´ì ë°í
    */
   public String getMultiGroupByResult(String collectionName, String field) {
       String ret = "";
       ret = search.w3GetMultiGroupByResult(collectionName, field);
       return ret ;
   }

   /**
    * ê·¸ë£¹ ê²ìê²°ê³¼ì ì ë ¬íëë¥¼ ì¤ì íë¤.
    * @param collectionName
    * @param sortField
    * @param sortOrder
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int addSortFieldInGroup(String collectionName, String sortField,
           int sortOrder) {
       int ret = 0;
       ret = search.w3AddSortFieldInGroup(collectionName, sortField,
               sortOrder);
       systemOut("[w3AddSortFieldInGroup] " + collectionName + " / "
               + sortField);
       return ret;
   }

   /**
    * ê·¸ë£¹ë´ì ë¬¸ìë¤ì ì ë ¬ ì ë³´ë¤ì ì§ì í´ ì£¼ë í¨ì
    * @param collectionName
    * @param sortValue url/DESC,RANK/DESC,DATE/ASC
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int setSortFieldInGroup(String collectionName, String sortValue) {
       int ret = 0;
       ret = search.w3SetSortFieldInGroup(collectionName, sortValue);
       systemOut("[w3SetSortFieldInGroup] " + collectionName + " / " + sortValue);
       return ret;
   }


   /**
    * ê¶í ì¿¼ë¦¬ (Authority Query)
    * @param collection
    * @param authTargetField
    * @param authCollection
    * @param authReferField
    * @param authorityQuery
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int setAuthorityQuery(String collection, String authTargetField,
           String authCollection, String authReferField, String authorityQuery ) {
       int ret = search.w3SetAuthorityQuery(collection, authTargetField,
               authCollection, authReferField, authorityQuery);
       systemOut("[w3SetAuthorityQuery]" + authorityQuery);
       return ret;
   }

   /**
    *
    * @param collectionName
    * @return ê²ìê¸°ë¡ë¶í° ë°ìì¨ ìì± ê·¸ë£¹ì ê°ìë¥¼ ë°í
    */
   public int getCountPropertyGroup(String collectionName) {
       return search.w3GetCountPropertyGroup(collectionName);
   }

   /**
    *
    * @param collectionName
    * @return ì ì²´ ê·¸ë£¹ ê°ì
    */
   public int getResultGroupCount(String collectionName) {
       return search.w3GetResultGroupCount(collectionName);
   }


   /**
    *
    * @param collectionName
    * @return ì ì²´ ê·¸ë£¹ ê°ì
    */
   public int getResultTotalGroupCount(String collectionName) {
       return search.w3GetResultTotalGroupCount(collectionName);
   }

   /**
    *
    * @param collectionName
    * @parma groupIndex
    * @return ê·¸ë£¹ì ìíë ë¬¸ì ì¤ ê°ì ¸ì¨ ë¬¸ì ê°ì
    */
   public int getCountInGroup(String collectionName, int groupIndex) {
       return search.w3GetCountInGroup(collectionName, groupIndex);
   }

   /**
    *
    * @param collectionName
    * @parma groupIndex
    * @return ê·¸ë£¹ì ìíë ì ì²´ë¬¸ì ê°ì
    */
   public int getTotalCountInGroup(String collectionName, int groupIndex) {
       return search.w3GetTotalCountInGroup(collectionName, groupIndex);
   }


   /**
    *
    * @param collectionName
    * @return ì±ê³µì í´ë¹ ìì± ê·¸ë£¹ì ìµìê°ì ë°ííë©°, ìë¬ ë°ìì ììë¥¼ ë°í
    */
   public int getMinValuePropertyGroup(String collectionName){
       return search.w3GetMinValuePropertyGroup(collectionName);
   }

   /**
    *
    * @param collectionName
    * @return ì±ê³µì í´ë¹ ìì± ê·¸ë£¹ì ìµëê°ì ë°ííë©°, ìë¬ ë°ìì ììë¥¼ ë°í
    */
   public int getMaxValuePropertyGroup(String collectionName){
       return search.w3GetMaxValuePropertyGroup(collectionName);
   }

   /**
    *
    * @param collectionName
    * @parma groupIndex
    * @return ì±ê³µì ìì± ê·¸ë£¹ ê²°ê³¼ì ìµìê°ì ë°ííë©°, ìë¬ ë°ìì ììë¥¼ ë°í
    */
   public int getMinValueInPropertyGroup(String collectionName, int groupIndex){
       return search.w3GetMinValueInPropertyGroup(collectionName, groupIndex);
   }

   /**
    *
    * @param collectionName
    * @parma groupIndex
    * @return ì±ê³µì ìì± ê·¸ë£¹ ê²°ê³¼ì ìµëê°ì ë°ííë©°, ìë¬ ë°ìì ììë¥¼ ë°í
    */
   public int getMaxValueInPropertyGroup(String collectionName, int groupIndex){
       return search.w3GetMaxValueInPropertyGroup(collectionName, groupIndex);
   }


   /**
    *
    * @param collectionName
    * @parma groupIndex
    * @return ì§ì ë ìì± ê·¸ë£¹ ë´ ë¬¸ìê°ìë¥¼ ë°í
    */
   public int getDocumentCountInPropertyGroup(String collectionName, int groupIndex){
       return search.w3GetDocumentCountInPropertyGroup(collectionName, groupIndex);
   }

   /**
    * ê·¸ë£¹íë ë¬¸ì ì¤ ì§ì ë ììì ê·¸ë£¹ ë´ìì ì£¼ì´ì§ collection ê²°ê³¼ ìì index ë²ì§¸ ë¬¸ìì Collection IDë¥¼ ë°í
    * @param collectionName
    * @param groupIndex
    * @param docIndex
    * @return ê·¸ë£¹ì ìíë ë¬¸ìì¤ ìíë ë¬¸ìì íëê°
    */
   public String getCollectionIdInGroup(String collectionName,	int groupIndex, int docIndex) {
       return search.w3GetCollectionIdInGroup(collectionName, groupIndex, docIndex);
   }

   /**
    *
    * @param collectionName
    * @param groupIndex
    * @param docIndex
    * @return ê·¸ë£¹ì ìíë ë¬¸ìì¤ ìíë ë¬¸ìì íëê°
    */
   public long getRankInGroup(String collectionName,	int groupIndex, int docIndex) {
       return search.w3GetRankInGroup(collectionName, groupIndex, docIndex);
   }

   /**
    *
    * @param collectionName
    * @param groupIndex
    * @param docIndex
    * @return ê·¸ë£¹ì ìíë ë¬¸ìì¤ ìíë ë¬¸ìì íëê°
    */
   public String getFieldInGroup(String collectionName, String fieldName,
           int groupIndex, int docIndex) {
       return search.w3GetFieldInGroup(collectionName, fieldName,
               groupIndex, docIndex);
   }

   /**
    *
    * @param collectionName
    * @param groupIndex
    * @param docIndex
    * @return ê·¸ë£¹ì ìíë ë¬¸ìì¤ ìíë ë¬¸ìì uidê°
    */
   public long getUidInGroup(String collectionName, int groupIndex,
           int docIndex) {
       return search.w3GetUidInGroup(collectionName, groupIndex, docIndex);
   }

   /**
    *
    * @param collectionName
    * @param groupIndex
    * @param docIndex
    * @return ê·¸ë£¹ì ìíë ë¬¸ìì¤ ìíë ë¬¸ìì ê°ì¤ì¹ ê°
    */
   public long getWeightInGroup(String collectionName, int groupIndex,
           int docIndex) {
       return search.w3GetWeightInGroup(collectionName, groupIndex,
               docIndex);
   }

   /**
    *
    * @param collectionName
    * @param groupIndex
    * @param docIndex
    * @return ê·¸ë£¹ì ìíë ë¬¸ìì¤ ìíë ë¬¸ìì ë ì§ ì ë³´
    */
   public String getDateInGroup(String collectionName, int groupIndex,
           int docIndex) {
       return search
               .w3GetDateInGroup(collectionName, groupIndex, docIndex);
   }

   /**
    *
    * @param collectionName
    * @param groupIndex
    * @param docIndex
    * @return ê·¸ë£¹ì ìíë ë¬¸ìì¤ ìíë ë¬¸ìì sc ì ë³´
    */
   public String getSearcherIdInGroup(String collectionName, int groupIndex,
           int docIndex) {
       return search.w3GetSearcherIdInGroup(collectionName, groupIndex, docIndex);
   }


   /**
    * v4.x í¸í method
    * v5.0ììë ì­ì ëìë¤.
    * íì´ë¼ì´íë  ë¬¸ìì´ì ë³´ì¬ì£¼ë í¨ìì´ë¤.
    * @return íì´ë¼ì´íë  ë¬¸ìì´
   public String getHighlightKeyword() {
       String keyWord = this.search.w3GetHighlightKeyword().trim();
       return keyWord;
   }
    */

   /**
    * ííì ë¶ìë ê²°ê³¼ ë¬¸ìì´ì ë³´ì¬ì£¼ë í¨ìì´ë¤.
    * @param colName
    * @param field
    * @return íì´ë¼ì´íë  ë¬¸ìì´
    */
   public String getHighlightKeywordByField(String colName,
           String searchField) {
       String keyWord = this.search.w3GetHighlightByField(colName,
               searchField);
       return keyWord;
   }

   /**
    *
    * @param collectionName
    * @return ê²ìê²°ê³¼ ê°ì
    */
   public int getResultCount(String collectionName) {
       return search.w3GetResultCount(collectionName);
   }

   /**
    *
    * @param collectionName
    * @return ê²ìê²°ê³¼ ì´ ê°ì
    */
   public int getResultTotalCount(String collectionName) {
       return search.w3GetResultTotalCount(collectionName);
   }


   /**
    *
    * @param collectionName
    * @param idx
    * @return ê²ìí í´ë¹ ë¬¸ìì ì¤ë³µë¬¸ì ê°ìë¥¼ ë°í
    */
   public int getDuplicateDocumentCount(String collectionName, int idx) {
       return search.w3GetDuplicateDocumentCount(collectionName, idx);
   }

   /**
    *
    * @param collectionName
    * @param groupIndex
    * @param docIndex
    * @return ê·¸ë£¹íë ë¬¸ì ì¤ ì§ì ë ììì ê·¸ë£¹ ë´ìì ê° ê²°ê³¼ë¤ì´ ì¤ë³µë ë¬¸ìì ê°ìë¥¼ ë°í
    */
   public int getDuplicateDocumentCountInGroup(String collectionName, int groupIndex,
           int docIndex) {
       return search.w3GetDuplicateDocumentCountInGroup(collectionName, groupIndex, docIndex);
   }

   /**
    * ìµê·¼ì ê²ìë í¤ìëë¦¬ì¤í¸ë¥¼ ë°ííë¤.
    * @param count
    * @return ìµê·¼ì ê²ìë í¤ìëë¦¬ì¤í¸
    */
   public String[] receiveRecentQueryListResult(int mode, int count) {
       int ret = search.w3ReceiveRecentQueryListResult(mode, count);
       if( ret < 0 ){
           systemOut("[W3ReceiveRecentQueryListResult] " + search.w3GetErrorInfo() + ", ret=" + ret);
           return null;
       }
       int size = search.w3GetRecentQueryListSize();
       String[] keyList = new String[size];
       for(int i=0; i<size; i++ ){
           keyList[i] = search.w3GetRecentQuery(i);
       }
       return keyList;
   }

   /**
    * ìµê·¼ì ê²ìë í¤ìëë¦¬ì¤í¸ë¥¼ ë°ííë¤.
    * @param count
    * @return ìµê·¼ì ê²ìë í¤ìëë¦¬ì¤í¸
    */
   public int receiveRecentQueryListResultAsXml(int mode, int count) {
       int ret = search.w3ReceiveRecentQueryListResultAsXml(mode, count);
       if( ret < 0 ){
           systemOut("[w3ReceiveRecentQueryListResultAsXml] " + search.w3GetErrorInfo() + ", ret=" + ret);
           return -1;
       }
       return ret;
   }

   /**
    * ìµê·¼ì ê²ìë í¤ìëë¦¬ì¤í¸ë¥¼ ë°ííë¤.
    * @param count
    * @return ìµê·¼ì ê²ìë í¤ìëë¦¬ì¤í¸
    */
   public int receiveRecentQueryListResultAsJson(int mode, int count) {
       int ret = search.w3ReceiveRecentQueryListResultAsJson(mode, count);
       if( ret < 0 ){
           systemOut("[w3ReceiveRecentQueryListResultAsJson] " + search.w3GetErrorInfo() + ", ret=" + ret);
           return -1;
       }
       return ret;
   }


   /**
   */
   public String getSuggestedQuery() {
       return search.w3GetSuggestedQuery();
   }

   /**
    * v4.x í¸í method
    * @param mode
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    * @deprecated  As of v4.x, replaced by
    * {@link #receiveSearchQueryResult(int)}
    */
   public int recvResult(int mode) {
       int ret = search.w3ReceiveSearchQueryResult(mode);
       return ret;
   }

   /**
   *
   */
   public int recvDuplicateDocumentsResult(int mode) {
       int ret = search.w3ReceiveDuplicateDocumentsResult(mode);
       return ret;
   }

   /**
   *
   */
   public int recvDuplicateDocumentsResultAsJson(int mode) {
       int ret = search.w3ReceiveDuplicateDocumentsResultAsJson(mode);
       return ret;
   }

   /**
   *
   */
   public int recvDuplicateDocumentsResultAsXml(int mode) {
       int ret = search.w3ReceiveDuplicateDocumentsResultAsXml(mode);
       return ret;
   }


   /**
    *
    * @param mode
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int receiveSearchQueryResult(int mode) {
       int ret = search.w3ReceiveSearchQueryResult(mode);
       return ret;
   }

   /**
    *
    * @param mode
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int receiveSearchQueryResultAsXml(int mode) {
       int ret = search.w3ReceiveSearchQueryResultAsXml(mode);
       return ret;
   }


   /**
    *
    * @param mode
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int receiveSearchQueryResultAsJson(int mode) {
       int ret = search.w3ReceiveSearchQueryResultAsJson(mode);
       return ret;
   }

   /**
    *
    * @return ì±ê³µì´ë©´ ê²ìê²°ê³¼ë¥¼ XMLë¡ ë°ííë¤.
    */
   public String getResultXml() {
       String ret = search.w3GetResultXml();
       return ret;
   }

   /**
    *
    * @return ì±ê³µì´ë©´ ê²ìê²°ê³¼ë¥¼ JSON dataë¡ ë°ííë¤.
    */
   public String getResultJson() {
       String ret = search.w3GetResultJson();
       return ret;
   }

   /**
    * UID ê²ìì ê²ìê¸°ì ì ë¬íê³ , ê²°ê³¼ë¥¼ ë°ë í¨ìì´ë¤.
    * v4.x í¸í method
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    * @deprecated  As of v4.x, replaced by
    * {@link #receiveUidResult(int)}
    */
   public int recvDocument(int mode) {
       int ret = search.w3ReceiveUidResult(mode);
       return ret;
   }

   /**
    * UID ê²ìì ê²ìê¸°ì ì ë¬íê³ , ê²°ê³¼ë¥¼ ë°ë í¨ìì´ë¤.
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int receiveUidResult(int mode) {
       int ret = search.w3ReceiveUidResult(mode);
       return ret;
   }

   /**
    * UID ê²ìì ê²ìê¸°ì ì ë¬íê³ , ê²°ê³¼ë¥¼ ë°ë í¨ìì´ë¤.
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int receiveUidResultAsXml(int mode) {
       int ret = search.w3ReceiveUidResultAsXml(mode);
       return ret;
   }

   /**
    * UID ê²ìì ê²ìê¸°ì ì ë¬íê³ , ê²°ê³¼ë¥¼ ë°ë í¨ìì´ë¤.
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int receiveUidResultAsJson(int mode) {
       int ret = search.w3ReceiveUidResultAsJson(mode);
       return ret;
   }

   /**
    * v4.x í¸í method
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    * @deprecated  As of v4.x, replaced by
    * {@link #receiveMorphemeAnalysisResult(int)}
    */
   public int recvAnalyzedQuery(int mode) {
       int ret = search.w3ReceiveMorphemeAnalysisResult(mode);
       return ret;
   }

   /**
    *
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int receiveMorphemeAnalysisResult(int mode) {
       int ret = search.w3ReceiveMorphemeAnalysisResult(mode);
       return ret;
   }

   /**
    *
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int receiveMorphemeAnalysisResultAsXml(int mode) {
       int ret = search.w3ReceiveMorphemeAnalysisResultAsXml(mode);
       return ret;
   }

   /**
    *
    * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
    */
   public int receiveMorphemeAnalysisResultAsJson(int mode) {
       int ret = search.w3ReceiveMorphemeAnalysisResultAsJson(mode);
       return ret;
   }


   /**
    * ì£¼ì´ì§ collection ê²°ê³¼ ìì index ë²ì§¸ ë¬¸ìì Collection IDë¥¼ ë°ííë¤.
    * @param coll
    * @param idx
    * @return FIELD VALUE
    */
   public String getCollectionId(String coll, int idx) {
       return search.w3GetCollectionId(coll, idx);
   }

   /**
    *
    * @param coll
    * @param field
    * @param idx
    * @return FIELD VALUE
    */
   public String getField(String coll, String field, int idx) {
       return search.w3GetField(coll, field, idx);
   }

   /**
    *
    * @param coll
    * @param idx
    * @return DATE
    */
   public String getDate(String coll, int idx) {
       return search.w3GetDate(coll, idx);
   }

   /**
    *
    * @param coll
    * @param idx
    * @return DATE
    */
   public long getWeight(String coll, int idx) {
       return search.w3GetWeight(coll, idx);
   }

   /**
    *
    * @param coll
    * @param idx
    * @return RANK
    */
   public long getRank(String coll, int idx) {
       return search.w3GetRank(coll, idx);
   }

   /**
    *
    * @param coll
    * @param idx
    * @return UID
    */
   public long getUid(String coll, int idx) {
       return search.w3GetUid(coll, idx);
   }

   /**
    *
    * @param coll
    * @param idx
    * @return SearcherId
    */
   public String getSearcherId(String coll, int idx) {
       return search.w3GetSearcherId(coll, idx);
   }

   /*
     * ì¬ë¬ ì»¬ë ìì ê²ìê²°ê³¼ë¥¼ íëì ê°ì ì»¬ë ì(Merge Collection) ê²°ê³¼ë¡ íµí©íì¬ ê°ì ¸ì¤ê¸° ìí  ë ì¬ì©íë í¨ì
     * @param mergeCollection íµí© ê°ì ì»¬ë ìëª
     * @param collections[] (íµí©ëì) ì»¬ë ìëª
     * @param start (ê²°ê³¼ ì¤) ìì ë¬¸ì ì¸ë±ì¤
     * @param count (ê²°ê³¼ ì¤) ê°ì ¸ì¬ ë¬¸ì ê°ì
     * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
     */
   public int addMergeCollectionInfo(String mergeCollection, String[] collections, int start, int count ){
       int collectionLen = collections.length;
       int ret = 0;

       for(int i=0; i < collectionLen; i++) {

           ret = search.w3AddMergeCollection(mergeCollection, collections[i]);
       }

       ret = search.w3SetMergePageInfo(mergeCollection, start, count);

       return ret;
   }

   /*
     * íµí© ì»¬ë ì(Merge Collection)ì ê²°ê³¼ íë(Document Field)ì íµí©ë  ê°ë³ ì»¬ë ìì ê²°ê³¼ íëë¥¼ 1:N ( 0 < N < 64 ) ê´ê³ë¡ ì°ê²°ìí¨ë¤
     * @param mergeCollection íµí© ê°ì ì»¬ë ìëª
     * @param mergeFields[] ê°ì íµí© ì»¬ë ìì ê²°ê³¼ íëëª
     * @param collections[] (íµí©ëì) ì»¬ë ìëª
     * @param fields[,] (íµí©ëì) ì»¬ë ìì ê²°ê³¼ íëëª
     * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
     */
   public int addMergeDocumentField(String mergeCollection, String[] mergeFields, String[] collections, String[][] fields) {
       int ret = 0;
       int collectionLen = collections.length;
       int fieldsLen = mergeFields.length;

       for(int i=0; i < collectionLen; i++) {

           for(int j=0; j<fieldsLen; j++) {
               ret = search.w3AddMergeDocumentField(mergeCollection, mergeFields[j], collections[i], fields[i][j]);
           }
       }
       return ret;
   }

     /*
      * w3AddMergeDocumentField í¨ìê° íµí© ì»¬ë ìì ê²°ê³¼ íëë¥¼ ì ì íìë¤ë©´, ì´ í¨ìë íµí© ì»¬ë ìì
      * MultiGroupBy íëëªì ì ì ë° ê°ë³ ì»¬ë ìì MultiGroupBy íëëªê³¼ ì°ê²°ìí¤ë ì­í 
      * @param mergeCollection íµí© ê°ì ì»¬ë ìëª
      * @param mergeFields[] ê°ì íµí© ì»¬ë ìì ê²°ê³¼ íëëª
      * @param collections[] (íµí©ëì) ì»¬ë ìëª
      * @param fields[,] (íµí©ëì) ì»¬ë ìì ê²°ê³¼ íëëª
      * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
      */
   public int addMergeMultiGroupByField(String mergeCollection, String[] mergeFields, String[] collections, String[][] fields) {
       int ret = 0;
       int collectionLen = collections.length;
       int fieldsLen = mergeFields.length;
       for(int i=0; i < collectionLen; i++) {
           for(int j=0; j<fieldsLen; j++) {
               ret = search.w3AddMergeMultiGroupByField(mergeCollection, mergeFields[j], collections[i], fields[i][j]);
           }
       }
       return ret;
   }

   /*
     * íµí© ì»¬ë ìì CategoryGroupBy íëëªì ì ì ë° ê°ë³ ì»¬ë ìì
     * CategoryGroupBy íëëªê³¼ ì°ê²°ìí¤ë ì­í 
     * @param mergeCollection íµí© ê°ì ì»¬ë ìëª
     * @param mergeFields[] ê°ì íµí© ì»¬ë ìì ê²°ê³¼ íëëª
     * @param collections[] (íµí©ëì) ì»¬ë ìëª
     * @param fields[,] (íµí©ëì) ì»¬ë ìì ê²°ê³¼ íëëª
     * @return ì±ê³µì´ë©´ 0ì ë°ííë¤. ì¤í¨ë©´ 0ì´ ìë ê°ì ë°ííë¤.
     */
   public int addMergeCategoryGroupByField(String mergeCollection, String[] mergeFields, String[] collections, String[][] fields) {
       int ret = 0;
       int collectionLen = collections.length;
       int fieldsLen = mergeFields.length;
       for(int i=0; i < collectionLen; i++) {
           for(int j=0; j<fieldsLen; j++) {
               ret = search.w3AddMergeCategoryGroupByField(mergeCollection, mergeFields[j], collections[i], fields[i][j]);
           }
       }
       return ret;
   }

   /*
     * ê²ìê¸°ìì ë°ìì¬ íµí© ì»¬ë ì(Merge Collection) ê²°ê³¼ì ìì ì¸ë±ì¤ì ë¬¸ì ê°ìë¥¼ ì¤ì 
     * CategoryGroupBy íëëªê³¼ ì°ê²°ìí¤ë ì­í 
     * @param mergeCollection íµí© ê°ì ì»¬ë ìëª
     * @param collections (íµí©ëì) ì»¬ë ìëª
     *
     * @return ë¬¸ì ê°ì ë°ííë¤.
     */
   public int getResultTotalCountInMerge(String mergeCollection, String collection){
       return search.w3GetResultTotalCountInMerge(mergeCollection, collection);
   }

   /**
    * ë¤í¸ìí¬ ì¢ë£
    */
   public void closeServer() {
       if (search != null) {
           search.w3CloseServer();
           search = null;
       }
   }

   /**
    * ì¸ìë¡ ì ë¬ë°ì collectionì ê²ìê²°ê³¼ì ìë¬ê° ë°ìíë©´ ìë¬ ì½ëì ë©ìì§ë¥¼ ë°ííë¤.
    * @param collectionName
    * @return
    */
   public String getCollectionErrorInfo(String collectionName) {
       String errorMsg = "";
       int errorCode = search.w3GetCollectionError(collectionName);
       if (errorCode != 0) {
           errorMsg = search.w3GetCollectionErrorInfo(collectionName);
           errorMsg = errorMsg + "(<b>code:<font color='red'>" + errorCode
                   + "</font></b>)";
       }
       return errorMsg;
   }



   /**
    * ê²ìê²°ê³¼ì ìë¬ê° ë°ìíë©´ ìë¬ ì½ëì ë©ìì§ë¥¼ ë°ííë¤.
    * @return
    */
   public String getErrorInfo() {
       String errorMsg = "";
       int errorCode = search.w3GetError();
       if (errorCode != 0) {
           errorMsg = search.w3GetErrorInfo();
           errorMsg = errorMsg + "(<b>code:<font color='red'>" + errorCode
                   + "</font></b>)";
       }
       return errorMsg;
   }

   /**
    * ê²ì apiì ë²ì ì ë³´ë¥¼ ë°ííë¤.
    * @return
    */
   public String getVersionInfo() {
       return search.w3GetVersionInfo();
   }



   /**
    * ìë¬ ì½ëì ëí ìë¬ì ë³´ë¥¼ web applicationì standard out logì ì¶ë ¥íë¤.
    * @param msg
    */
   public void systemOut(String msg) {
       if (out != null && isDebug) {
           try {
               out.println(msg + "<br>");
           } catch (IOException e) {
               e.printStackTrace();
           }
       }
   }
}
%>