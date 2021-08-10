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
    
    
    let layout = UICollectionViewFlowLayout()
    let db = Firestore.firestore()
    //FolderVCからタップされたcellの情報を受け取る変数
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
        let dateString = dateToString(date: bingosheet!.deadline!)
        deadlineLabel.text = dateString
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "開始", style: .plain, target: self, action: #selector(startButtonTapped))
    }
    
    //Date型からString型へ変換
    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateStyle = .medium//2017/08/13
//        formatter.doesRelativeDateFormatting = true//当日を「今日」、前日を「昨日」などと表示する
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
    
    //ビンゴシート開始ボタン押下時の挙動
    @objc private func startButtonTapped() {
        
        guard let documentId = bingosheet?.documentId else { return }
        
        let dogData = [
            //ここに編集済みのデータを入れる
            "tasks": bingosheet!.tasks!
        ] as [String: Any]

        //firestpreにデータを上書き保存
        db.collection("bingoSheets").document(documentId).setData(dogData, merge: true) { err in
            if let err = err {
                print("Firestoreへの上書きに失敗しました", err)
            } else {
                print("Firestoreの情報を上書きしました！", documentId)
                //＠ビンゴシートの内容、タスクの並び順を固定。変更した場合はFirestoreに反映。
                //＠MissionInProgressVCのビンゴシートへ値渡し
                
                //MissionInprogressVCへ遷移 -> @クラッシュしてしまうので直す
//                let storyboard = UIStoryboard.init(name: "MissionInProgress", bundle: nil)
//                let missionInProgressVC = storyboard.instantiateViewController(identifier: "MissionInProgressViewController") as! MissionInProgressViewController
//
//                self.navigationController?.pushViewController(missionInProgressVC, animated: true)
            }
            
        }
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
//            print(bingosheet!.tasks!)//この時点でtaskの順番は並び替えされている["1", "2", "3", "4", "free", "6", "5", "free", "free"]
            
        default:
            //移動の取消
            bingoCollectionView.cancelInteractiveMovement()
        }
    }
    
    
}




//MARK: - CollectionView Delegates
extension EditBingoSheetViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1//tasks.count
    }
    
    
    //セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bingosheet!.tasks!.count//tasks[section].count//9
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

            cell.taskLabel.text = bingosheet!.tasks![indexPath.row]//tasks[indexPath.row]

        return cell
    }
    
    //セルタップ時の挙動
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //＠cellのテキストラベルを編集できるようにしたい
        let cell = bingosheet!.tasks![indexPath.row]//bingoCollectionView.cellForItem(at: indexPath)
        
        print(cell)//Optional(<Mission.EditBingoCollectionViewCell: 0x13d8dc830; baseClass = UICollectionViewCell; frame = (0 0; 116.667 116.667); layer = <CALayer: 0x6000025a7be0>>)
    }
    
    

    
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
