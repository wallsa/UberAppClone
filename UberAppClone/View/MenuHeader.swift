//
//  MenuHeader.swift
//  UberAppClone
//
//  Created by Wallace Santos on 11/12/22.
//

import UIKit

class MenuHeader: UIView {

//MARK: - Properties
    
//    var user:User?{
//        didSet{
//            print("DEBUG: USER SET ON HEADER")
//            print("DEBUG: \(user?.fullname)")
//            print("DEBUG: \(user?.email)")
//
//            nameLabel.text = user?.fullname
//            emailLabel.text = user?.email
//        }
//    }
    
    private let user : User
    
    private let profileImage : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "John Doe"
        label.text = user.fullname
        label.textColor = .white
        return label
    }()
    
    private lazy var emailLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "text@gmail.com"
        label.text = user.email
        label.textColor = .lightGray
        return label
    }()
    
    
//MARK: - Life Cycle
    
    init(user:User, frame:CGRect){
        self.user = user
        super.init(frame: frame)
        backgroundColor = .backgroundColor
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(){
        addSubview(profileImage)
        profileImage.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, paddingTop: 4, paddingLeft: 12, width: 64, height: 64)
        profileImage.layer.cornerRadius = 64/2
        let stack = UIStackView(arrangedSubviews: [nameLabel, emailLabel])
        stack.distribution = .fillEqually
        stack.spacing = 4
        stack.axis = .vertical
        addSubview(stack)
        stack.centerY(inview: profileImage, leftAnchor: profileImage.rightAnchor, paddinLeft: 12)
    }
}
