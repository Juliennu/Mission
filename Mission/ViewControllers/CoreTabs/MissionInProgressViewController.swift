//
//  MissionInProgressViewController.swift
//  Mission
//
//  Created by Juri Ohto on 2021/07/09.
//

import UIKit

class MissionInProgressViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bingoCollectionView: UICollectionView!
    
    
    @IBOutlet weak var bannerView: UIImageView!//Admobを表示予定
    
    let titles = ["死ぬまでにやりたいこと", "デイリーミッション", "週末用"]
    let tasks = ["洗い物", "洗濯物", "掃除機かけ", "ゴミ出し","手紙を出す", "鳥小屋の掃除", "ふるさと納税", "単語帳10,000ページ", "ドラッグストアでシャンプーを買う"]
    let layout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpBingoCollectionView()
        setUpScrollView()

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


// MARK: - Delegates
extension MissionInProgressViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {//@sectionとは何かわからない。
//        return 1//デフォルト値1のためメソッドごと消して良い
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count//@Firebaseからデータを持ってきたい
    }
    
//    //collectionViewのHeaderからの距離。0なのでいらない
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return 0
//    }
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = bingoCollectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! BingoCollectionViewCell
        cell.taskLabel.text = tasks[indexPath.row]//@Firebaseからデータを持ってきたい
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = bingoCollectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! BingoCollectionViewCell
        cell.backgroundColor = .blue//@タップ時に色を変えたい
        //@タップ時にイラストを表示したい
        
        
        
        let task = tasks[indexPath.row]
        print(task)
        
    }
}



extension MissionInProgressViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == self.scrollView else { return }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else { return }
    }
}




//MARK: - MissionInProgressCollectionViewCell

class BingoCollectionViewCell: UICollectionViewCell {
    
    
    
    
    
    
    
    
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.text = "タスク１"
        label.clipsToBounds = true
        //@lavelを折り返して全文表示したい
        label.lineBreakMode = .byWordWrapping//単語単位で区切って改行
        label.numberOfLines = 0//最大制限なし（必要なだけ行数を使用）
//        label.backgroundColor = .yellow
        return label
    }()

    override init(frame: CGRect) {//＠これは何？→カスタムUIViewの初期化を記述
        super.init(frame: frame)
        
        addSubview(taskLabel)
        
        taskLabel.frame.size = self.frame.size
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.systemGray.cgColor
        self.layer.backgroundColor = UIColor.systemPink.cgColor
    
        
    }
    required init?(coder: NSCoder) {//＠これは何？→よくわからない。swiftの場合、override init(frame: CGRect)とセットで必要になる模様。
        
        fatalError("init(coder:) has not been implemented")

    }
}
