//
//  FeedCoordinator.swift
//  Highlights
//
//  Created by ming yeow ng on 1/27/17.
//  Copyright © 2017 Meow. All rights reserved.
//

import UIKit
import RxSwift
import SVProgressHUD
import Moya

protocol FeedCoordinatorDelegate: class {
}

final class FeedCoordinator: RootCoordinator, NavigationCoordinator {
  
  var disposeBag = DisposeBag()
  
  // MARK: - Dependencies
  private let preferences = container.resolve(Preferences.self)!
  private let apiProvider = container.resolve(RxMoyaProvider<API>.self)!
  
  // MARK: - Inputs
  private var delegate: FeedCoordinatorDelegate?
  
  var friends: Variable<[User]> = Variable<[User]>([])

  // MARK: - Mutable state
  
  private var childCoordinators = CoordinatorArray()
  
  // MARK: - RootCoordinator
  
  private lazy var feedViewController: FeedViewController  = FeedViewController(delegate: self)
  
  lazy var navigationController: NavigationController = NavigationController(rootViewController: self.feedViewController)
  
  var rootViewController: UIViewController {
    return navigationController
  }
    
  init(delegate: FeedCoordinatorDelegate) {
    self.delegate = delegate
  }
  
}

// MARK: - DiscoverUsersViewControllerDelegate

extension FeedCoordinator: FeedViewControllerDelegate {
}

