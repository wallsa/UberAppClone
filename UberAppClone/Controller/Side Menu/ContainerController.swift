//
//  ContainerController.swift
//  UberAppClone
//
//  Created by Wallace Santos on 11/12/22.
//

import UIKit
import Firebase

class ContainerController: UIViewController {
    
//MARK: - Properties
    
    private let homeController = HomeController()
    private var menuController : MenuController!
    private var isExpanded = false
    
    private var user:User?{
        didSet{
            guard let user = user else {return}
            homeController.user = user
            
            configureMenuController(withUser: user)
        }
    }
    
//MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeController()
        fetchUserData()
        
    }
 
//MARK: - API
    
    func fetchUserData(){
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        Service.shared.fetchUserData(uid: currentUID) { user in
            self.user = user
        }
    }
//MARK: - Selectors
    
//MARK: - Helper Functions
    
    func configureHomeController(){
        addChild(homeController)
        homeController.delegate = self
        homeController.didMove(toParent: self)
        view.addSubview(homeController.view)
    }
    
    func configureMenuController(withUser user:User){
        menuController = MenuController(user: user)
        addChild(menuController)
        menuController.didMove(toParent: self)
        view.insertSubview(menuController.view, at: 0)
    }
    
    func animateMenu(shouldExpand:Bool){
        if shouldExpand{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.homeController.view.frame.origin.x = self.view.frame.width - 80
            }, completion: nil)
        }else{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.homeController.view.frame.origin.x = 0
            }, completion: nil)
        }
    }
}

//MARK: - HomeController Delegate
extension ContainerController : HomeControllerDelegate{
    func handleMenuToggle() {
        isExpanded.toggle()
        animateMenu(shouldExpand: isExpanded)
    } 
}
