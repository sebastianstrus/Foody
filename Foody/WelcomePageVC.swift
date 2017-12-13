

import UIKit
import AVKit
import AVFoundation

class WelcomePageVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // play video in the background
        playVideo()
        
        // get screen size
        let bounds: CGRect = UIScreen.main.bounds
        let width:CGFloat = bounds.size.width
        let height:CGFloat = bounds.size.height
        
        //add title
        let titleLabel = UILabel(frame: CGRect(x: width / 2 - 150, y: 180, width: 300, height: 50))
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 70, weight: 20)
        titleLabel.text = "FOODY"
        self.view.addSubview(titleLabel)
        
        let subtitleLabel = UILabel(frame: CGRect(x: width / 2 - 150, y: 240, width: 300, height: 20))
        subtitleLabel.textAlignment = NSTextAlignment.center
        subtitleLabel.textColor = .white
        subtitleLabel.font = UIFont.systemFont(ofSize: 22, weight: 4)
        subtitleLabel.text = "Find your meal"
        self.view.addSubview(subtitleLabel)
        
        
        // create login button
        let loginButton = UIButton(frame: CGRect(x: width / 2 - 160, y: height - 160, width: 320, height: 60))
        loginButton.backgroundColor = .clear
        loginButton.layer.cornerRadius = 30
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.setTitle("LOGIN", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: 15)
        loginButton.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        self.view.addSubview(loginButton)
        
        // create register button
        let registerButton = UIButton(frame: CGRect(x: width / 2 - 160, y: height - 80, width: 320, height: 60))
        registerButton.backgroundColor = .clear
        registerButton.layer.cornerRadius = 30
        registerButton.layer.borderWidth = 2
        registerButton.layer.borderColor = UIColor.white.cgColor
        registerButton.setTitle("REGISTER", for: .normal)
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
        guard let path = Bundle.main.path(forResource: "test2", ofType:"mov") else {  // m4v
            debugPrint("video.m4v not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.player = player
        playerController.showsPlaybackControls = false
        self.addChildViewController(playerController)
        let screenSize:CGRect = UIScreen.main.bounds
        playerController.view.frame = screenSize
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
    }
    
    
    
    
}
/*
 

let url = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
let item = AVPlayerItem(url: url!)
self.player = AVPlayer(playerItem: item)
self.avplayerController = AVPlayerViewController()
self.avplayerController.player = self.player
self.avplayerController.view.frame = videoPreviewLayer.frame
self.avplayerController.showsPlaybackControls = true
self.avplayerController.requiresLinearPlayback = true

self.addChildViewController(self.avplayerController)
self.view.addSubview(self.avplayerController.view)

self.avpController.player?.play()*/
