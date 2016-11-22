class Predictor {
  

  String[] getPrediction(String prefix){
    JSONArray P;
    String[] Words;
    try{
      println("prevWord ==" + prevWord);
      JSONObject O = twoWordDict.getJSONObject(prevWord);
      println("here...");
      P = O.getJSONArray(prefix);
      println("here!");
      Words = P.getStringArray();
      while(Words.length < 3){
        Words[Words.length] = "";
      }
      for(int i = 0; i < Words.length; i ++){
        println("here!!");
        println(Words[i]);
      }
      return Words;
    } catch (RuntimeException e) {
      try{
        println("here :(");
        P = wordDict.getJSONArray(prefix);
        Words = P.getStringArray();
        while(Words.length < 3){
          Words[Words.length] = "";
        }
        for(int i = 0; i < Words.length; i ++){
          println(Words[i]);
        }
        return Words;
      } catch (RuntimeException ex) {
        String A[] = new String[3];
        A[0] = "";
        A[1] = "";
        A[2] = "";
        return A;
      }
    }
  }
  
  String getLastWord(String s){
    int stringlen = s.length();
    if(stringlen <= 0 || s.charAt(stringlen - 1) == ' '){
      return "";
    }
    String[] wordList = s.split("\\s+");
    return wordList[wordList.length-1];
  }
  
  String getSecondToLastWord(String s){
    int stringlen = s.length();
    if(stringlen <= 0 || s.charAt(stringlen - 1) == ' '){
      return "";
    }
    String[] wordList = s.split("\\s+");
    if(wordList.length <= 1){
      return "";
    } else {
      return wordList[wordList.length-2];
    }
  }
  
}