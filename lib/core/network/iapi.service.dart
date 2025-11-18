abstract class IApiService {
  /// GET qui retourne une liste (ex: /wallets)
  Future<List<dynamic>> get(String endpoint);

  /// GET qui retourne un objet unique (ex: /users/{id})
  Future<Map<String, dynamic>> getObject(String endpoint);

  /// GET par chemin dynamique (ex: /wallets/{id})
  Future<Map<String, dynamic>> getByPath(String resource, String value);

  /// GET par chemin dynamique qui retourne une liste (ex: /users/{id}/wallets)
  Future<List<dynamic>> getListByPath(String resource, String value);

  /// POST
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data);

  /// PUT
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data);

  /// DELETE
  Future<void> delete(String endpoint);

  /// GET raw data (SVG, images, etc.)
  Future<String> getRaw(String endpoint);
}
