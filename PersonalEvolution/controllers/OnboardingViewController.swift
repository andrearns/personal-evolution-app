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
        OnboardingPage(title: "Desenvolvimento  e hábitos", subtitle: "A melhor forma de efetivar o desenvolvimento pessoal é por meio de hábitos. Estamos aqui para de ajudar", image: UIImage(named: "onboarding1")!, backgroundColor: UIColor(red: 253/255, green: 205/255, blue: 221/255, alpha: 1)),
        OnboardingPage(title: "Desafios & Frequência", subtitle: "Você pode criar desafios com total liberdade e selecionar a repetição dele durante os dias da semana!", image: UIImage(named: "onboarding2")!, backgroundColor: UIColor(red: 195/255, green: 158/255, blue: 237/255, alpha: 1)),
        OnboardingPage(title: "Colaboração & Compartilhamento", subtitle: "Crie metas e compartilhe com seus amigos, assim juntos vocês podem se ajudar a se manter mais motivado.", image: UIImage(named: "onboarding3")!, backgroundColor: UIColor(red: 125/255, green: 226/255, blue: 240/255, alpha: 1)),
        OnboardingPage(title: "Registre & Acompanhe", subtitle: "Você pode registrar como se sente diariamente além do seu progresso nos desafios. Depois verifique sua evolução.", image: UIImage(named: "onboarding4")!, backgroundColor: UIColor(red: 130/255, green: 224/255, blue: 179/255, alpha: 1)),
        OnboardingPage(title: "Registro & Galeria ", subtitle: "Ao fazer check-in nos desafios você pode acrescentar imagens. Gera uma retrospectiva e visualize sua jornada.", image: UIImage(named: "onboarding5")!, backgroundColor:  UIColor(red: 255/255, green: 217/255, blue: 121/255, alpha: 1)),
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
