//
//  UserTableViewCell.swift
//  ReqResApp
//
//  Created by Даниил Сивожелезов on 25.06.2024.
//

import UIKit
import SnapKit
import Kingfisher

final class UserTableViewCell: UITableViewCell {
    // MARK: - GUI Variables
    private lazy var avatarImage: UIImageView = {

        let view = UIImageView()
        view.layer.cornerRadius = 36
        view.clipsToBounds = true
       let view = UIImageView()

        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "email@gmail.com"
        return label
    }()
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func configure(with user: UserModel) {
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        emailLabel.text = user.email
        
        avatarImage.kf.setImage(with: user.avatar)
    }
    
    private func setupUI() {
        addSubview(avatarImage)
        addSubview(nameLabel)
        addSubview(emailLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        avatarImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview().inset(4)
            make.width.height.equalTo(72)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.trailing.equalToSuperview()
            make.leading.equalTo(avatarImage.snp.trailing).offset(8)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.equalTo(avatarImage.snp.trailing).offset(8)
        }
    }
}
