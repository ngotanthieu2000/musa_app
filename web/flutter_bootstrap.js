// Define CORS proxy for use in Flutter app
window.addEventListener('load', function () {
    // Initialize with no proxy by default - direct connection to our backend
    window.corsProxyUrl = '';
    window.useProxy = false;
    window.isCorsEnabled = false;

    console.log("Flutter Bootstrap loaded - Direct API connection mode");

    // Check if we're on localhost development
    if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
        // We're on localhost - let's check the backend URL
        window.addEventListener('flutterInAppWebViewPlatformReady', function (event) {
            console.log("Flutter app is ready, checking backend URL");

            // If backend is also on localhost, just add CORS headers
            // No need for a proxy that won't work with localhost
            window.corsProxyUrl = '';
            window.useProxy = false;
            window.isCorsEnabled = true;

            console.log("Localhost development mode - CORS support enabled without proxy");
        });
    }

    // Helper function for testing backend connectivity
    window.testBackendConnection = function (url) {
        console.log("Testing backend connection with URL: " + url);

        // Don't use proxy for localhost URLs
        if (url.includes('localhost') || url.includes('127.0.0.1')) {
            console.log("Detected localhost URL, skipping proxy");

            fetch(url, {
                method: 'OPTIONS',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                mode: 'cors'
            })
                .then(response => {
                    console.log("Backend responded with status:", response.status);
                    console.log("CORS headers:", response.headers.get('Access-Control-Allow-Origin'));
                    return "Backend responded with status: " + response.status;
                })
                .catch(error => {
                    console.error("Error connecting to backend:", error);
                    return "Error connecting to backend: " + error.message;
                });

            return "Test initiated for direct connection. Check console for results.";
        }
    };
}); 