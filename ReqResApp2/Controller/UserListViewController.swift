//
//  UserListViewController.swift
//  ReqResApp2
//
//  Created by Даниил Сивожелезов on 01.07.2024.
//

import UIKit

class UserListViewController: UITableViewController {

    private var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.rowHeight = 80
    }
    
    private func setupUI() {
        view.backgroundColor = .white
    }
}

// MARK: - UITableViewDataSource
//extension UserListViewController {
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return users.count
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
//        
//        cell.configure(with: users[indexPath.row])
//        return cell
//    }
//    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let user = users[indexPath.row]
//            deleteUser(id: user.id, at: indexPath)
//        }
//    }
//}
