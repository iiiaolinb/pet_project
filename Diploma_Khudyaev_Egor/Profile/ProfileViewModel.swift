import Foundation

final class ProfileViewModel {
    let networkDataFetcher = NetworkDataFetcher()
    var dataModel: ProfileModel?
    let router: PublishedFilesRoute

    init(router: PublishedFilesRoute) {
        self.router = router
    }

    func openPublishedFilesScreen() {
        router.openPublishedFilesScreen()
    }
    
    func logOut() {
        router.logOut()
    }
}

    //MARK: - get info about disk space

extension ProfileViewModel {
    func getInfo() {
        let urlString = "https://cloud-api.yandex.net/v1/disk/"
        networkDataFetcher.fetchDataProfile(urlString: urlString) { info in
            self.dataModel = info
        }
    }
}
