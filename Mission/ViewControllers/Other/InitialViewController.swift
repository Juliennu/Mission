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

        alreadyHaveAccountButton.addTarget(self, action: #selector(alreadyHaveAccountButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    
    @objc func startButtonTapped() {
        //TabBarControllerに遷移
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "TabBar")
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)

        
    }
    
    @objc func alreadyHaveAccountButtonTapped() {
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)

        
        
        
    }


    
}
