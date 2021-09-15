//
//  HabitsViewController.swift
//  PersonalEvolution
//
//  Created by André Arns on 30/08/21.
//
import CloudKit
import UIKit

class HabitsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var habitsTableView: UITableView!
    @IBOutlet var addHabitButton: UIButton!
    
    var habitsList: [Habit] = []
    
    private let database = CKContainer(identifier: "iCloud.PersonalEvolution").publicCloudDatabase
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchHabits()
        
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(swipeDownToReload), for: .valueChanged)
        self.habitsTableView.refreshControl = control
        
        self.addHabitButton.layer.cornerRadius = 15
        self.addHabitButton.layer.shadowColor = UIColor.black.cgColor
        self.addHabitButton.layer.shadowOpacity = 0.05
        self.addHabitButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.addHabitButton.layer.shadowRadius = 20
        self.addHabitButton.layer.shadowPath = UIBezierPath(rect: addHabitButton.bounds).cgPath
        self.addHabitButton.layer.shouldRasterize = true
        
        self.habitsTableView.dataSource = self
        self.habitsTableView.delegate = self
        
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
}

