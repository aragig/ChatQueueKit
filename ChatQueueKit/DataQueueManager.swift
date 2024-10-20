//
//  ChatDatas.swift
//  ChatQueueKit
//
//  Created by Toshihiko Arai on 2024/10/18.
//

import Foundation

protocol DataManagerDelegate: AnyObject {
    func doReloadTable<T>(isQueueFull: Bool, movedData: [T])
}

class DataManager<T> {
    private var mainData = CoreDatas<T>()
    private var queueData = CoreDatas<T>()
    
    weak var delegate: DataManagerDelegate?
    
    private var timer: Timer?
    private let queueThreshold: Int
    private let reloadTableTimeInterval: TimeInterval
    private let insertAtTop: Bool

    //キューがたとえば 50 を超えたら、一気にdataへ移す
    //キューがたとえば 50 を超えたら、delegate で通知する
    init(queueThreshold: Int = 50, reloadTableTimeInterval: TimeInterval = 1.0, insertAtTop: Bool = false) {
        self.queueThreshold = queueThreshold
        self.reloadTableTimeInterval = reloadTableTimeInterval
        self.insertAtTop = insertAtTop
    }
    
    deinit {
        stopQueueProcessing()
    }
    
    func append(_ data: T) {
        queueData.append(data)
        checkQueueLimit()
    }
    
    func count() -> Int {
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
    func startQueueProcessing() {
        timer = Timer.scheduledTimer(withTimeInterval: reloadTableTimeInterval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.moveQueueToMain(isQueueFull: false)
        }
    }
    
    // タイマー停止
    func stopQueueProcessing() {
        timer?.invalidate()
        timer = nil
    }
    
    // キューの上限チェック
    private func checkQueueLimit() {
        if queueData.count() >= queueThreshold {
            moveQueueToMain(isQueueFull: true)
        }
    }
    
    func clearMainAndQueueData() {
        queueData.clear()
        mainData.clear()
    }
    
//    func getLastMainData() -> T? {
//        if insertAtTop {
//            return mainData.getData(at:0)
//        } else {
//            return mainData.getLastData()
//        }
//    }
    
    func getMainData(at: Int) -> T? {
        return mainData.getData(at: at)
    }
    
    func sortMainData(by comparator: (T, T) -> Bool) {
        mainData.sort(by: comparator)
    }
}
