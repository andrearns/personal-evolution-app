//
//  UsersParticipatingListViewController.swift
//  PersonalEvolution
//
//  Created by André Arns on 15/09/21.
//

import UIKit

class UsersParticipatingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var usersList: [User]!
    
    @IBOutlet var usersParticipatingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usersParticipatingTableView.delegate = self
        usersParticipatingTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = usersParticipatingTableView.dequeueReusableCell(withIdentifier: "usersParticipatingCell") as? UsersParticipatingTableViewCell
        cell?.setup(user: usersList[indexPath.row])
        return cell!
    }
    
}
