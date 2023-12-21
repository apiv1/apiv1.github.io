package main

import (
	"net"
	"net/http"
	"os"
	"strings"
)

type ipServerWraper struct {
}

func (f *ipServerWraper) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	println("Request: " + r.RemoteAddr + " | " + r.URL.String())
	ip := ""
	var err error
	xffIPs := r.Header.Get("X-FORWARDED-FOR")
	if xffIPs != "" {
		ip = strings.Split(xffIPs, ",")[0]
	} else {
		ip, _, err = net.SplitHostPort(r.RemoteAddr)
		if err != nil {
			http.Error(w, "Error parsing remote address ["+r.RemoteAddr+"]", http.StatusInternalServerError)
			return
		}
	}
	w.Write([]byte(ip))
}

func main() {
	http.Handle("/", &ipServerWraper{})
	addr := ":8089"
	if len(os.Args) >= 2 {
		addr = os.Args[1]
	}
	println("addr = ", addr)
	defer println("Quit")
	err := http.ListenAndServe(addr, nil)
	if err != nil {
		println(err.Error())
	}
}
