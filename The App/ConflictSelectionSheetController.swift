//
//  ActionSheetViewController.swift
//  The App
//
//  Created by Hugo Prinsloo on 2017/01/24.
//  Copyright © 2017 Hugo Prinsloo. All rights reserved.
//

import UIKit

class ConflictSelectionSheetController: UIViewController {

    private struct Configuration {
        static let defaultCornerRadius: CGFloat = 10
    }
    
    public struct Action {
        let title: String
        let subtitle: String
        let image: UIImage?
        
        public init(title: String, subtitle: String, image: UIImage?) {
            self.title = title
            self.subtitle = subtitle
            self.image = image
        }
    }
    
    public var completionWithSelectedIndicesHandler: ((_ selectedIndices: [Int]) -> Void)? = nil
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var backgroundView: UIView!
    @IBOutlet fileprivate weak var dismissButton: UIButton!
    @IBOutlet fileprivate weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var stackView: UIStackView!
    @IBOutlet fileprivate weak var headerTitleLabel: UILabel!
    @IBOutlet fileprivate weak var headerMessageLabel: UILabel!
    
    fileprivate var actions: [Action] = []
    
    public class func create(title: String, message: String, actions: [Action]) -> ConflictSelectionSheetController {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let vc = main.instantiateViewController(withIdentifier: "ConflictSelectionSheetController") as! ConflictSelectionSheetController
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = vc
        vc.actions = actions
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView = blurView
        setupLayout()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ConflictSelectionSheetController.dismissController))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViewHeightConstraint.constant = tableView.contentSize.height
        
        // This enables scroll only when the content exceeds the view's frame height
        if tableView.contentSize.height <= tableView.frame.height {
            tableView.isScrollEnabled = false
        } else {
            tableView.isScrollEnabled = true
        }
    }
    
    @objc fileprivate func dismissController() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction fileprivate func handleDoneButtonTapped(_ sender: UIButton) {
        let items = tableView.indexPathsForSelectedRows?.map { $0.row } ?? []
        self.completionWithSelectedIndicesHandler?(items)
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupLayout() {
        dismissButton.layer.cornerRadius = Configuration.defaultCornerRadius
        dismissButton.clipsToBounds = true
        
        tableView.layer.cornerRadius = Configuration.defaultCornerRadius
        tableView.clipsToBounds = true
    }
}

extension ConflictSelectionSheetController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let vc = DimPresentationController(presentedViewController: presented, presenting: presenting)
        return vc
    }
}

// TableView Data
extension ConflictSelectionSheetController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ProjectCell
        cell.backgroundColor = UIColor.clear
        cell.projectImageView.image = actions[indexPath.row].image
        cell.titleLabel.text = actions[indexPath.row].title
        cell.messageLabel.text = actions[indexPath.row].subtitle
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateCount()
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        updateCount()
    }
    
    private func updateCount() {
        if let list = tableView.indexPathsForSelectedRows {
            if list.count == self.actions.count {
                let localString = NSLocalizedString("Keep all", comment: "Keep all items")
                self.dismissButton.setTitle(localString, for: .normal)
            } else {
                let format = NSLocalizedString("Keep %d", comment: "Keep {number-of-items}")
                let title = String.localizedStringWithFormat(format, list.count)
                self.dismissButton.setTitle(title, for: .normal)
            }
        } else {
            let localString = NSLocalizedString("Cancel", comment: "Cancel process")
            self.dismissButton.setTitle(localString, for: .normal)
        }
    }
}

class DimPresentationController: UIPresentationController {
    var dimView: UIView?
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        presentingViewController.view.tintAdjustmentMode = .dimmed
        guard let container = containerView else { return }
        let dimView = UIView(frame: container.bounds)
        dimView.backgroundColor = UIColor.black
        dimView.alpha = 0.0
        dimView.translatesAutoresizingMaskIntoConstraints = true
        dimView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView?.addSubview(dimView)
        containerView?.sendSubview(toBack: dimView)
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { (_ context: UIViewControllerTransitionCoordinatorContext) -> Void in
            dimView.alpha = 0.5
        }, completion: { (_ context: UIViewControllerTransitionCoordinatorContext) -> Void in
            self.dimView = dimView
        })
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        presentingViewController.view.tintAdjustmentMode = .automatic
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { (_ context: UIViewControllerTransitionCoordinatorContext) -> Void in
            self.dimView?.alpha = 0.0
        }, completion: { (_ context: UIViewControllerTransitionCoordinatorContext) -> Void in
            self.dimView?.removeFromSuperview()
            self.dimView = nil
        })
    }
}

class ProjectCell: UITableViewCell {
    
    private struct Configuration {
        static let selectorRadius: CGFloat = 10
        static let selectorBorderWidth: CGFloat = 1
        static let selectorBorderColor = UIColor.gray.cgColor
        static let imageCornerRadius: CGFloat = 4
    }
    
    @IBOutlet fileprivate weak var selectionImageView: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var messageLabel: UILabel!
    @IBOutlet fileprivate weak var projectImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        projectImageView.layer.cornerRadius = Configuration.imageCornerRadius
        projectImageView.clipsToBounds = true
        
        selectionImageView.layer.cornerRadius = Configuration.selectorRadius
        selectionImageView.clipsToBounds = true
        selectionImageView.layer.borderColor = Configuration.selectorBorderColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            selectionImageView.image = #imageLiteral(resourceName: "Checkmark-Icon")
            selectionImageView.layer.borderWidth = 0
        } else {
            selectionImageView.image = nil
            selectionImageView.layer.borderWidth = Configuration.selectorBorderWidth
        }
    }

}
