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
	w.Header().Set("Content-Type", "application/octet-stream")
	f.handler.ServeHTTP(w, r)
}

func main() {
	if len(os.Args) < 2 {
		print("Usage: <dir> [listen-addr]")
		return
	}
	p, _ := filepath.Abs(os.Args[1])
	http.Handle("/", fileServerWrapper{http.FileServer(http.Dir(p))})
	addr := ":8088"
	if len(os.Args) >= 3 {
		addr = os.Args[2]
	}
	print("Running dir '", os.Args[1], "', on: '", addr, "'")
	defer print("Quit")
	err := http.ListenAndServe(addr, nil)
	if err != nil {
		print(err)
	}
}
