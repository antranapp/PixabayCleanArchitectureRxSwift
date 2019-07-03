//
//  Copyright © 2019 An Tran. All rights reserved.
//

import RxSwift
import RxCocoa
import Kingfisher
import UIKit

class NetworkImageListViewController: ViewController {

    // MARK: Properties

    // Public

    @IBOutlet weak var searchTermTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    // Private

    private var activityIndicator: UIActivityIndicatorView!

    let disposeBag = DisposeBag()

    // MARK: Setup ViewModel

    lazy var viewModel = ImageListViewModel(service: context.networkPixaBayService)

    // MARK: Lifecyles

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        activityIndicator = UIActivityIndicatorView(style: .gray)
        let rightButton = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem = rightButton

        tableView.register(UINib(nibName: "ImageListTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageListTableViewCell")

        title = "List"

        // UI Binding
        searchTermTextField.rx.text
            .orEmpty
            .bind(to: viewModel.searchTerm)
            .disposed(by: disposeBag)

        // Observe Property
        viewModel.imageList.subscribe(
            onNext: { imageList in
                self.tableView.reloadData()
            }
        ).disposed(by: disposeBag)

        // Observe Signal
        viewModel.activity.subscribe(
            onNext: { value in
                DispatchQueue.main.async {
                    value ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
                }
            }
        ).disposed(by: disposeBag)

    }
}

extension NetworkImageListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.imageList.value.hits.count
    }
}

extension NetworkImageListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ImageListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ImageListTableViewCell") as! ImageListTableViewCell

        let imageItem = viewModel.imageList.value.hits[indexPath.row]
        cell.titleLabel?.text = imageItem.previewURL
        guard let url = URL(string: imageItem.previewURL) else {
            return cell
        }

        cell.previewImageView.kf.setImage(with: url)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imageItem = viewModel.imageList.value.hits[indexPath.row]
        let detailViewController = UIViewController.instantiateController(storyboard: "Main", bundleClass: ImageDetailViewController.self, context: context, identifier: "ImageDetailViewController") as! ImageDetailViewController
        detailViewController.image = imageItem
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
