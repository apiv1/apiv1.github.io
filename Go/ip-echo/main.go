package main

import (
	"flag"
	"net"
	"net/http"
	"net/url"
	"os"
	"strings"
	"sync"
)

var ipMap sync.Map

var redirectMap sync.Map

type ipServerWraper struct {
}

func (f *ipServerWraper) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	println("Request: " + r.RemoteAddr + " | " + r.URL.String())
	if getIp := r.URL.Query().Get("get_ip"); len(getIp) > 0 {
		if v, ok := ipMap.Load(getIp); ok {
			if ip, ok := v.(string); ok {
				w.Write([]byte(ip))
				return
			}
		}
		http.Error(w, "Not found ip ["+getIp+"]", http.StatusNotFound)
		return
	}
	redirectParams, ok := os.LookupEnv("PARAMS_NAME_REDIRECT")
	if !ok {
		redirectParams = "redirect_to"
	}
	if getRedirect := r.URL.Query().Get(redirectParams); len(getRedirect) > 0 {
		if v, ok := redirectMap.Load(getRedirect); ok {
			if redirect, ok := v.(string); ok {
				redirectURL, err := url.Parse(redirect)
				if err != nil {
					http.Error(w, "Redirect url ["+redirect+"] parse error", http.StatusInternalServerError)
					return
				}
				origURL := r.URL.String()
				newURL, err := url.Parse(origURL)
				if err != nil {
					http.Error(w, "Original url ["+origURL+"] parse error", http.StatusInternalServerError)
					return
				}

				{
					newURLQuery := newURL.Query()
					newURLQueryMap := map[string][]string(newURLQuery)

					query := redirectURL.Query()
					queryMap := map[string][]string(query)

					for k, v := range newURLQueryMap {
						if k == redirectParams {
							continue
						}
						queryMap[k] = v
					}
					newURL.RawQuery = url.Values(queryMap).Encode()
				}

				newURL.Scheme = redirectURL.Scheme
				newURL.Host = redirectURL.Host
				newURL.Path = redirectURL.Path + newURL.Path
				http.Redirect(w, r, newURL.String(), http.StatusFound)
				return
			}
		}
		http.Error(w, "Not found redirect ["+getRedirect+"]", http.StatusNotFound)
		return
	}
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
	if updateIp := r.URL.Query().Get("update_ip"); len(updateIp) > 0 {
		if r.URL.Query().Get("token") == os.Getenv("TOKEN") {
			ipMap.Store(updateIp, ip)
		} else {
			http.Error(w, "'update_ip' Unauthorized", http.StatusUnauthorized)
			return
		}
	}
	if updateRedirect, redirectUrl := r.URL.Query().Get("update_redirect"), r.URL.Query().Get("redirect_url"); len(updateRedirect) > 0 && len(redirectUrl) > 0 {
		if r.URL.Query().Get("token") == os.Getenv("TOKEN") {
			redirectUrl = strings.ReplaceAll(redirectUrl, "$MY_IP", ip)
			if _, err := url.Parse(redirectUrl); err == nil {
				redirectMap.Store(updateRedirect, redirectUrl)
			} else {
				http.Error(w, "Redirect url ["+redirectUrl+"] invalid", http.StatusBadRequest)
				return
			}
		} else {
			http.Error(w, "'update_ip' Unauthorized", http.StatusUnauthorized)
			return
		}
	}
	w.Write([]byte(ip))
}

func main() {
	useTls := flag.Bool("tls", false, "use tls")
	certFile := flag.String("cert", "crt.pem", "cert file path (default: crt.pem)")
	keyFile := flag.String("key", "key.pem", "cert file path (default: key.pem)")
	flag.Parse()

	http.Handle("/", &ipServerWraper{})
	addr := ":8089"
	args := flag.Args()
	if len(args) >= 1 {
		addr = args[0]
	}
	println("addr = ", addr)
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
