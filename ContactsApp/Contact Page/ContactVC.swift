//
//  ContactVC.swift
//  ContactsApp
//
//  Created by Aleyna Aktaş on 22.07.2023.
//

import UIKit
import CoreData


let appDelegate = UIApplication.shared.delegate as! AppDelegate

var contactUsersType = ["All Contacts", "Family", "Work", "Friends", "Neighbors", "University"]


class ContactVC: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext
    let fetchRequest: NSFetchRequest<ContactUsers> = ContactUsers.fetchRequest()
    
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
        getAllUsers()
        contactTableView.reloadData()
        
        contactTableView.delegate = self
        contactTableView.dataSource = self
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle.fill"), style: .done, target: self, action: #selector(filterButtonAct))
        filterButton.tintColor = UIColor(named: "pink")
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .done, target: self, action: #selector(addButtonAct))
               addButton.tintColor = UIColor(named: "pink")
               
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = filterButton
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllUsers()
        contactTableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        selectedContactType = nil
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
        if let vc = storyboard.instantiateViewController(withIdentifier: "AddUserVC") as? AddUserVC {
            navigationController?.show(vc, sender: nil)
        }
    }
    
    func getAllUsers() {
        do {
            contactUsers = try context.fetch(fetchRequest)
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
        return filterContactUsers(section).count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return setSections()[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell") as! ContactTableViewCell
        guard indexPath.section >= 0 && indexPath.section < numberOfSections(in: tableView) else {
            return cell
        }
        
        let usersInSection = filterContactUsers(indexPath.section)
        guard indexPath.row >= 0 && indexPath.row < usersInSection.count else {
            return cell
        }
        
        let user = usersInSection[indexPath.row]
        let name = user.name ?? "No Name"
        let surname = user.surname ?? "No Surname"
        cell.cellTitleLabel.text = name + " " + surname
        cell.cellImageView.backgroundColor = UIColor(named: "gray")
        cell.cellImageView.layer.cornerRadius = cell.cellImageView.frame.height / 2
        let imageName = user.gender == true ? "Female" : "Male"
        cell.cellImageView.image = UIImage(named: imageName)
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "UserDetailVC", bundle: nil)
        
        if let webVC = storyboard.instantiateViewController(withIdentifier: "UserDetailVC") as? UserDetailVC {
            let imageName = filterContactUsers(indexPath.section)[indexPath.row].gender == true ? "Female" : "Male"
            let userName =  (filterContactUsers(indexPath.section)[indexPath.row].name ?? "No Name") + " " + (filterContactUsers(indexPath.section)[indexPath.row].surname ?? "No Surname")
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            let user = self.filterContactUsers(indexPath.section)[indexPath.row]
            
            let alertController = UIAlertController(title: "Delete User", message: "Are you sure you want to delete this user?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                completion(false)
            }))
            alertController.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { _ in
                self.context.delete(user)
                appDelegate.saveContext()
                self.contactTableView.reloadData()
                completion(true)
            }))

            self.present(alertController, animated: true, completion: nil)
        }

        
        let updateAction = UIContextualAction(style: .normal, title: "Update") { (action, view, completion) in
            let storyboard = UIStoryboard(name: "AddUserVC", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "AddUserVC") as? AddUserVC {
                self.navigationController?.show(vc, sender: nil)
                let user = self.filterContactUsers(indexPath.section)[indexPath.row]
                vc.user = user
                completion(true)

            }
        }
        
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
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
