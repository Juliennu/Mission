//
//  LoginViewController.swift
//  Mission
//
//  Created by Juri Ohto on 2021/07/11.
//

import UIKit
import Firebase
import PKHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var dontHaveAccountButton: UIButton!
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
//        view.backgroundColor = .blue
    }
    
    
    func setUpViews() {
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.tag = 0
        passwordTextField.tag = 1
        
        loginButton.layer.cornerRadius = 12
        loginButton.addTarget(self, action: #selector(tappedLoginButton), for: .touchUpInside)
        dontHaveAccountButton.addTarget(self, action: #selector(tappedDontHaveAccountButton), for: .touchUpInside)
    }
    
    //ログイン処理
    @objc func tappedLoginButton() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        //ログインボタンを表示した時にインジケーターを表示
        HUD.show(.progress)
        
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("ログインに失敗しました", err)
                HUD.hide()
                HUD.flash(.error)
                return
            }
            //ログイン成功時
            // - ＠会員のビンゴシート情報を取得
            // - ＠folderVCへ遷移
            HUD.hide()
            HUD.flash(.success)
            
        }
    }
    
    //@SignUpVCへ遷移
    @objc func tappedDontHaveAccountButton() {
        
    }
    
    //textfieldの枠外をタップしたときにedit状態を終了
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}

//MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    //リターンキーが押されたイベントを検知
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
