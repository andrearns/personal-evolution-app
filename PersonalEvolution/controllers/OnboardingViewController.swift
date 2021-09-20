//
//  OnboardingViewController.swift
//  PersonalEvolution
//
//  Created by André Arns on 19/09/21.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    
    
    var pages: [OnboardingPage] = [
        OnboardingPage(title: "Improvement and Habits", subtitle: "The best way to effectuate personal growth is through habits. And we’re here to help you improve them with you.", image: UIImage(named: "onboarding1")!, backgroundColor: UIColor(red: 253/255, green: 205/255, blue: 221/255, alpha: 1)),
        OnboardingPage(title: "Challenges and Frequency", subtitle: "You can create challenges with full freedom and define its frequency by choosing the days of the week you’ll want to repeat!", image: UIImage(named: "onboarding2")!, backgroundColor: UIColor(red: 195/255, green: 158/255, blue: 237/255, alpha: 1)),
        OnboardingPage(title: "Collaboration and Sharing", subtitle: "Create goals and share them with your friends, that way you can keep each other motivated.", image: UIImage(named: "onboarding3")!, backgroundColor: UIColor(red: 125/255, green: 226/255, blue: 240/255, alpha: 1)),
        OnboardingPage(title: "Register and Follow up", subtitle: "You can record how you feel on a daily basis, as well as your progress on challenges. All your records will be available in the “evolution” section.", image: UIImage(named: "onboarding4")!, backgroundColor: UIColor(red: 130/255, green: 224/255, blue: 179/255, alpha: 1)),
        OnboardingPage(title: "Retrospective and Gallery ", subtitle: "By checking-in your challenges you can add photos, the app will generate a retrospective and you can visualize your self- improvement journey.", image: UIImage(named: "onboarding5")!, backgroundColor:  UIColor(red: 255/255, green: 217/255, blue: 121/255, alpha: 1)),
    ]
    
    var frame = CGRect.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        drawPage()
        drawOnboardingFinishButton()
        startButton.layer.cornerRadius = 15
        startButton.dropShadow()
    }
    
    @IBAction func swipeRight(_ sender: Any) {
        if pageControl.currentPage > 0 {
            pageControl.currentPage -= 1
        }
        print("Swipe Right")
        drawPage()
        drawOnboardingFinishButton()
    }
    
    @IBAction func swipeLeft(_ sender: Any) {
        if pageControl.currentPage < pages.count - 1 {
            pageControl.currentPage += 1
        }
        print("Swipe left")
        drawPage()
        drawOnboardingFinishButton()
    }
    
    func drawPage() {
        self.imageView.image = pages[pageControl.currentPage].image
        self.titleLabel.text = pages[pageControl.currentPage].title
        self.subtitleLabel.text = pages[pageControl.currentPage].subtitle
        self.view.backgroundColor = pages[pageControl.currentPage].backgroundColor
    }
    
    func drawOnboardingFinishButton() {
        if pageControl.currentPage < 4 {
            UIView.animate(withDuration: 0.3, animations: {
                self.startButton.alpha = 0.0
            })
        } else if pageControl.currentPage == 4 {
            UIView.animate(withDuration: 0.3, animations: {
                self.startButton.alpha = 1.0
            })
        }
    }
}

struct OnboardingPage {
    var title: String
    var subtitle: String
    var image: UIImage
    var backgroundColor: UIColor
}
