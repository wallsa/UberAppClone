//
//  PickupController.swift
//  UberAppClone
//
//  Created by Wallace Santos on 03/12/22.
//

import UIKit
import MapKit

protocol PickupControllerDelegate:AnyObject{
    func didAcceptTrip(_ trip:Trip)
}

class PickupController:UIViewController{
    
//MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureMapview()
        
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    init(trip: Trip) {
        self.trip = trip
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Properties
    
    weak var delegate:PickupControllerDelegate?
    private let mapView = MKMapView()
    let trip:Trip
    
    private let cancelButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(imageLiteralResourceName: "cancelButton").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    private let pickupLabel : UILabel = {
        let label = UILabel()
        label.text = "Would you like to pickup this passenger?"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let acceptTripButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ACCEPT TRIP", for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleAcceptTrip), for: .touchUpInside)
        return button
    }()
    
    
//MARK: - API
    
    

//MARK: - Selectors
    @objc func handleDismissal(){
        dismiss(animated: true)
    }
    
    @objc func handleAcceptTrip(){
        print("DEBUG: Deal with accept trip")
        DriverService.shared.acceptTrip(trip: trip) { error, dataref in
            self.delegate?.didAcceptTrip(self.trip)
        }
    }
    
//MARK: - Helper Functions
    
    func configureMapview(){
        mapView.region = .init(center: trip.pickupCoordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
        let anno = MKPointAnnotation()
        mapView.addAnnotationAndSelect(forCoordinates: trip.pickupCoordinates)
        
    }
    func configureUI(){
        view.backgroundColor = .backgroundColor
        view.addSubview(cancelButton)
        cancelButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingLeft: 16)
        
        view.addSubview(mapView)
        mapView.setDimensions(height: 270, width: 270)
        mapView.layer.cornerRadius = 270 / 2
        mapView.centerX(inview: view)
        mapView.centerY(inview: view, constant: -150)
        
        view.addSubview(pickupLabel)
        pickupLabel.centerX(inview: view)
        pickupLabel.anchor(top: mapView.bottomAnchor, paddingTop: 24)
        
        
        view.addSubview(acceptTripButton)
        acceptTripButton.centerX(inview: view)
        acceptTripButton.layer.cornerRadius = 5
        acceptTripButton.anchor(top: pickupLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 25, paddingLeft: 50, paddingRight: 50, height: 50)
        
    }
    
}
