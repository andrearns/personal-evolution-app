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
    
    var habitsList: [String] = []
    
    private let database = CKContainer(identifier: "iCloud.PersonalEvolution").publicCloudDatabase
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(swipeDownToReload), for: .valueChanged)
        
        self.addHabitButton.layer.cornerRadius = 5
        
        self.habitsTableView.dataSource = self
        self.habitsTableView.delegate = self
        self.habitsTableView.refreshControl = control
        
        fetchHabits()
    }
    
    @objc func fetchHabits() {
        let query = CKQuery(recordType: "Habit", predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil) { records, error in
            guard let records = records, error == nil else { return }
            DispatchQueue.main.async {
                
                self.habitsList = records.compactMap({ $0.value(forKey: "Name") as? String})
                self.habitsTableView.reloadData()
                print(self.habitsList)
            }
        }
    }
    
    @objc func swipeDownToReload() {
        self.habitsTableView.refreshControl?.beginRefreshing()
        
        let query = CKQuery(recordType: "Habit", predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil) { records, error in
            guard let records = records, error == nil else { return }
            DispatchQueue.main.async {
                self.habitsList = records.compactMap({ $0.value(forKey: "Name") as? String})
                self.habitsTableView.reloadData()
                print(self.habitsList)
                self.habitsTableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CreateNewHabitViewController {
            vc.onSave = {
                self.fetchHabits()
                self.habitsTableView.reloadData()
            }
        }
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
        present(vc, animated: true, completion: nil)
    }
}

