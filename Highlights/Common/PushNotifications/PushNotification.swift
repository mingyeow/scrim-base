//
//  PushNotification.swift
//  Highlights
//
//  Created by ming yeow ng on 1/26/17.
//  Copyright © 2017 Meow. All rights reserved.
//

import Foundation

import Foundation

struct PushNotification {
  enum NotificationType {
    case Users
    
    static func getType(string: String) -> NotificationType? {
      switch string {
      case "users":
        return .Users
      default:
        return nil
      }
    }
  }
  
  let notificationType: NotificationType
  var userID: Int?
  var highlightID:Int?
  var bookISBN:Int?
  let payload: [String : AnyObject]
  
  init?(userInfo: [String : AnyObject]) {
    payload = userInfo
    
    guard let typeString = (userInfo["type"] as? String) else { return nil }
    guard let type = NotificationType.getType(string: typeString) else { return nil }
    
    self.notificationType = type
    
    switch (self.notificationType) {
    case .Users:
      guard let uid = (userInfo["user_id"] as? Int) else {
        return nil
      }
      self.userID = uid
    }
  }
  
  init?(url: NSURL){
    
    payload = [:]
    
    guard let typeString = url.getQueryItemValueForKey(key: "type") else { return nil }
    guard let type = NotificationType.getType(string: typeString) else { return nil }
    
    self.notificationType = type
    
    switch (self.notificationType) {
    case .Users:
      guard let uidString = url.getQueryItemValueForKey(key: "user_id") else {
        return nil
      }
      guard let uid = Int(uidString) else {
        return nil
      }
      self.userID = uid
      
    }
  }
  
  init?(branchPayload: [String : AnyObject]){
    
    payload = [:]
    
    guard let typeString = (branchPayload["linkType"] as? String) else { return nil }
    guard let type = NotificationType.getType(string: typeString) else { return nil }
    
    self.notificationType = type
    
    switch (self.notificationType) {
    case .Users:
      guard let uidString = (branchPayload["user_id"] as? String) else {
        return nil
      }
      guard let uid = Int(uidString) else {
        return nil
      }
      self.userID = uid
    }
  }
}
