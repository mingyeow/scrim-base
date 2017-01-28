//
//  Pagination.swift
//  Spark
//
//  Created by Teng Siong Ong on 8/21/16.
//
//

import Foundation
import ObjectMapper

struct Pagination: Mappable {
  var currentPage: Int = 0
  var nextPage: Int = 0
  var prevPage: Int = 0
  var totalPages: Int = 0
  var totalCount: Int = 0
  
  init?(map: Map) {}

  mutating func mapping(map: Map){
    currentPage <- map["current_page"]
    nextPage <- map["next_page"]
    prevPage <- map["prev_page"]
    totalPages <- map["total_pages"]
    totalCount <- map["total_count"]
  }
}
