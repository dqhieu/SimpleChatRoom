//
//  LoginViewController.swift
//  SimpleChatRoom
//
//  Created by Dinh Quang Hieu on 1/22/18.
//  Copyright © 2018 Dinh Quang Hieu. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    @IBOutlet weak var logoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    
    
    func initControls() {
        self.btnSignIn.layer.cornerRadius = 4
        self.btnSignIn.clipsToBounds = true
        self.btnSignUp.layer.cornerRadius = 4
        self.btnSignUp.clipsToBounds = true
        
        self.txtEmail.delegate = self
        self.txtPassword.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initControls()
    }

    @IBAction func didTapSignInButton(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapSignUpButton(_ sender: UIButton) {
        
    }
    
    override func onKeyboardWillShow(notification: NSNotification) {
        super.onKeyboardWillShow(notification: notification)
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = (userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as? NSValue)!
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        let keyboardTop = UIScreen.main.bounds.height - keyboardHeight
        let loginButtonBottom = btnSignIn.frame.origin.y + btnSignIn.frame.size.height
        
        if keyboardTop < loginButtonBottom {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.frame.origin.y = (keyboardTop - loginButtonBottom) - 20
            })
        }
    }
    
    override func onKeyboardWillHide() {
        super.onKeyboardWillHide()
        UIView.animate(withDuration: 0.2, animations: {
            self.view.frame.origin.y = 0
        })
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.logoWidthConstraint.constant = UIScreen.main.bounds.width
        self.logoHeightConstraint.constant = UIScreen.main.bounds.width * 3.0 / 4.0
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtEmail {
            self.txtPassword.becomeFirstResponder()
        } else if textField == self.txtPassword {
            textField.resignFirstResponder()
        }
        return false
    }
}
