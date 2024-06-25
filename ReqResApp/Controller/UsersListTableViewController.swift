//
//  UsersListTableViewController.swift
//  ReqResApp
//
//  Created by Даниил Сивожелезов on 25.06.2024.
//

import UIKit

class UsersListTableViewController: UITableViewController {

    private let networkManager = NetworkManager.shared
    private var users = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Title"
        view.backgroundColor = .white
        
        tableView.rowHeight = 80
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
        
        fetchUsers()
    }
}

// MARK: Networking
extension UsersListTableViewController {
    private func fetchUsers() {
//        users = [UserModel.example]
        networkManager.fetchUsers { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
                self?.tableView.reloadData()
            case .failure(let error):
                print("Error in fetchUsers: \(error.localizedDescription)")
            }
        }
        
    }
}

// MARK: - UITableViewDataSource
extension UsersListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        
        let user = users[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = "\(user.firstName) \(user.lastName)"
        content.secondaryText = user.email
        content.image = UIImage(systemName: "face.smiling")
        
        cell.contentConfiguration = content
        
        networkManager.fetchAvatar(from: user.avatar) { imageData in
            content.image = UIImage(data: imageData)
            content.imageProperties.cornerRadius = tableView.rowHeight / 2
            
            cell.contentConfiguration = content
        }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension UsersListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        let userViewController = UserViewController()
        userViewController.configure(with: user)
            
        navigationController?.pushViewController(userViewController, animated: true)
    }
}
