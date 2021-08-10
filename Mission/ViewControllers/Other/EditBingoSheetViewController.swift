//
//  EditBingoSheetViewController.swift
//  Mission
//
//  Created by Juri Ohto on 2021/07/11.
//

import UIKit
import Firebase

class EditBingoSheetViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bingoCollectionView: UICollectionView!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    
//    let titles = ["死ぬまでにやりたいこと", "デイリーミッション", "週末用"]
//
//    var tasks = [//@Firebaseから取得したデータを一次元配列にする
//        "洗い物", "洗濯物", "掃除機かけ",
//        "ゴミ出し","手紙を出す", "鳥小屋の掃除",
//        "ふるさと納税", "単語帳10,000ページ", "ドラッグストアでシャンプーを買った後にスーパーでパイナップルを買う"
//    ]
    
    let layout = UICollectionViewFlowLayout()
    let db = Firestore.firestore()
    var bingosheet: BingoSheet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        setUpBingoCollectionView()
        addEventListner()
//        fetchBingosheetInfoFromFirestore()
        
    }
    
    private func setUpView() {
        titleLabel.text = bingosheet?.title
        rewardLabel.text = bingosheet?.reward
//        deadlineLabel.text = bingosheet?.deadline
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "開始", style: .plain, target: self, action: #selector(startButtonTapped))
    }
    
    //ビンゴシート開始ボタン押下時の挙動
    @objc private func startButtonTapped() {
        //ビンゴシートの内容、タスクの並び順を固定
        
        //MissionInProgressVCのビンゴシートを生成？（このタイミング？）
        
        //MissionInprogressVCへ遷移 -> @クラッシュしてしまうので直す
        let storyboard = UIStoryboard.init(name: "MissionInProgress", bundle: nil)
        let missionInProgressVC = storyboard.instantiateViewController(identifier: "MissionInProgressViewController") as! MissionInProgressViewController
        
        navigationController?.pushViewController(missionInProgressVC, animated: true)
    }
    
    private func setUpBingoCollectionView() {
        bingoCollectionView.delegate = self
        bingoCollectionView.dataSource = self
        bingoCollectionView.register(EditBingoCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        bingoCollectionView.backgroundColor = .clear
        
        bingoCollectionView.layer.borderWidth = 0
//        bingoCollectionView.layer.borderColor = UIColor.clear.cgColor//UIColor.systemGray2.cgColor
        
        bingoCollectionView.collectionViewLayout = layout
    }
    
    private func addEventListner() {
        //インスタンスを生成
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture))
        //viewにインスタンスを追加
        bingoCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    //collectionViewをドラッグ＆ドロップで並び替えるメソッド
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        
        switch gesture.state {
        
        case UIGestureRecognizer.State.began:
            guard let selectedIndexPath = bingoCollectionView.indexPathForItem(at: gesture.location(in: bingoCollectionView)) else {
                break
            }
            //移動開始
            bingoCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            
        case UIGestureRecognizer.State.changed:
            //移動中
            bingoCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
            
        case UIGestureRecognizer.State.ended:
            //移動終了
            bingoCollectionView.endInteractiveMovement()
            
        default:
            //移動の取消
            bingoCollectionView.cancelInteractiveMovement()
        }
    }
    
    
//    private func fetchBingosheetInfoFromFirestore() {
//
//        //Firestoreからコレクションのすべてのドキュメントを取得する
//        db.collection("bingoSheets").getDocuments() { (querySnapshot, err) in
//            //非同期処理：記述された順番は関係なく、getDocumentsの処理が完了したらクロージャを実行する
//            if let err = err {
//                print("Firestoreから情報の取得に失敗しました。", err)
//            } else {
//                for document in querySnapshot!.documents {
////                    print("Firestoreから情報を取得しました！", "\(document.documentID) => \(document.data())")
//                    //Firestoreから特定のフィールドのみを抜き出す。nilチェック
//                    guard let title = document.get("title") else { return }
//                    guard let createdAt = document.get("createdAt") else { return }
//
////                    titleArray.append(title as! String)//Any型をString型に変換->@arrayじゃなくてこのまま表示したい
//
//                    //ビンゴシートを作成日順に並び替え
////                    guard let createdAt =  document.get("createdAt") else { return }
////                    self.titleArray.sort.{ (b1, b2) -> Bool in
////                        let b1Date = b1
////                    }
//                }
//
//                self.bingoCollectionView.reloadData()
//            }
//        }
//
//
//
//
////        db.collection("bingoSheets").addSnapshotListener{ (snapshots, err) in
////            if let err = err {
////                print("ビンゴシートの取得に失敗しました", err)
////                return
////            }
////
////            snapshots?.documentChanges.forEach({ (documentChange) in
////                switch documentChange.type {
////                case .added:
////                    let dic = documentChange.document.data()
////
////
////                case .modified:
////                    print("Need to restore the data")
////
////                case .removed:
////                    print("nothing to do now...")
////                }
////            })
////        }
//
//
////        //Firestoreからコレクションのすべてのドキュメントを取得する
////        db.collection("bingoSheets").getDocuments() { (snapshots, err) in
////            //非同期処理：記述された順番は関係なく、getDocumentsの処理が完了したらクロージャを実行する
////            if let err = err {
////                print("Firestoreから情報の取得に失敗しました。", err)
////                return
////            }
////
////            snapshots?.documents.forEach({ (snapshot) in
////                let dic = snapshot.data()
////                let bingoSheet = BingoSheet(dic: dic)
////                bingoSheet.doumentId = snapshot.documentID
////
////                print(dic)/*
////                 ["tasks": <__NSArrayM 0x168599180>(
////                 free,
////                 free,
////                 free,
////                 free,
////                 free,
////                 free,
////                 free,
////                 free,
////                 free
////                 )
////                 , "createdAt": <FIRTimestamp: seconds=1628154004 nanoseconds=186366000>, "deadLine": <FIRTimestamp: seconds=1628154004 nanoseconds=185819000>, "title": No Title, "reward": No Reward]*/
////                print(bingoSheet)//Mission.BingoSheet
////                print(bingoSheet.doumentId)//Optional("ysKOp9yiElpQjGsLP47B")
////            })
////
////
////
////            self.bingoCollectionView.reloadData()
////        }
//    }
}




//MARK: - CollectionView Delegates
extension EditBingoSheetViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1//tasks.count
    }
    
    
    //セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bingosheet!.tasks!.count///9//tasks[section].count//@Firebaseからデータを持ってきたい
    }
    
    //セルのサイズ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideOfSquare = collectionView.frame.width / 3
        return .init(width: sideOfSquare, height: sideOfSquare)
    }
    
    //cell同士のスペース
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //行間のスペース
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = bingoCollectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! EditBingoCollectionViewCell
        //        cell.taskLabel.text = tasks[indexPath.section][indexPath.row]//@Firebaseからデータを持ってきたい
        cell.taskLabel.text = bingosheet!.tasks![indexPath.row]//tasks[indexPath.row]
        return cell
    }
    
    //セルタップ時の挙動
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //＠cellのテキストラベルを編集できるようにしたい
        let cell = bingosheet!.tasks![indexPath.row]//bingoCollectionView.cellForItem(at: indexPath)
        print(cell)//Optional(<Mission.EditBingoCollectionViewCell: 0x13d8dc830; baseClass = UICollectionViewCell; frame = (0 0; 116.667 116.667); layer = <CALayer: 0x6000025a7be0>>)
    }
    
    
    
    
    
    //    このメソッドを実装していなくても、collectionView(_:moveItemAt:to:)メソッドを実装していれば、コレクションビューはすべてのアイテムの並び替えを許可します。
    //    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
    //        return true
    //    }
    
    //cellの移動
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tempTask = bingosheet!.tasks!.remove(at: sourceIndexPath.item)//tasks.remove(at: sourceIndexPath.item)
        bingosheet!.tasks!.insert(tempTask, at: destinationIndexPath.item)
//        tasks.insert(tempTask, at: destinationIndexPath.item)
    }
    
    
    
}

//MARK: - EditBingoCollectionViewCell

class EditBingoCollectionViewCell: UICollectionViewCell {
    
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.text = "タスク１"
        label.clipsToBounds = true
        //lavelを折り返して全文表示
        label.lineBreakMode = .byWordWrapping//単語単位で区切って改行
        label.numberOfLines = 0//最大制限なし（必要なだけ行数を使用）
        //        label.backgroundColor = .yellow
        label.backgroundColor = .clear
        
        return label
    }()
    
    override init(frame: CGRect) {//＠これは何？→カスタムUIViewの初期化を記述
        super.init(frame: frame)
        
        addSubview(taskLabel)
        
        taskLabel.frame.size = self.frame.size
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.systemGray.cgColor
        
        self.layer.backgroundColor = notDoneUIColor.cgColor//UIColor.yellow.cgColor
        self.layer.cornerRadius = 8.0
        
        
        
    }
    required init?(coder: NSCoder) {//＠これは何？→よくわからない。swiftの場合、override init(frame: CGRect)とセットで必要になる模様。
        
        fatalError("init(coder:) has not been implemented")
        
    }
}
