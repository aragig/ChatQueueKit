//
//  ViewController.swift
//  ChatTableSampleApp
//
//  Created by Toshihiko Arai on 2024/10/19.
//

import UIKit

// テスト用のデータ型
struct Comment {
    let no: Int
    let content: String
}


class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var addInBulkButton: UIButton!
    @IBOutlet weak var addButton: UIButton!

//    var chatData: [Comment] = []
    var chatData = DataManager<Comment>(queueThreshold: 5, reloadTableTimeInterval: 1.0, insertAtTop: true)
    
    var lastNo = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatData.delegate = self

        // ここでセルを登録
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    
    @IBAction func onTappedClearButton(_ sender: UIButton) {
        triggerVibration()
        lastNo = 0
        chatData.stopQueueProcessing()
        chatData.clearMainAndQueueData()
        tableView.reloadData()
    }

    @IBAction func onTappedAddButton(_ sender: UIButton) {
        triggerVibration()

        if lastNo == 0 {
            chatData.startQueueProcessing()
        }

        let nextNo = lastNo + 1
        chatData.append(Comment(no: nextNo, content: "New message \(nextNo)"))
        lastNo = nextNo
    }

    @IBAction func onTappedAddInBulkButton(_ sender: UIButton) {
        triggerVibration()

        if lastNo == 0 {
            chatData.startQueueProcessing()
        }

        var comments = [Comment]()
                
        // コメントを作成
        var startNo = lastNo
        for _ in 0..<10 {
            startNo = startNo + 1
            comments.append(Comment(no: startNo, content: "Bulk message \(startNo)"))
        }
        lastNo = startNo

        // コメントをランダムに並べ替え
        comments.shuffle()
        
        // ランダムに並べ替えたコメントを追加
        for comment in comments {
            chatData.append(comment)
        }
    }

    private func triggerVibration() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatData.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let data = chatData.getMainData(at: indexPath.row)
        if data != nil {
            cell.textLabel?.text = "No: \(data!.no), Content: \(data!.content)"
        }
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: DataManagerDelegate {
    func doReloadTable<T>(isQueueFull: Bool, movedData: [T]) {
        let indexPaths = movedData.enumerated().map { IndexPath(row: $0.offset, section: 0) }
// 参考のために以下処理を残す
//        var indexPaths:[IndexPath] = []
//        var i = 0
//        
//        for c in movedData {
//            let indexPath = IndexPath(row: i, section: 0)
//            indexPaths.append(indexPath)
//            i = i + 1
//        }

        self.tableView.beginUpdates()
        self.tableView.insertRows(at: indexPaths, with: .top)
        self.tableView.endUpdates()
        
        if isQueueFull {
            // 実際はもっと良い方法で実装すること
            let ascending = false
            chatData.sortMainData { ascending ? $0.no < $1.no : $0.no > $1.no }
            self.tableView.reloadData()
        }

    }
    
    
}
