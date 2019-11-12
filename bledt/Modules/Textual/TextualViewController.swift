//
// File:      TextualViewController
// Module:    Textual
// Package:   bledt
//
// Author:    Roderic Linguri <rlinguri@mac.com>
// Copyright: © 2019 Roderic Linguri. All Rights Reserved.
// License:   MIT
//
// Requires:  > Swift 5.0 && > iOS 12.0
// Version:   0.2.3
// Since:     0.1.2
//

/// The first view's controller
class TextualViewController: UIViewController {
    
    // MARK: - Instance Properties
    
    /// Handles data to be displayed by the view
    let presenter: TextualPresenter
    
    /// The bar button to transition to the graph
    var graphButton: UIBarButtonItem!
    
    // MARK: - Subviews
    
    /// The spinner to animate when loading
    var activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            spinner.style = .large
        } else {
            spinner.style = .whiteLarge
        }
        spinner.color = .systemBlue
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    /// The view that contains the text to display
    let textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isEditable = false
        view.font = UIFont(name: "Menlo-Regular", size: 14.0)
        view.textAlignment = .center
        return view
    }()

    // MARK: - Actions
    
    /// Action for the Graph bar button
    @objc func didTouchGraph() {
        self.presenter.interactor.router.rootRouter.showGraph()
    }
    
    // MARK: - Instance Methods
    
    /// Initialize the `TextualViewController` instance
    ///
    /// - Parameter presenter: Handles data to be displayed by the view
    init(presenter: TextualPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.delegate = self
    }
    
    /// Required initializer (not implemented)
    ///
    /// - Parameter coder: an `NSCoder` instance
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configure and add subviews
    private func setupSubviews() {
        
        self.graphButton = UIBarButtonItem(image: UIImage(named: "graph"), style: .plain, target: self, action: #selector(TextualViewController.didTouchGraph))
        self.navigationItem.rightBarButtonItem = self.graphButton
        
        self.view.addSubview(self.textView)
        self.view.addSubview(self.activityIndicator)
    }
    
    /// Set and activate autolayout constraints
    private func setupConstraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.textView.leadingAnchor.constraint(
            equalTo: safeArea.leadingAnchor,
            constant: 24.0
        ).isActive = true
        
        self.textView.trailingAnchor.constraint(
            equalTo: safeArea.trailingAnchor,
            constant: -24.0
        ).isActive = true
        
        self.textView.topAnchor.constraint(
            equalTo: safeArea.topAnchor,
            constant: 24.0
        ).isActive = true
        
        self.textView.bottomAnchor.constraint(
            equalTo: safeArea.bottomAnchor,
            constant: -24.0
        ).isActive = true

        self.activityIndicator.centerYAnchor.constraint(
            equalTo: self.view.centerYAnchor
        ).isActive = true
        
        self.activityIndicator.centerXAnchor.constraint(
            equalTo: self.view.centerXAnchor
        ).isActive = true
    }
    
    /// Reload data from preseneter
    private func updateSubviews() {
        if self.presenter.isLoading {
            self.activityIndicator.startAnimating()
            self.textView.text = nil
        } else {
            self.activityIndicator.stopAnimating()
            self.textView.text = self.presenter.text
        }
    }
    
    /// Set colors to dynamic system colors
    func updateTraitCollection() {
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = .systemBackground
            self.textView.backgroundColor = .systemGray6
            self.textView.textColor = .systemGray
        } else {
            self.view.backgroundColor = .white
            self.textView.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
            self.textView.textColor = .lightGray
        }
    }
    
    /// Called when the iOS interface environment changes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.updateTraitCollection()
    }

    // MARK: - UIViewController Overrides
    
    /// Called after the controller's view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        self.setupSubviews()
        self.setupConstraints()
        self.updateSubviews()
        self.updateTraitCollection()
        self.presenter.interactor.dataManager.fetch()
    }
    
}

/// TextualPresenterDelegate
extension TextualViewController: TextualPresenterDelegate {
    
    /// Called when the presenter's data or state have changed
    func presenterDidUpdate() {
        self.updateSubviews()
    }
    
}
