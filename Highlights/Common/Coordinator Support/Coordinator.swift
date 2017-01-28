//
//  Coordinator.swift
//  Highlights
//
//  Created by ming yeow ng on 1/25/17.
//  Copyright © 2017 Meow. All rights reserved.
//

/**
 Coordinator Pattern
 
 Learn more:
 - https://vimeo.com/144116310
 - http://khanlou.com/2015/10/coordinators-redux/
 - http://khanlou.com/2015/01/the-coordinator/
 */
public protocol Coordinator: class {
}

public struct CoordinatorArray: ExpressibleByArrayLiteral {
  private var coordinators: [Coordinator] = []
  
  public init(arrayLiteral elements: Coordinator...) {
    coordinators.append(contentsOf: elements)
  }
  
  public mutating func append(coordinator: Coordinator) {
    coordinators.append(coordinator)
  }
  
  public mutating func removeObject(coordinator: Coordinator) -> Coordinator? {
    guard let index = coordinators.index(where: { $0 === coordinator }) else { return nil }
    
    return coordinators.remove(at: index)
  }
}
