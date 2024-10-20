//
//  DataManagerTests.swift
//  ChatQueueKitTests
//
//  Created by Toshihiko Arai on 2024/10/19.
//

import XCTest
@testable import ChatQueueKit


// テスト用のデータ型
struct Message {
    let id: Int
    let content: String
}


// デリゲートのモッククラス
class DataManagerDelegateMock: DataManagerDelegate {
    
    var didReloadTableCalled = false
    var didQueueFull = false
    var movedData: [Message] = []  // movedData の追加
    
    func doReloadTable<T>(isQueueFull: Bool, movedData: [T]) {
        didReloadTableCalled = true
        didQueueFull = isQueueFull
        self.movedData = movedData as! [Message]
    }

    func reset() {
        didReloadTableCalled = false
        didQueueFull = false
        movedData = [] // リセット時に movedData もクリア
    }
}



final class DataManagerTests: XCTestCase {

    var dataManager: DataManager<Message>!
    var delegateMock: DataManagerDelegateMock!

    override func setUp() {
        super.setUp()
        delegateMock = DataManagerDelegateMock()
        dataManager = DataManager<Message>(queueThreshold: 5, reloadTableTimeInterval: 0.5)
        dataManager.delegate = delegateMock
    }
    
    override func tearDown() {
        dataManager = nil
        delegateMock = nil
        super.tearDown()
    }
    
    func testAppendAndQueueProcessing() {
        // テスト用のメッセージ
        let message1 = Message(id: 1, content: "Hello, World!")
        let message2 = Message(id: 2, content: "Second Message")
        
        // キューにメッセージを追加
        dataManager.append(message1)
        dataManager.append(message2)
        
        // キューに追加されたメッセージがメインデータに移行されるのを待機
        let expectation = XCTestExpectation(description: "Wait for queue to move to main data")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.dataManager.count(), 2)
            XCTAssertTrue(self.delegateMock.didReloadTableCalled)
            XCTAssertFalse(self.delegateMock.didQueueFull)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    

    func testQueueThresholdExceeded() {
        let messages = [
            Message(id: 1, content: "Message 1"),
            Message(id: 2, content: "Message 2"),
            Message(id: 3, content: "Message 3"),
            Message(id: 4, content: "Message 4"),
            Message(id: 5, content: "Message 5")
        ]
        
        // キューがしきい値に達するまでメッセージを追加
        for message in messages {
            dataManager.append(message)
        }
        
        // キューのしきい値を超えた時にメインデータに移行される
        XCTAssertEqual(dataManager.count(), 5)
        XCTAssertTrue(delegateMock.didReloadTableCalled)
        XCTAssertTrue(delegateMock.didQueueFull)
        
        // movedData に関するチェックを追加
        XCTAssertEqual(delegateMock.movedData.count, 5)
        XCTAssertEqual(delegateMock.movedData[0].content, "Message 1")
        XCTAssertEqual(delegateMock.movedData[4].content, "Message 5")
    }
}
