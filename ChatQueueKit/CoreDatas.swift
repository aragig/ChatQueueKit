//
//  ChatQueue.swift
//  ChatQueueKit
//
//  Created by Toshihiko Arai on 2024/10/18.
//

import UIKit


class CoreDatas<T> {

    fileprivate var _data: [T] = []
    
    // Subscriptを追加して、インデックスでアクセス可能にする
    subscript(index: Int) -> T {
        get {
            return _data[index]
        }
        set(newValue) {
            _data[index] = newValue
        }
    }
    
    func count() -> Int {
        return _data.count
    }
    
    func getDatas() -> [T] {
        return _data
    }

    func getFilteredDatas(_ filter: (T) -> Bool) -> [T] {
        return _data.filter(filter)
    }

    func getData(at index: Int) -> T? {
        guard index >= 0 && index < _data.count else {
            return nil
        }
        return _data[index]
    }

    func getLastData() -> T? {
        return _data.last
    }

    func append(_ new: T) {
        _data.append(new)
    }
    
    func insert(_ new: T, at: Int) {
        _data.insert(new, at: at)
    }
    
//    func replace(_ new: [T]) {
//        _data = new
//    }

    func update(_ new: T, at: Int) {
        _data[at] = new
    }
    
    func clear() {
        _data = []
    }

    func sort(by comparator: (T, T) -> Bool) {
        _data.sort(by: comparator)
    }

}
