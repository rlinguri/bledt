//
// File:      GraphicViewController
// Module:    Graphic
// Package:   bledt
//
// Author:    Roderic Linguri <rlinguri@mac.com>
// Copyright: © 2019 Roderic Linguri. All Rights Reserved.
// License:   MIT
//
// Requires:  > Swift 5.0 && > iOS 12.0
// Version:   0.2.3
// Since:     0.2.0
//

/// The first view's controller
class GraphicViewController: UIViewController {
    
    // MARK: - Instance Properties
    
    /// Handles data to be displayed by the view
    let presenter: GraphicPresenter
        
    // MARK: - Subviews
    
    /// The view containing the sparkline graph
    var graphView: GraphView = {
        let view = GraphView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .redraw
        view.clipsToBounds = true
        return view
    }()
    
    /// Enable a long graph to be displayed
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = true
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    /// Anchors the graphView to the scrollView
    var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    /// A label for the x axis
    var xLegend: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Menlo-Regular", size: 12.0)
        label.text = "milliseconds"
        return label
    }()
    
    /// A label for the y axis
    var yLegend: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        label.font = UIFont(name: "Menlo-Regular", size: 12.0)
        label.text = "samples in batch"
        return label
    }()
    
    /// Reference to the graph width constraint, so we can update it
    var graphWidth: NSLayoutConstraint!
    
    /// Reference to the content width constraint, so we can update it
    var contentWidth: NSLayoutConstraint!
    
    // MARK: - Actions
    
    // MARK: - Instance Methods
    
    /// Initialize the `GraphicViewController` instance
    ///
    /// - Parameter presenter: Handles data to be displayed by the view
    init(presenter: GraphicPresenter) {
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
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.view.addSubview(self.scrollView)

        self.scrollView.leadingAnchor.constraint(
            equalTo: safeArea.leadingAnchor,
            constant: 24.0
        ).isActive = true
        
        self.scrollView.trailingAnchor.constraint(
            equalTo: safeArea.trailingAnchor,
            constant: -24.0
        ).isActive = true
        
        self.scrollView.topAnchor.constraint(
            equalTo: safeArea.topAnchor,
            constant: 24.0
        ).isActive = true
        
        self.scrollView.bottomAnchor.constraint(
            equalTo: safeArea.bottomAnchor,
            constant: -24.0
        ).isActive = true

        self.scrollView.addSubview(self.contentView)

        self.contentView.leadingAnchor.constraint(
            equalTo: self.scrollView.leadingAnchor
        ).isActive = true

        self.contentView.trailingAnchor.constraint(
            equalTo: self.scrollView.trailingAnchor
        ).isActive = true

        self.contentView.topAnchor.constraint(
            equalTo: self.scrollView.topAnchor
        ).isActive = true

        self.contentView.bottomAnchor.constraint(
            equalTo: self.scrollView.bottomAnchor
        ).isActive = true

        self.contentView.heightAnchor.constraint(
            equalTo: safeArea.heightAnchor, constant: -48
        ).isActive = true
        
        self.contentWidth = self.contentView.widthAnchor.constraint(
            equalToConstant: self.presenter.graphwidth
        )
        self.contentWidth.isActive = true
        
        self.contentView.addSubview(self.graphView)
        
        self.graphWidth = self.graphView.widthAnchor.constraint(
            equalToConstant: self.presenter.graphwidth
        )
        self.graphWidth.isActive = true
        
        self.graphView.heightAnchor.constraint(
            equalTo: self.view.heightAnchor
        ).isActive = true
        
        self.view.addSubview(self.xLegend)
        self.view.addSubview(self.yLegend)
        
        self.yLegend.centerYAnchor.constraint(
            equalTo: safeArea.centerYAnchor
        ).isActive = true
        
        self.yLegend.leftAnchor.constraint(
            equalTo: safeArea.leftAnchor,
            constant: -44
        ).isActive = true

        self.xLegend.centerXAnchor.constraint(
            equalTo: safeArea.centerXAnchor
        ).isActive = true
        
        self.xLegend.bottomAnchor.constraint(
            equalTo: safeArea.bottomAnchor,
            constant: -8.0
        ).isActive = true
    }
    
    /// Make sure we have some background for the legends
    func assureMinimumWidth() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            let minWidth = self.scrollView.bounds.width
            if self.presenter.graphwidth < minWidth {
                self.presenter.graphwidth = minWidth
                self.contentWidth.constant = minWidth
                self.graphWidth.constant = minWidth
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    /// Set colors to dynamic system colors
    func updateTraitCollection() {
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = .systemBackground
            self.graphView.backgroundColor = .systemGray6
            self.xLegend.textColor = .systemGray
            self.yLegend.textColor = .systemGray
        } else {
            self.view.backgroundColor = .white
            self.graphView.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
            self.xLegend.textColor = .lightGray
            self.yLegend.textColor = .lightGray
        }
        self.assureMinimumWidth()
        self.graphView.setNeedsDisplay()
        self.graphView.setNeedsLayout()
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
        self.view.autoresizesSubviews = true
        self.setupSubviews()
        self.updateTraitCollection()
        self.presenter.interactor.dataManager.retrieve()
    }
        
}

/// GraphicPresenterDelegate
extension GraphicViewController: GraphicPresenterDelegate {
    
    /// Called when the presenter's data or state have changed
    func presenterDidUpdate() {
        self.graphView.model.coordinates = self.presenter.coordinates
        self.contentWidth.constant = self.presenter.graphwidth
        self.graphWidth.constant = self.presenter.graphwidth
        self.graphView.setNeedsLayout()
        self.graphView.setNeedsDisplay()
    }
    
}
