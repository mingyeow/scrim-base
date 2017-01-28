//
//  NavigationController.swift
//  Spark
//
//  Created by Teng Siong Ong on 8/15/16.
//
//

import UIKit

final class NavigationController: UINavigationController {
  
  // MARK: - Inputs
  
  private let rootViewController: UIViewController
  
  // MARK: - Mutable state
  
  fileprivate var viewControllersToChildCoordinators: [UIViewController: Coordinator] = [:]
  
  // MARK: - Initialization
  
  convenience init(rootCoordinator: RootCoordinator) {
    self.init(rootViewController: rootCoordinator.rootViewController)
    
    viewControllersToChildCoordinators[rootCoordinator.rootViewController] = rootCoordinator
  }
  
  override init(rootViewController: UIViewController) {
    self.rootViewController = rootViewController
    
    super.init(nibName: nil, bundle: nil)
    
    self.pushViewController(rootViewController, animated: false)
    
    tabBarItem = rootViewController.tabBarItem
    
    /*
     This seems to be necessary when using a custom view controller that will be added to a tab bar controller, and
     will also wrap a `UINavigationController` and be expected to behave in the same way that
     `UINavigationController` would if it was added to the tab bar controller directly.
     
     We are using opaque bars and without this, scroll insets and frames get all kinds of fucked up.
     */
    extendedLayoutIncludesOpaqueBars = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UIViewController
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.delegate = self
    self.interactivePopGestureRecognizer?.delegate = self
    
  }
  
  // MARK: - Public
  
  func pushCoordinator(coordinator: RootCoordinator, animated: Bool) {
    viewControllersToChildCoordinators[coordinator.rootViewController] = coordinator
    
    asyncPushViewController(viewController: coordinator.rootViewController, animated: animated)
  }
  
  func asyncPushViewController(viewController: UIViewController, animated: Bool) {
    DispatchQueue.main.async {
      self.pushViewController(viewController, animated: animated)
    }
  }
}

// MARK: - UIGestureRecognizerDelegate

extension NavigationController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                         shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    // Necessary to get the child navigation controller’s interactive pop gesture recognizer to work.
    return true
  }
  
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
  }
}

// MARK: - UINavigationControllerDelegate

extension NavigationController: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController,
                            didShow viewController: UIViewController, animated: Bool) {
    cleanUpChildCoordinators()
  }
  
  // MARK: - Private
  
  private func cleanUpChildCoordinators() {
    for viewController in viewControllersToChildCoordinators.keys {
      if !self.viewControllers.contains(viewController) {
        viewControllersToChildCoordinators.removeValue(forKey: viewController)
      }
    }
  }
}

// MARK: - RootCoordinator

extension NavigationController {
  func showCoordinator(coordinator: RootCoordinator) {
    pushCoordinator(coordinator: coordinator, animated: true)
  }
}
