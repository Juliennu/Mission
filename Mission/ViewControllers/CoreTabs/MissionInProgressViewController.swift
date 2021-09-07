//
//  MissionInProgressViewController.swift
//  Mission
//
//  Created by Juri Ohto on 2021/07/09.
//
//AppID: ca-app-pub-4434300298107671~1133508022
//UnitID: ca-app-pub-4434300298107671/5662660412
//TestUnitID: ca-app-pub-3940256099942544/2934735716

import UIKit
import GoogleMobileAds
import SnapKit//AutoLayoutを簡潔にかけるライブラリ
//import UserNotifications
import Lottie//Animation
import Firebase

class MissionInProgressViewController: UIViewController {
    
    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!


    @IBOutlet weak var bannerView: GADBannerView!//Admobを表示
    
    let db = Firestore.firestore()
    //実行中のビンゴ情報を格納する配列
    var bingoSheetsInProgress = [BingoSheetInProgress]()
    
    var bingoSheetInProgressDataFromFirebase = [BingoSheetInProgressDataFromFirebase]()
    
    var bingoStatusLabelArray = [UILabel]()
    
    var offsetX: CGFloat = 0
    //pageControlのcurrentPage番号
    var currentPageIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = viewBackgroundColor

        setUpVannerView()
        setUpSoundPrepare()
        setUpBarButtonItem()
        setUpScrollView()
        setUpPageControl()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        createBingoSheet()
    }
    
//MARK: - AdMob バナー広告の設定
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Note loadBannerAd is called in viewDidAppear as this is the first time that
        // the safe area is known. If safe area is not a concern (e.g., your app is
        // locked in portrait mode), the banner can be loaded in viewWillAppear.
        loadBannerAd()
    }
    
    override func viewWillTransition(to size: CGSize,
                                  with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to:size, with:coordinator)
            coordinator.animate(alongsideTransition: { _ in
              self.loadBannerAd()
            })
          }

          func loadBannerAd() {
            // Step 2 - Determine the view width to use for the ad width.
            let frame = { () -> CGRect in
              // Here safe area is taken into account, hence the view frame is used
              // after the view has been laid out.
              if #available(iOS 11.0, *) {
                return view.frame.inset(by: view.safeAreaInsets)
              } else {
                return view.frame
              }
            }()
            let viewWidth = frame.size.width

            // Step 3 - Get Adaptive GADAdSize and set the ad view.
            // Here the current interface orientation is used. If the ad is being preloaded
            // for a future orientation change or different orientation, the function for the
            // relevant orientation should be used.
            bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)

            // Step 4 - Create an ad request and load the adaptive banner ad.
            bannerView.load(GADRequest())
          }
    
    private func setUpVannerView() {
        bannerView.adUnitID = "ca-app-pub-4434300298107671/5662660412"//本番用
        bannerView.rootViewController = self
        bannerView.delegate = self
    }
    
//MARK: - functions
    
//    func setUpBigCheckAnimationView() {
//        let animationView = AnimationView(name: "lf30_editor_rk36ohuj")//大きいチェックマーク
//        animationView.loopMode = .playOnce
//        animationView.play()
//        view.addSubview(animationView)
//    }
    
//    func setUpSmallCrackerAnimationView() {
//        let animationView = AnimationView(name: "71420-sparkle")//弾けるクラッカー
//    //        animationView.frame =
//        animationView.loopMode = .playOnce
//        animationView.play()
//        bingoCollectionView.addSubview(animationView)
//    }

    
    private func setUpTitleLabel() -> UILabel {
        
        let viewWidthInt = Int(self.view.frame.size.width)
        let positionX = Int(viewWidthInt) * (bingoSheetsInProgress.count - 1)
        var bingoWidth = viewWidthInt - 40//スマホ用
        if viewWidthInt > 700 {
            //iPad用
            bingoWidth = viewWidthInt / 15 * 10
        }
        let x = positionX + (viewWidthInt - bingoWidth) / 2
        
        let titleLabel = UILabel(frame: CGRect(x: x, y: 20, width: bingoWidth, height: 30))
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "System Bold", size: 19.0)
        titleLabel.backgroundColor = .systemGray5
        return titleLabel
    }
    
    private func setUpDeadlineLabel() -> UILabel {
        
        let viewWidthInt = Int(self.view.frame.size.width)
        let positionX = Int(viewWidthInt) * (bingoSheetsInProgress.count - 1)
        var bingoWidth = viewWidthInt - 40//スマホ用
        if viewWidthInt > 700 {
            //iPad用
            bingoWidth = viewWidthInt / 15 * 10
        }
        let x = positionX + (viewWidthInt - bingoWidth) / 2
        
        let deadlineLabel = UILabel(frame: CGRect(x: x, y: 55, width: bingoWidth, height: 30))
        deadlineLabel.textAlignment = .center
        deadlineLabel.font = UIFont(name: "System Bold", size: 19.0)
        deadlineLabel.backgroundColor = .systemGray5
        deadlineLabel.sizeToFit()
        return deadlineLabel
    }

    
    private func setUpBingoCollectionView() -> UICollectionView {

        let viewWidthInt = Int(self.view.frame.size.width)
        let positionX = Int(viewWidthInt) * (bingoSheetsInProgress.count - 1)
        var bingoWidth = viewWidthInt - 40//スマホ用
        if viewWidthInt > 700 {
            //iPad用
            bingoWidth = viewWidthInt / 15 * 10
        }
        let x = positionX + (viewWidthInt - bingoWidth) / 2
        
        let bingoCollectionView = UICollectionView(frame: CGRect(x: x, y: 100, width: bingoWidth, height: bingoWidth), collectionViewLayout: UICollectionViewFlowLayout())
        bingoCollectionView.register(BingoCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        bingoCollectionView.backgroundColor = .clear
        bingoCollectionView.delegate = self
        bingoCollectionView.dataSource = self
        bingoCollectionView.layer.borderWidth = 0.0
        
        return bingoCollectionView

    }
    
    private func setUpBingoStatusLabel() -> UILabel {
        
        let viewWidthInt = Int(self.view.frame.size.width)
        let positionX = Int(viewWidthInt) * (bingoSheetsInProgress.count - 1)
        var bingoWidth = viewWidthInt - 40//スマホ用
        if viewWidthInt > 700 {
            //iPad用
            bingoWidth = viewWidthInt / 15 * 10
        }
        let x = positionX + (viewWidthInt - bingoWidth) / 2
        
        let bingoStatusLabel = UILabel(frame: CGRect(x: x, y: (100 + bingoWidth / 2), width: bingoWidth, height: 80))
        bingoStatusLabel.isHidden = true
        bingoStatusLabel.font = UIFont(name: "Party LET Plain", size: 61.0)
        bingoStatusLabel.textColor = .yellow
        bingoStatusLabel.shadowColor = .brown
        bingoStatusLabel.textAlignment = .center
        return bingoStatusLabel
    }
    
    private func setUpScrollView() {
        
        let viewWidthInt = Int(self.view.frame.size.width)
        var bingoWidth = viewWidthInt - 40//スマホ用
        if viewWidthInt > 700 {
            //iPad用
            bingoWidth = viewWidthInt / 15 * 10
        }
        
        let navBarHeight = Int((navigationController?.navigationBar.frame.size.height)!)
        // scrollViewの画面表示サイズを指定
        scrollView = UIScrollView(frame: CGRect(x: 0, y: navBarHeight, width: viewWidthInt, height: 100 + bingoWidth + 80))
        // scrollViewのデリゲートになる
        scrollView.delegate = self
        scrollView.backgroundColor = viewBackgroundColor
        // ページ単位のスクロールを可能にする
        scrollView.isPagingEnabled = true
        // 水平方向のスクロールインジケータを非表示にする
        scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollView)
        // scrollviewを最背面に移動
        self.view.sendSubviewToBack(scrollView)
    }
    
    private func setUpPageControl() {
        
        let viewWidthInt = Int(self.view.frame.size.width)
        var bingoWidth = viewWidthInt - 40//スマホ用
        if viewWidthInt > 700 {
            //iPad用
            bingoWidth = viewWidthInt / 15 * 10
        }
        // pageControlの表示位置とサイズの設定
        pageControl = UIPageControl(frame: CGRect(x: 0, y: 100 + bingoWidth + 80 + 10, width: viewWidthInt, height: 30))
        //ページ数が1の時ドットが表示されなくなる
        pageControl.hidesForSinglePage = true
        //pageControl上をスクロールすることでページを切り替えられる
        pageControl.allowsContinuousInteraction = true
        // pageControlのドットの色
        pageControl.pageIndicatorTintColor = UIColor.gray
        // pageControlの現在のページのドットの色
        pageControl.currentPageIndicatorTintColor = UIColor.systemPink
        //pageControlの値変更時にアクションを設定
        pageControl.addTarget(self, action: #selector(pageScroll), for: .valueChanged)

        
        self.view.addSubview(pageControl)
    }
    
    
    @objc func pageScroll() {
        
        let viewWidth = view.frame.size.width
        currentPageIndex = pageControl.currentPage
        offsetX = CGFloat(Int(viewWidth) * currentPageIndex)
        
        //scrollViewの原点からずらす
        scrollView.contentOffset.x = offsetX
    }
    
    
    func createNewBingoSheet(bingoSheetInProgress: BingoSheetInProgress) {
        
        bingoSheetsInProgress.append(bingoSheetInProgress)

        let bingoCollectionView = setUpBingoCollectionView()
        let titleLabel = setUpTitleLabel()
        let deadlineLabel = setUpDeadlineLabel()
        let bingoStatusLabel = setUpBingoStatusLabel()

        let viewWidthInt = Int(self.view.frame.size.width)
        let positionX = Int(viewWidthInt) * (bingoSheetsInProgress.count - 1)
        var bingoWidth = viewWidthInt - 40//スマホ用
        if viewWidthInt > 700 {
            //iPad用
            bingoWidth = viewWidthInt / 15 * 10
        }
        let x = positionX + (viewWidthInt - bingoWidth) / 2
        
        //@ここで呼ばないとscrollView上に表示されないのはなんで？
        deadlineLabel.frame = CGRect(x: x, y: 55, width: bingoWidth, height: 30)
 
        titleLabel.text = bingoSheetInProgress.bingoSheet.title
        
        let dateString = dateFormatter(date: bingoSheetInProgress.bingoSheet.deadline!)
        deadlineLabel.text = "期限 : \(dateString)"
        
        self.scrollView.addSubview(bingoCollectionView)
        self.scrollView.addSubview(titleLabel)
        self.scrollView.addSubview(deadlineLabel)
        self.scrollView.addSubview(bingoStatusLabel)
        
        //bingoStatusLabelを追加
        bingoStatusLabelArray.append(bingoStatusLabel)
 
        // scrollViewのサイズを指定（幅は1ページに表示するViewの幅×ページ数）
        
        scrollView.contentSize = CGSize(width: viewWidthInt * bingoSheetsInProgress.count, height: 1)//縦スクロールなし
        // pageControlのページ数を設定
        pageControl.numberOfPages = bingoSheetsInProgress.count
        
        // pageControlの現在ページを配列の最後のインデックスと同じにする
        pageControl.currentPage = bingoSheetsInProgress.count
        pageScroll()
    }
    
    private func readBingoSheetInProgressFromFirestore() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        //Firestoreからコレクションのすべてのドキュメントを取得する
        db.collection("users").document(uid).collection("bingoSheetsInProgress").getDocuments() { (querySnapshot, err) in
            //非同期処理：記述された順番は関係なく、getDocumentsの処理が完了したらクロージャを実行する
            if let err = err {
                print("Firestoreから情報の取得に失敗しました。", err)
            } else {
                for document in querySnapshot!.documents {
                    //Firestoreから取得した情報をBingoSheet型のモデルに変換
                    let data = BingoSheetInProgressDataFromFirebase(document: document)
                    //配列に追加
                    self.bingoSheetInProgressDataFromFirebase.append(data)
                }
            }
        }

    }
    
    
    
    func drawBingoSheet() {
        
        let viewWidthInt = Int(self.view.frame.size.width)
        
        guard bingoSheetsInProgress.count > 0 else {
            //bingoSheetsInProgress.count = 0だった時
            let subViews = scrollView.subviews
            //scrollViewからsubViewsを削除する
            for subview in subViews {
                subview.removeFromSuperview()
            }
            return
        }
        
        
        for i in 0..<bingoSheetsInProgress.count {
            let bingoCollectionView = setUpBingoCollectionView()
            let titleLabel = setUpTitleLabel()
            let deadlineLabel = setUpDeadlineLabel()
            let bingoStatusLabel = setUpBingoStatusLabel()

            
            let positionX = Int(viewWidthInt) * (i - 1)
            var bingoWidth = viewWidthInt - 40//スマホ用
            if viewWidthInt > 700 {
                //iPad用
                bingoWidth = viewWidthInt / 15 * 10
            }
            let x = positionX + (viewWidthInt - bingoWidth) / 2
            
            //@ここで呼ばないとscrollView上に表示されないのはなんで？
            deadlineLabel.frame = CGRect(x: x, y: 55, width: bingoWidth, height: 30)
     
            titleLabel.text = bingoSheetsInProgress[i].bingoSheet.title
            
            let dateString = dateFormatter(date: bingoSheetsInProgress[i].bingoSheet.deadline!)
            deadlineLabel.text = "期限 : \(dateString)"
            
            if bingoSheetsInProgress[i].isDone! {
                bingoStatusLabel.text = "Congratulations!"
            } else {
                bingoStatusLabel.text = "BINGO!"
            }
            
            self.scrollView.addSubview(bingoCollectionView)
            self.scrollView.addSubview(titleLabel)
            self.scrollView.addSubview(deadlineLabel)
            self.scrollView.addSubview(bingoStatusLabel)
        }
        // scrollViewのサイズを指定（幅は1ページに表示するViewの幅×ページ数）
        scrollView.contentSize = CGSize(width: viewWidthInt * bingoSheetsInProgress.count, height: 1)//縦スクロールなし
        // pageControlのページ数を設定
        pageControl.numberOfPages = bingoSheetsInProgress.count
    }
    

    private func setUpBarButtonItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shared))//(title: "シェア", style: .plain, target: self, action: #selector(shared))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), style: .plain, target: self, action: #selector(removeButtonTapped))//(title: "中断", style: .plain, target: self, action: #selector(canceled))
        navigationItem.rightBarButtonItem?.tintColor = .red
    }
    
    //シェア
    @objc func shared() {
        //ビンゴシートが存在しない時エラー表示
        if bingoSheetsInProgress.count < 1 {
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            showAlert(title: "共有エラー", message: "実行中のビンゴシートが存在しません", actions: [okAction])
            return
        }
        
        let viewWidthInt = Int(self.view.frame.size.width)
        let heightInt = Int(self.scrollView.frame.size.height)
        
        // scrollViewの画面表示サイズを指定
        let size = CGSize(width: viewWidthInt, height: heightInt)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        //scrollViewをスクショの範囲に指定
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)//self.scrollView.frame
        //スリーンショットをUIImage型で取得
        let screenShotImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //ビンゴシートが完了か否かでメッセージを変える
        var message = ""
        if bingoSheetsInProgress[currentPageIndex].isDone == false {
            message = "ビンゴミッションに挑戦中！"
        } else {
          message = "ビンゴミッションをクリア☆"
        }
        
        let activityViewController = UIActivityViewController(activityItems: [message, screenShotImage], applicationActivities: nil)
        
        //iOS8のiPad用：初期化しないとクラッシュするため以下1文追加
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)

    }
    
    //ビンゴシート削除
    @objc func removeButtonTapped() {
        //ビンゴシートが存在しない時エラー表示
        if bingoSheetsInProgress.count < 1 {
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            showAlert(title: "削除エラー", message: "実行中のビンゴシートが存在しません", actions: [okAction])
            return
        }

        //削除をアラート表示
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .destructive) { _ in

            //現在表示中のビンゴシートを配列から削除
            self.bingoSheetsInProgress.remove(at: self.currentPageIndex)
            //bingoStatusLabelArrayからも削除
            self.bingoStatusLabelArray.remove(at: self.currentPageIndex)
            //再描写する
            self.drawBingoSheet()
        }
        //Alertを表示
            showAlert(title: "ビンゴシート削除", message: "現在表示中のビンゴシートを\n削除してもよろしいですか?", actions: [cancelAction, okAction])
    }
    
    
    
//    func setUpImageView() {
//        let bingoImage = UIImage(named: "cracker")?.withRenderingMode(.alwaysTemplate)
////        let congratulations = UIImage(named: "")?.withRenderingMode(.alwaysTemplate)
//        imageView = UIImageView(frame: CGRect(x: 20, y: 320, width: self.view.frame.size.width - 40, height: 400))
//        imageView.image = bingoImage
//        imageView.isHidden = true
//        self.view.addSubview(imageView)
//    }

    
    


    //ビンゴになった時の挙動
    func bingoAction() {
//        sleep(1)//1秒止める
        bingoStatusLabelArray[currentPageIndex].isHidden = false
//        bingoStatusLabel.isHidden = false
//        scrollView.bringSubviewToFront(bingoStatusLabel)
        bingoSoundPlay()
//        imageView.isHidden = false
//        setUpSmallCrackerAnimationView()
//        sleep(2)//2秒止める
//        bingoStatusLabel.isHidden = true
    }
    
    //Date型をString型へ変換
    func dateFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
    
    
    
    //日時指定通知
//    func localNotification() {
//        //通知内容
//        let content = UNMutableNotificationContent()
//        content.sound = UNNotificationSound.default
//        content.title = "ローカル通知テスト"
//        content.subtitle = "日時指定"
//        content.body = "まだ未完了のタスクがありますよ〜"//@未完了タスクの有無によって通知を切り替える？
//        //通知日時をセット
//        guard let deadline = bingoSheetsInProgress[currentPageIndex].bingoSheet.deadline else { return }//@今開いているビンゴシートしか通知対象にならないので要修正
//        //1時間前に通知
//        let alertDate = Date(timeInterval: -(60*60), since: deadline)
//        let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: alertDate)
//        //通知リクエストを作成
//        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: true)
//        //ユニークなIDを作る
//        let identifier = NSUUID().uuidString
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//
//        //通知リクエストを登録
//        UNUserNotificationCenter.current().add(request) { (error) in
//            if let error = error {
//                print("通知リクエストの登録に失敗しました: ", error.localizedDescription)
//            }
//        }
//    }
    

    
}


    

// MARK: - CollectionView Delegates

extension MissionInProgressViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //セクション数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
//        return tasks.count
    }
    
    
    //セクションごとのアイテム数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
//        return tasks[section].count//@Firebaseからデータを持ってきたい
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
    
    //セルの中身(描写)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = bingoCollectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! BingoCollectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! BingoCollectionViewCell
        
        
        let currentBingo = bingoSheetsInProgress[currentPageIndex]
//        let taskIsDone = currentBingo.tasksAreDone[indexPath.section][indexPath.row]
        
        cell.taskLabel.text = currentBingo.tasks[indexPath.section][indexPath.row]
        
        //freeマスの時は専用イラストにする
        if currentBingo.tasks[indexPath.section][indexPath.row] == "free" {
            cell.imageView.image = UIImage(named: "freeImage1")
            bingoSheetsInProgress[currentPageIndex].tasksAreDone[indexPath.section][indexPath.row] = true
        } else {
            cell.imageView.image = UIImage(named: "thumbsUpImage")//thumbsUpImage, checkMarkImage, medalImage
        }
        
        //セルタップ時にtrue/falseを切り替え、trueの時backgroundColorを灰色にする
        //未完了タスクセル
        if bingoSheetsInProgress[currentPageIndex].tasksAreDone[indexPath.section][indexPath.row] == false {
            cell.backgroundColor? = undoneCellUIColor
            cell.imageView.isHidden = true

        //完了タスクセル
        } else {
            cell.backgroundColor = doneCellUIColor
            cell.imageView.isHidden = false
            

        }

        
        return cell
    }
    
    //セルタップ時の挙動
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath)

        let currentBingo = bingoSheetsInProgress[currentPageIndex]

        let taskIsDone = currentBingo.tasksAreDone[indexPath.section][indexPath.row]
        bingoStatusLabelArray[currentPageIndex].text = "BINGO!"
//        bingoStatusLabel.isHidden = true
        bingoStatusLabelArray[currentPageIndex].isHidden = true
//        imageView.isHidden = true
    
//        taskIsDone.toggle()
        //未完了タスクセル押下時
        if taskIsDone == false {
            currentBingo.tasksAreDone[indexPath.section][indexPath.row] = true
            taskIsDoneSoundPlay()
            
        //完了タスクセル押下時
        } else {
            currentBingo.tasksAreDone[indexPath.section][indexPath.row] = false
            taskIsUndoneSoundPlay()
            bingoSheetsInProgress[currentPageIndex].isDone = false
        }
        
        collectionView.reloadData()

        
        //縦横斜めが揃ったら「ビンゴ」と表示する
        //横の判定
        if currentBingo.tasksAreDone[indexPath.section] == [true, true, true] {
//        if tasksAreDone[indexPath.section] == [true, true, true] {
//            print("よこビンゴ！")
            bingoAction()
        }
        
        //結果シートの縦の列を配列に格納
        let tasksAreDoneColumn = [
            currentBingo.tasksAreDone[0][indexPath.row],
            currentBingo.tasksAreDone[1][indexPath.row],
            currentBingo.tasksAreDone[2][indexPath.row]
        ]
//        let tasksAreDoneColumn = [tasksAreDone[0][indexPath.row], tasksAreDone[1][indexPath.row], tasksAreDone[2][indexPath.row]]
        //縦の判定
        if tasksAreDoneColumn == [true, true, true] {
//            print("たてビンゴ！")
            bingoAction()
        }
        
        //結果シートの斜めの列を配列に格納
        let tasksAreDoneDiagonalArray1 = [currentBingo.tasksAreDone[0][0],
                                          currentBingo.tasksAreDone[1][1],
                                          currentBingo.tasksAreDone[2][2]]
        let tasksAreDoneDiagonalArray2 = [currentBingo.tasksAreDone[0][2],
                                          currentBingo.tasksAreDone[1][1],
                                          currentBingo.tasksAreDone[2][0]]
//        let tasksAreDoneDiagonalArray1 = [tasksAreDone[0][0], tasksAreDone[1][1], tasksAreDone[2][2]]
//        let tasksAreDoneDiagonalArray2 = [tasksAreDone[0][2], tasksAreDone[1][1], tasksAreDone[2][0]]
            
            if indexPath.section == indexPath.row,
               tasksAreDoneDiagonalArray1 == [true, true, true] {
//                print("ななめビンゴ1！")
                bingoAction()
            }
            
            if indexPath.section + indexPath.row == 2,
               tasksAreDoneDiagonalArray2 == [true, true, true] {
//                print("ななめビンゴ2！")
                bingoAction()
            }


        //ビンゴシート達成の判定
        if currentBingo.tasksAreDone == [[true, true, true], [true, true, true], [true, true, true]] {
//        if tasksAreDone == [[true, true, true], [true, true, true], [true, true, true]] {
            print("ビンゴシートクリア！")
            currentBingo.isDone = true
//            bingoSheetIsDone = true
//            sleep(1)
            bingoStatusLabelArray[currentPageIndex].text = "Congratulations!"
//            bingoStatusLabel.isHidden = false
            bingoStatusLabelArray[currentPageIndex].isHidden = false
            clearSoundPlay()
//            setUpBigCheckAnimationView()
            
            //ごほうびをアラート表示
            let message = currentBingo.bingoSheet.reward
            //UIAlertControllerクラスのインスタンスを生成
            let actionSheet = UIAlertController(title: message, message: "", preferredStyle: .alert)//.actionSheet:画面下部から出てくるアラート//.alert:画面中央に表示されるアラート
            //UIAlertControllerにActionを追加
            let title = ["お疲れ様でした☕️", "いい感じです🍀", "さすが！", "バッチリです✨", "すごい!👏", "がんばってますね😌", "エライ！", "その調子！", "素晴らしい🌟", "やりました🎉", "その調子！", "Nice🌟"]
            actionSheet.addAction(UIAlertAction(title: title.randomElement(), style: .default, handler: nil))
            //Alertを表示
            present(actionSheet, animated: true, completion: nil)
           
            
        }
    }
}


//MARK:- ScrollView Delegate

extension MissionInProgressViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // scrollViewのページ移動に合わせてpageControlの表示も移動させる
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        //offsetXの値を更新
        offsetX = scrollView.contentOffset.x
        //currentPageIndexの値を更新
        currentPageIndex = pageControl.currentPage
        
    }
    
}


//MARK:- Admob BannerView Delegate
extension MissionInProgressViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        
//        bannerView.alpha = 0
//        UIView.animate(withDuration: 1, animations: {
//            bannerView.alpha = 1
//        })
//        print("bannerView:広告を受信しました")
    }
//
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
//        print("bannerView:広告の受信に失敗しました: \(error.localizedDescription)")
    }
}


//MARK: - MissionInProgressCollectionViewCell

class BingoCollectionViewCell: UICollectionViewCell {
    
    //セル選択時にボタン色を変更する※できない
//    override var isHighlighted: Bool {
//        didSet {
//            if isHighlighted {
//                //                self.taskLabel.backgroundColor = .gray
//                imageView.isHidden = false
////                self.taskLabel.alpha = 0.3//alphaは薄さのこと。数字が大きいほど濃い。
//            } else {
//                imageView.isHidden = true
////                self.taskLabel.alpha = 1.0
//            }
//        }
//    }
    
    
    
    var imageView: UIImageView = {
        let image = UIImageView()
//        image.image = UIImage(named: "thumbsUpImage")
        //＠設定画面でスタンプのデザインを選べるようにしたい
        return image
    }()
    
    
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Futura", size: 20)
        label.clipsToBounds = true
        //lavelを折り返して全文表示
        label.lineBreakMode = .byWordWrapping//単語単位で区切って改行
        label.numberOfLines = 0//最大制限なし（必要なだけ行数を使用）
        label.backgroundColor = .clear
        
        return label
    }()
    
    override init(frame: CGRect) {//＠これは何？→カスタムUIViewの初期化を記述
        super.init(frame: frame)
        
        addSubview(taskLabel)
        addSubview(imageView)

        
        taskLabel.frame.size = self.frame.size
        let imageWidth = self.frame.width / 2
        imageView.frame.size = CGSize(width: imageWidth, height: imageWidth)//＠イメージサイズはセルの大きさより少し小さくしたい
        imageView.isHidden = true//タスククリア前はイメージ表示しない
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = bingoCellBorderColor.cgColor//UIColor.systemGray.cgColor
    
        self.layer.backgroundColor = undoneCellUIColor.cgColor//UIColor.yellow.cgColor
        self.layer.cornerRadius = 8.0
        
        
    }
    required init?(coder: NSCoder) {//＠これは何？→よくわからない。swiftの場合、override init(frame: CGRect)とセットで必要になる模様。
        
        fatalError("init(coder:) has not been implemented")
        
    }
}
