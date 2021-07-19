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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bingoCollectionView: UICollectionView!
    
    
    
    @IBOutlet weak var bannerView: GADBannerView!//Admobを表示予定
//    let viewWidth = UIScreen.main.bounds.size.width
    
    
    
    let titles = ["死ぬまでにやりたいこと", "デイリーミッション", "週末用"]
    
    let tasks = [//task arrayは二次元配列にする
        ["洗い物", "洗濯物", "掃除機かけ"],
        ["ゴミ出し","手紙を出す", "鳥小屋の掃除"],
        ["ふるさと納税", "単語帳10,000ページ", "ドラッグストアでシャンプーを買った後にスーパーでパイナップルを買う"]
    ]
    
    //タスクの完了状況を管理する配列
    var tasksAreDone = [[Bool]]()
    
    
    let layout = UICollectionViewFlowLayout()
    //let bingoLogic = BingoLogic(isDone: true, bingoWidth: 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpBingoCollectionView()
        setUpScrollView()
        setUpVannerView()
        

        tasksAreDone = [[Bool]](repeating: [Bool](repeating: false, count: tasks.count), count: tasks.count)
//        tasksAreDone[0] = true//クリック時にtrueに置き換えたい
//        print(tasksAreDone[0, 0])//二次元配列の座標の示し方がわからない
//        print("タスク配列の要素数の合計: ", tasks.capacity)//要素の合計数を取得できる
    }
    
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
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.delegate = self
    }
    
    
    

    private func setUpBingoCollectionView() {
        bingoCollectionView.delegate = self
        bingoCollectionView.dataSource = self
        bingoCollectionView.register(BingoCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        bingoCollectionView.backgroundColor = .clear
        
        bingoCollectionView.layer.borderWidth = 1.0
        bingoCollectionView.layer.borderColor = UIColor.systemGray2.cgColor
        
        bingoCollectionView.collectionViewLayout = layout
    }
    
    private func setUpScrollView() {
        
        scrollView.delegate = self
        //横幅
        let width: CGFloat = 350
        //タブのx座標．0から始まり，少しずつずらしていく．
        var originX: CGFloat = 0
        
        for title in titles {
            titleLabel.frame = CGRect(x: originX, y: 0, width: width, height: 23.5)
            titleLabel.text = title
            //次のタブのx座標を用意する
            originX += width
        }
        //scrollViewのcontentSizeを，タブ全体のサイズに合わせてあげる(ここ重要！)
        //最終的なoriginX = タブ全体の横幅 になります
        scrollView.contentSize = CGSize(width: width, height: 505)
    }
    
}


// MARK: - CollectionView Delegates
extension MissionInProgressViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return tasks.count
    }
    
    
    //セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks[section].count//@Firebaseからデータを持ってきたい
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
        cell.taskLabel.text = tasks[indexPath.section][indexPath.row]//@Firebaseからデータを持ってきたい
        return cell
    }
    
    //セルタップ時の挙動
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //@タップ時に色を変えたい
        //@タップ時にイラストを表示したい
        let cell = bingoCollectionView.cellForItem(at: indexPath)
//                cell?.backgroundColor = .yellow
        
        let task = tasks[indexPath.section][indexPath.row]
        let taskIsDone = tasksAreDone[indexPath.section][indexPath.row]
        
        //セルタップ時にtrue/falseを切り替える
        if taskIsDone == false {
            tasksAreDone[indexPath.section][indexPath.row] = true
            cell?.backgroundColor = .gray
        } else {
            tasksAreDone[indexPath.section][indexPath.row] = false
            cell?.backgroundColor = .yellow
        }
       
        
        
        print(task)
        print(tasksAreDone)
        
    }
}


//MARK:- ScrollView Delegate
extension MissionInProgressViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == self.scrollView else { return }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else { return }
    }
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
                self.taskLabel.alpha = 1.0
            }
        }
    }
    
    
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "checkMarkImage")
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
        
        taskLabel.frame.size = self.frame.size
        imageView.frame.size = self.frame.size
        imageView.isHidden = true//タスククリア前はイメージ表示しない
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.systemGray.cgColor
    
        self.layer.backgroundColor = UIColor.yellow.cgColor
        
        
        
    }
    required init?(coder: NSCoder) {//＠これは何？→よくわからない。swiftの場合、override init(frame: CGRect)とセットで必要になる模様。
        
        fatalError("init(coder:) has not been implemented")
        
    }
}
