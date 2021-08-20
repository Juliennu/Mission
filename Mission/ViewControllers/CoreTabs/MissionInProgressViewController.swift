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

class MissionInProgressViewController: UIViewController {
    
    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    private var bingoCollectionView: UICollectionView!
    private var titleLabel: UILabel!
    private var bingoStatusLabel: UILabel!
    
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var bingoCollectionView: UICollectionView!
    
//    @IBOutlet weak var bingoStatusLabel: UILabel!//Font: Party LET Plain 61.0
    @IBOutlet weak var bannerView: GADBannerView!//Admobを表示
    
    //実行中のビンゴ情報を格納する配列
    var bingoSheetsInProgress = [BingoSheetInProgress]()
    //pageControlのcurrentPage番号
    var x: Int = 0
//    //実行中のビンゴ情報を格納する配列
//    var bingoSheets = [BingoSheet]()
//    //タスクを格納する二次元配列
//    var tasks = [[String]]()
//    //タスクの完了状況を管理する二次元配列
//    var tasksAreDone = [[Bool]]()

    
    
    
    //ビンゴシートの完了状況を管理するBool型
//    var bingoSheetIsDone = false//@bingoSheets.last?.isDoneみたいな感じで対応するのでこれは消す予定
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        


//        print("tasks", tasks)
        setUpVannerView()
        setUpSoundPrepare()
        setUpBarButtonItem()

        setUpScrollView()
//        setUpImageView()
        setUpPageControl()
        setUpBingoStatusLabel()
        setUpView()
        setUpBingoCollectionView()
        
//        addEventListner()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
//        createNewBingoSheet()
                
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
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"//!!!!!!!!!!!Apple申請前に本番用IDに変更する!!!!!!!!!!!
        bannerView.rootViewController = self
        bannerView.delegate = self
    }
    
//MARK: - functions
    
    func setUpView() {
        

        
        
        titleLabel = UILabel(frame: CGRect(x: 20, y: 20, width: self.view.frame.size.width - 40, height: 30))
        titleLabel.text = "イントロダクション"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "System Bold", size: 19.0)//System Bold 19.0
        titleLabel.backgroundColor = .systemGray5
//        scrollView.addSubview(titleLabel)
        
//        tasks = [
//            ["フォルダータブを選択", "＋ボタンを押下", "新規ビンゴシートを作成"],
//            ["ビンゴシート詳細を編集","ドラッグ&ドロップでタスクを並び替え", "タスクをシャッフルボタンでランダム並び替え"],
//            ["開始ボタンを押下", "ビンゴミッションスタート", "完了したタスクをクリックしてスタンプを押そう！"]
//        ]
//
//        tasksAreDone = [[Bool]](repeating: [Bool](repeating: false, count: tasks.count), count: tasks.count)

    }
    
    
    
    private func setUpBingoCollectionView() {

        // bingoCollectionViewの画面表示サイズ・レイアウトを指定
        bingoCollectionView = UICollectionView(frame: CGRect(x: 20, y: 100, width: 350, height: 350), collectionViewLayout: UICollectionViewFlowLayout())
//        let layout = UICollectionViewFlowLayout()
//        bingoCollectionView.collectionViewLayout = layout

        bingoCollectionView.delegate = self
        bingoCollectionView.dataSource = self
        bingoCollectionView.register(BingoCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")

        bingoCollectionView.backgroundColor = .clear
        bingoCollectionView.layer.borderWidth = 0.0
//        bingoCollectionView.layer.borderColor = UIColor.systemGray2.cgColor

    }
    
    
    
    
    func createNewBingoSheet(bingoSheetInProgress: BingoSheetInProgress) {
        bingoSheetsInProgress.append(bingoSheetInProgress)
        
        //bingoCollectionViewの新しいインスタンスを生成
        setUpBingoCollectionView()
        setUpView()
        
        let width = self.view.frame.size.width
        let positionX = CGFloat(Int(width) * (bingoSheetsInProgress.count - 1))//＠座標の指定をどこにすればいいかわからない
        bingoCollectionView.frame = CGRect(x: positionX + 20, y: 100, width: 350, height: 350)
        
        titleLabel.frame = CGRect(x: positionX + 20, y: 20, width: width - 40, height: 30)
        titleLabel.text = bingoSheetInProgress.bingoSheet.title
        
        // scrollViewのサイズを指定（幅は1ページに表示するViewの幅×ページ数）
        scrollView.contentSize = CGSize(width: Int(width) * bingoSheetsInProgress.count, height: 200)
        // pageControlのページ数を設定
        pageControl.numberOfPages = bingoSheetsInProgress.count
        
        // pageControlの現在ページを配列の最後のインデックスと同じにする
        pageControl.currentPage = bingoSheetsInProgress.count
        x = pageControl.currentPage
        
        self.scrollView.addSubview(bingoCollectionView)
        self.scrollView.addSubview(titleLabel)
    }

    
    //＠どのタイミングでオブジェクトを設定しておけば良いのかわからなくなった。
//    func createNewBingoSheet(bingosheet: BingoSheet) {
//        
//        bingoSheets.append(bingosheet)
////        bingoSheets.insert(bingosheet, at: 0)
//        //＠配列の最初に新要素を追加したい。bingosheetもscrollViewの左側に追加されるようにしたい（ゆくゆくでOK）
//  
////        print("ビンゴ数", bingoSheets.count)
//        
//        //bingoCollectionViewの新しいインスタンスを生成
//        setUpBingoCollectionView()
//        setUpView()
//        
//        //タスクを二次元配列に変換
//        tasks = bingosheet.tasks?.chunked(by: 3) ?? [[String]]()
//        
//        //初期値は全てfalseにする
//        tasksAreDone = [[Bool]](repeating: [Bool](repeating: false, count: tasks.count), count: tasks.count)
//        
//        
//        let width = self.view.frame.size.width
//        let positionX = CGFloat(Int(width) * (bingoSheets.count - 1))//＠座標の指定をどこにすればいいかわからない
//        bingoCollectionView.frame = CGRect(x: positionX + 20, y: 100, width: 350, height: 350)
//        
//        titleLabel.frame = CGRect(x: positionX + 20, y: 20, width: width - 40, height: 30)
//        titleLabel.text = bingosheet.title ?? ""
//
//        
//        // scrollViewのサイズを指定（幅は1ページに表示するViewの幅×ページ数）
//        scrollView.contentSize = CGSize(width: Int(width) * bingoSheets.count, height: 200)
//        // pageControlのページ数を設定
//        pageControl.numberOfPages = bingoSheets.count
//        
//        self.scrollView.addSubview(bingoCollectionView)
//        self.scrollView.addSubview(titleLabel)
//        
//        
//        
//        
////        print("ビンゴシート数: ", bingoSheets.count)
//        
//        //配列の個数分collectionViewを生成
////        for i in 0...bingoSheets.count {
////            let width = self.view.frame.size.width
////            //x座標をviewの幅 * i ずらしていく
////            let positionX = CGFloat(Int(width) * i)
////            bingoCollectionView.frame = CGRect(x: positionX, y: 0, width: width, height: width)
////
////
//////            scrollView.addSubview(bingoCollectionView)
////        }
//    }
    
    
    func setUpScrollView() {
        // scrollViewの画面表示サイズを指定
//        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 470)
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 630))
        // scrollViewのデリゲートになる
        scrollView.delegate = self
        scrollView.backgroundColor = .systemPink
        // ページ単位のスクロールを可能にする
        scrollView.isPagingEnabled = true
        // 水平方向のスクロールインジケータを非表示にする
        scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollView)
        // scrollviewを最背面に移動
        self.view.sendSubviewToBack(scrollView)
    }
    
//    func setUpImageView() {
//        //配列の個数分UIImageViewを生成
//        for i in 0..<bingoSheets.count {
//            //x座標をviewの幅 * i ずらしていく
//            let positionX = CGFloat(Int(self.view.frame.size.width) * i)
//            //imageViewの表示位置とサイズ、画像の設定
//            let imageView = createImageView(x: positionX, y: 0, width: self.view.frame.size.width, height: 470, image: bingoSheets[i])
//            scrollView.addSubview(imageView)
//        }
//    }
//
//    // UIImageViewを生成するメソッド
//    func createImageView(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, image: String) -> UIImageView {
//        let imageView = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
//        let image = UIImage(named:  image)
//        imageView.image = image
//        return imageView
//    }
    
    func setUpPageControl() {
        // pageControlの表示位置とサイズの設定
        pageControl = UIPageControl(frame: CGRect(x: 0, y: 630, width: self.view.frame.size.width, height: 30))//y: 370
        //ページ数が1の時ドットが表示されなくなる
        pageControl.hidesForSinglePage = true
        //pageControl上をスクロールすることでページを切り替えられる->＠ページ切り替えできない
        pageControl.allowsContinuousInteraction = true
        // pageControlのドットの色
        pageControl.pageIndicatorTintColor = UIColor.gray
        // pageControlの現在のページのドットの色
        pageControl.currentPageIndicatorTintColor = UIColor.systemPink

        
        self.view.addSubview(pageControl)
    }
    
//    @objc func pageControlValueChanged() {
//        let currentPageIndex = pageControl.currentPage
//
//
//    }
    
    
    private func setUpBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shared))//(title: "シェア", style: .plain, target: self, action: #selector(shared))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "nosign"), style: .plain, target: self, action: #selector(canceled))//(title: "中断", style: .plain, target: self, action: #selector(canceled))
        navigationItem.leftBarButtonItem?.tintColor = .red
    }
    
    //シェア
    @objc func shared() {
        let size = view.frame.size//スクリーンショットを撮る座標と縦横幅を指定->@AdMobの範囲は外す。
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let screenShotImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!  //スリーンショットがUIImage型で取得できる
        UIGraphicsEndImageContext()
        
        //＠ビンゴシートが完了か否かでメッセージを変える
        var message = ""
        if bingoSheetsInProgress[x].isDone == false {//@現在表示中のビンゴシートの配列番号を取得したい！！！
//        if bingoSheetIsDone == false {
            message = "ビンゴミッションに挑戦中！"
        } else {
          message = "ビンゴミッションをクリア☆"
        }
        
        
        let activityViewController = UIActivityViewController(activityItems: [message, screenShotImage], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
        
        //@シュミレーター上でimageとして保存しようとするとクラッシュするのを直す
    }
    
    //中断
    @objc func canceled() {
        //中断をアラート表示
        //UIAlertControllerクラスのインスタンスを生成
        let actionSheet = UIAlertController(title: "挑戦中のビンゴシートを中断しますか", message: "この画面からビンゴシートが削除されます", preferredStyle: .actionSheet)//.actionSheet:画面下部から出てくるアラート//.alert:画面中央に表示されるアラート
        //UIAlertControllerにActionを追加
        actionSheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "OK", style: .destructive) { _ in
            //@OKだった時のビンゴシート中断処理を実装
//            guard let documentId = self.bingoSheets.first?.documentId else { return }//＠現在表示中のビンゴシートを指定したい
            //bingoSheetsから削除
            self.bingoSheetsInProgress.remove(at: self.x)//＠現在表示中のビンゴシートの順番を取得したい！！！！！
//            self.bingoSheets.removeFirst()
            // scrollViewのサイズを指定（幅は1ページに表示するViewの幅×ページ数）
            self.scrollView.contentSize = CGSize(width: Int(self.view.frame.size.width) * self.bingoSheetsInProgress.count, height: 200)
//            self.scrollView.contentSize = CGSize(width: Int(self.view.frame.size.width) * self.bingoSheets.count, height: 200)
            // pageControlのページ数を設定
            self.pageControl.numberOfPages = self.bingoSheetsInProgress.count
//            self.pageControl.numberOfPages = self.bingoSheets.count
            
        })
        
        //Alertを表示
        present(actionSheet, animated: true, completion: nil)
        
        
        
    }
    

    
    
    private func setUpBingoStatusLabel() {
        bingoStatusLabel = UILabel(frame: CGRect(x: 20, y: 320, width: self.view.frame.size.width - 40, height: 80))
//        bingoStatusLabel.frame = CGRect(x: 20, y: 320, width: self.view.frame.size.width - 20, height: 90)
        bingoStatusLabel.isHidden = true
        bingoStatusLabel.font = UIFont(name: "Party LET Plain", size: 61.0)
        bingoStatusLabel.backgroundColor = .yellow
        bingoStatusLabel.textAlignment = .center
        self.view.addSubview(bingoStatusLabel)
//        self.bingoCollectionView.addSubview(bingoStatusLabel)
        //viewを最前面に持ってくる->@最前面に来ない
        self.view.bringSubviewToFront(bingoStatusLabel)
//        bingoStatusLabel.layer.cornerRadius = 20
//        bingoStatusLabel.clipsToBounds = true//この設定を入れないと角丸にならない
    }
    
    


    
    
    

    //ビンゴになった時の挙動
    func bingoAction() {
//        sleep(1)//1秒止める
        bingoStatusLabel.isHidden = false
        bingoSoundPlay()
//        sleep(2)//2秒止める
//        bingoStatusLabel.isHidden = true
    }
    
}

//    //左右スワイプでビンゴシートの切り替え
//    private func addEventListner() {
//        //右スワイプ
//        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
//        rightSwipeGesture.direction = .right
//        bingoCollectionView.addGestureRecognizer(rightSwipeGesture)
//
//        //左スワイプ
//        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
//        leftSwipeGesture.direction = .left
//        bingoCollectionView.addGestureRecognizer(leftSwipeGesture)
//    }
//
//    @objc func swiped(sender: UISwipeGestureRecognizer) {
//        switch sender.direction {
//        case .right:
//            print("右スワイプ")
//            //配列の一つ隣のアイテムを表示
//        case .left:
//            print("左スワイプ")
//            //配列の一つ前のアイテムを表示
//        default:
//            break
//        }
//    }

//    private func setUpScrollView() {
//
//        scrollView.delegate = self
//        //横幅
//        let width: CGFloat = 350
//        //タブのx座標．0から始まり，少しずつずらしていく．
//        var originX: CGFloat = 0
//
//        for title in titles {
//            titleLabel.frame = CGRect(x: originX, y: 0, width: width, height: 23.5)
//            titleLabel.text = title
//            //次のタブのx座標を用意する
//            originX += width
//        }
//        //scrollViewのcontentSizeを，タブ全体のサイズに合わせてあげる(ここ重要！)
//        //最終的なoriginX = タブ全体の横幅 になります
//        scrollView.contentSize = CGSize(width: width, height: 505)
//    }
    

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
    
    //セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = bingoCollectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! BingoCollectionViewCell
        
        let currentBingo = bingoSheetsInProgress[x]

//        cell.taskLabel.text = tasks[indexPath.section][indexPath.row]
        cell.taskLabel.text = currentBingo.tasks[indexPath.section][indexPath.row]
        
        //freeマスの時はイラストを表示
        if currentBingo.tasks[indexPath.section][indexPath.row] == "free" {
//            cell.taskLabel.text = ""
            cell.imageView.image = UIImage(named: "freeImage1")//@目立つのでサイズを小さくして色も薄くしたい
            cell.imageView.isHidden = false
            currentBingo.tasksAreDone[indexPath.section][indexPath.row] = true
//            tasksAreDone[indexPath.section][indexPath.row] = true
            cell.backgroundColor? = doneCellUIColor
        }
        
        return cell
    }
    
    //セルタップ時の挙動
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //@タップ時にイラストを表示したい
        let cell = bingoCollectionView.cellForItem(at: indexPath)
        
        let currentBingo = bingoSheetsInProgress[x]
        
//        let task = tasks[indexPath.section][indexPath.row]
        let taskIsDone = currentBingo.tasksAreDone[indexPath.section][indexPath.row]
        bingoStatusLabel.text = "BINGO!"
        bingoStatusLabel.isHidden = true
    
        //セルタップ時にtrue/falseを切り替え、trueの時backgroundColorを灰色にする
        //未完了タスクセル
        if taskIsDone == false {
            currentBingo.tasksAreDone[indexPath.section][indexPath.row] = true
            cell?.backgroundColor = doneCellUIColor
            cell?.isOpaque = false//透過にする
            
            cell?.isHighlighted = true
            taskIsDoneSoundPlay()
        //完了タスクセル
        } else {
            currentBingo.tasksAreDone[indexPath.section][indexPath.row] = false
            cell?.backgroundColor? = undoneCellUIColor//.yellow
            cell?.isHighlighted = false
            taskIsUndoneSoundPlay()
        }
        
        //縦横斜めが揃ったら「ビンゴ」と表示する
        //横の判定
        if currentBingo.tasksAreDone[indexPath.section] == [true, true, true] {
//        if tasksAreDone[indexPath.section] == [true, true, true] {
            print("よこビンゴ！")
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
            print("たてビンゴ！")
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
                print("ななめビンゴ1！")
                bingoAction()
            }
            
            if indexPath.section + indexPath.row == 2,
               tasksAreDoneDiagonalArray2 == [true, true, true] {
                print("ななめビンゴ2！")
                bingoAction()
            }
        //斜めビンゴの対象となるセルのindexPathをInt型の二次元配列にする
//        let diagonalArrayIndexPaths = [[0, 0], [1, 1], [2, 2], [0, 2], [2, 0]]
        //IndexPath型をInt型に変換
//        let indexPathInt = indexPath.map({element in Int(element)})
        //斜めの判定
//        if //diagonalArrayIndexPaths.contains(indexPathInt),
//           tasksAreDone[indexPath.section][indexPath.row] == true {
//        }
        


        //ビンゴシート達成の判定
        if currentBingo.tasksAreDone == [[true, true, true], [true, true, true], [true, true, true]] {
//        if tasksAreDone == [[true, true, true], [true, true, true], [true, true, true]] {
            print("ビンゴシートクリア！")
            currentBingo.isDone = true
//            bingoSheetIsDone = true
//            sleep(1)
            bingoStatusLabel.text = "COMPLETE!"
            bingoStatusLabel.isHidden = false
            clearSoundPlay()
            
            //ごほうびをアラート表示
            let message = currentBingo.bingoSheet.reward
//            let message = bingoSheets.last?.reward ?? "ポッキー1袋"
            //UIAlertControllerクラスのインスタンスを生成
            let actionSheet = UIAlertController(title: "ビンゴミッション\nコンプリート!", message: message, preferredStyle: .alert)//.actionSheet:画面下部から出てくるアラート//.alert:画面中央に表示されるアラート
            //UIAlertControllerにActionを追加
            let title = ["お疲れ様でした☕️", "いい感じです🍀", "さすが！", "バッチリです✨", "すごい!👏", "がんばってますね😌", "エライ！", "その調子！", "素晴らしい🌟", "やりました🎉", "その調子！"]
            actionSheet.addAction(UIAlertAction(title: title.randomElement(), style: .default, handler: nil))
            //Alertを表示
            present(actionSheet, animated: true, completion: nil)
           
            
        }
    }
}


//MARK:- ScrollView Delegate
// scrollViewのページ移動に合わせてpageControlの表示も移動させる
extension MissionInProgressViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
//        print("現在のページ: ", pageControl.currentPage)//動いた瞬間に検知される。0ページからスタート
        //@pageControlのcurrentPageの移動に合わせてscrollViewのページも移動させたい
        
    }
    
    //    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    //        guard scrollView == self.scrollView else { return }
    //    }
    //
    //    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    //        guard scrollView == self.scrollView else { return }
    //    }
    
}










//MARK:- Admob BannerView Delegate
extension MissionInProgressViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        
//        bannerView.alpha = 0
//        UIView.animate(withDuration: 1, animations: {
//            bannerView.alpha = 1
//        })
        print("bannerView:広告を受信しました")
    }
//
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:広告の受信に失敗しました: \(error.localizedDescription)")
    }
//
//    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
//        print("bannerViewDidRecordImpression")
//    }
//
//    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
//        print("bannerViewWillPresentScreen")
//    }
//
//    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
//        print("bannerViewWillDIsmissScreen")
//    }
//
//    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
//        print("bannerViewDidDismissScreen")
//    }
}


//MARK: - MissionInProgressCollectionViewCell

class BingoCollectionViewCell: UICollectionViewCell {
    
    //セル選択時にボタン色を変更する※できない
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                //                self.taskLabel.backgroundColor = .gray
                imageView.isHidden = false
                self.taskLabel.alpha = 0.3//alphaは薄さのこと。数字が大きいほど濃い。
            } else {
                imageView.isHidden = true
                self.taskLabel.alpha = 1.0
            }
        }
    }
    
    
    
    var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "bingoImage2")//thumbsUpImage, checkMarkImage, medalImage
        //＠設定画面でスタンプのデザインを選べるようにしたい
        return image
    }()
    
    
    
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
        addSubview(imageView)
//        addSubview(statusTextLabel)
        
        taskLabel.frame.size = self.frame.size
        imageView.frame.size = self.frame.size//＠イメージサイズはセルの大きさより少し小さくしたい
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
