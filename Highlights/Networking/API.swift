//
//  API.swift
//  Highlights
//
//  Created by ming yeow ng on 1/27/17.
//  Copyright © 2017 Meow. All rights reserved.
//

import Foundation
import Moya

private extension String {
  var URLEscapedString: String {
    return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlHostAllowed)!
  }
}

enum API {
  // Users
  case GetMe
  case UpdateDeviceToken(deviceToken: String)
}

extension API: TargetType {

  var baseURL: URL {
    let buildConfiguration = container.resolve(BuildConfiguration.self)!
    return NSURL(string: buildConfiguration.apiEndpoint)! as URL
  }
  
  var path: String {
    switch self {
    case .GetMe:
      return "/v1/info/me"
    case .UpdateDeviceToken:
      return "/v1/info"
      
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .GetMe:
      return .get
    case .UpdateDeviceToken:
      return .put
    }
  }
  
  var parameters: [String: Any]? {
    switch self {
    case .GetMe:
      return nil
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
    case .GetMe, .UpdateDeviceToken:
      return .request
    }
  }
  
  var sampleData: Data {
    return Data()
  }
}

