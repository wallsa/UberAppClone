//
//  RideActionView.swift
//  UberAppClone
//
//  Created by Wallace Santos on 29/11/22.
//

import UIKit
import MapKit

//MARK: - Delegate Protocol
protocol RideActionViewDelegate: AnyObject{
    func uploadTrip(view:RideActionView)
    func cancelTrip()
}
//MARK: - Configuration Enums
enum RideActionViewConfiguration{
    case requestRide
    case tripAccepted
    case pickupPassenger
    case tripInProgress
    case endTrip
    
    init(){
        self = .requestRide
    }
}

enum ButtonActionConfiguration:CustomStringConvertible{
    case requestRide
    case cancel
    case getDirections
    case pickup
    case dropOff
    
    var description: String{
        switch self {
            
        case .requestRide: return "CONFIRM UBER X"
        case .cancel: return "CANCEL RIDE"
        case .getDirections: return "GET DIRECTIONS"
        case .pickup: return "PICKUP PASSENGER"
        case .dropOff: return "DROPOFF PASSENGER"
        }
    }
    
    init(){
        self = .requestRide
    }
}


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
    
//    var rideActionConfig = RideActionViewConfiguration()
    var buttonActionConfig = ButtonActionConfiguration()
    weak var delegate:RideActionViewDelegate?
    var user: User?
    
    
    var destination:MKPlacemark?{
        didSet{
            localNameLabel.text = destination?.name
            adressLabel.text = destination?.fullAdress
        }
    }
    
    let localNameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    let adressLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    private lazy var infoView:UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
    
        
        view.addSubview(initialLetterLabel)
        initialLetterLabel.centerX(inview: view)
        initialLetterLabel.centerY(inview: view)
        
        return view
    }()
    
    private let initialLetterLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        label.text = "X"
        return label
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
        switch buttonActionConfig {
        case .requestRide:
            delegate?.uploadTrip(view: self)
        case .cancel:
            delegate?.cancelTrip()
        case .getDirections:
            print("DEBUG: HANDLE GET DIRECTIONS")
        case .pickup:
            print("DEBUG: HANDLE PICKUP")
        case .dropOff:
            print("DEBUG: HANDLE DROPOFF")
        }
        
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
 /* devido a nossa logica em nossa HomeController, estamos enviando para nossa funcao um usuario driver para nossa config de rider e o inverso é valido, assim em nossa configuracao, quando o usuario é um driver configuramos para disponibilizar as informacoes do rider
  Cada usuario ve as informacoes do outro, nao as proprias */
    func configureUI(withConfig config:RideActionViewConfiguration){
        switch config {
        case .requestRide:
            buttonActionConfig = .requestRide
            actionButton.setTitle(buttonActionConfig.description, for: .normal)
            
        case .tripAccepted:
            guard let user = user else {return}
            
            if user.accountType == .passenger{
                localNameLabel.text = "En route To Passenger"
                buttonActionConfig = .getDirections
                actionButton.setTitle(buttonActionConfig.description, for: .normal)
            } else {
                localNameLabel.text = "Driver En Route"
                buttonActionConfig = .cancel
                actionButton.setTitle(buttonActionConfig.description, for: .normal)
            }
            initialLetterLabel.text = String(user.fullname.first ?? "X")
            infoLabel.text = user.fullname
            
        case .pickupPassenger:
            
            localNameLabel.text = "Arrived at Passenger Location"
            buttonActionConfig = .pickup
            actionButton.setTitle(buttonActionConfig.description, for: .normal)
            
        case .tripInProgress:
            
            guard let user = user else {return}
            
            if user.accountType == .driver {
                actionButton.setTitle("TRIP IN PROGRESS", for: .normal)
                actionButton.isEnabled = false
            } else {
                buttonActionConfig = .getDirections
                actionButton.setTitle(buttonActionConfig.description, for: .normal)
            }
            
        case .endTrip:
            guard let user = user else {return}
            
            if user.accountType == .driver{
                actionButton.setTitle("ARRIVE AT DESTINATION", for: .normal)
                actionButton.isEnabled = false
            } else {
                buttonActionConfig = .dropOff
                actionButton.setTitle(buttonActionConfig.description, for: .normal)
            }
        }
    }
    
    
}
