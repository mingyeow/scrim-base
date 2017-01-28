//
//  TabBarCoordinator.swift
//  Highlights
//
//  Created by ming yeow ng on 1/26/17.
//  Copyright © 2017 Meow. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Moya

protocol TabBarCoordinatorDelegate: class {
  func tabBarCoordinatorDidLogOutUser(coordinator: TabBarCoordinator)
}

final class TabBarCoordinator: NSObject, RootCoordinator {
  var disposeBag = DisposeBag()
  
  // MARK: - Child coordinators
  
  private var application = container.resolve(UIApplication.self)!
  
  private lazy var tabBarController: UITabBarController = UITabBarController().then {
    $0.delegate = self
    $0.viewControllers = [
    ]
  }
  
  lazy var rootViewController: UIViewController = self.tabBarController
  
  fileprivate var lastTabBarIndex: Int?
  
  // MARK: - Inputs
  
  fileprivate weak var delegate: TabBarCoordinatorDelegate?
  
  // MARK: - Initialization
  
  init(delegate: TabBarCoordinatorDelegate) {
    super.init()
    self.delegate = delegate
    
    updateCurrentUser()
  }
  
  // MARK: - Public
  
  
  // Updates current user
  func updateCurrentUser() {
    let apiProvider = container.resolve(RxMoyaProvider<API>.self)!
    let preferences = container.resolve(Preferences.self)!
    apiProvider.request(.GetMe)
      .mapObject(type: User.self, keyPath: "user")
      .subscribe(onNext: { user in
        preferences.user = user
      })
      .addDisposableTo(disposeBag)
  }
}

// MARK: - UITabBarControllerDelegate

extension TabBarCoordinator: UITabBarControllerDelegate {
  
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    if let vc = viewController as? NavigationController {
      if tabBarController.selectedIndex == self.lastTabBarIndex {
        vc.popToRootViewController(animated: true)
      }
    } else {
      fatalError("Root of tab bar should be navigation controller")
    }
    self.lastTabBarIndex = tabBarController.selectedIndex
  }
  
  
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    return true
  }
}

// MARK: - Tab Bar Item Configuration

extension UITabBarItem {
  func applyStandardTheme() {
    self.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)
    self.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: 30000.0)
  }
}
