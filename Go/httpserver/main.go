package main

import (
	"flag"
	"net/http"
	"path/filepath"
)

type fileServerWrapper struct {
	handler http.Handler
}

func (f *fileServerWrapper) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	println("Request: " + r.RemoteAddr + " | " + r.URL.String())
	w.Header().Set("Content-Type", "application/octet-stream")
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
	http.Handle("/", &fileServerWrapper{http.FileServer(http.Dir(p))})
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
