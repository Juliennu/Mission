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
//    @IBOutlet weak var dontHaveAccountButton: UIButton!
    

    
    
    
    
    
    
    
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
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor.rgb(red: 100, green: 100, blue: 100, alpha: 1.0)
//        dontHaveAccountButton.addTarget(self, action: #selector(tappedDontHaveAccountButton), for: .touchUpInside)
    }
    
    //ログイン処理
    @objc func tappedLoginButton() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        //ログインボタンを表示した時にインジケーターを表示
        HUD.show(.progress)
        
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            if let err = err as NSError?,
               let errcode = AuthErrorCode(rawValue: err.code){
                let errMessage = self.switchErrMessage(error: err, errorCode: errcode)
                print("ログインに失敗しました", err)
                HUD.hide()
                HUD.flash(.error)
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                self.showAlert(title: "エラー", message: errMessage, actions: [okAction])
                return
                
            }
            //ログイン成功時

            HUD.hide()
            HUD.flash(.success)
            //ログイン成功時はviewcontrollerを消す
            self.navigationController?.popToRootViewController(animated: true)
//            self.dismiss(animated: true, completion: nil)
            // - ＠会員のビンゴシート情報を取得
            
        }
    }
    
    //認証エラーコードごとにメッセージの出し分けを行う
    func switchErrMessage(error: NSError, errorCode: AuthErrorCode) -> String {
        switch errorCode {
        case .invalidEmail:
            return "メールアドレスの形式が\n正しくありません"
            
        case .emailAlreadyInUse:
            return "このメールアドレスは\n既に登録されています"
        case .weakPassword:
            return "パスワードは6文字以上で\n入力してください"
        default:
            return "エラーコード: \(error.domain)"
        }
    }
    
    //@SignUpVCへ遷移
//    @objc func tappedDontHaveAccountButton() {
//
//    }
    
    //textfieldの枠外をタップしたときにedit状態を終了
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}

//MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emailTextField.text?.isEmpty ?? false
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? false
        
        if emailIsEmpty || passwordIsEmpty {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 100, green: 100, blue: 100, alpha: 1.0)
        } else {
            loginButton.isEnabled = true
            loginButton.backgroundColor = buttonOrange
        }
    }

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
