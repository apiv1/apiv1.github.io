package main

import (
	"net/http"
	"os"
	"path/filepath"
)

type fileServerWrapper struct {
	handler http.Handler
}

func (f fileServerWrapper) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	println("Request: " + r.RemoteAddr + " | " + r.URL.String())
	w.Header().Set("Content-Type", "application/octet-stream")
	f.handler.ServeHTTP(w, r)
}

func main() {
	if len(os.Args) < 2 {
		println("Usage: <dir> [listen-addr]")
		return
	}
	p, _ := filepath.Abs(os.Args[1])
	http.Handle("/", fileServerWrapper{http.FileServer(http.Dir(p))})
	addr := ":8088"
	if len(os.Args) >= 3 {
		addr = os.Args[2]
	}
	println("Running dir '", os.Args[1], "', on: '", addr, "'")
	defer println("Quit")
	err := http.ListenAndServe(addr, nil)
	if err != nil {
		println(err)
	}
}
