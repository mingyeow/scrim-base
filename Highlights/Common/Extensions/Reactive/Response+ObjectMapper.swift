import Foundation
import Moya
import ObjectMapper

public extension Response {
  
  typealias JSONDictionary = [String: Any]
  
  func mapObject<T: BaseMappable>(type: T.Type, keyPath: String) throws -> T {
    guard let jsonDictionary = try mapJSON() as? JSONDictionary else {
      throw MoyaError.jsonMapping(self)
    }
    guard let jsonDictionaryAtKeyPath = jsonDictionary[keyPath] as? JSONDictionary else {
      throw MoyaError.jsonMapping(self)
    }
    guard let object = Mapper<T>().map(JSON: jsonDictionaryAtKeyPath) else {
      throw MoyaError.jsonMapping(self)
    }
    return object
  }
  
  internal func mapArray<T: BaseMappable>(type: T.Type, keyPath: String) throws -> ([T], Pagination?) {
    guard let jsonDictionary = try mapJSON() as? JSONDictionary else {
      throw MoyaError.jsonMapping(self)
    }
    guard let jsonDictionaryAtKeyPath = jsonDictionary[keyPath] as? [JSONDictionary] else {
      throw MoyaError.jsonMapping(self)
    }
    guard let objects = Mapper<T>().mapArray(JSONArray: jsonDictionaryAtKeyPath) else {
      throw MoyaError.jsonMapping(self)
    }
    return (objects, nil)
  }
  
}
