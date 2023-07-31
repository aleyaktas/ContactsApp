//
//  AddModalVC.swift
//  ContactsApp
//
//  Created by Aleyna Aktaş on 31.07.2023.
//

import UIKit

class AddModalVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var genderType: UISegmentedControl!
    
    @IBOutlet weak var phoneTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.layer.cornerRadius = 20
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackViewAct(_:)))
        backView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleBackViewAct(_ sender: UITapGestureRecognizer) {
          dismiss(animated: true, completion: nil)
      }

    @IBAction func closeButtonAct(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
}
