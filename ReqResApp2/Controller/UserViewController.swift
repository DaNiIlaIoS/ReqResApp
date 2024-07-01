//
//  UserViewController.swift
//  ReqResApp2
//
//  Created by Даниил Сивожелезов on 01.07.2024.
//

import UIKit
import SnapKit

final class UserViewController: UIViewController {
    // MARK: - GUI Variables
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "email@gmail.com"
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Properties
    private var user: User?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Methods
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        setupConstraints()
        
        guard let user = user else { return }
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        emailLabel.text = user.email
        
        imageView.kf.setImage(with: user.avatar)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.snp.width)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(imageView.snp.bottom).offset(32)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
        }
    }
    
    func configure(with user: User) {
        self.user = user
    }
}
