//
//  Copyright © 2019 An Tran. All rights reserved.
//

import UIKit

class ImageDetailViewController: ViewController {

    // MARK: Properties

    @IBOutlet weak var imageView: UIImageView!

    var image: Image?

    // MARK: Lifecyles

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Detail"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let image = image else { return }

        guard let url = URL(string: image.largeImageURL) else { return }

        imageView.kf.setImage(with: url)
    }

}
