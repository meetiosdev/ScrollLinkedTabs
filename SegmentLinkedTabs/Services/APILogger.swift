//
//  APILogger.swift
//  SegmentLinkedTabs
//
//  Created by Swarajmeet Singh on 11/07/25.
//

import Foundation
import OSLog

/// A utility class responsible for logging API request and response details with unique identifiers.
/// Uses Apple's OSLog for better performance and integration with Console.app
final class APILogger {
    
    // MARK: - Properties
    
    private static let logger = Logger(subsystem: "com.segmentlinkedtabs.api", category: "network")
    private static let isLogEnabled = true // Can be controlled via environment or build configuration
    
    // MARK: - Request Logging
    
    /// Logs the API request details.
    /// - Parameters:
    ///   - url: The full URL of the request.
    ///   - method: HTTP method.
    ///   - headers: Request headers.
    ///   - body: Request body data.
    /// - Returns: The UUID associated with this request log.
    @discardableResult
    static func logRequest(
        url: String,
        method: String,
        headers: [String: String]?,
        body: Data? = nil
    ) -> String {
        let requestId = UUID().uuidString.uppercased()
        
        guard isLogEnabled else { return requestId }
        
        let timestamp = DateFormatter.logTimestamp.string(from: Date())
        let summary = "\(timestamp) ⚪️ Request started\n"
        let details = formatKeyValue([
            ("id", requestId),
            ("method", method),
            ("url", url),
            ("headers", headers?.prettyHeadersString ?? "{}"),
            ("body", body?.json ?? "nil")
        ])
        print("\(summary)\n\(details)")
        logger.info("Request started: \(requestId)")
        
        return requestId
    }
    
    // MARK: - Response Logging
    
    /// Logs the API response.
    /// - Parameters:
    ///   - requestId: The ID matching the request.
    ///   - data: Raw response data.
    ///   - statusCode: HTTP status code.
    ///   - responseTime: Time taken for the request in seconds.
    static func logResponse(
        requestId: String,
        data: Data?,
        statusCode: Int?,
        responseTime: TimeInterval? = nil
    ) {
        guard isLogEnabled else { return }
        
        let timestamp = DateFormatter.logTimestamp.string(from: Date())
        let summary = "\(timestamp) 🟢 Request succeeded\n"
        let details = formatKeyValue([
            ("id", requestId),
            ("status", statusCode.map { String($0) } ?? "nil"),
            ("responseTime", responseTime.map { String(format: "%.2fs", $0) } ?? "nil"),
            ("body", data?.json ?? "nil")
        ])
        print("\(summary)\n\(details)")
        logger.info("Request succeeded: \(requestId)")
    }
    
    // MARK: - Error Logging
    
    /// Logs an API error.
    /// - Parameters:
    ///   - requestId: The ID matching the request.
    ///   - data: Raw response data.
    ///   - statusCode: HTTP status code.
    ///   - error: The error that occurred.
    ///   - responseTime: Time taken for the request in seconds.
    /// - Returns: A formatted NSError for the calling code.
    static func logError(
        requestId: String,
        data: Data?,
        statusCode: Int?,
        error: Error,
        responseTime: TimeInterval? = nil
    ) -> NSError {
        
        guard isLogEnabled else {
            let fallbackMessage = "Something went wrong. Please try again."
            return NSError(
                domain: "APILoggerErrorDomain",
                code: statusCode ?? -1,
                userInfo: [NSLocalizedDescriptionKey: fallbackMessage]
            )
        }
        
        let timestamp = DateFormatter.logTimestamp.string(from: Date())
        let summary = "\(timestamp) 🔴 Request failed\n"
        let errorDescription = error.localizedDescription
        let details = formatKeyValue([
            ("id", requestId),
            ("error", errorDescription),
            ("requestResult", "failed")
        ])
        print("\(summary)\n\(details)")
        logger.error("Request failed: \(requestId) - \(errorDescription)")
        
        return NSError(
            domain: "APILoggerErrorDomain",
            code: statusCode ?? -1,
            userInfo: [NSLocalizedDescriptionKey: errorDescription]
        )
    }
    
    // MARK: - Formatting Helpers
    private static func formatKeyValue(_ pairs: [(String, String)]) -> String {
        let maxKeyLength = pairs.map { $0.0.count }.max() ?? 0
        return pairs.map { key, value in
            let paddedKey = key.padding(toLength: maxKeyLength, withPad: " ", startingAt: 0)
            if key == "headers" && value.contains("\n") {
                // Indent multiline headers
                let indented = value.split(separator: "\n").map { "           \($0)" }.joined(separator: "\n")
                return "  \(paddedKey): \n\(indented)"
            }
            if key == "body" && value != "nil" && value.contains("\n") {
                let indented = value.split(separator: "\n").map { "           \($0)" }.joined(separator: "\n")
                return "  \(paddedKey): \n\(indented)"
            }
            return "  \(paddedKey): \(value)"
        }.joined(separator: "\n") + "\n"
    }
}

// MARK: - Supporting Types

private extension APILogger {
    // Removed unused LogType enum and printConsoleOutput method
}

// MARK: - API Error Response

private struct APIErrorResponse: Codable {
    let success: Bool
    let message: String
}

// MARK: - Extensions

private extension Dictionary where Key == String, Value == String {
    var prettyHeadersString: String {
        self.map { "\($0): \($1)" }.joined(separator: "\n           ")
    }
}


private extension DateFormatter {
    static let logTimestamp: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
} 
