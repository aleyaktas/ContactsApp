//
//  ContactVC.swift
//  ContactsApp
//
//  Created by Aleyna Aktaş on 22.07.2023.
//

import UIKit
import CoreData

//struct ContactUserModel: Equatable {
//    var name: String
//    var gender: Gender
//    var phoneNumber: String
//    var contactType: ContactUserType
//
//    static func == (lhs: ContactUserModel, rhs: ContactUserModel) -> Bool {
//        return lhs.name == rhs.name &&
//               lhs.gender == rhs.gender &&
//               lhs.phoneNumber == rhs.phoneNumber &&
//               lhs.contactType == rhs.contactType
//    }
//}

//enum ContactUserType: CaseIterable {
//    case allContacts
//    case family
//    case friends
//    case work
//    case neighbors
//    case university
//
//    var contactType: String {
//        switch self {
//            case .allContacts:
//                return "AllContacts"
//            case .family:
//                return "Family"
//            case .friends:
//                return "Friends"
//            case .work:
//                return "Work"
//            case .neighbors:
//                return "Neighbors"
//            case .university:
//                return "University"
//        }
//    }
//}

//enum Gender: CaseIterable {
//    case male
//    case female
//
//    var genderType: String {
//        switch self {
//        case .female:
//            return "Female"
//        case .male:
//            return "Male"
//        }
//    }
//}

//
//class Contacts {
//    static let contacts: [ContactUserModel] = [
//        ContactUserModel(name: "John Doe", gender: .male, phoneNumber: "123-456-7890", contactType: .family),
//        ContactUserModel(name: "Jane Smith", gender: .female, phoneNumber: "987-654-3210", contactType: .family),
//        ContactUserModel(name: "Emily Davis", gender: .female, phoneNumber: "777-666-5555", contactType: .family),
//        ContactUserModel(name: "Jimmy John", gender: .male, phoneNumber: "555-123-4567", contactType: .family),
//        ContactUserModel(name: "Robert Lee", gender: .male, phoneNumber: "222-999-3333", contactType: .family),
//        ContactUserModel(name: "Sophia Anna", gender: .female, phoneNumber: "444-555-6666", contactType: .family),
//
//        ContactUserModel(name: "Alice Brown", gender: .female, phoneNumber: "444-777-8888", contactType: .friends),
//        ContactUserModel(name: "Will Taylor", gender: .male, phoneNumber: "666-888-9999", contactType: .friends),
//        ContactUserModel(name: "Oliver Harris", gender: .male, phoneNumber: "111-333-5555", contactType: .friends),
//        ContactUserModel(name: "Lucas Carter", gender: .male, phoneNumber: "555-777-8888", contactType: .friends),
//        ContactUserModel(name: "Ella Wilson", gender: .female, phoneNumber: "888-222-4444", contactType: .friends),
//
//        ContactUserModel(name: "David Miller", gender: .male, phoneNumber: "888-222-4444", contactType: .work),
//        ContactUserModel(name: "Emily Davis", gender: .female, phoneNumber: "777-666-5555", contactType: .work),
//        ContactUserModel(name: "Ava White", gender: .female, phoneNumber: "888-777-4444", contactType: .work),
//        ContactUserModel(name: "Sarah Wilson", gender: .female, phoneNumber: "111-333-5555", contactType: .work),
//
//        ContactUserModel(name: "James Ander", gender: .male, phoneNumber: "444-555-6666", contactType: .neighbors),
//        ContactUserModel(name: "Olivia Martin", gender: .female, phoneNumber: "222-333-4444", contactType: .neighbors),
//        ContactUserModel(name: "Noah Green", gender: .male, phoneNumber: "111-555-9999", contactType: .neighbors),
//        ContactUserModel(name: "Ethan Hall", gender: .male, phoneNumber: "333-222-1111", contactType: .neighbors),
//        ContactUserModel(name: "Lily Murphy", gender: .female, phoneNumber: "777-888-9999", contactType: .neighbors),
//
//        ContactUserModel(name: "Liam Robin", gender: .male, phoneNumber: "333-222-1111", contactType: .university),
//        ContactUserModel(name: "Ava White", gender: .female, phoneNumber: "888-777-4444", contactType: .university),
//        ContactUserModel(name: "Noah Green", gender: .male, phoneNumber: "111-555-9999", contactType: .university),
//        ContactUserModel(name: "Emma Turner", gender: .female, phoneNumber: "222-333-4444", contactType: .university),
//        ContactUserModel(name: "Mason King", gender: .male, phoneNumber: "555-777-8888", contactType: .university),
//        ContactUserModel(name: "Olivia Brown", gender: .female, phoneNumber: "444-777-8888", contactType: .university)
//    ]
//}

let appDelegate = UIApplication.shared.delegate as! AppDelegate

let contactUsersType = ["All Contacts", "Family", "Work", "Friends", "Neighbors", "University"]


class ContactVC: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext
    
    var contactUsers = [ContactUsers]()

    @IBOutlet weak var contactTableView: UITableView!
    
    private var selectedContactType: String? {
        didSet {
            contactTableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Your Contacts"
        contactTableView.delegate = self
        contactTableView.dataSource = self
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle.fill"), style: .done, target: self, action: #selector(filterButtonAct))
        filterButton.tintColor = UIColor(named: "pink")
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .done, target: self, action: #selector(addButtonAct))
               addButton.tintColor = UIColor(named: "pink")
               
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = filterButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllUsers()
        if !contactUsers.isEmpty {
            print(contactUsers[0].fullName, contactUsers[0].phoneNumber, contactUsers[0].gender, contactUsers[0].contactType)

        }else {
            print("lşvkd")
        }
        contactTableView.reloadData()
    }
    
    @objc private func filterButtonAct() {
        let storyboard = UIStoryboard(name: "ContactPickerVC", bundle: nil)
        if let vc = storyboard.instantiateViewController(identifier: "ContactPickerVC") as? ContactPickerVC {
            vc.delegate = self
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true)
        }
    }
    
    @objc private func addButtonAct() {
        let storyboard = UIStoryboard(name: "AddUserVC", bundle: nil)
        if let vc = storyboard.instantiateViewController(identifier: "AddUserVC") as? AddUserVC {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getAllUsers() {
        do {
            contactUsers = try context.fetch(ContactUsers.fetchRequest())
        } catch {
            print(error)
        }
    }
}

extension ContactVC: ContactPickerViewDelegate {
    func didSelectContactType(_ type: String) {
        selectedContactType = type
    }
}

extension ContactVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return setSections().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactUsers.filter({ $0.contactType == contactUsersType[section] }).count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return setSections()[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell") as! ContactTableViewCell
        
        cell.cellTitleLabel.text = filterContactUsers(indexPath.section)[indexPath.row].fullName
        cell.cellImageView.backgroundColor = UIColor(named: "gray")
        cell.cellImageView.layer.cornerRadius = cell.cellImageView.frame.height / 2
        let imageName = filterContactUsers(indexPath.section)[indexPath.row].gender == true ? "Female" : "Male"
        cell.cellImageView.image = UIImage(named: imageName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "UserDetailVC", bundle: nil)
        
        if let webVC = storyboard.instantiateViewController(withIdentifier: "UserDetailVC") as? UserDetailVC {
            let imageName = filterContactUsers(indexPath.section)[indexPath.row].gender == true ? "Female" : "Male"
            let userName = filterContactUsers(indexPath.section)[indexPath.row].fullName
            let contactType = filterContactUsers(indexPath.section)[indexPath.row].contactType
            let phoneNumber = filterContactUsers(indexPath.section)[indexPath.row].phoneNumber
            let selectedUser = filterContactUsers(indexPath.section)[indexPath.row]
            
            var filterUser = filterContactUsers(indexPath.section)
            if let indexToRemove = filterUser.firstIndex(of: selectedUser) {
                filterUser.remove(at: indexToRemove)
            }
            
            webVC.userList = filterUser
            webVC.userImage = imageName
            webVC.userName = userName
            webVC.contactType = contactType
            webVC.phoneNumber = phoneNumber
            
            self.navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
    private func setSections() -> [String] {
        if let selectedContactType = selectedContactType, selectedContactType != "All Contacts" {
            return [selectedContactType]
        } else {
            return contactUsersType
            
        }
    }
    
    private func filterContactUsers(_ sectionIndex: Int) -> [ContactUsers] {
        if selectedContactType == nil || selectedContactType == "All Contacts" {
            return contactUsers.filter({ $0.contactType == contactUsersType[sectionIndex] })
        } else {
            return contactUsers.filter({ $0.contactType == selectedContactType })
        }
    }

}
