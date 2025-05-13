package main

import (
	"flag"
	"mime"
	"net/http"
	"path/filepath"
)

type fileServerWrapper struct {
	handler http.Handler
	dir     string
}

func (f *fileServerWrapper) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	path := filepath.Join(f.dir, r.URL.Path)

	ext := filepath.Ext(path)
	mimeType := mime.TypeByExtension(ext)

	if mimeType == "" {
		mimeType = "text/html"
	}

	println("Request: " + r.RemoteAddr + " | " + r.URL.String() + " | " + mimeType)

	w.Header().Set("Content-Type", mimeType)

	f.handler.ServeHTTP(w, r)
}

func main() {
	useTls := flag.Bool("tls", false, "use tls")
	certFile := flag.String("cert", "crt.pem", "cert file path (default: crt.pem)")
	keyFile := flag.String("key", "key.pem", "cert file path (default: key.pem)")
	flag.Parse()

	args := flag.Args()
	if len(args) < 1 {
		println("Usage: <dir> [listen-addr]")
		return
	}
	dir := args[0]
	p, _ := filepath.Abs(dir)
	http.Handle("/", &fileServerWrapper{http.FileServer(http.Dir(p)), p})
	addr := ":8088"
	if len(args) >= 2 {
		addr = args[1]
	}
	println("Running dir '", dir, "', on: '", addr, "'")
	defer println("Quit")
	var err error
	if *useTls {
		err = http.ListenAndServeTLS(addr, *certFile, *keyFile, nil)
	} else {
		err = http.ListenAndServe(addr, nil)
	}
	if err != nil {
		println(err.Error())
	}
}
