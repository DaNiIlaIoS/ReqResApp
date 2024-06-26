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
    private lazy var firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "First name"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Last name"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    // MARK: - Properties
    private let edgeInsets = 32
    
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
    }
    
    @objc private func doneButtonAction() {
        
        dismiss(animated: true)
    }
    
    @objc private func cancelButtonAction() {
        dismiss(animated: true)
    }
}
