FrontPanel Web API Pipetest Sample
==============================

Once only setup
-------
Ensure that `@opalkelly/frontpanel-samples-common` package is set up
(see `frontpanel-samples/WebAPI/README.md`).

Then install the modules required by this package:
```
npm install
```

Editor
-------
Any text editor can be used, but Visual Studio Code is preferred.

Run the sample
-------
Run the localhost server with the sample using `parcel`:
```
npm start
```

Debug
-------
Run the localhost server using the previous run command and then
press F5 in VS-Code to start debugging.

Debugging the Typescript code in the browser also works fine
(e.g. F12 in Chrome).

Build
-------
Standalone version that can be simply opened in a browser (i.e. without
running a HTML server) can be built with the command:
```
npm run build
```

Then just open `dist/index.html` in a browser.

Note
-------

If you run a local FPoIP server using self-signed certificate (e.g
wss://localhost:9999/) then you need to open the corresponding HTTPS
URL (e.g. https://localhost:9999/) in the same browser, in order to
accept the certificate, as you won't have any possibility to do it
when connecting via WebSocket.
