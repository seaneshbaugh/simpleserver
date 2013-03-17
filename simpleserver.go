package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.ListenAndServe(":4568", http.HandlerFunc(Handler))
}

func Handler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Server", "simpleserver")

	w.Header().Set("Content-Type", "text/html")
	
	fmt.Fprintf(w, "<!DOCTYPE html><html dir=\"ltr\" lang=\"en-US\"><head><meta charset=\"utf-8\"><title>Hello, %s!</title></head><body><h1>Hello, %s!</h1><p>You requested %s</p></body></html>", r.RemoteAddr, r.RemoteAddr, r.URL.Path)
}
