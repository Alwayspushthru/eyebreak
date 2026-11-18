import Foundation
import Combine

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case simplifiedChinese = "zh-Hans"

    var id: String { rawValue }

    var name: String {
        switch self {
        case .english: "English"
        case .simplifiedChinese: "简体中文"
        }
    }
}

final class AppLocalization: ObservableObject {
    static let shared = AppLocalization()
    private static let preferenceKey = "appLanguage"

    @Published var language: AppLanguage {
        didSet {
            UserDefaults.standard.set(language.rawValue, forKey: Self.preferenceKey)
        }
    }

    var locale: Locale { Locale(identifier: language.rawValue) }

    private init() {
        if let saved = UserDefaults.standard.string(forKey: Self.preferenceKey),
           let language = AppLanguage(rawValue: saved) {
            self.language = language
        } else if let preferred = Locale.preferredLanguages.first,
                  Locale.Language(identifier: preferred).script?.identifier == "Hans" {
            language = .simplifiedChinese
        } else {
            language = .english
        }
    }
}

enum L10n {
    private static let chineseBundle = Bundle.main
        .url(forResource: "zh-Hans", withExtension: "lproj")
        .flatMap(Bundle.init(url:))

    static func text(_ source: String) -> String {
        guard AppLocalization.shared.language == .simplifiedChinese else { return source }
        return chineseBundle?.localizedString(forKey: source, value: source, table: nil) ?? source
    }

    static func format(_ source: String, _ arguments: Any...) -> String {
        String(format: text(source), locale: AppLocalization.shared.locale,
               arguments: arguments.map { String(describing: $0) })
    }
}
