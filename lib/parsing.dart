String xWwwFormUrlencoded(Map<String,dynamic> parameters){
  List<String> keyValuePairs = [];
  for(String key in parameters.keys){
    keyValuePairs.add("$key=${parameters[key]}");
  }
  return keyValuePairs.join("&");
}