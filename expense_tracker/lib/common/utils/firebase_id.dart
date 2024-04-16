Map<String, dynamic> withoutId(Map<String, dynamic> json) {
  json.remove('id');
  return json;
}

Map<String, dynamic> withId(Map<String, dynamic> json, String id) {
  json['id'] = id;
  return json;
}
