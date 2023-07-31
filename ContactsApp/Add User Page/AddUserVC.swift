//
//  AddUserVC.swift
//  ContactsApp
//
//  Created by Aleyna Aktaş on 31.07.2023.
//

import UIKit

class AddUserVC: UIViewController {
    
    @IBOutlet weak var girlView: UIView!
    @IBOutlet weak var boyView: UIView!
    @IBOutlet weak var girlText: UILabel!
    @IBOutlet weak var boyText: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var selectGroupTextField: UITextField!
    
    var isSelectGirl = true
    
    let context = appDelegate.persistentContainer.viewContext
    
    private var selectedContactType: String? {
        didSet {
            if let selectedContactType {
                print(selectedContactType)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        print(isSelectGirl)

        let girlTapGesture = UITapGestureRecognizer(target: self, action: #selector(girlViewAct))
        let boyTapGesture = UITapGestureRecognizer(target: self, action: #selector(boyViewAct))

        girlView.addGestureRecognizer(girlTapGesture)
        boyView.addGestureRecognizer(boyTapGesture)

        girlView.backgroundColor = UIColor(named: "gray")
        girlView.layer.cornerRadius = 12
        boyView.backgroundColor = UIColor.white
        boyView.layer.cornerRadius = 12
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldTapped))
        selectGroupTextField.addGestureRecognizer(tapGesture)


    }
    
    @objc func girlViewAct() {
        girlView.backgroundColor = UIColor(named: "gray")
        boyView.backgroundColor = UIColor.white
        girlText.textColor = UIColor(named: "pink")
        boyText.textColor = UIColor.gray
    }

    @objc func boyViewAct() {
        boyView.backgroundColor = UIColor(named: "gray")
        girlView.backgroundColor = UIColor.white
        girlText.textColor = UIColor.gray
        boyText.textColor = UIColor.systemBlue
    }
    
    @objc func textFieldTapped() {
        let storyboard = UIStoryboard(name: "ContactPickerVC", bundle: nil)
        if let vc = storyboard.instantiateViewController(identifier: "ContactPickerVC") as? ContactPickerVC {
            vc.delegate = self
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true)
        }
    }
    @IBAction func addButtonAct(_ sender: UIButton) {
        if let name = nameTextField.text,
           let surname = surnameTextField.text,
           let phone = phoneTextField.text,
           let contactType = selectedContactType
        {
            let user = ContactUsers(context: context)
            
            user.fullName = name + " " + surname
            user.phoneNumber = phone
            user.gender = Bool(isSelectGirl)
            user.contactType = String(describing: contactType)
            appDelegate.saveContext()
            dismiss(animated: true, completion: nil)
        }
    }
}

extension AddUserVC: ContactPickerViewDelegate {
    func didSelectContactType(_ type: String) {
        selectedContactType = type
        selectGroupTextField.text = type
    }
}

extension AddUserVC: UITextFieldDelegate {
  
}
