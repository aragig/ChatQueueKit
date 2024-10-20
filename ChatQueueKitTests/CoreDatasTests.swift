//
//  ChatTableDataTests.swift
//  ChatQueueKitTests
//
//  Created by Toshihiko Arai on 2024/10/18.
//

import XCTest
@testable import ChatQueueKit


class CoreDatasTests: XCTestCase {

    var coreDatas: CoreDatas<Message>!

    override func setUp() {
        super.setUp()
        coreDatas = CoreDatas<Message>()
    }

    override func tearDown() {
        coreDatas = nil
        super.tearDown()
    }

    func testAppendData() {
        let message = Message(id: 1, content: "Hello, World!")
        coreDatas.append(message)
        
        XCTAssertEqual(coreDatas.count(), 1)
        XCTAssertEqual(coreDatas.getData(at: 0)?.content, "Hello, World!")
    }

    func testInsertData() {
        let message1 = Message(id: 1, content: "First Message")
        let message2 = Message(id: 2, content: "Second Message")
        
        coreDatas.append(message1)
        coreDatas.insert(message2, at: 0)
        
        XCTAssertEqual(coreDatas.count(), 2)
        XCTAssertEqual(coreDatas.getData(at: 0)?.content, "Second Message")
    }

    func testUpdateData() {
        let message1 = Message(id: 1, content: "Original Message")
        let message2 = Message(id: 2, content: "Updated Message")
        
        coreDatas.append(message1)
        coreDatas.update(message2, at: 0)
        
        XCTAssertEqual(coreDatas.count(), 1)
        XCTAssertEqual(coreDatas.getData(at: 0)?.content, "Updated Message")
    }

    func testClearData() {
        let message1 = Message(id: 1, content: "Message 1")
        coreDatas.append(message1)
        XCTAssertEqual(coreDatas.count(), 1)
        
        coreDatas.clear()
        XCTAssertEqual(coreDatas.count(), 0)
    }

    func testSortData() {
        let message1 = Message(id: 1, content: "Message 1")
        let message2 = Message(id: 2, content: "Message 2")
        
        coreDatas.append(message2)
        coreDatas.append(message1)
        
        coreDatas.sort { $0.id < $1.id }
        
        XCTAssertEqual(coreDatas.getData(at: 0)?.id, 1)
    }

    func testGetFilteredDatas() {
        let message1 = Message(id: 1, content: "Hello")
        let message2 = Message(id: 2, content: "World")
        
        coreDatas.append(message1)
        coreDatas.append(message2)
        
        let filtered = coreDatas.getFilteredDatas { $0.content.contains("Hello") }
        
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.content, "Hello")
    }
}
