//  ProfileViewController.swift
//  Foodly
//  Created by Decagon on 12/06/2021.

import Foundation
import FirebaseFirestore
import FirebaseAuth
import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var profileNumberTextField: UITextField!
    @IBOutlet weak var profileNumberLabel: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var updateProfileButtonOutlet: UIButton!
    @IBOutlet weak var saveProfileButtonOutlet: UIButton!
    
    let profileViewModel = ProfileViewModel()
    let cartViewModel = CartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveProfileButtonOutlet.isEnabled = false
        profileNumberTextField.isHidden = true
        addressTextField.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        profileViewModel.getProfileDetails()
        profileViewModel.notificationCompletion = {
            DispatchQueue.main.async {
                self.profileName.text = self.profileViewModel.fullName
                self.profileNumberLabel.text = self.profileViewModel.phoneNumber
                self.addressLabel.text = self.profileViewModel.userAddress
            }
        }
        
        cartViewModel.addressUpdateCompletion = { [weak self] in
            DispatchQueue.main.async {
                self?.profileName.text = self?.profileViewModel.fullName
                self?.profileNumberLabel.text = self?.profileViewModel.phoneNumber
                self?.addressLabel.text = self?.profileViewModel.userAddress
            }
        }
    }
    
    @IBAction func updateProfileButton(_ sender: Any) {
        updateProfileButtonOutlet.isEnabled = false
        saveProfileButtonOutlet.isEnabled = true
        addressTextField.text = addressLabel.text
        profileNumberTextField.text = profileNumberLabel.text
        addressLabel.isHidden = true
        profileNumberLabel.isHidden = true
        addressTextField.isHidden = false
        profileNumberTextField.isHidden = false
    }
    
    @IBAction func saveProfileButton(_ sender: UIButton) {
        
        if profileNumberTextField.text != nil && profileNumberTextField.text?.isEmpty == false
            && addressTextField != nil
            && addressTextField.text?.isEmpty == false {
            HUD.show(status: "Updating...")
            profileNumberLabel.text = profileNumberTextField.text
            addressLabel.text = addressTextField.text
        } else {
            HUD.hide()
            self.showAlert(alertText: "Error",
                           alertMessage: "Please type in your address and phone number")
        }
        saveProfileButtonOutlet.isEnabled = false
        updateProfileButtonOutlet.isEnabled = true
        addressLabel.isHidden = false
        profileNumberLabel.isHidden = false
        addressTextField.isHidden = true
        profileNumberTextField.isHidden = true
        profileViewModel.updateProfile(view: self, profileViewModel.email, profileViewModel.fullName,
                                       addressLabel.text ??
                                       "Update your address", profileNumberLabel.text ?? "Update your phone number")
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        HUD.show(status: "Logging out...")
        do {
            try Auth.auth().signOut()
        } catch {
            self.showAlert(alertText: "Error",
                           alertMessage: "There was an error logging you out. Please try again.")
        }
        HUD.hide()
        let newStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = newStoryboard
            .instantiateViewController(identifier: "LoginViewController")
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .flipHorizontal
        present(controller, animated: true, completion: nil)
    }
    
}
