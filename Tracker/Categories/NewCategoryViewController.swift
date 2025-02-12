//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Anastasiia on 11.02.2025.
//

import UIKit

protocol NewCategoryViewControllerDelegate: AnyObject {
    func createCategory(name: String)
}

final class NewCategoryViewController: UIViewController {
    
    // MARK: - Public Properties
    weak var delegate: NewCategoryViewControllerDelegate?
    
    // MARK: - Private Properties
    private lazy var nameField: UITextField = {
        let textField = CustomTextField(padding: GenericEventConstants.nameFieldPadding)
        textField.backgroundColor = .ypLightGray
        textField.layer.cornerRadius = 16
        textField.placeholder = "Введите название категории"
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .ypBlack
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(nameFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var cautionLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение \(CategoriesConstants.nameTextLimit) символов"
        label.textColor = .ypRed
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameField, cautionLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhite, for: .normal)
        button.backgroundColor = .ypGray
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gesture.cancelsTouchesInView = false
        return gesture
    }()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setupConstraints()
    }
    
    // MARK: - Private Methods
    private func configureView() {
        view.backgroundColor = .ypWhite
        navigationItem.title = "Новая категория"
    }
    
    private func updateCreateButtonState() {
        guard let text = nameField.text else { return }
        
        let notEmpty = text.isEmpty == false &&
        text.count < GenericEventConstants.nameTextLimit
        
        addButton.backgroundColor = notEmpty ? .ypBlack : .ypGray
        addButton.isEnabled = notEmpty
    }
    
    private func setupConstraints() {
        [addButton,
         nameFieldStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        view.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            nameFieldStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameFieldStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameFieldStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameField.heightAnchor.constraint(equalToConstant: CategoriesConstants.nameFieldHeight),
            
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func nameFieldDidChange() {
        updateCreateButtonState()
    }
    
    @objc private func addButtonTapped() {
        guard let text = nameField.text else { return }
        delegate?.createCategory(name: text)
        navigationController?.dismiss(animated: true)
    }
    
    @objc private func hideKeyboard() {
        view?.endEditing(true)
    }
}

extension NewCategoryViewController: UITextFieldDelegate {
    // механика показа нотификации при превышении лимита символов в текстовом поле
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let currentText = textField.text ?? ""
        
        // Вычисляем количество символов после изменения
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        let moreThanLimit = updatedText.count > GenericEventConstants.nameTextLimit
        cautionLabel.isHidden = !moreThanLimit
        return !moreThanLimit
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
