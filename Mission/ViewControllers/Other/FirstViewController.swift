//
//  FirstViewController.swift
//  Mission
//
//  Created by Juri Ohto on 2021/09/01.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //初回起動時にはログイン画面を表示する
//        let ud = UserDefaults.standard
//        let firstLaunchKey = "firstLaunch"
//        if  ud.bool(forKey: firstLaunchKey) {
//            ud.set(false, forKey: firstLaunchKey)
//            ud.synchronize()
            
            //Xibへ遷移
            let initialVC = InitialViewController(nibName: "InitialViewController", bundle: nil)
            initialVC.modalPresentationStyle = .fullScreen
            present(initialVC,animated: false)
//        } else {
//            //セグエを使って移動
//            performSegue(withIdentifier: "moveToTabBarController", sender: nil)
//
//        }
    }
    

}
