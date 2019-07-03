//
//  Copyright © 2019 An Tran. All rights reserved.
//

import RxSwift
import RxRelay
import PromiseKit

class ImageListViewModel: ViewModel {

    // MARK: Properties

    var searchTerm = BehaviorRelay<String>(value: "")
    var imageList = BehaviorRelay<ImageList>(value: ImageList(total: 0, totalHits: 0, hits: []))

    let activity = PublishRelay<Bool>()

    private let disposeBag = DisposeBag()

    // MARK: APIs

    override init(service: ServiceProtocol) {
        super.init(service: service)

        searchTerm.subscribe(onNext: { value in
            if value.count > 2 {
                self.fetchImage(searchTerm: value)
            }
        }).disposed(by: disposeBag)
    }

    func fetchImage(searchTerm: String) {
        activity.accept(true)
        pixaBayService.fetch(searchTerm: searchTerm)
            .done { [weak self] imageList in
                self?.imageList.accept(imageList)
            }
            .catch { error in
                print(error)
            }.finally {
                self.activity.accept(false)
            }
    }
}

extension ImageListViewModel {

    var pixaBayService: PixaBayService {
        return service as! PixaBayService
    }
}
