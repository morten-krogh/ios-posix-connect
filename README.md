# ios-posix-connect

This app tests the time to establish a posix tcp connection and do a HTTP request/response cycle 
on iOS devices.

When the button is tapped, a C function is called that establishes a tcp connection to
a web server in Sweden. The C function sends an HTTP request, and waits for the response.
The response is compared with the expected result which is just HTTP 400.

If everything is okay, the C function returns 0.

The C functions only uses Posix calls.

Swift code handles the tap of the button and measures the time to complete the C function.

The resulting duration, in seconds, is printed in a label.
