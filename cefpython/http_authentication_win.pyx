# Copyright (c) 2012 CefPython Authors. All rights reserved.
# License: New BSD License.
# Website: http://code.google.com/p/cefpython/

cdef cpp_bool HttpAuthenticationDialog(
        browser, isProxy, host, port, realm, scheme, username, password
        ) except *:
    cdef AuthCredentialsData* credentialsData
    cdef int innerWindowHandle = browser.GetWindowHandle()
    cdef HWND hwnd = <HWND>innerWindowHandle
    with nogil:
        credentialsData = AuthDialog(hwnd)
    if credentialsData == NULL:
        return False
    else:
        # In Python 2.7 c_str returns a string.
        username[0] = credentialsData.username.c_str()
        password[0] = credentialsData.password.c_str()
        # In Python 3 c_str returns bytes.
        if str != bytes:
            if type(username[0]) == bytes:
                username[0] = username[0].decode(
                        g_applicationSettings["unicode_to_bytes_encoding"])
            if type(password[0]) == bytes:
                password[0] = password[0].decode(
                        g_applicationSettings["unicode_to_bytes_encoding"])
        return True
