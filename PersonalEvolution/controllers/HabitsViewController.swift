//
//  HabitsViewController.swift
//  PersonalEvolution
//
//  Created by André Arns on 30/08/21.
//
import CloudKit
import UIKit
import iCarousel

class HabitsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, iCarouselDataSource, iCarouselDelegate {
    
    @IBOutlet weak var dailyComment: UIView!
    @IBOutlet weak var dailyMood: UIView!
    @IBOutlet var habitsTableView: UITableView!
    @IBOutlet var usernameLabel: UILabel!
    
    var habitsList: [Habit] = []
    var currentUser = User(name: "", imageData: nil, recordID: nil)
    
    private let database = CKContainer(identifier: "iCloud.PersonalEvolution").publicCloudDatabase
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(swipeDownToReload), for: .valueChanged)
        self.habitsTableView.refreshControl = control
        
        self.habitsTableView.dataSource = self
        self.habitsTableView.delegate = self
        
        view.addSubview(carousel)
        setupCarousel()
        
        fetchHabits()
        self.habitsTableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.currentUser.name = UserSingleton.shared.fetchName() ?? UserSingleton.shared.name!
            self.currentUser.imageData = UserSingleton.shared.fetchUserImageData() ?? UserSingleton.shared.imageData!
            self.currentUser.recordID = UserSingleton.shared.fetchUserRecordID() ?? UserSingleton.shared.recordID
            self.usernameLabel.text = self.currentUser.name
            print("Current user: \(self.currentUser)")
        }
    }
    
    func updateMoodPanel(index : Int){
        if index == currentDay(){
            dailyComment.isHidden = true
            dailyMood.isHidden = false
            
        } else if index > currentDay(){
            dailyComment.isHidden = true
            dailyMood.isHidden = true
        }
        else{
            dailyComment.isHidden = false
            dailyMood.isHidden = true
        }
    }
    
    func currentDay() -> Int{
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        
        return day
    }
    
    @objc func swipeDownToReload() {
        self.habitsTableView.refreshControl?.beginRefreshing()
        self.fetchHabits()
        self.habitsTableView.refreshControl?.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CreateOrEditHabitViewController {
            vc.onSave = {
                self.fetchHabits()
            }
        }
    }
    
    func fetchHabits() {
        DispatchQueue.main.async {
            var habits: [Habit] = []
            CloudKitHelper.fetchHabits { (result) in
                switch result {
                case .success(let newItem):
                    habits.append(newItem)
                    print(newItem)
                    print("Successfully fetched item")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.habitsList = habits
                self.habitsTableView.reloadData()
            }
        }
    }
    
    // MARK: - Carousel
    
    let carousel: iCarousel = {
        let view = iCarousel()
        view.type = .linear
        return view
    }()
    
    func setupCarousel(){
        carousel.frame = CGRect(x: 0, y: 195, width: view.frame.size.width, height: 70)
        carousel.dataSource = self
        carousel.delegate = self
        carousel.stopAtItemBoundary = true
        
        carousel.scrollToItem(at: (currentDay() - 1), animated: true)
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        
        let calendar = Calendar.current
        let date = Date()
        
        let interval = calendar.dateInterval(of: .month, for: date)!
        let days = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
        return days
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        carousel.reloadData()
    }

    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch (option) {
        case .spacing: return 1.045 // 1.045 points spacing

            default: return value
        }
    }
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        let curentView = self.carousel.currentItemIndex
        
        updateMoodPanel(index: curentView + 1)
        
        if self.carousel.currentItemIndex == index{
            let view = setupCarouselView()
            view.frame = CGRect(x: -5, y: -5, width: view.frame.width * 1.2, height:  view.frame.height * 1.2)
            let label = setupCarouselLabel(view: view)
            
            view.backgroundColor = UIColor(named: "Lilas")
            view.addSubview(label)

            label.frame = CGRect(x: 0, y: 0, width: view.frame.width, height:  view.frame.height)
            label.text = "\(index + 1)"
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 22)
            return view
        }else {
            let view = setupCarouselView()
            let label = setupCarouselLabel(view: view)
            
            view.addSubview(label)
            label.textColor = UIColor(named: "FontColorBlack")
            label.text = "\(index + 1)"
            return view
        }
    }
    
    func setupCarouselView() -> UIView {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        view.backgroundColor = UIColor(named: "TextFieldBackgroundColor")
        view.layer.cornerRadius = 15
        view.dropShadow()
        
        return view
    }
    
    func setupCarouselLabel(view : UIView) -> UILabel {
        
        let label = UILabel(frame: view.bounds)
        label.center = view.center
        label.textAlignment = .center
        label.contentMode = .center
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.systemFont(ofSize: 18)

        
        return label
    }
    
    
    
    @IBAction func addHabit(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "CreateOrEditHabit") as? CreateOrEditHabitViewController
        navigationController?.showDetailViewController(vc!, sender: self)
    }
    
    // MARK: - Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.habitsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = habitsTableView.dequeueReusableCell(withIdentifier: "habitCell") as! HabitTableViewCell
        
        let habit = habitsList[indexPath.row]
        cell.setup(habit: habit)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let habit = habitsList[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "singleHabit") as! SingleHabitViewController
        vc.habit = habit
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CloudKitHelper.delete(recordID: habitsList[indexPath.row].recordID!) { (result) in
                switch result {
                case .success(let recordID):
                    self.habitsList.removeAll{ (habit) -> Bool in
                        return habit.recordID == recordID
                    }
                    print("Successfully deleted habit")
                    self.fetchHabits()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    @IBAction func blueMoodDay(_ sender: Any) {
        openPopUp()
    }
    @IBAction func purpleMoodDay(_ sender: Any) {
        openPopUp()
    }
    @IBAction func greenMoodDay(_ sender: Any) {
        openPopUp()
    }
    @IBAction func pinkMoodDay(_ sender: Any) {
        openPopUp()
    }
    @IBAction func yellowMoodDay(_ sender: Any) {
        openPopUp()
    }
    
    func openPopUp(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "DailyMoodPopUp") as? PopUpDailyMoodViewController
        
        present(vc!, animated: true)
    }
}


