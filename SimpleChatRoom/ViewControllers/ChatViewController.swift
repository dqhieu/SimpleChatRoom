//
//  ChatViewController.swift
//  SimpleChatRoom
//
//  Created by Dinh Quang Hieu on 1/22/18.
//  Copyright © 2018 Dinh Quang Hieu. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

class ChatViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    var pickedImage: UIImage?
    
    var user: User!
    var database: DatabaseReference!
    var storage: StorageReference!
    
    var messages: [Message] = []
    
    func initControls() {
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.txtMessage.addTarget(self, action: #selector(textFieldDidChangeValue), for: .editingChanged)
        self.txtMessage.delegate = self
    }
    
    func observeMessages() {
        database.child("MESSAGE").observe(.value) { [weak self] (snapshot) in
            guard let `self` = self else { return }
            self.messages.removeAll()
            
            guard let allChilds:[DataSnapshot] = snapshot.children.allObjects as? [DataSnapshot] else { return }
            for child in allChilds {
                if let dict = child.value as? NSDictionary {
                    if let userEmail = dict["userEmail"] as? String {
                        let message = Message(user: User(email: userEmail))
                        if let id = dict["id"] as? String {
                            message.id = id
                        }
                        if let text = dict["text"] as? String {
                            message.text = text
                        }
                        if let imageUrl = dict["imageUrl"] as? String {
                            message.imageUrl = imageUrl
                        }
                        self.messages.append(message)
                    }
                }
            }
            
            self.updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initControls()
        self.observeMessages()
    }
    
    func updateUI() {
        self.tableView.reloadData()
        self.tableView.scrollToRow(at: IndexPath.init(row: self.messages.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
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
        let newMesageRef = database.child("MESSAGE").childByAutoId()
        
        let message = Message(user: self.user)
        message.id = newMesageRef.key
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if let imageData = UIImagePNGRepresentation(image) {
            storage.child("MESSAGE_IMAGES/\(newMesageRef.key).jpg").putData(imageData, metadata: nil, completion: { [weak self] (metadata, error) in
                guard let `self` = self else { return }
                if error == nil {
                    let downloadURL = metadata!.downloadURL()
                    message.imageUrl = downloadURL?.absoluteString
                    newMesageRef.setValue(message.toDictionary()) { [weak self] (error, _) in
                        guard let `self` = self else { return }
                        MBProgressHUD.hide(for: self.view, animated: true)
                        if error == nil {
                            self.pickedImage = nil
                            self.txtMessage.isEnabled = true
                            self.txtMessage.text = ""
                            self.btnSend.setImage(UIImage(named: "ic_insert_photo"), for: .normal)
                            self.view.endEditing(true)
                        }
                    }
                }
            })
        }
    }
    
    func sendTextMessage(text: String) {
        let newMesageRef = database.child("MESSAGE").childByAutoId()
        
        let message = Message(user: self.user)
        message.text = text
        message.id = newMesageRef.key
        
        newMesageRef.setValue(message.toDictionary()) { [weak self] (error, data) in
            guard let `self` = self else { return }
            if error == nil {
                self.txtMessage.text = ""
                self.btnSend.setImage(UIImage(named: "ic_insert_photo"), for: .normal)
                self.view.endEditing(true)
            }
        }
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
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.messages[indexPath.row]
        if let text = message.text, !text.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as? TextTableViewCell else { return UITableViewCell() }
            cell.setup(message: message)
            return cell
        } else if let _ = message.imageUrl {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as? ImageTableViewCell else { return UITableViewCell() }
            cell.setup(message: message)
            return cell
        }
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
