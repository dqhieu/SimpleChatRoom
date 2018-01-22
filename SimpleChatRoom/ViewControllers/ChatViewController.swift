//
//  ChatViewController.swift
//  SimpleChatRoom
//
//  Created by Dinh Quang Hieu on 1/22/18.
//  Copyright © 2018 Dinh Quang Hieu. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    var pickedImage: UIImage?
    
    func initControls() {
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.txtMessage.addTarget(self, action: #selector(textFieldDidChangeValue), for: .editingChanged)
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
    }
    
    func sendTextMessage(text: String) {
        self.txtMessage.text = ""
        self.btnSend.setImage(UIImage(named: "ic_insert_photo"), for: .normal)
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
