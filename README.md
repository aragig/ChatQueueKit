# ChatQueueKit

ChatQueueKit は、リアルタイムアプリケーション、特にチャットアプリに最適な軽量なデータ管理フレームワークです。このフレームワークを利用することで、キューシステムを活用してデータのバッチ処理を行い、テーブルビューのパフォーマンスを最適化できます。特に、頻繁にデータが追加される場合において、スムーズかつ効率的なデータ移行とリロードを実現します。

## 主な機能
- キューとメインデータの管理: キューに追加されたデータを一定量保持し、閾値に達するとメインデータに移行します。
- バッチ追加: 1件ずつの追加だけでなく、複数のデータを一括で追加することも可能です。
- テーブルのリロード: デリゲートを用いることで、データが移行されたタイミングでテーブルビューを簡単にリロードできます。
- 柔軟なデータ操作: データの挿入位置を指定したり、ソート、フィルタリング、データ置換なども柔軟に行うことができます。

## インストール

ChatQueueKit をCocoaPods経由でインストールするには、まずPodfileに以下の行を追加します。


```ruby
target 'YourAppTargetName' do
  use_frameworks!

  pod 'ChatQueueKit', :git => 'https://github.com/aragig/ChatQueueKit.git'
end
```

次に、以下のコマンドを実行してインストールします。


```zsh
$ pod install
```

インストールが完了したら、プロジェクト内でimport ChatQueueKitを使ってフレームワークを利用できます。

## 使い方

### 基本的な使い方

以下のコードは、ChatQueueKitを利用したサンプルです。DataManagerを使用して、チャットデータを効率的に管理し、キューシステムでテーブルをリロードします。

```swift
import UIKit
import ChatQueueKit

struct Comment {
    let no: Int
    let content: String
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var chatData = DataManager<Comment>(queueThreshold: 5, reloadTableTimeInterval: 1.0, insertAtTop: true)
    var lastNo = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatData.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    @IBAction func onTappedAddButton(_ sender: UIButton) {
        let nextNo = lastNo + 1
        chatData.append(Comment(no: nextNo, content: "New message \(nextNo)"))
        lastNo = nextNo
    }
}

extension ViewController: DataManagerDelegate {
    func doReloadTable<T>(isQueueFull: Bool, movedData: [T]) {
        self.tableView.reloadData()
    }
}
```

### デリゲートメソッドでのテーブルリロード

データがキューからメインデータに移行されたタイミングで、テーブルのリロードを行うためにデリゲートメソッドを活用できます。

```
func doReloadTable<T>(isQueueFull: Bool, movedData: [T]) {
    self.tableView.reloadData()
}
```

これにより、効率的なデータ処理とスムーズなテーブル更新が可能になります。

## ライセンス

ChatQueueKit は MIT ライセンスのもとで提供されています。詳細は LICENSE をご覧ください。

このようにして、リアルタイムアプリケーションにおけるデータ処理の負荷を軽減し、ユーザー体験を向上させることができます。ぜひ、ChatQueueKit をプロジェクトに導入し、活用してみてください。
