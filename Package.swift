import PackageDescription

let package = Package(
    name: "wtmapp",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura-router.git", versions: Version(0,3,0)..<Version(0,4,0)),
        .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", versions: Version(0,0,0)..<Version(0,1,0))
    ]
)

