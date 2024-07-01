//
//  UserListViewController.swift
//  ReqResApp2
//
//  Created by Даниил Сивожелезов on 01.07.2024.
//

import UIKit

class UserListViewController: UITableViewController {
    
    private let networkManager = NetworkManager.shared
    private var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
        
        setupUI()
        fetchUsers()
    }
    
    private func setupUI() {
        title = "Users"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonAction))
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
    }
    
    @objc private func addButtonAction() {
        
    }
    
    private func showAlert(with error: NetworkError) {
        let alert = UIAlertController(title: error.title, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension UserListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: users[indexPath.row])
        return cell
    }
//    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let user = users[indexPath.row]
//            deleteUser(id: user.id, at: indexPath)
//        }
//    }
}

// MARK: - Networking
extension UserListViewController {
    private func fetchUsers() {
        networkManager.fetchUsers { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
                self?.tableView.reloadData()
            case .failure(let error):
                print("Error in fetch users: \(error)")
                self?.showAlert(with: error)
            }
        }
    }
}
