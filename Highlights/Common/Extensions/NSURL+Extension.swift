//
//  NSURL+Extension.swift
//  Spark
//
//  Created by ming yeow ng on 10/21/16.
//
//

import Foundation

extension NSURL {
  func getQueryItemValueForKey(key: String) -> String? {
    guard let components = NSURLComponents(url: self as URL, resolvingAgainstBaseURL: false) else {
      return nil
    }
    
    guard let queryItems = components.queryItems else { return nil }
    return queryItems.filter {
      $0.name == key
      }.first?.value
  }
}
