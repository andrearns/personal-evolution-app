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
        
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(swipeDownToReload), for: .valueChanged)
        self.habitsTableView.refreshControl = control
        
        self.addHabitButton.layer.cornerRadius = 5
        
        self.habitsTableView.dataSource = self
        self.habitsTableView.delegate = self
        
        self.fetchHabits()
    }
    
    @objc func swipeDownToReload() {
        self.habitsTableView.refreshControl?.beginRefreshing()
        self.fetchHabits()
        self.habitsTableView.refreshControl?.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CreateNewHabitViewController {
            vc.onSave = {
                self.fetchHabits()
                self.habitsTableView.reloadData()
            }
        }
    }
    
    func fetchHabits() {
        CloudKitHelper.fetchHabits { (result) in
            switch result {
            case .success(let newItem):
                self.habitsList.append(newItem)
                print(newItem)
                print("Successfully fetched item")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        self.habitsTableView.reloadData()
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
        navigationController?.present(vc, animated: true)
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
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

