//
//  NewUserViewController.swift
//  ReqResApp
//
//  Created by Даниил Сивожелезов on 26.06.2024.
//

import UIKit
import SnapKit

final class NewUserViewController: UIViewController {
    // MARK: - GUI Variables
    private lazy var fullNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Your full name"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Your email"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    // MARK: - Properties
    private let edgeInsets = 32
    private let networkManager = NetworkManager.shared
    private var delegate: NewUserViewControllerDelegate?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    // MARK: - Methods
    private func setupUI() {
        title = "New User"
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonAction))
        
        view.addSubview(fullNameTextField)
        view.addSubview(emailTextField)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        fullNameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(edgeInsets)
            make.leading.trailing.equalToSuperview().inset(edgeInsets)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(fullNameTextField.snp.bottom).offset(edgeInsets)
            make.leading.trailing.equalToSuperview().inset(edgeInsets)
        }
    }
    
    @objc private func doneButtonAction() {
        let user = UserModel(id: 0,
                             email: emailTextField.text ?? "",
                             firstName: fullNameTextField.text ?? "",
                             lastName: "")
        post(user: user)
        dismiss(animated: true)
    }
    
    @objc private func cancelButtonAction() {
        dismiss(animated: true)
    }
}

// MARK: - Networking
extension NewUserViewController {
    private func post(user: UserModel) {
        networkManager.postUser(user) { [weak self] result in
            switch result {
            case .success(let postUserQuery):
                print("\(postUserQuery) created")
                self?.delegate?.createUser(user: UserModel(postUserQuery: postUserQuery))
            case .failure(let error):
                print("Error in post user: \(error)")
            }
        }
    }
}
