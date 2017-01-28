//
//  PaginationDataAccessor.swift
//  Spark
//
//  Created by Teng Siong Ong on 8/21/16.
//
//

import UIKit
import RxSwift

protocol PaginationDataAccessor {
  var isLoadingMore: Bool { get }
  var reloadDistance: CGFloat { get }
  var pagination: Pagination? { get }
  
  func loadMore()
  func checkAndLoadMore(scrollView: UIScrollView)
}

extension PaginationDataAccessor {
  func checkAndLoadMore(scrollView: UIScrollView) {
    let offset = scrollView.contentOffset
    let bounds = scrollView.bounds
    let size = scrollView.contentSize
    let inset = scrollView.contentInset
    
    let yPosition = offset.y + bounds.size.height - inset.bottom
    let height = size.height
    
    if yPosition > height - reloadDistance {
      loadMore()
    }
  }
}
