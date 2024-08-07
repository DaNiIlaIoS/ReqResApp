//
//  NewUserViewController.swift
//  ReqResApp2
//
//  Created by Даниил Сивожелезов on 01.07.2024.
//

import UIKit
import SnapKit

final class NewUserViewController: UIViewController {
    // MARK: - GUI Variables
    private lazy var firstNameTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Your first name"
        field.delegate = self
        field.autocorrectionType = .no
        return field
    }()
    
    private lazy var lastNameTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Your last name"
        field.delegate = self
        field.autocorrectionType = .no
        return field
    }()
    
    private lazy var emailTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Your email"
        field.delegate = self
        field.autocorrectionType = .no
        return field
    }()
    
    // MARK: - Properties
    private let edgeInsets = 32
    private let networkManager = NetworkManager.shared
    var delegate: NewUserViewControllerDelegate?
    
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
        
        view.addSubview(firstNameTextField)
        view.addSubview(emailTextField)
        view.addSubview(lastNameTextField)
        setupConstraints()
    }
    
    private func setupConstraints() {
        firstNameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(edgeInsets)
            make.leading.trailing.equalToSuperview().inset(edgeInsets)
        }
        
        lastNameTextField.snp.makeConstraints { make in
            make.top.equalTo(firstNameTextField.snp.bottom).offset(edgeInsets)
            make.leading.trailing.equalToSuperview().inset(edgeInsets)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(lastNameTextField.snp.bottom).offset(edgeInsets)
            make.leading.trailing.equalToSuperview().inset(edgeInsets)
        }
    }
    
    @objc private func doneButtonAction() {
        let user = User(id: 0,
                             email: emailTextField.text ?? "",
                             firstName: firstNameTextField.text ?? "",
                             lastName: lastNameTextField.text ?? "")
        delegate?.createUser(user: user)
        dismiss(animated: true)
    }
    
    @objc private func cancelButtonAction() {
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension NewUserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if firstNameTextField.isFirstResponder {
            lastNameTextField.becomeFirstResponder()
        } else if lastNameTextField.isFirstResponder {
            emailTextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        
        return true
    }
}
