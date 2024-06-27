//
//  UsersListTableViewController.swift
//  ReqResApp
//
//  Created by Даниил Сивожелезов on 25.06.2024.
//

import UIKit
import SnapKit

protocol NewUserViewControllerDelegate {
    func createUser(controller: NewUserViewController, user: UserModel)
}

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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonAction))
        
        view.addSubview(activityIndicator)
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
        present(navigationController, animated: true, completion: nil)
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
    
    private func post(user: UserModel) {
        networkManager.postUser(user) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let postUserQuery):
                    print("\(postUserQuery) created")
                    self?.users.append(UserModel(postUserQuery: postUserQuery))
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Error in post user: \(error)")
                }
            }
        }
    }
    
    private func deleteUser(id: Int, at indexPath: IndexPath) {
        Task {
            if try await networkManager.deleteUserWithId(id: id) {
                print("User with id \(id) was deleted")
                users.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                showAlert(with: .deletingError)
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
extension UsersListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        let userViewController = UserViewController()
        userViewController.configure(with: user)
        
        navigationController?.pushViewController(userViewController, animated: true)
    }
}

// MARK: - NewUserViewControllerDelegate
extension UsersListTableViewController: NewUserViewControllerDelegate {
    func createUser(controller: NewUserViewController, user: UserModel) {
        post(user: user)
    }
}
