//
//  UsersListTableViewController.swift
//  ReqResApp
//
//  Created by Даниил Сивожелезов on 25.06.2024.
//

import UIKit
import SnapKit

class UsersListTableViewController: UITableViewController {

    // MARK: - GUI Variables
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Properties
    private let networkManager = NetworkManager.shared
    private var users = [UserModel]()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.rowHeight = 80
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
        
        setupUI()
        fetchUsers()
    }
    
    // MARK: - Methods
    private func showAlert(with error: NetworkError) {
        let alert = UIAlertController(title: error.title, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func setupUI() {
        title = "Title"
        view.backgroundColor = .white
        
        view.addSubview(activityIndicator)
        setupConstraints()
    }
    
    private func setupConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: Networking
extension UsersListTableViewController {
    private func fetchUsers() {
//        users = [UserModel.example]
        networkManager.fetchUsers { [weak self] result in
            self?.activityIndicator.stopAnimating()
            switch result {
            case .success(let users):
                self?.users = users
                self?.tableView.reloadData()
            case .failure(let error):
                print("Error in fetchUsers: \(error)")
                self?.showAlert(with: error)
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
        
        cell.configure(with: users[indexPath.row])
//        let user = users[indexPath.row]
//        
//        var content = cell.defaultContentConfiguration()
//        content.text = "\(user.firstName) \(user.lastName)"
//        content.secondaryText = user.email
//        content.image = UIImage(systemName: "face.smiling")
//        
//        cell.contentConfiguration = content
//        
//        networkManager.fetchAvatar(from: user.avatar) { imageData in
//            content.image = UIImage(data: imageData)
//            content.imageProperties.cornerRadius = tableView.rowHeight / 2
//            
//            cell.contentConfiguration = content
//        }

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
