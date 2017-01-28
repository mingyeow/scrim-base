//
//  Preferences.swift
//  Highlights
//
//  Created by ming yeow ng on 1/25/17.
//  Copyright © 2017 Meow. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import ObjectMapper
import Toaster
import Amplitude_iOS

extension DefaultsKeys {
  static let user = DefaultsKey<String?>("userKey")
  static let userState = DefaultsKey<Int?>("userStateKey")
}

final class Preferences {
  
  let buildConfiguration = container.resolve(BuildConfiguration.self)!
  
  enum UserState: Int {
    case loggedOut
    case loggedIn
  }
  
  var user: User? {
    get {
      if let userDictionary = Defaults[.user] {
        return Mapper<User>().map(JSONString: userDictionary)
      } else {
        return nil
      }
    }
    set(newValue) {
      if let newValue = newValue {
        Defaults[.user] = Mapper().toJSONString(newValue, prettyPrint: true)
      } else {
        Defaults[.user] = nil
      }
      updateAmplitudeUserId()
    }
  }
  
  var userState: UserState {
    get {
      guard let stateInt = Defaults[.userState] else {
        return buildConfiguration.startingState
      }
      guard let state = Preferences.UserState(rawValue: stateInt) else {
        return buildConfiguration.startingState
      }
      return state
    }
    set(newValue) {
      Defaults[.userState] = newValue.rawValue
    }
  }
  
  init() {
  }
  
  // MARK: - Public
  
  func updateAmplitudeUserId() {
    let amplitudeInstance = Amplitude.instance()
    if let user = self.user {
      amplitudeInstance?.setUserId("\(user.id)")
    } else {
      amplitudeInstance?.clearUserProperties()
    }
  }
  
  func loginUser(user: User) {
    self.user = user
    userState = .loggedIn
  }
  
  func updateUser(user: User) {
    self.user = user
  }
  
  func logoutUser() {
    self.user = nil
    userState = .loggedOut
  }
  
}
