package main

import (
	"fmt"
	"net/http"
	"os"
	"log"
	"time"
)

func main() {
	logFile, err := os.OpenFile("../log/simpleserver.log", os.O_WRONLY|os.O_APPEND|os.O_CREATE, 0666)

	if err != nil {
		fmt.Println(time.Now().Format(time.RFC1123Z) + ":", err)

		return
	}

	logger := log.New(logFile, "", 0)

	fmt.Println(time.Now().Format(time.RFC1123Z) + ": Starting simpleserver.")

	logger.Println(time.Now().Format(time.RFC1123Z) + ": Starting simpleserver.")

	err = http.ListenAndServe(":4568", http.HandlerFunc(Handler))

	if err != nil {
		fmt.Println(time.Now().Format(time.RFC1123Z) + ":",  err)

		logger.Fatal(time.Now().Format(time.RFC1123Z) + ":", err)
	}
}

func Handler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Server", "simpleserver")

	w.Header().Set("Content-Type", "text/html")

	fmt.Fprintf(w, "<!DOCTYPE html><html dir=\"ltr\" lang=\"en-US\"><head><meta charset=\"utf-8\"><title>Hello, %s!</title></head><body><h1>Hello, %s!</h1><p>You requested %s</p></body></html>", r.RemoteAddr, r.RemoteAddr, r.URL.Path)
}
