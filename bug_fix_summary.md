The `WeatherApiService` has been refactored to include more robust error handling for network requests.

**Changes Made:**

1.  **`lib/core/errors/exceptions.dart`**: Modified `ServerException` to include optional `message` and `statusCode` properties, allowing for more detailed error information.
2.  **`lib/features/weather/data/weather_api_service.dart`**:
    *   Added `import 'dart:io';` for `SocketException` handling.
    *   Imported `ServerException` from `lib/core/errors/exceptions.dart`.
    *   Implemented `try-catch` blocks around `http.get` calls in both `fetchWeather` and `fetchForecast` methods.
    *   **Specific Error Handling:**
        *   Catches `SocketException` (indicating no internet connection) and re-throws `ServerException` with a specific message.
        *   Catches `http.ClientException` (for other client-side network issues) and re-throws `ServerException` with its message.
        *   If the HTTP response status code is not `200`, it throws a `ServerException` with a descriptive message and the actual status code.
        *   Catches any other generic `Exception` and re-throws it as a `ServerException` for unexpected errors.

**Impact:**

These changes significantly improve the application's ability to identify and propagate specific network-related errors. This allows higher layers of the application (repositories, use cases, and presentation) to:
*   Catch `ServerException` instances.
*   Map them to `ServerFailure` (defined in `lib/core/errors/failures.dart`).
*   Provide more precise and user-friendly error messages to the end-user, such as "No internet connection" or "Failed to load data (Status Code: 404)", instead of generic error messages.

This makes the application more resilient to network issues and provides better diagnostic information when the `XMLHttpRequest onError` callback is triggered due to underlying network problems.