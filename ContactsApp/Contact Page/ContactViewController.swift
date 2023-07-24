//
//  ContactViewController.swift
//  ContactsApp
//
//  Created by Aleyna Aktaş on 22.07.2023.
//

import UIKit

struct ContactUserModel {
    var name: String
    var gender: Gender
    var phoneNumber: String
    var contactType: ContactUserType
}

enum ContactUserType: CaseIterable {
    case allContacts
    case family
    case friends
    case work
    case neighbors
    case university
    
    var contactType: String {
        switch self {
            case .allContacts:
                return "AllContacts"
            case .family:
                return "Family"
            case .friends:
                return "Friends"
            case .work:
                return "Work"
            case .neighbors:
                return "Neighbors"
            case .university:
                return "University"
        }
    }
}

enum Gender: CaseIterable {
    case male
    case female
    
    var genderType: String {
        switch self {
        case .female:
            return "Female"
        case .male:
            return "Male"
        }
    }
}


class Contacts {
    static let contacts: [ContactUserModel] = [
        ContactUserModel(name: "John Doe", gender: .male, phoneNumber: "123-456-7890", contactType: .family),
        ContactUserModel(name: "Jane Smith", gender: .female, phoneNumber: "987-654-3210", contactType: .family),
        ContactUserModel(name: "Emily Davis", gender: .female, phoneNumber: "777-666-5555", contactType: .family),
        ContactUserModel(name: "Michael Johnson", gender: .male, phoneNumber: "555-123-4567", contactType: .family),
        ContactUserModel(name: "Robert Lee", gender: .male, phoneNumber: "222-999-3333", contactType: .family),
        ContactUserModel(name: "Sophia Anderson", gender: .female, phoneNumber: "444-555-6666", contactType: .family),
        
        ContactUserModel(name: "Alice Brown", gender: .female, phoneNumber: "444-777-8888", contactType: .friends),
        ContactUserModel(name: "William Taylor", gender: .male, phoneNumber: "666-888-9999", contactType: .friends),
        ContactUserModel(name: "Oliver Harris", gender: .male, phoneNumber: "111-333-5555", contactType: .friends),
        ContactUserModel(name: "Isabella Allen", gender: .female, phoneNumber: "222-333-4444", contactType: .friends),
        ContactUserModel(name: "Lucas Carter", gender: .male, phoneNumber: "555-777-8888", contactType: .friends),
        ContactUserModel(name: "Ella Wilson", gender: .female, phoneNumber: "888-222-4444", contactType: .friends),
        
        ContactUserModel(name: "David Miller", gender: .male, phoneNumber: "888-222-4444", contactType: .work),
        ContactUserModel(name: "William Taylor", gender: .male, phoneNumber: "666-888-9999", contactType: .work),
        ContactUserModel(name: "Emily Davis", gender: .female, phoneNumber: "777-666-5555", contactType: .work),
        ContactUserModel(name: "Michael Johnson", gender: .male, phoneNumber: "555-123-4567", contactType: .work),
        ContactUserModel(name: "Ava White", gender: .female, phoneNumber: "888-777-4444", contactType: .work),
        ContactUserModel(name: "Sarah Wilson", gender: .female, phoneNumber: "111-333-5555", contactType: .work),
        
        ContactUserModel(name: "James Anderson", gender: .male, phoneNumber: "444-555-6666", contactType: .neighbors),
        ContactUserModel(name: "Olivia Martinez", gender: .female, phoneNumber: "222-333-4444", contactType: .neighbors),
        ContactUserModel(name: "Sophia Hernandez", gender: .female, phoneNumber: "555-777-8888", contactType: .neighbors),
        ContactUserModel(name: "Noah Green", gender: .male, phoneNumber: "111-555-9999", contactType: .neighbors),
        ContactUserModel(name: "Ethan Hall", gender: .male, phoneNumber: "333-222-1111", contactType: .neighbors),
        ContactUserModel(name: "Lily Murphy", gender: .female, phoneNumber: "777-888-9999", contactType: .neighbors),
        
        ContactUserModel(name: "Liam Robinson", gender: .male, phoneNumber: "333-222-1111", contactType: .university),
        ContactUserModel(name: "Ava White", gender: .female, phoneNumber: "888-777-4444", contactType: .university),
        ContactUserModel(name: "Noah Green", gender: .male, phoneNumber: "111-555-9999", contactType: .university),
        ContactUserModel(name: "Emma Turner", gender: .female, phoneNumber: "222-333-4444", contactType: .university),
        ContactUserModel(name: "Mason King", gender: .male, phoneNumber: "555-777-8888", contactType: .university),
        ContactUserModel(name: "Olivia Brown", gender: .female, phoneNumber: "444-777-8888", contactType: .university)
    ]
}

class ContactViewController: UIViewController {

    @IBOutlet weak var contactTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Your Contacts"
        contactTableView.delegate = self
        contactTableView.dataSource = self
    }
}

extension ContactViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ContactUserType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterContactUsers(section).count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ContactUserType.allCases[section].contactType
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell") as! ContactTableViewCell
        
        cell.cellTitleLabel.text = filterContactUsers(indexPath.section)[indexPath.row].name
        cell.cellImageView.backgroundColor = .white
        cell.cellImageView.layer.cornerRadius = cell.cellImageView.frame.height / 2
        let imageName = filterContactUsers(indexPath.section)[indexPath.row].gender.genderType
        cell.cellImageView.image = UIImage(named: imageName)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func filterContactUsers(_ sectionIndex: Int) -> [ContactUserModel] {
        return Contacts.contacts.filter({ $0.contactType == ContactUserType.allCases[sectionIndex] })
    }
}
