//
//  ContactPickerViewDelegate.swift
//  ContactsApp
//
//  Created by Aleyna Aktaş on 24.07.2023.
//

import UIKit

protocol ContactPickerViewDelegate {
    func didSelectContactType(_ type: String)
}

class ContactPickerVC: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var filterPickerView: UIPickerView!
    
    private var selectedContactType: String?
    var delegate: ContactPickerViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterPickerView.delegate = self
        filterPickerView.dataSource = self
        
        let lineView = UIView(frame: CGRect(x: 0, y: topView.frame.height - 1, width: topView.frame.width, height: 1))
             lineView.backgroundColor = UIColor.lightGray
        topView.addSubview(lineView)
    }
    
    @IBAction func doneButtonAct(_ sender: UIButton) {
        delegate?.didSelectContactType(selectedContactType ?? "All Contacts")
        dismiss(animated: true)
    }
}

extension ContactPickerVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return contactUsersType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return contactUsersType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedContactType = contactUsersType[row]
  }
    
}
