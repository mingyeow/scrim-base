////
////  ObjectMapper+RxSwift.swift
////  Spark
////
////  Created by Teng Siong Ong on 8/14/16.
////
////
//
import Foundation
import RxSwift
import Moya
import ObjectMapper
import Toaster

extension ObservableType where E == Response {
  
  /// Maps data received from the signal into an object
  /// which implements the Mappable protocol and returns the result back
  /// If the conversion fails, the signal errors.
  func mapObject<T: BaseMappable>(type: T.Type, keyPath: String) -> Observable<T> {
    return flatMap { response -> Observable<T> in
      return Observable.just(try response.mapObject(type: T.self, keyPath: keyPath))
    }
  }
  
  /// Maps data received from the signal into an array of objects
  /// which implement the Mappable protocol and returns the result back
  /// If the conversion fails, the signal errors.
  func mapArray<T: BaseMappable>(type: T.Type, keyPath: String) -> Observable<([T], Pagination?)> {
    return flatMap { response -> Observable<([T], Pagination?)> in
      return Observable.just(try response.mapArray(type: T.self, keyPath: keyPath))
    }
  }

}
