extension Result {
    var minimumOSVersionRequirement: String {
        guard let minimumOSVersion = minimumOSVersion, !minimumOSVersion.isEmpty else {
            return "Not listed"
        }
        
        return "iOS \(minimumOSVersion) or later"
    }
}
