

import UIKit
import AVKit
import AVFoundation
import SwiftKeychainWrapper
import CoreData

class WelcomeVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //clearData
        /*func1()
        func2()
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "EMAIL")
        print("removeSuccessful: \(removeSuccessful)")*/
        
        
        

        // play video in the background
        playVideo()
        
        // get screen size
        let bounds: CGRect = UIScreen.main.bounds
        let width:CGFloat = bounds.size.width
        let height:CGFloat = bounds.size.height
        
        // add title
        let titleLabel = UILabel(frame: CGRect(x: width / 2 - 150, y: 180, width: 300, height: 56))
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 70, weight: 20)
        titleLabel.text = "FOODY"
        self.view.addSubview(titleLabel)
        
        // add subtitle
        let subtitleLabel = UILabel(frame: CGRect(x: width / 2 - 150, y: 240, width: 300, height: 20))
        subtitleLabel.textAlignment = NSTextAlignment.center
        subtitleLabel.textColor = .white
        subtitleLabel.font = UIFont.systemFont(ofSize: 22, weight: 4)
        subtitleLabel.text = "Find your meal"
        self.view.addSubview(subtitleLabel)
        
        
        // create login button
        let loginButton = UIButton(frame: CGRect(x: width / 2 - 160, y: height - 160, width: 320, height: 60))
        loginButton.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
        loginButton.layer.cornerRadius = 30
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0).cgColor
        loginButton.setTitle("LOG IN", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: 15)
        loginButton.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        self.view.addSubview(loginButton)
        
        // create register button
        let registerButton = UIButton(frame: CGRect(x: width / 2 - 160, y: height - 80, width: 320, height: 60))
        registerButton.backgroundColor = .clear
        registerButton.layer.cornerRadius = 30
        registerButton.layer.borderWidth = 2
        registerButton.layer.borderColor = UIColor.white.cgColor
        registerButton.setTitle("SIGN UP", for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: 15)
        registerButton.addTarget(self, action: #selector(registerPressed), for: .touchUpInside)
        self.view.addSubview(registerButton)
    }
    
    
    
    @objc func loginPressed() {
        performSegue(withIdentifier: "toLogin", sender: nil)
    }
    @objc func registerPressed() {
        performSegue(withIdentifier: "toRegister", sender: nil)}
    
    /*
 
 */
    
    private func playVideo() {
        //guard let path = Bundle.main.path(forResource: "test2", ofType:"mov") else {  // m4v
        guard let path = Bundle.main.path(forResource: "foody_background", ofType:"mov") else {  // m4v
            debugPrint("foody_background.mov not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.player = player
        playerController.showsPlaybackControls = false
        self.addChildViewController(playerController)
        let screenSize:CGRect = UIScreen.main.bounds
        let width:CGFloat = screenSize.size.width
        let height:CGFloat = screenSize.size.height
        playerController.view.frame = CGRect(x: 0, y: -22, width: width, height: height + 44)
        //playerController.view.frame = screenSize
        self.view.addSubview(playerController.view)
        player.play()
        // repead video
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            player.seek(to: kCMTimeZero)
            player.play()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // hide navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if let inloggedUserEmail: String = KeychainWrapper.standard.string(forKey: "EMAIL") {
            print("Saved email is: " + inloggedUserEmail)
            performSegue(withIdentifier: "welcomeToHome", sender: nil)
            
        } else {
            print("KeychainWrapper is empty.")
            //performSegue(withIdentifier: "logout", sender: nil)
        }
    }
}















//clear data
/*
func func1() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
    fetchRequest.returnsObjectsAsFaults = false
    do {
        let results = try managedContext.fetch(fetchRequest)
        for managedObject in results
        {
            let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
            managedContext.delete(managedObjectData)
            try managedContext.save()
        }
    } catch let error as NSError {
        print("Detele all data in User error : \(error) \(error.userInfo)")
    }
}
func func2() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Meal")
    fetchRequest.returnsObjectsAsFaults = false
    do {
        let results = try managedContext.fetch(fetchRequest)
        for managedObject in results
        {
            let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
            managedContext.delete(managedObjectData)
            try managedContext.save()
        }
    } catch let error as NSError {
        print("Detele all data in Meal error : \(error) \(error.userInfo)")
    }
}*/
