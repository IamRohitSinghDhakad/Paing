//
//  FeedPageViewController.swift
//  Paing
//
//  Created by Paras on 26/07/21.
//

import Foundation
import UIKit

typealias IndexedFeed = (feed: BlogListModel, index: Int)

protocol FeedPageView: AnyObject, ProgressIndicatorHUDPresenter {
    func presentInitialFeed(_ feed: BlogListModel)
}

class FeedPageViewController: UIPageViewController, FeedPageView {
    fileprivate var presenter: FeedPagePresenterProtocol!
    
    var customView = UIView()
    
    func presentInitialFeed(_ feed: BlogListModel) {
//        let viewController = FeedViewController.instantiate(feed: feed, andIndex: 0, isPlaying: true) as! FeedViewController
//        setViewControllers([viewController], direction: .forward, animated: false, completion: nil)
        let viewController = NewFeedViewController.instantiate(feed: feed, andIndex: 0, isPlaying: true) as! NewFeedViewController
        setViewControllers([viewController], direction: .forward, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        presenter = FeedPagePresenter(view: self)
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    

}


extension FeedPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let indexedFeed = presenter.fetchPreviousFeed() else {
            return nil
        }
        return NewFeedViewController.instantiate(feed: indexedFeed.feed, andIndex: indexedFeed.index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let indexedFeed = presenter.fetchNextFeed() else {
            return nil
        }
        return NewFeedViewController.instantiate(feed: indexedFeed.feed, andIndex: indexedFeed.index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        if
            let viewController = pageViewController.viewControllers?.first as? NewFeedViewController,
            let previousViewController = previousViewControllers.first as? NewFeedViewController
        {
            previousViewController.pause()
            viewController.play()
            presenter.updateFeedIndex(fromIndex: viewController.index)
        }
    }
}


