//
//  BaseViewController.swift
//  SimpleChatRoom
//
//  Created by Dinh Quang Hieu on 1/22/18.
//  Copyright © 2018 Dinh Quang Hieu. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - Variables
    private var tapGesture: UITapGestureRecognizer?
    
    // MARK: - Life cycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardNotifications()
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
    // MARK: - Keyboard
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc open func onKeyboardWillShow(notification:NSNotification) {
        addGesture()
    }
    
    @objc open func onKeyboardWillHide() {
        removeGesture()
    }
    
    private func addGesture() {
        if tapGesture == nil {
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        }
        view.addGestureRecognizer(tapGesture!)
    }
    
    private func removeGesture() {
        if tapGesture != nil {
            view.removeGestureRecognizer(tapGesture!)
        }
    }
    
    @objc private func didTap() {
        view.endEditing(true)
    }

}
