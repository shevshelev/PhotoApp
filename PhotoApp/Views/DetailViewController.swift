//
//  DetailViewController.swift
//  PhotoApp
//
//  Created by Shevshelev Lev on 29.04.2022.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    var detailsViewModel: DetailViewModelProtocol! {
        didSet {
            setupUI()
        }
    }
    
    private lazy var scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var favoriteButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemRed
        button.addTarget(detailsViewModel, action: Selector(("setFavouriteStatus")), for: .touchUpInside)
        return button
    }()
    
    private lazy var labelStackView: UIStackView = createStackView(.vertical)
    private lazy var textViewStack: UIStackView = createStackView(.vertical)
    private lazy var horizontalStack: UIStackView = createStackView(.horizontal)
    
    private lazy var descriptionLabel: UILabel = createLabel(with: "Description:")
    private lazy var descriptionValueLabel: UITextView = createTextView()
    private lazy var userLabel: UILabel = createLabel(with: "User:")
    private lazy var userNameLabel: UILabel = createLabel(with: nil)
    private lazy var rawLabel: UILabel = createLabel(with: "RAW")
    private lazy var rawTextView: UITextView = createTextView()
    private lazy var fullLabel: UILabel = createLabel(with: "Full")
    private lazy var fullTextView: UITextView = createTextView()
    private lazy var regularLabel: UILabel = createLabel(with: "Regular")
    private lazy var regularTextView: UITextView = createTextView()
    private lazy var smallLabel: UILabel = createLabel(with: "Small")
    private lazy var smallTextView: UITextView = createTextView()
    private lazy var thumbLabel: UILabel = createLabel(with: "Thumb")
    private lazy var thumbTextView: UITextView = createTextView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Details"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: detailsViewModel.aspectRatio),
            
            favoriteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            favoriteButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8),
            
            horizontalStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            horizontalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            horizontalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            horizontalStack.heightAnchor.constraint(equalToConstant: 500),
            horizontalStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private func setupUI() {
        guard let imageURL = URL(string:detailsViewModel.urls["regular"] ?? "") else {return}
        imageView.sd_setImage(with: imageURL)
        descriptionValueLabel.text = detailsViewModel.description
        userNameLabel.text = detailsViewModel.userName
        rawTextView.text = detailsViewModel.urls["raw"]
        fullTextView.text = detailsViewModel.urls["full"]
        regularTextView.text = detailsViewModel.urls["regular"]
        smallTextView.text = detailsViewModel.urls["small"]
        thumbTextView.text = detailsViewModel.urls["thumb"]
        detailsViewModel.isFavourite.bind { [unowned self] value in
            self.setupFavouriteButtonImage(with: value)
        }
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
        addSubviews([imageView, favoriteButton, horizontalStack])
        view.addSubview(scrollView)
    }
    
    private func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { scrollView.addSubview($0) }
    }
    
    private func setupStackViews(_ subviews: [UIView], _ stack: UIStackView) {
        subviews.forEach { stack.addArrangedSubview($0) }
    }
    
    private func createLabel(with text: String?) -> UILabel {
        let label = UILabel()
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    private func createTextView() -> UITextView {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isSelectable = true
        textView.dataDetectorTypes = .link
        return textView
    }
    
    private func createStackView(_ axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stackView = UIStackView()
         stackView.axis = axis
         stackView.distribution = .fillEqually
         stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.spacing = 0
         return stackView
    }
    private func setupFavouriteButtonImage(with status: Bool) {
        favoriteButton.setImage(
            UIImage(systemName: status ? "heart.fill" : "heart"),
            for: .normal)
    }
//    private func favouriteButtonPressed() {
//        detailsViewModel.setFavouriteStatus()
//    }
}

// MARK: - UIScrollViewDelegate

extension DetailViewController: UIScrollViewDelegate {
    
}
