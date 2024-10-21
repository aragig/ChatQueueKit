//
//  ChatDatas.swift
//  ChatQueueKit
//
//  Created by Toshihiko Arai on 2024/10/18.
//

import Foundation

public protocol DataManagerDelegate: AnyObject {
    func doReloadTable<T>(isQueueFull: Bool, movedData: [T])
}

public class DataManager<T> {
    
    public enum DataContainerType {
        case QueueData
        case MainData
    }
    
    private var mainData = CoreDatas<T>()
    private var queueData = CoreDatas<T>()
    
    public weak var delegate: DataManagerDelegate?
    
    private var timer: Timer?
    private let queueThreshold: Int
    private let reloadTableTimeInterval: TimeInterval
    private let insertAtTop: Bool

    //キューがたとえば 50 を超えたら、一気にdataへ移す
    //キューがたとえば 50 を超えたら、delegate で通知する
    public init(queueThreshold: Int = 50, reloadTableTimeInterval: TimeInterval = 1.0, insertAtTop: Bool = false) {
        self.queueThreshold = queueThreshold
        self.reloadTableTimeInterval = reloadTableTimeInterval
        self.insertAtTop = insertAtTop
    }
    
    deinit {
        stopQueueProcessing()
    }
    
    public func append(_ data: T) {
        queueData.append(data)
        checkQueueLimit()
    }
    
    public func count() -> Int {
        return mainData.count()
    }
    
    // キューからメインデータへ移行
    private func moveQueueToMain(isQueueFull: Bool) {
        let allQueueData = queueData.getDatas()
        
        // キューにデータがない場合、デリゲートを呼び出さない
         guard !allQueueData.isEmpty else { return }
  
        // データをメインに移動
        for item in allQueueData {
            if insertAtTop {
                mainData.insert(item, at: 0)  // 上に追加
            } else {
                mainData.append(item)  // 下に追加
            }
        }
        queueData.clear()
        
        // デリゲート通知 (移動されたデータを渡す)
        delegate?.doReloadTable(isQueueFull: isQueueFull, movedData: allQueueData)
    }

    // 定期的にキューを処理するためのタイマー開始
    public func startQueueProcessing() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: reloadTableTimeInterval, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                self.moveQueueToMain(isQueueFull: false)
            }
        }
    }
    
    // タイマー停止
    public func stopQueueProcessing() {
        timer?.invalidate()
        timer = nil
    }
    
    // キューの上限チェック
    private func checkQueueLimit() {
        if queueData.count() >= queueThreshold {
            moveQueueToMain(isQueueFull: true)
        }
    }
    
    public func cleaDatas(selects:[DataContainerType]) {
        for dataType in selects {
            switch dataType {
            case .QueueData:
                queueData.clear()
                break
            case .MainData:
                mainData.clear()
                break
            }
        }
        
        
    }
    

    public func getDatas(select:DataContainerType) -> [T] {
        switch select {
        case .QueueData:
            return queueData.getDatas()
        case .MainData:
            return mainData.getDatas()
        }
    }

    public func getData(select:DataContainerType, at: Int) -> T? {
        switch select {
        case .QueueData:
            return queueData.getData(at: at)
        case .MainData:
            return mainData.getData(at: at)
        }
    }

    
    public func sortData(select:DataContainerType, by comparator: (T, T) -> Bool) {
        switch select {
        case .QueueData:
            queueData.sort(by: comparator)
            break
        case .MainData:
            mainData.sort(by: comparator)
            break
        }
    }
    
    public func filteredDatas(select:DataContainerType, filter: (T) -> Bool) -> [T]? {
        
        switch select {
        case .QueueData:
            return queueData.getFilteredDatas(filter)
        case .MainData:
            return mainData.getFilteredDatas(filter)
        }
    }
    
    public func replaceDatas(select:DataContainerType, newDatas: [T]) {
        switch select {
        case .QueueData:
            queueData.clear()
            newDatas.forEach { queueData.append($0) }
            break
        case .MainData:
            mainData.clear()  // 既存のデータをクリア
            newDatas.forEach { mainData.append($0) }  // 新しいデータを追加
            break
        }

    }
    
    public func replaceData(select:DataContainerType, at: Int, newData: T) {
        switch select {
        case .QueueData:
            queueData[at] = newData
            break
        case .MainData:
            mainData[at] = newData
            break
        }

    }
}
