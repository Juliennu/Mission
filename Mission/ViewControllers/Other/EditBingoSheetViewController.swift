//
//  EditBingoSheetViewController.swift
//  Mission
//
//  Created by Juri Ohto on 2021/07/11.
//

import UIKit
import Firebase

class EditBingoSheetViewController: UIViewController {
    
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var rewardLabel: UILabel!
//    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var bingoCollectionView: UICollectionView!

    
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var rewardButton: UIButton!
    @IBOutlet weak var deadlineDatePicker: UIDatePicker!
    
//    @IBOutlet weak var deadlineButton: UIButton!
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
//        fetchBingosheetInfoFromFirestore()
        
    }
    
    private func setUpView() {
//        titleLabel.text = bingosheet?.title
//        rewardLabel.text = bingosheet?.reward
//        let dateString = dateToString(date: bingosheet!.deadline!)
//        deadlineLabel.text = dateString
        
        
        titleButton.setTitle(bingosheet?.title, for: .normal)
        titleButton.backgroundColor = .systemGray5
        titleButton.layer.cornerRadius = 8.0
        titleButton.addTarget(self, action: #selector(titleButtonTapped), for: .touchUpInside)
        
        rewardButton.setTitle(bingosheet?.reward, for: .normal)
        rewardButton.backgroundColor = .systemGray5
        rewardButton.layer.cornerRadius = 8.0
        rewardButton.addTarget(self, action: #selector(rewardButtonTapped), for: .touchUpInside)
        
        //初期値はデータベース上のdeadlineの日付
        deadlineDatePicker.date = bingosheet!.deadline!
        //西暦表示 -> ＠和暦表示になってしまうので直す
        var calender = Calendar(identifier: .gregorian)
        calender.locale = Locale.current
        deadlineDatePicker.calendar = calender
        //日付のみ変更できるように設定
        deadlineDatePicker.datePickerMode = .date
        // DatePickerを日本語化
        deadlineDatePicker.locale = Locale(identifier: "ja_JP")
        deadlineDatePicker.addTarget(self, action: #selector(deadlineDatePickerChanged), for: .allEvents)

//        deadlineButton.setTitle(dateString, for: .normal)
//        deadlineButton.addTarget(self, action: #selector(deadlineButtonTapped), for: .touchUpInside)
        
        shuffleButton.addTarget(self, action: #selector(shuffleButtonTapped), for: .touchUpInside)
        shuffleButton.backgroundColor = .systemGray5
        shuffleButton.layer.cornerRadius = 8.0
        
        let startButton = UIBarButtonItem(title: "開始", style: .plain, target: self, action: #selector(startButtonTapped))
        let saveButton = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItems = [startButton, saveButton]
    }
    
    //Date型からString型へ変換
//    func dateToString(date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.calendar = Calendar(identifier: .gregorian)
//        formatter.dateStyle = .medium//2017/08/13
//        formatter.doesRelativeDateFormatting = true//当日を「今日」、前日を「昨日」などと表示する
//        formatter.locale = Locale(identifier: "ja_JP")
//        return formatter.string(from: date)
//    }
    
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
            guard let documentId = self.bingosheet?.documentId else { return }

            let dogData = [
                //ここに編集済みのデータを入れる。ビンゴシートの内容、タスクの並び順を固定。
                "title": self.bingosheet!.title!,
                "tasks": self.bingosheet!.tasks!,
                "reward": self.bingosheet!.reward!,
                "deadline": self.bingosheet!.deadline!
            ] as [String: Any]

            //Firestoreにデータを上書き保存
            self.db.collection("bingoSheets").document(documentId).setData(dogData, merge: true) { err in
                if let err = err {
                    print("Firestoreへの上書きに失敗しました", err)

                } else {
                    print("Firestoreの情報を上書きしました！", documentId)

                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)//MissionInProgress
                    let nc = self.tabBarController?.viewControllers![1] as! UINavigationController
                    let missionInProgressVC = nc.topViewController as! MissionInProgressViewController
//                    let missionInProgressVC = nc.topViewController as! MissionInProgressViewController
//                    let missionInProgressVC = storyboard.instantiateViewController(identifier: "MissionInProgressViewController") as! MissionInProgressViewController
                    //instantiate: インスタンスを生成する-> これだとTabBarControllerで管理されているViewControllerとは別のものになってしまう
                    
                    
                    //ビンゴシート情報を遷移先の変数に渡す
                    missionInProgressVC.bingoSheets.append(self.bingosheet!)

                    //MissionInprogressタブへ遷移
                    //①タブバーのインスタンスを取得
                    if let tabBarController = UIApplication.shared.windows.first?.rootViewController as? UITabBarController {
                        //②MissionInprogressタブを選択状態にする（0が一番左）
                        DispatchQueue.main.async {
                            tabBarController.selectedIndex = 1
                            
                        }

                    }

                    //MissionInprogressVCへ遷移
                    self.navigationController?.pushViewController(missionInProgressVC, animated: true)
                }
            }
        }
       showAlert(title: "ビンゴミッションを\n開始しますか?", message: "", actions: [cancelAction,okAction])
    }

    
    
    private func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0)}
        present(alert, animated: true)
    }
    
    
    
    
    
    
    
    
    @objc private func saveButtonTapped() {
        overwriteFirestore()
    }
    
    private func overwriteFirestore() {
        guard let documentId = bingosheet?.documentId else { return }
        
        let dogData = [
            //ここに編集済みのデータを入れる。ビンゴシートの内容、タスクの並び順を固定。
            "title": bingosheet!.title!,
            "tasks": bingosheet!.tasks!,
            "reward": bingosheet!.reward!,
            "deadline": bingosheet!.deadline!
        ] as [String: Any]

        //Firestpreにデータを上書き保存
        db.collection("bingoSheets").document(documentId).setData(dogData, merge: true) { err in
            if let err = err {
                print("Firestoreへの上書きに失敗しました", err)
            } else {
                print("Firestoreの情報を上書きしました！", documentId)
                //保存完了アラート表示
                self.showSaveAlert()
            }
        }
    }
    
    
    private func showSaveAlert() {
        let alert = UIAlertController(title: "保存しました", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
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
        label.text = "free"
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
        
        self.layer.backgroundColor = undoneUIColor.cgColor//UIColor.yellow.cgColor
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
