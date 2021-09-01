//
//  InitialViewController.swift
//  Mission
//
//  Created by Juri Ohto on 2021/08/31.
//

import UIKit

class InitialViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var alreadyHaveAccountButton: UIButton!
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        startButton.layer.cornerRadius = 15
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    @objc func startButtonTapped() {
        //folderTabに遷移
        
    }


    
}
