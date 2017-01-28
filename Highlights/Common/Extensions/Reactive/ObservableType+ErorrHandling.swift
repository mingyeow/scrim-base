//
//  ObservableType.swift
//  Spark
//
//  Created by ming yeow ng on 8/11/16.
//
//

import Foundation
import RxSwift

extension ObservableType {
  func keepCalmAndCarryOn(errorHandler: @escaping ((Error) -> Void)) -> Observable<E> {
    return catchError { error in
      errorHandler(error)
      return Observable.empty()
    }
  }
  
  func feedNextInto(variable: Variable<E>) -> Observable<E> {
    return Observable<E>.create { observer -> Disposable in
      return self.subscribe(
        onNext: {
          variable.value = $0
          observer.onNext($0)
        },
        onError: { observer.onError($0)},
        onCompleted: {observer.onCompleted()}
      )
    }
  }
}
