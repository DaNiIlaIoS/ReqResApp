//
//  UserListViewController.swift
//  ReqResApp2
//
//  Created by Даниил Сивожелезов on 01.07.2024.
//

import UIKit

protocol NewUserViewControllerDelegate {
    func createUser(controller: NewUserViewController, user: User)
}

class UserListViewController: UITableViewController {
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
       let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    
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
        view.addSubview(activityIndicator)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonAction))
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc private func addButtonAction() {
        let newUserViewController = NewUserViewController()
        newUserViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: newUserViewController)
        present(navigationController, animated: true)
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let user = users[indexPath.row]
            deleteUser(id: user.id, at: indexPath)
        }
    }
}

// MARK: - UITableViewDelegate
extension UserListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let userViewController = UserViewController()
        userViewController.configure(with: user)
        navigationController?.pushViewController(userViewController, animated: true)
    }
}

// MARK: - Networking
extension UserListViewController {
    private func fetchUsers() {
        networkManager.fetchUsers { [weak self] result in
            self?.activityIndicator.stopAnimating()
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
    
    func post(user: User) {
        networkManager.postUser(user) { [weak self] result in
            switch result {
            case .success(let postUserQuery):
                print("User (\(postUserQuery.name) with email \(postUserQuery.email)) created")
                self?.users.append(User(postUserQuery: postUserQuery))
                self?.tableView.reloadData()
            case .failure(let error):
                print("Error in post user: \(error)")
            }
        }
    }
    
    func deleteUser(id: Int, at indexPath: IndexPath) {
        Task {
            if try await networkManager.deleteUserWithId(id: id) {
                print("User with id: \(id) was deleted")
                users.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                showAlert(with: .deletingError)
            }
        }
    }
}

// MARK: -
extension UserListViewController: NewUserViewControllerDelegate {
    func createUser(controller: NewUserViewController, user: User) {
        post(user: user)
    }
}
