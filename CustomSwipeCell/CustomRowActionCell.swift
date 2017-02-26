//
//  CustomRowActionCell.swift
//  CustomSwipeCell
//
//  Created by Atuooo on 26/02/2017.
//  Copyright © 2017 xyz. All rights reserved.
//

import UIKit

enum CellSwipeState: Int {
    case normal
    case showingRight
    case showingLeft
}

private let cellHeight: CGFloat = 60
private let kScreenWidth = UIScreen.main.bounds.width
private let actionButtonWidth: CGFloat = 80

private let minSwipeScale: CGFloat = 0.4

private let leftActionViewWidth = actionButtonWidth * 2
private let rightActionViewOriginX = kScreenWidth + leftActionViewWidth

private let originalOffset = CGPoint(x: leftActionViewWidth, y: 0)
private let toShowLeftOffset  = CGPoint.zero
private let toShowRightOffset = CGPoint(x: actionButtonWidth * 3, y: 0)

class CustomRowActionCell: UITableViewCell {
    
    static var isSwiping: Bool = false
    
    var rowAction: (() -> Void)?
    
    fileprivate var state: CellSwipeState = .normal {
        didSet {
            CustomRowActionCell.isSwiping = state != .normal
        }
    }
    
    fileprivate var panGesture: UIPanGestureRecognizer!
    fileprivate var tapGesture: UITapGestureRecognizer!
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: cellHeight)
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    fileprivate lazy var cellContentView: UIView = {
        let view = UIView(frame: CGRect(x: actionButtonWidth * 2, y: 0.0, width: kScreenWidth, height: cellHeight))
        view.backgroundColor = .white
        return view
    }()
    
    fileprivate lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: cellHeight))
        view.contentSize = CGSize(width: kScreenWidth + actionButtonWidth * 3, height: cellHeight)
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    fileprivate lazy var l1ActionButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: actionButtonWidth, height: cellHeight - 1)
        button.backgroundColor = .darkGray
        button.setTitleColor(.white, for: .normal)
        button.setTitle("l1Button", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        
        button.addTarget(self, action: #selector(CustomRowActionCell.actionButtonHandler), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var l2ActionButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: actionButtonWidth, y: 0, width: actionButtonWidth, height: cellHeight - 1)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.setTitle("l2Button", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.addTarget(self, action: #selector(CustomRowActionCell.actionButtonHandler), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var r1ActionButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: rightActionViewOriginX, y: 0, width: actionButtonWidth, height: cellHeight - 1)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.setTitle("r1Button", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.addTarget(self, action: #selector(CustomRowActionCell.actionButtonHandler), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        scrollView.addSubview(l1ActionButton)
        scrollView.addSubview(l2ActionButton)
        scrollView.addSubview(r1ActionButton)

        cellContentView.addSubview(titleLabel)
        scrollView.addSubview(cellContentView)
        contentView.addSubview(scrollView)
        
        titleLabel.text = " 👈   It's custom row action cell   👉"

        scrollView.isUserInteractionEnabled = false
        scrollView.contentOffset = originalOffset
        scrollView.delegate = self
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(CustomRowActionCell.panGestureHandler(_:)))
        panGesture.delegate = self
        contentView.addGestureRecognizer(panGesture)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomRowActionCell.tapGestureHandler(_:)))
        cellContentView.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(CustomRowActionCell.encloseRowActionView(notification:)),
                                               name: Notification.Name("encloseSwipeCell"),
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        scrollView.contentOffset = originalOffset
        scrollView.isUserInteractionEnabled = false
        isUserInteractionEnabled = true
    }
}

// MARK: - Methods

extension CustomRowActionCell {
    
    func actionViewDidAppear(state: CellSwipeState) {
        
        panGesture.isEnabled = false
        scrollView.isUserInteractionEnabled = true
        self.state = state
    }
    
    func actionViewDidDisappear() {
        
        panGesture.isEnabled = true
        scrollView.isUserInteractionEnabled = false
        state = .normal
    }
    
    func actionButtonHandler() {
        rowAction?()
    }
}

// MARK: - Notification

extension CustomRowActionCell {
    
    func encloseRowActionView(notification: Notification) {
        
        if state != .normal {
        
            DispatchQueue.main.async { [weak self] in
                self?.state = .normal
                
                UIView.animate(withDuration: 0.2, animations: {
                    self?.scrollView.setContentOffset(originalOffset, animated: false)
                }, completion: { _ in
                    self?.actionViewDidDisappear()
                })
            }
        }
    }
}

// MARK: - Gesture Handler

extension CustomRowActionCell {
    
    func panGestureHandler(_ ges: UIPanGestureRecognizer) {
        
        let offsetX = ges.translation(in: self).x
        
        switch ges.state {
            
        case .possible:
            break
            
        case .began:
            
            NotificationCenter.default.post(name: Notification.Name("encloseSwipeCell"), object: nil)
            
        case .changed:
            
            scrollView.setContentOffset(CGPoint(x: originalOffset.x - offsetX, y: 0), animated: false)
            
        case .ended:
            
            if offsetX <= 0 { // left <=
                
                if offsetX > -actionButtonWidth * 0.4 {
                    
                    scrollView.setContentOffset(originalOffset, animated: true)
                    
                } else {
                    
                    scrollView.setContentOffset(toShowRightOffset, animated: true)
                }
                
            } else { // => right
                
                if offsetX < leftActionViewWidth * 0.4 {
                    
                    scrollView.setContentOffset(originalOffset, animated: true)
                    
                } else {
                    
                    scrollView.setContentOffset(toShowLeftOffset, animated: true)
                }
            }
            
            
        case .failed, .cancelled:
            break
        }
    }
    
    func tapGestureHandler(_ ges: UITapGestureRecognizer) {
        
        if (state == .showingRight && scrollView.contentOffset == toShowRightOffset) ||
            (state == .showingLeft && scrollView.contentOffset == toShowLeftOffset) {
            
            isUserInteractionEnabled = false
            scrollView.setContentOffset(originalOffset, animated: true)
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let ges = gestureRecognizer as? UIPanGestureRecognizer,
            ges === panGesture {
            
            let gesLocation = ges.location(in: self)
            
            if gesLocation.x <= 22 {    // EdgePanGesture
                return false
                
            } else {    // table view scroll
                
                let translation = ges.translation(in: superview)
                return fabs(translation.x) > fabs(translation.y)
            }
            
        } else {
            
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
    }
}

// MARK: - Scroll View Delegate

extension CustomRowActionCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetX = scrollView.contentOffset.x
        
        switch offsetX {
            
        case -kScreenWidth ... 0:
            
            l1ActionButton.frame.origin.x = offsetX
            l2ActionButton.frame.origin.x = offsetX + actionButtonWidth
            
        case 0 ... originalOffset.x:
            
            l1ActionButton.frame.origin.x = 0
            l2ActionButton.frame.origin.x = actionButtonWidth
            
        case originalOffset.x ... toShowRightOffset.x:
            
            r1ActionButton.frame.origin.x = rightActionViewOriginX
            
        case toShowRightOffset.x ... toShowRightOffset.x + kScreenWidth:
            
            r1ActionButton.frame.origin.x = rightActionViewOriginX + offsetX - leftActionViewWidth - actionButtonWidth
            
        default:
            break
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let tOx = targetContentOffset.pointee.x
        let cOx = scrollView.contentOffset.x
        
        switch state {
            
        case .showingLeft:
            
            if tOx <= (leftActionViewWidth * 0.4) {
                
                targetContentOffset.pointee = toShowLeftOffset
                
            } else {
                
                if cOx <= originalOffset.x + actionButtonWidth * 0.4 {
                    
                    targetContentOffset.pointee = originalOffset
                    
                    DispatchQueue.main.async { [weak self] in
                        
                        UIView.animate(withDuration: 0.2, animations: {
                            
                            self?.scrollView.setContentOffset(originalOffset, animated: false)
                            
                        }, completion: { _ in
                            
                            self?.actionViewDidDisappear()
                        })
                    }
                
                } else {
                    
                    targetContentOffset.pointee = toShowRightOffset
                    actionViewDidAppear(state: .showingRight)
                }
            }
            
        case .showingRight:
            
            if tOx >= toShowRightOffset.x - actionButtonWidth * 0.4 {
                
                targetContentOffset.pointee = toShowRightOffset
                
            } else {
                
                if cOx >= 0.4 * leftActionViewWidth {
                    
                    targetContentOffset.pointee = originalOffset
                    
                    DispatchQueue.main.async { [weak self] in
                        
                        UIView.animate(withDuration: 0.2, animations: {
                            
                            self?.scrollView.setContentOffset(originalOffset, animated: false)
                            
                        }, completion: { _ in
                            
                            self?.actionViewDidDisappear()
                        })
                    }
                    
                } else {
                    
                    targetContentOffset.pointee = toShowLeftOffset
                    actionViewDidAppear(state: .showingLeft)
                }
            }
            
        case .normal:
            
            break
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        
        if offset == toShowLeftOffset {
            
            actionViewDidAppear(state: .showingLeft)
            
        } else if offset == toShowRightOffset {
            
            actionViewDidAppear(state: .showingRight)
            
        } else {
            
            actionViewDidDisappear()
        }
        
        isUserInteractionEnabled = true
    }
}
