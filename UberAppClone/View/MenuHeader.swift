//
//  MenuHeader.swift
//  UberAppClone
//
//  Created by Wallace Santos on 11/12/22.
//

import UIKit

class MenuHeader: UIView {

//MARK: - Properties
    
    
    private let user : User
    
    private lazy var profileImage : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.addSubview(initialLetter)
        initialLetter.centerX(inview: view)
        initialLetter.centerY(inview: view)
        return view
    }()
    
    private lazy var initialLetter : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40)
        label.text = user.firstInitial
        label.textColor = .white
        return label
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
