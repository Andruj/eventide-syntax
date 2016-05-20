part of services;

/// A [RestService] that uses the [Location] model for reflection.
///
/// The [LocationService] calls the [RestService]'s constructor with the
/// [Type] [Location] to have it's [Location.fromMap] constructor, which is
/// inherited from [Mappable].
@Injectable()
class LocationService extends Service
  /// The path used by the [RestService] for API requests.
  static const String path = '/api/locations';
  Location fresh = new Location();
  List<Location> cache = [];

  Future all({Object query: ''}) async {
    cache = [];
    return _wrap(_decode(await HttpRequest.getString('$path$query')))
        .map((Map data) => new Location.fromMap(data))
        .map((loc) {
      cache.add(loc);

      return loc;
    }).toList();
  }

  Future<Location> one(String id) async {
    return new Location.fromMap(
        _decode(await HttpRequest.getString('$path/$id')));
  }

  Future<Location> save(Location location) async {
    final json = JSON.encode(location.toMap());
    final response =
        await HttpRequest.request(path, method: 'POST', sendData: json);
    return new Location.fromMap(JSON.decode(response.responseText));
  }

  Future<Location> update(Location location) async {
    final json = JSON.encode(location.toMap());
    final response = await HttpRequest.request('$path/${location.id}',
        method: 'PUT', sendData: json);
    return new Location.fromMap(JSON.decode(response.responseText));
  }

  _decode(String data) => JSON.decode(data);
  _wrap(Object data) => data is List ? data : [data];
}
