//
//  AppCoordinator.swift
//  Spark
//
//  Created by Ming Yeow Ng on 8/5/16.
//
//

import UIKit
import RxSwift
import Moya
import SVProgressHUD
import SwiftyStoreKit
import Toaster

final class AppCoordinator {
  private struct Constants {
    static let rootViewControllerTransitionDuration: TimeInterval = 0.5
  }
  
  fileprivate let disposeBag = DisposeBag()
  
  private let integrations = container.resolve(AppIntegrations.self)!
  private let preferences = container.resolve(Preferences.self)!
  
  private var isLoggedIn: Bool {
    return self.preferences.userState == .loggedIn
  }
  
  private var rootViewController: UIViewController {
    return rootCoordinator.rootViewController
  }
  
  private var rootCoordinator: RootCoordinator! {
    didSet {
      if let oldValue = oldValue {
        _ = childCoordinators.removeObject(coordinator: oldValue)
        
        UIView.transition(with: window, duration: Constants.rootViewControllerTransitionDuration, options: .transitionFlipFromLeft, animations: {
          self.window.rootViewController = self.rootCoordinator.rootViewController
          }, completion: nil)
      } else {
        window.rootViewController = rootCoordinator.rootViewController
      }
      
      childCoordinators.append(coordinator: rootCoordinator)
    }
  }
  
  private lazy var pushNotificationRegistrar: PushNotificationRegistrar = PushNotificationRegistrar(
    application: self.application,
    device: container.resolve(UIDevice.self)!,
    delegate: self
  )
  
  private var childCoordinators = CoordinatorArray()
  
  // MARK: - Inputs
  
  private let application: UIApplication
  private let window: UIWindow
  private var tabBarCoordinator: TabBarCoordinator? {
    return rootCoordinator as? TabBarCoordinator
  }
  
  // MARK: - Initialization
  
  init(application: UIApplication, window: UIWindow, launchOptions: [NSObject: AnyObject]?) {
    self.application = application
    self.window = window
  }
  
  convenience init(application: UIApplication, window: UIWindow, launchOptions: [NSObject: AnyObject]?, setUpIntegrations: Bool) {
    
    self.init(application: application, window: window, launchOptions: launchOptions)
    
    if setUpIntegrations {
      integrations.setup(application: application, launchOptions: launchOptions, appCoordinator: self)
    }
  }
  
  // MARK: - Public
  
  func start() {
    setRootCoordinator()
    setDefault()
    
    if isLoggedIn {
      registerForPushNotifications()
    }
  }
  
  func openURL(url: NSURL, application: UIApplication, sourceApplication: String?, annotation: AnyObject) -> Bool {
    return integrations.openURL(url: url, application: application, sourceApplication: sourceApplication, annotation: annotation)
  }
  
  func openURL(url: NSURL, application: UIApplication, options: [String : AnyObject]) -> Bool {
    return integrations.openURL(url: url, application: application, options: options)
  }
  
  func handleAppDidBecomeActive() {
    preferences.updateAmplitudeUserId()
    tabBarCoordinator?.updateCurrentUser()
  }
  
  fileprivate func setRootCoordinator() {
    rootCoordinator = { Void -> RootCoordinator in
      switch preferences.userState {
      case .loggedOut:
        return TabBarCoordinator(delegate: self)
      case .loggedIn:
        return TabBarCoordinator(delegate: self)
      }
    }()
  }
  
  private func setDefault() {
    SVProgressHUD.setMinimumDismissTimeInterval(1)
    SVProgressHUD.setDefaultMaskType(.black)
  }
  
  private func registerForPushNotifications() {
    pushNotificationRegistrar.register()
  }
}

// MARK: - TabBarCoordinatorDelegate

extension AppCoordinator: TabBarCoordinatorDelegate {
  func tabBarCoordinatorDidLogOutUser(coordinator: TabBarCoordinator) {
    setRootCoordinator()
  }
}

// MARK: - PushNotificationRegistrarDelegate

extension AppCoordinator: PushNotificationRegistrarDelegate {
  func pushNotificationRegistrarDidRegisterForRemoteNotifications(token: String) {
    let apiProvider = container.resolve(RxMoyaProvider<API>.self)!
    
    apiProvider.request(.UpdateDeviceToken(deviceToken: token))
      .mapObject(type: User.self, keyPath: "user")
      // do nothing upon success or failure
      .subscribe()
      .addDisposableTo(self.disposeBag)
  }
}

