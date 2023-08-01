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
    @IBOutlet weak var buttonType: UIButton!
    @IBOutlet weak var titleText: UILabel!
    
    var isSelectGirl = true
    var user: ContactUsers?
    
    let context = appDelegate.persistentContainer.viewContext
    
    private var selectedContactType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user {
            titleText.text = "Update user information"
            isSelectGirl = user.gender
            nameTextField.text = user.name
            surnameTextField.text = user.surname
            phoneTextField.text = user.phoneNumber
            selectedContactType = user.contactType
            isSelectGirl = user.gender
            selectGroupTextField.text = user.contactType
            buttonType.setTitle("Update", for: .normal)
            buttonType.tag = 1
        }
        
        if isSelectGirl {
            girlViewAct()
        } else {
            boyViewAct()
        }
        
        let girlTapGesture = UITapGestureRecognizer(target: self, action: #selector(girlViewAct))
        let boyTapGesture = UITapGestureRecognizer(target: self, action: #selector(boyViewAct))
        
        girlView.addGestureRecognizer(girlTapGesture)
        boyView.addGestureRecognizer(boyTapGesture)
        
        girlView.layer.cornerRadius = 12
        boyView.layer.cornerRadius = 12
        
        navigationController?.navigationBar.tintColor = UIColor(named: "pink")
        navigationController?.navigationBar.prefersLargeTitles = false

        
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
        isSelectGirl = false
    }
    
    @objc func textFieldTapped() {
        let storyboard = UIStoryboard(name: "ContactPickerVC", bundle: nil)
        if let vc = storyboard.instantiateViewController(identifier: "ContactPickerVC") as? ContactPickerVC {
            vc.delegate = self
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true)
        }
    }
    @IBAction func buttonAct(_ sender: UIButton) {
        
        guard let name = nameTextField.text, !name.isEmpty,
                  let surname = surnameTextField.text, !surname.isEmpty,
                  let phone = phoneTextField.text, !phone.isEmpty,
                  let _ = selectedContactType else {
                let alertController = UIAlertController(title: "Incomplete Information", message: "Please fill in all required fields.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }

        if let name = nameTextField.text,
           let surname = surnameTextField.text,
           let phone = phoneTextField.text,
           let contactType = selectedContactType
        {
            if buttonType.tag == 0 {
                let newUser = ContactUsers(context: context)
                newUser.name = name
                newUser.surname = surname
                newUser.phoneNumber = phone
                newUser.gender = Bool(isSelectGirl)
                newUser.contactType = contactType
            } else {
                if let existingUser = self.user {
                    existingUser.name = name
                    existingUser.surname = surname
                    existingUser.phoneNumber = phone
                    existingUser.gender = Bool(isSelectGirl)
                    existingUser.contactType = contactType
                } else {
                    return
                }
            }
            appDelegate.saveContext()
            self.navigationController?.popViewController(animated: true)
            
        }
        
    }
}

extension AddUserVC: ContactPickerViewDelegate {
    func didSelectContactType(_ type: String) {
        selectedContactType = type
        selectGroupTextField.text = type
    }
}

