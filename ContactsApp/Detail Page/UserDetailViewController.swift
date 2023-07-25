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
    @IBOutlet weak var userInfoTableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var contactTypeLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    var userImage: String?
    var userName: String?
    var contactType: String?
    var phoneNumber: String?
    var userList: [ContactUserModel] = []
    
    var userInfoTitles = ["Name", "Contact Type", "Phone Number"]

    var favoriteButton: UIBarButtonItem!
    var gradientLayer = CAGradientLayer()


    override func viewDidLoad() {
        super.viewDidLoad()
        usersCollectionView.dataSource = self
        usersCollectionView.delegate = self
        
        userInfoTableView.dataSource = self
        userInfoTableView.delegate = self
        
        usersCollectionView.showsHorizontalScrollIndicator = false

        navigationController?.navigationBar.tintColor = .white
        

        let startColor = UIColor(red: 215/255, green: 165/255, blue: 140/255, alpha: 1).cgColor
        let endColor = UIColor(red: 215/255, green: 80/255, blue: 120/255, alpha: 1).cgColor
        gradientLayer.colors = [startColor, endColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = topView.bounds
        topView.layer.insertSublayer(gradientLayer, at: 0)
        
        bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 50)

        if let userImage, let userName, let phoneNumber, let contactType {
            userImageView.image = UIImage(named: userImage)
            userImageView.backgroundColor = .white
            userNameLabel.text = userName
            phoneNumberLabel.text = phoneNumber
            contactTypeLabel.text = "Other \(contactType)"
        }
        if let layout = usersCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                   layout.scrollDirection = .horizontal
        }
        userImageView.layer.cornerRadius = userImageView.layer.frame.height / 2
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateGradientLayerFrame()
        bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 50)

    }
    func updateGradientLayerFrame() {
        gradientLayer.frame = topView.bounds
        gradientLayer.locations = [0, NSNumber(value: Float(topView.bounds.width / topView.bounds.height)), 1]
    }

}

extension UserDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserDetailCollectionViewCell", for: indexPath) as! UserDetailCollectionViewCell
        let userImage = userList[indexPath.row].gender.genderType
        cell.name.text = userList[indexPath.row].name
        cell.image.image = UIImage(named: userImage)
        cell.image.backgroundColor = UIColor(named: "gray")
        cell.image.layer.cornerRadius = cell.image.layer.frame.height / 2
        cell.image.layer.borderWidth = 0.4
        cell.image.layer.borderColor = UIColor.purple.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 3.0 - 10
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension UserDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfoTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoTableViewCell") as! UserInfoTableViewCell
        
        let title = userInfoTitles[indexPath.row] // "row" özelliği kullanılmalı
        var selectedValue = ""
        switch title {
            case "Name":
           selectedValue = userName ?? "No Name"
            case "Contact Type":
           selectedValue = contactType ?? "No Type"
           case "Phone Number":
               selectedValue = phoneNumber ?? "No Number"
           default:
               break
        }
       
       cell.cellTitleLabel.text = title
       cell.celSubTitleLabel.text = selectedValue
           
        return cell
    }
    
    
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}
