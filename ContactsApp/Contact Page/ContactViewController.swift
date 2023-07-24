//
//  ContactViewController.swift
//  ContactsApp
//
//  Created by Aleyna Aktaş on 22.07.2023.
//

import UIKit

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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell") as! ContactTableViewCell
        
        cell.cellTitleLabel.text = "Name"
        cell.cellImageView.backgroundColor = .white
        cell.cellImageView.layer.cornerRadius = cell.cellImageView.frame.height / 2
        cell.cellImageView.image = UIImage(named: "woman")
    
        return cell
    }
    
    
    
}
