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
    
    private var selectedContactType: String? {
        didSet {
            if let selectedContactType {
                print(selectedContactType)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user {
            titleText.text = "Update user information"
            isSelectGirl = user.gender
            nameTextField.text = user.name
            surnameTextField.text = user.surname
            phoneTextField.text = user.phoneNumber
            selectedContactType = user.contactType
            selectGroupTextField.text = user.contactType
            buttonType.setTitle("Update", for: .normal)
            buttonType.tag = 1
        }
        
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
        print(nameTextField.text!,surnameTextField.text!,phoneTextField.text!,selectedContactType!)
        if let name = nameTextField.text,
           let surname = surnameTextField.text,
           let phone = phoneTextField.text,
           let contactType = selectedContactType
        {
            if buttonType.tag == 0 {
                print("0")
                // Yeni bir kullanıcı eklemek için ContactUsers nesnesini oluşturup verileri atayalım
                let newUser = ContactUsers(context: context)
                newUser.name = name
                newUser.surname = surname
                newUser.phoneNumber = phone
                newUser.gender = Bool(isSelectGirl)
                newUser.contactType = contactType
            } else {
                print("1")

                // Mevcut kullanıcıyı güncellemek için self.user'ı kontrol edelim
                if let existingUser = self.user {
                    existingUser.name = name
                    existingUser.surname = surname
                    existingUser.phoneNumber = phone
                    existingUser.gender = Bool(isSelectGirl)
                    existingUser.contactType = contactType
                } else {
                    print("2")
                    // Hata durumunda uygulama buraya gelebilir
                    // Eğer burada uygun bir çözüm yoksa hata yönetimi yapılmalıdır
                    return
                }
            }
            print("3")

            
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

extension AddUserVC: UITextFieldDelegate {
  
}
