//
//  UserDetailViewController.swift
//  ContactsApp
//
//  Created by Aleyna Aktaş on 24.07.2023.
//

import UIKit

class UserDetailViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usersCollectionView: UICollectionView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var contactTypeLabel: UILabel!
    
    var userImage: String?
    var userName: String?
    var contactType: String?
    
    var userList: [ContactUserModel] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersCollectionView.dataSource = self
        usersCollectionView.delegate = self
                
        if let userImage, let userName, let contactType {
            userImageView.image = UIImage(named: userImage)
            userImageView.backgroundColor = .lightGray
            userNameLabel.text = userName
            contactTypeLabel.text = contactType
        }
        if let layout = usersCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                   layout.scrollDirection = .horizontal
               }
        userImageView.layer.cornerRadius = userImageView.layer.frame.height / 2
    }
}

extension UserDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserDetailCollectionViewCell", for: indexPath) as! UserDetailCollectionViewCell
        cell.name.text = "aleyna"
        cell.image.image = UIImage(named: "Male")
        cell.image.backgroundColor = .lightGray
        cell.image.layer.cornerRadius = cell.image.layer.frame.height / 2
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 4.0 - 10 //
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Hücreler arasındaki boşluk miktarını belirleyebilirsiniz
    }
    
    
}
