//
//  EditBingoSheetViewController.swift
//  Mission
//
//  Created by Juri Ohto on 2021/07/11.
//

import UIKit

class EditBingoSheetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "開始", style: .plain, target: self, action: #selector(startButtonTapped))

        // Do any additional setup after loading the view.
    }
    
    @objc private func startButtonTapped() {
        
//        let storyboard = UIStoryboard.init(name: "MissionInProgress", bundle: nil)
//        let missionInProgressVC = storyboard.instantiateViewController(identifier: "MissionInProgressViewController") as! MissionInProgressViewController
//
//        navigationController?.pushViewController(missionInProgressVC, animated: true)
    }

    
}
