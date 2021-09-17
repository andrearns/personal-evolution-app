//
//  RetrospectiveViewController.swift
//  PersonalEvolution
//
//  Created by André Arns on 14/09/21.
//

import UIKit
import SwiftVideoGenerator
import AVFoundation
import AVKit

class RetrospectiveViewController: UIViewController {

    var habit: Habit!
    
    var checkinsList: [Checkin]!
    var retrospectiveType: RetrospectiveType!
    var images: [UIImage] = []
    var videoURL: URL?
    var player: AVPlayer?
    
    @IBOutlet var playVideoButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var retrospectiveTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shareButton.layer.cornerRadius = 15
        playVideoButton.setBackgroundImage(checkinsList[checkinsList.count - 1].image, for: .normal)
        
        if retrospectiveType == .personal {
            retrospectiveTitleLabel.text = "Sua retrospectiva"
        } else if retrospectiveType == .group {
            retrospectiveTitleLabel.text = "Retrospectiva do grupo"
        }
        
        for i in 0..<checkinsList.count {
            if checkinsList[i].image != nil {
                images.append(checkinsList[i].image!)
            }
        }
        
        if let audioURL = Bundle.main.url(forResource: "Audio1", withExtension: "mp3") {
            LoadingView.lockView()
            
            VideoGenerator.fileName = "Wedo-Retrospective"
            VideoGenerator.videoBackgroundColor = .black
            VideoGenerator.maxVideoLengthInSeconds = 2 * Double(self.images.count)
            VideoGenerator.scaleWidth = 1000
            VideoGenerator.shouldOptimiseImageForVideo = true
            
            VideoGenerator.current.generate(withImages: self.images, andAudios: [audioURL], andType: .singleAudioMultipleImage, { (progress) in
                print(progress)
            }) { (result) in
                LoadingView.unlockView()
                switch result {
                case .success(let url):
                    self.videoURL = url
                    print(url)
                    self.createAlertView(message: "Finished video generation")
                case .failure(let error):
                    print(error)
                    self.createAlertView(message: error.localizedDescription)
                }
            }
        } else {
            self.createAlertView(message: "Missing audio file")
        }
    }
    
    @IBAction func playVideo(_ sender: Any) {
        guard let url = videoURL else { return }
        
        player = AVPlayer(url: url)
        
        let controller = AVPlayerViewController()
        controller.player = self.player
        
        present(controller, animated: true) {
            self.player?.play()
        }
    }
    
    @IBAction func shareVideo(_ sender: Any) {
        let message = "Dá uma olhada na minha evolução fazendo o hábito de \(habit.name) no app WeDo!"
        let videoData = try? Data(contentsOf: videoURL!)

        let objectsToShare = [message, videoData as Any] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.openInIBooks, UIActivity.ActivityType.postToWeibo]
        self.present(activityVC, animated: true, completion: nil)
    }
    
    fileprivate func createAlertView(message: String?) {
        let messageAlertController = UIAlertController(title: message, message: message, preferredStyle: .alert)
        messageAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            messageAlertController.dismiss(animated: true, completion: nil)
        }))
        DispatchQueue.main.async { [weak self] in
            self?.present(messageAlertController, animated: true, completion: nil)
        }
    }
}
