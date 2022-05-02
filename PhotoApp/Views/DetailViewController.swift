//
//  DetailViewController.swift
//  PhotoApp
//
//  Created by Shevshelev Lev on 29.04.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    var detailsViewModel: DetailViewModelProtocol! {
        didSet {
            setupUI()
        }
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var labelStackView: UIStackView = createStackView(.vertical)
    private lazy var textViewStack: UIStackView = createStackView(.vertical)
    private lazy var horizontalStack: UIStackView = createStackView(.horizontal)
    
    private lazy var descriptionLabel: UILabel = createLabel(with: "Description:")
    private lazy var descriptionValueLabel: UILabel = createLabel(with: nil)
    private lazy var userLabel: UILabel = createLabel(with: "User:")
    private lazy var userNameLabel: UILabel = createLabel(with: nil)
    private lazy var rawLabel: UILabel = createLabel(with: "RAW")
    private lazy var rawTextView: UITextView = createTextView(.URL)
    private lazy var fullLabel: UILabel = createLabel(with: "Full")
    private lazy var fullTextView: UITextView = createTextView(.URL)
    private lazy var regularLabel: UILabel = createLabel(with: "Regular")
    private lazy var regularTextView: UITextView = createTextView(.URL)
    private lazy var smallLabel: UILabel = createLabel(with: "Small")
    private lazy var smallTextView: UITextView = createTextView(.URL)
    private lazy var thumbLabel: UILabel = createLabel(with: "Thumb")
    private lazy var thumbTextView: UITextView = createTextView(.URL)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Details \(detailsViewModel.userName)"
        print(detailsViewModel.urls["raw"]!)
//        setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            horizontalStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            horizontalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            horizontalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            horizontalStack.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupUI() {
        setupStackViews(
            [
                descriptionLabel, userLabel, rawLabel, fullLabel,
                regularLabel, smallLabel, thumbLabel
            ],
            labelStackView
        )
        setupStackViews(
            [
                descriptionValueLabel, userNameLabel, rawTextView,
                fullTextView, regularTextView, smallTextView, thumbTextView
            ],
            textViewStack
        )
        setupStackViews([labelStackView, textViewStack], horizontalStack)
        addSubviews([imageView, horizontalStack])
    }
    
    private func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { view.addSubview($0) }
    }
    
    private func setupStackViews(_ subviews: [UIView], _ stack: UIStackView) {
        subviews.forEach { stack.addSubview($0) }
    }
    
    private func createLabel(with text: String?) -> UILabel {
        let label = UILabel()
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    private func createTextView(_ type: UITextContentType) -> UITextView {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.textContentType = type
        return textView
    }
    
    private func createStackView(_ axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stackView = UIStackView()
         stackView.axis = axis
         stackView.distribution = .fillEqually
         stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.spacing = 10
         return stackView
    }
}
