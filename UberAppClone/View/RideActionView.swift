//
//  RideActionView.swift
//  UberAppClone
//
//  Created by Wallace Santos on 29/11/22.
//

import UIKit

class RideActionView: UIView {

//MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addShadow()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Properties
    
    let localNameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Padaria do Fodac"
        label.textAlignment = .center
        return label
    }()
    
    let adressLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.text = "Rua Capitao Eugenio de Macedo, 39 Itaim Paulista"
        return label
    }()
    
    private lazy var infoView:UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        label.text = "X"
        
        view.addSubview(label)
        label.centerX(inview: view)
        label.centerY(inview: view)
        
        return view
    }()
    
    let actionButton:UIButton = {
        let button = UIButton(type: .system).createMainButton(withPlaceholder: "CONFIRM UBERX")
        button.backgroundColor = .backgroundColor
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleConfirmRide), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }()
    
    let infoLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "UberX"
        label.textAlignment = .center
        return label
    }()
    
    private let separatorView:UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    
    
    
    
//MARK: - Selectors
    
    @objc func handleCancelRide(){
        
    }
    
    @objc func handleConfirmRide(){
        print("DEBUG: 123")
    }
    
//MARK: - Helper Functions
    
    func configureView(){
        let labelStack = UIStackView(arrangedSubviews: [localNameLabel, adressLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 4
        labelStack.distribution = .fillEqually
        addSubview(labelStack)
        labelStack.centerX(inview: self)
        labelStack.anchor(top: topAnchor, paddingTop: 16)
        
        addSubview(infoView)
        infoView.centerX(inview: self)
        infoView.anchor(top: labelStack.bottomAnchor, paddingTop: 16, width: 60, height: 60)
        infoView.layer.cornerRadius = 60 / 2
        addShadow()
        
        addSubview(infoLabel)
        infoLabel.centerX(inview: self)
        infoLabel.anchor(top: infoView.bottomAnchor, paddingTop: 8)
        
        addSubview(separatorView)
        separatorView.centerX(inview: self)
        separatorView.anchor(top: infoLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 16, paddingRight: 16, height: 0.75)
        
        addSubview(actionButton)
        actionButton.centerX(inview: self)
        actionButton.anchor(left: leftAnchor, bottom:safeAreaLayoutGuide.bottomAnchor ,right: rightAnchor, paddingLeft: 16, paddingBottom: 16 ,paddingRight: 12, height: 50)
    }
    
    
}
