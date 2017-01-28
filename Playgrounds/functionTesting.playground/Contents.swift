//: Playground - noun: a place where people can play

import XCPlayground
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Moya
import ObjectMapper
import Swinject


let container = Container()


enum API {
  // Users
  case GetMe
  case UpdateDeviceToken(deviceToken: String)
  case GetSearchUsers(searchTerm: String)
}

extension API: TargetType {
  
  var baseURL: URL {
    return NSURL(string: "https://answer-api.herokuapp.com/")! as URL
  }
  
  var path: String {
    switch self {
    case .GetMe:
      return "/v1/info/me"
    case .UpdateDeviceToken:
      return "/v1/info"
    case .GetSearchUsers:
      return "/v1/users/search"
      
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .GetMe, .GetSearchUsers:
      return .get
    case .UpdateDeviceToken:
      return .put
    }
  }
  
  var parameters: [String: Any]? {
    switch self {
    case .GetMe:
      return nil
    case .GetSearchUsers(let searchTerm):
      return ["user_search_term": searchTerm]
    case .UpdateDeviceToken(let deviceToken):
      return ["user": [
        "device_token": deviceToken
        ]
      ]
    }
  }
  
  var multipartBody: [MultipartFormData]? {
    switch self {
    default:
      return nil
    }
  }
  
  public var parameterEncoding: ParameterEncoding {
    return URLEncoding.default
  }
  
  /// The type of HTTP task to be performed.
  var task: Task {
    switch self {
    case .GetMe, .UpdateDeviceToken, .GetSearchUsers:
      return .request
    }
  }
  
  var sampleData: Data {
    return Data()
  }
}

import Foundation
import UIKit
import ObjectMapper
import RxSwift

struct User: Mappable, Equatable {
  
  struct Defaults {
    // User Defaults
    static var id: Int  = 0
    static var name: String  = "A User"
    static var avatarUrl: String  = "https://avatars2.githubusercontent.com/u/19230016"
  }
  
  var id: Int = Defaults.id
  var name: String = Defaults.name
  var username: String = ""
  
  /// The number of followers the receiver has.
  var followersCount: Int = 0
  /// The number of people the receiver is following.
  var followCount: Int = 0
  /// `true` if the current user is following the receiver.
  var following: Bool = false
  
  // Authenticated user only attributes
  var email: String = ""
  var authenticationToken: String = ""
  
  var avatarUrl: String = Defaults.avatarUrl
  var avatarOriginalUrl: String = Defaults.avatarUrl
  var avatarThumbUrl: String = Defaults.avatarUrl
  
  var avatarNSURL: NSURL { return NSURL(string: avatarUrl)! }
  var avatarOriginalNSURL: NSURL { return NSURL(string: avatarOriginalUrl)! }
  var avatarThumbNSURL: NSURL { return NSURL(string: avatarThumbUrl)! }
  
  init?(map: Map) {}
  
  mutating func mapping(map: Map) {
    id <- map["id"]
    name <- map["name"]
    username <- map["username"]
    
    following <- map["following"]
    followersCount <- map["followers_count"]
    followCount <- map["follow_count"]
    
    email <- map["email"]
    authenticationToken <- map["authentication_token"]
    
    avatarUrl <- map["avatar_url"]
    avatarOriginalUrl <- map["avatar_original_url"]
    avatarThumbUrl <- map["avatar_thumb_url"]
  }
  
  init() {}
}

func ==(lhs: User, rhs: User) -> Bool {
  return lhs.id == rhs.id
}



struct Pagination: Mappable {
  var currentPage: Int = 0
  var nextPage: Int = 0
  var prevPage: Int = 0
  var totalPages: Int = 0
  var totalCount: Int = 0
  
  init?(map: Map) {}
  
  mutating func mapping(map: Map){
    currentPage <- map["current_page"]
    nextPage <- map["next_page"]
    prevPage <- map["prev_page"]
    totalPages <- map["total_pages"]
    totalCount <- map["total_count"]
  }
}


typealias JSONDictionary = [String: Any]

private extension String {
  var URLEscapedString: String {
    return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlHostAllowed)!
  }
}

let endpointClosure = { (target: API) -> Endpoint<API> in
  let url = target.baseURL.appendingPathComponent(target.path).absoluteString
  let endpoint: Endpoint<API> = Endpoint<API>(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
  
  return endpoint.adding(newHTTPHeaderFields: [
    "Authorization": "Token token=\"Phu1MtlkvV7/7PiYLI99zYgooXzCb/7MfFbc+JQw4QD705e9k5bwHIfw7aGTZUhjtlXsjCYoWjFpLdtezVv/Xw=="
    ])
}


extension ObservableType where E == Response {
  
  /// Maps data received from the signal into an object
  /// which implements the Mappable protocol and returns the result back
  /// If the conversion fails, the signal errors.
  public func mapObject<T: BaseMappable>(type: T.Type, keyPath: String) -> Observable<T> {
    return flatMap { response -> Observable<T> in
      return Observable.just(try response.mapObject(type: T.self, keyPath: keyPath))
    }
  }
  
  /// Maps data received from the signal into an array of objects
  /// which implement the Mappable protocol and returns the result back
  /// If the conversion fails, the signal errors.
  func mapArray<T: BaseMappable>(type: T.Type, keyPath: String) -> Observable<([T])> {
    return flatMap { response -> Observable<[T]> in
      return Observable<([T])>.just(try response.mapArray(type: T.self, keyPath: keyPath))
    }
  }
}

extension Response {

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

  func mapArray<T: BaseMappable>(type: T.Type, keyPath: String) throws -> ([T]) {
    guard let jsonDictionary = try mapJSON() as? JSONDictionary else {
      throw MoyaError.jsonMapping(self)
    }
    guard let jsonDictionaryAtKeyPath = jsonDictionary[keyPath] as? [JSONDictionary] else {
      throw MoyaError.jsonMapping(self)
    }
    guard let objects = Mapper<T>().mapArray(JSONArray: jsonDictionaryAtKeyPath) else {
      throw MoyaError.jsonMapping(self)
    }
    return objects
  }
  
}



let apiProvider = RxMoyaProvider<API>(endpointClosure: endpointClosure, plugins: [NetworkLoggerPlugin()])

apiProvider.request(.GetSearchUsers(searchTerm: "b"))
  .mapArray(type: User.self, keyPath: "users")
  .subscribe(
  onNext: { user in
    print("SUCCESS")
    print(user)
  },
  onError: { error in
    print("ERROR")
    print (error)
  }
)
 