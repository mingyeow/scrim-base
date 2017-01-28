//
//  FeedViewController.swift
//  Spark
//
//  Created by Ming Yeow Ng on 8/14/16.
//
//

import UIKit
import RxSwift
import Amplitude_iOS

protocol FeedViewControllerDelegate: class {
}

final class FeedViewController: UIViewController {

  var disposeBag = DisposeBag()
  
  private let delegate: FeedViewControllerDelegate
  
  // MARK: - Initialization
  
  init(delegate: FeedViewControllerDelegate) {
    self.delegate = delegate
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureUI() {
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
  }
  
}
