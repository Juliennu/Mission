//
//  EditBingoSheetViewController.swift
//  Mission
//
//  Created by Juri Ohto on 2021/07/11.
//

import UIKit
import Firebase
import SnapKit

class EditBingoSheetViewController: UIViewController {
    
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var rewardLabel: UILabel!
//    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var bingoCollectionView: UICollectionView!

//    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var rewardButton: UIButton!
    @IBOutlet weak var deadlineDatePicker: UIDatePicker!
    @IBOutlet weak var shuffleButton: UIButton!
    
    
    
    let layout = UICollectionViewFlowLayout()
    let db = Firestore.firestore()
    //FolderVCからタップされたcellの情報を受け取る変数
    var bingosheet: BingoSheet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        setUpBingoCollectionView()
        addEventListner()
        setUpLayout()
//        fetchBingosheetInfoFromFirestore()
        
    }
    
    private func setUpLayout() {
        
        let labelsHeight = 25
        let buttonHeight = 35
        let distanceFromLabel = 3
        let distanceFromOtherView = 10
        
        let smallDeviceButtonHeight = 30
        let smallDeviceDistanceFromOtherView = 10
        
        
        bingoCollectionView.snp.makeConstraints { make in
            //中央揃えが最優先
            make.centerX.equalToSuperview().priority(.required)
            make.left.equalTo(20).priority(.high)
            make.right.equalTo(20).priority(.high)
            
            //centerYをsuperViewより上にずらす
            if view.frame.height < 667 {
                make.centerY.equalToSuperview().offset(-30)
            } else {
                make.centerY.equalToSuperview().offset(-50)
            }
            
            //横幅の長さにbingoCollectionViewのサイズ設定を変更
            if self.view.frame.width > 700 {
                //iPad用
                make.width.equalToSuperview().dividedBy(1.5)
            } else {
                //スマホ用
                make.width.equalToSuperview().offset(-40)
            }
            //縦横比を1:1にする
            make.height.equalTo(bingoCollectionView.snp.width)
        }
        
        titleButton.snp.makeConstraints { make in

            make.centerX.equalToSuperview()
            make.width.equalTo(bingoCollectionView.snp.width)
            
            if view.frame.height < 667 {
                make.bottom.equalTo(bingoCollectionView.snp.top).offset(-(smallDeviceDistanceFromOtherView))
                make.height.equalTo(smallDeviceButtonHeight)
            } else {
                make.bottom.equalTo(bingoCollectionView.snp.top).offset(-(distanceFromOtherView))
                make.height.equalTo(buttonHeight)
            }

        }
        
//        titleLabel.snp.makeConstraints { make in
//            make.bottom.equalTo(titleButton.snp.top).offset(-(distanceFromLabel))
//            make.centerX.equalToSuperview()
//            make.width.equalTo(bingoCollectionView.snp.width)
//            make.height.equalTo(labelsHeight)
//        }
        
        rewardLabel.snp.makeConstraints { make in
            //一定値以下の場合は表示しない
            guard view.frame.height >= 667 else {
                rewardLabel.textColor = .clear
                return
            }
            
            make.top.equalTo(bingoCollectionView.snp.bottom).offset(distanceFromOtherView)
            make.centerX.equalToSuperview()
            make.width.equalTo(bingoCollectionView.snp.width)
            make.height.equalTo(labelsHeight)
        }
        
        rewardButton.snp.makeConstraints { make in
            
            make.centerX.equalToSuperview()
            make.width.equalTo(bingoCollectionView.snp.width)
            
            if view.frame.height < 667 {
                make.top.equalTo(bingoCollectionView.snp.bottom).offset(smallDeviceDistanceFromOtherView)
                make.height.equalTo(smallDeviceButtonHeight)
            } else {
                make.top.equalTo(rewardLabel.snp.bottom).offset(distanceFromLabel)
                make.height.equalTo(buttonHeight)
            }
        }
        
        deadlineLabel.snp.makeConstraints { make in
            //一定値以下の場合は表示しない
            guard view.frame.height >= 667 else {
                deadlineLabel.textColor = .clear
                return
            }
            
            make.top.equalTo(rewardButton.snp.bottom).offset(distanceFromOtherView)
            make.left.equalTo(rewardButton.snp.left)
            make.width.equalTo(200)
            make.height.equalTo(labelsHeight)
        }
        
        deadlineDatePicker.snp.makeConstraints { make in
            
            if view.frame.height < 667 {
                make.top.equalTo(rewardButton.snp.bottom).offset(smallDeviceDistanceFromOtherView)
                make.centerX.equalToSuperview()
//                make.left.equalTo(bingoCollectionView.snp.left)
                make.height.equalTo(smallDeviceButtonHeight)
                make.width.equalTo(200)
                
            } else {
                make.top.equalTo(deadlineLabel.snp.bottom).offset(distanceFromLabel)
                make.left.equalTo(rewardButton.snp.left)
                make.width.equalTo(deadlineLabel.snp.width)
                make.height.equalTo(buttonHeight)
            }
        }
        
        shuffleButton.snp.makeConstraints { make in
            make.width.equalTo(138).priority(.high)
            
            //viewの幅が一定値以下の場合はdatePickerの下に配置する
            if self.view.frame.width < 375 {
                make.top.equalTo(deadlineDatePicker.snp.bottom).offset(smallDeviceDistanceFromOtherView)
                make.centerX.equalToSuperview()
//                make.left.equalTo(deadlineDatePicker.snp.left)
                make.height.equalTo(smallDeviceButtonHeight)
            } else {
                make.top.equalTo(deadlineDatePicker.snp.top)
                make.right.equalTo(rewardButton.snp.right)
                make.left.equalTo(deadlineDatePicker.snp.right).offset(10).priority(.medium)
                make.height.equalTo(buttonHeight)
            }
        }
    }
    
    
    
    private func setUpView() {
        view.backgroundColor = viewBackgroundColor
        let views = [
            titleButton,
            rewardButton,
            shuffleButton
        ]
        
        views.forEach {
            $0?.tintColor = .systemBlue
            $0?.backgroundColor = .systemFill
            $0?.layer.cornerRadius = 8.0
        }
        
        
        titleButton.setTitle(bingosheet?.title, for: .normal)
        titleButton.addTarget(self, action: #selector(titleButtonTapped), for: .touchUpInside)
        
        rewardButton.setTitle(bingosheet?.reward, for: .normal)
        rewardButton.addTarget(self, action: #selector(rewardButtonTapped), for: .touchUpInside)
        
        //初期値はデータベース上のdeadlineの日付
        deadlineDatePicker.date = bingosheet!.deadline!
        //西暦表示
        var calender = Calendar(identifier: .gregorian)
        calender.locale = Locale.current
        deadlineDatePicker.calendar = calender
        //日付と時間を変更できるように設定
        deadlineDatePicker.datePickerMode = .dateAndTime
        deadlineDatePicker.addTarget(self, action: #selector(deadlineDatePickerChanged), for: .allEvents)

        
        shuffleButton.addTarget(self, action: #selector(shuffleButtonTapped), for: .touchUpInside)

        let startButton = UIBarButtonItem(image: UIImage(systemName: "arrowtriangle.forward.square"), style: .plain, target: self, action: #selector(startButtonTapped))
        startButton.tintColor = .systemPink
//        startButton.title = "START"
        let saveButton = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItems = [startButton, saveButton]
    }
    
    
    //タスクをランダムに並び替え
    @objc private func shuffleButtonTapped() {
        let shuffledTasks = bingosheet?.tasks?.shuffled()
        bingosheet?.tasks = shuffledTasks
        bingoCollectionView.reloadData()
    }
    
    
    @objc private func titleButtonTapped() {
        //テキストラベルを編集
        var alertTextField: UITextField?
        let title = self.bingosheet!.title
        
        let alert = UIAlertController(
            title: "タイトルを編集",
            message: "",
            preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(
            configurationHandler: {(textField: UITextField!) in
                alertTextField = textField
                textField.text = title
                textField.placeholder = title

       
            })
        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: UIAlertAction.Style.cancel,
                handler: nil))
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default) { _ in
                if let text = alertTextField?.text {
                    self.bingosheet!.title = text
                    //ボタンタイトルの更新
                    self.titleButton.setTitle(self.bingosheet!.title, for: .normal)
                }
            }
        )
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func rewardButtonTapped() {
        //テキストラベルを編集
        var alertTextField: UITextField?
        let title = self.bingosheet!.reward
        
        let alert = UIAlertController(
            title: "クリアごほうびを編集",
            message: "",
            preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(
            configurationHandler: {(textField: UITextField!) in
                alertTextField = textField
                textField.text = title
                textField.placeholder = title

       
            })
        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: UIAlertAction.Style.cancel,
                handler: nil))
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default) { _ in
                if let text = alertTextField?.text {
                    self.bingosheet!.reward = text
                    //ボタンタイトルの更新
                    self.rewardButton.setTitle(self.bingosheet!.reward, for: .normal)
                }
            }
        )
        self.present(alert, animated: true, completion: nil)
    }
    
    //datePickerの値が変更されたら呼ばれる
    @objc private func deadlineDatePickerChanged() {
        //datePickerの変更値をビンゴシートに代入
        self.bingosheet?.deadline = deadlineDatePicker.date

    }
    
    
    //ビンゴシート開始ボタン押下時の挙動
    @objc private func startButtonTapped() {

        //アラート表示
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in

            //Firestoreへ現時点の情報を保存
            guard let bingosheet = self.bingosheet else { return }
            guard let documentId = bingosheet.documentId else { return }

            let dogData = [
                //ここに編集済みのデータを入れる。ビンゴシートの内容、タスクの並び順を固定。
                "title": self.bingosheet!.title ?? "",
                "tasks": self.bingosheet!.tasks ?? [],
                "reward": self.bingosheet!.reward ?? "",
                "deadline": self.bingosheet!.deadline!
            ] as [String: Any]
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            //Firestoreにデータを上書き保存
            self.db.collection("users").document(uid).collection("bingoSheets").document(documentId).setData(dogData, merge: true) { err in
                if let err = err {
                    print("Firestoreへの上書きに失敗しました", err)

                } else {
                    print("Firestoreの情報を上書きしました！", documentId)
                    
                    
                    let bingoSheetInProgress = BingoSheetInProgress(bingoSheet: bingosheet)
                    //実行中のビンゴ情報をFirebaseに保存
                    self.addBingoSheetInProgressToFirestore()

                    
                    guard let tabBarController = self.navigationController?.tabBarController else { return }
                    guard let nc = tabBarController.viewControllers?[1] as? UINavigationController else { return }
                    guard let missionInProgressVC = nc.viewControllers[0] as? MissionInProgressViewController else { return }

                    //ビンゴシート情報を遷移先の変数に渡す
                    missionInProgressVC.createNewBingoSheet(bingoSheetInProgress: bingoSheetInProgress)
                    
                    //MissionInprogressタブを選択状態にする（0が一番左）
                    DispatchQueue.main.async {
                        tabBarController.selectedIndex = 1
                    }
                }
            }
        }
       showAlert(title: "ビンゴミッションを\n開始しますか？", message: "", actions: [cancelAction,okAction])
    }
    
    
    private func addBingoSheetInProgressToFirestore() {

        var ref: DocumentReference? = nil

        let dogData = [
            
            "title": self.bingosheet!.title ?? "",
            "tasks": self.bingosheet!.tasks ?? [],
            "reward": self.bingosheet!.reward ?? "",
            "deadline": self.bingosheet!.deadline!,
            
            "bingoSheetDocumentId": self.bingosheet!.documentId ?? "",
            "tasksAreDone":[Bool](repeating: false, count: bingosheet!.tasks!.count),
            "isDone": false,
            "startedAt": Timestamp()
        ] as [String : Any]

        guard let uid = Auth.auth().currentUser?.uid else { return }

        //Firestoreにコレクションを作成
        ref = db.collection("users").document(uid).collection("bingoSheetsInProgress").addDocument(data: dogData) { err in
            if let err = err {
                print("bingoSheetsInProgressへの保存に失敗しました: ", err)
            } else {
                print("bingoSheetsInProgressへの保存に成功しました: ", ref!.documentID)
            }
        }
    }
    
    
    
    
    
    
    
    
    @objc private func saveButtonTapped() {
        
        //アラート表示
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.overwriteFirestore()
        }
        showAlert(title: "変更を保存しますか？", message: "", actions: [cancelAction,okAction])
    }
    
    private func overwriteFirestore() {
        guard let documentId = bingosheet?.documentId else { return }
        
        let dogData = [
            //ここに編集済みのデータを入れる。ビンゴシートの内容、タスクの並び順を固定。
            "title": bingosheet!.title ?? "",
            "tasks": bingosheet!.tasks ?? [],
            "reward": bingosheet!.reward ?? "",
            "deadline": bingosheet!.deadline!
        ] as [String: Any]
        
        guard let uid = Auth.auth().currentUser?.uid else { return }

        //Firestpreにデータを上書き保存
        db.collection("users").document(uid).collection("bingoSheets").document(documentId).setData(dogData, merge: true) { err in
            if let err = err {
                print("Firestoreへの上書きに失敗しました", err)
                
            } else {
                print("Firestoreの情報を上書きしました！", documentId)
                
                //保存完了アラート表示
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                self.showAlert(title: "保存しました", message: "", actions: [okAction])
//                self.showSaveAlert()
            }
        }
    }
    
    
    
    private func setUpBingoCollectionView() {
        bingoCollectionView.delegate = self
        bingoCollectionView.dataSource = self
        bingoCollectionView.register(EditBingoCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        bingoCollectionView.backgroundColor = .clear
        
        bingoCollectionView.layer.borderWidth = 0
        
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
        
        let cell = bingosheet!.tasks![indexPath.row]//bingoCollectionView.cellForItem(at: indexPath)
        
        //cellのテキストラベルを編集
        var alertTextField: UITextField?
        
        let alert = UIAlertController(
            title: "タスクを編集",
            message: "",
            preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(
            configurationHandler: {(textField: UITextField!) in
                alertTextField = textField
                textField.text = self.bingosheet!.tasks![indexPath.row]
                textField.placeholder = cell
       
            })
        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: UIAlertAction.Style.cancel,
                handler: nil))
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default) { _ in
                if let text = alertTextField?.text {
                    self.bingosheet!.tasks![indexPath.row] = text
                    //collectionViewの更新
                    collectionView.reloadData()
                }
            }
        )
        self.present(alert, animated: true, completion: nil)
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
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.font = UIFont(name: "Futura", size: 20)
        //
//        label.adjustsFontSizeToFitWidth = true
//        //自動調整時の文字サイズ最小値(元々の文字サイズに対する比率)
//        label.minimumScaleFactor = 0.8
        
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
        self.layer.borderColor = bingoCellBorderColor.cgColor//UIColor.systemGray.cgColor
        
        self.layer.backgroundColor = undoneCellUIColor.cgColor//UIColor.yellow.cgColor
        self.layer.cornerRadius = 8.0
        
        //セルの境界からはみ出ているものを見えるようにする
        self.layer.masksToBounds = false
        //影をつける
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 1.0
//        self.layer.shadowColor = UIColor.black.cgColor
        
    }
    required init?(coder: NSCoder) {//＠これは何？→よくわからない。swiftの場合、override init(frame: CGRect)とセットで必要になる模様。
        
        fatalError("init(coder:) has not been implemented")
        
    }
}
