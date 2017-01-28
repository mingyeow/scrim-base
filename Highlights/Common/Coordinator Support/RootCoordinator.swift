//
//  RootCoordinator.swift
//  Spark
//
//  Created by Teng Siong Ong on 8/5/16.
//
//

import UIKit
import RxSwift

typealias RootCoordinator = Coordinator & RootViewController

protocol RootViewController: class {
  var rootViewController: UIViewController { get }
}

protocol NavigationCoordinator: class {
  var navigationController: NavigationController { get set }
  var disposeBag: DisposeBag {get set}
}

extension NavigationCoordinator {
  func showCoordinator(coordinator: RootCoordinator) {
    navigationController.pushCoordinator(coordinator: coordinator, animated: true)
  }
}
