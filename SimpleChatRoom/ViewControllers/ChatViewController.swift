//
//  ChatViewController.swift
//  SimpleChatRoom
//
//  Created by Dinh Quang Hieu on 1/22/18.
//  Copyright © 2018 Dinh Quang Hieu. All rights reserved.
//

import UIKit

class ChatViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    var pickedImage: UIImage?
    
    var user: User!
    
    func initControls() {
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.txtMessage.addTarget(self, action: #selector(textFieldDidChangeValue), for: .editingChanged)
        self.txtMessage.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initControls()
    }

    @IBAction func didTapSendButton(_ sender: UIButton) {
        if let pickedImage = self.pickedImage {
            self.sendPhotoMessage(image: pickedImage)
        } else if let text = self.txtMessage.text, !text.isEmpty {
            self.sendTextMessage(text: text)
        } else {
            self.presentImagePicker()
        }
    }
    
    func sendPhotoMessage(image: UIImage) {
        self.pickedImage = nil
        self.txtMessage.isEnabled = true
        self.txtMessage.text = ""
        self.btnSend.setImage(UIImage(named: "ic_insert_photo"), for: .normal)
        self.view.endEditing(true)
    }
    
    func sendTextMessage(text: String) {
        self.txtMessage.text = ""
        self.btnSend.setImage(UIImage(named: "ic_insert_photo"), for: .normal)
        self.view.endEditing(true)
    }
    
    func presentImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func textFieldDidChangeValue() {
        if let text = self.txtMessage.text, !text.isEmpty {
            self.btnSend.setImage(UIImage(named: "ic_send"), for: .normal)
        } else {
            self.btnSend.setImage(UIImage(named: "ic_insert_photo"), for: .normal)
        }
    }
    
    override func onKeyboardWillShow(notification: NSNotification) {
        super.onKeyboardWillShow(notification: notification)
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = (userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as? NSValue)!
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        let keyboardTop = UIScreen.main.bounds.height - keyboardHeight
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.frame.origin.y = -keyboardHeight
        })
    }
    
    override func onKeyboardWillHide() {
        super.onKeyboardWillHide()
        UIView.animate(withDuration: 0.2, animations: {
            self.view.frame.origin.y = 0
        })
    }
}

extension ChatViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.pickedImage = pickedImage
            self.btnSend.setImage(UIImage(named: "ic_send"), for: .normal)
            if let url = info[UIImagePickerControllerReferenceURL] as? URL {
                self.txtMessage.text = url.pathComponents.last
            } else {
                self.txtMessage.text = "picked image"
            }
            self.txtMessage.isEnabled = false
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
