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
