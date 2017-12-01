

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playVideo()
        
        let testView: UIView = UIView(frame: CGRect(x:70, y:270, width: 50, height: 50))
        testView.backgroundColor = .green
        
        view.addSubview(testView)
        
    }
    
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
        /*present(playerController, animated: true) {
                player.play()
        }*/
        
        
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            player.seek(to: kCMTimeZero)
            player.play()
        }
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
