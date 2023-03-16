//
//  Queue.swift
//  CityBikeStationsDemoTests
//
//  Created by Stanislav Kimov on 16.03.23.
//

import Foundation

struct Queue<T> {
  private var list = [T]()
  
  mutating func enqueue(_ element: T) {
    list.append(element)
  }
  
  mutating func dequeue() -> T? {
    if !list.isEmpty {
      return list.removeFirst()
    } else {
      return nil
    }
  }
  
  var isEmpty: Bool {
    list.isEmpty
  }
}
