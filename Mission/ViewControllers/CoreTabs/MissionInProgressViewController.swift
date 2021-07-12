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
    @IBOutlet weak var bannerView: UIImageView!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        let titles = ["死ぬまでにやりたいこと", "デイリーミッション", "週末用"]
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

extension MissionInProgressViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == self.scrollView else { return }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else { return }
    }
}
