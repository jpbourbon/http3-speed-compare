package services

import (
	"bytes"
	"crypto/tls"
	"fmt"
	"io/ioutil"
	"net/http"
	"strconv"
	"time"

	"bitbucket.org/jpbourbon/http3-speed-compare/internal/utils"
	retry "github.com/avast/retry-go"
)

// StartHTTP1 starts the TCP HTTP1.1 server
func StartHTTP1() {
	//startTi := time.Now()
	listenToPort := strconv.Itoa(*myConfig.ListenToPort)

	mux := http.NewServeMux()
	mux.HandleFunc("/", serverHandler)

	tlsCfg := &tls.Config{
		PreferServerCipherSuites: true,
	}

	srv := &http.Server{
		Addr:              addr + listenToPort,
		Handler:           mux,
		TLSConfig:         tlsCfg,
		TLSNextProto:      make(map[string]func(*http.Server, *tls.Conn, http.Handler), 0),
		ReadHeaderTimeout: 5 * time.Second,
		ReadTimeout:       5 * time.Second,
		WriteTimeout:      1 * time.Second,
	}

	err := srv.ListenAndServeTLS("internal/certs/"+*myConfig.ServerName+".pem", "internal/certs/"+*myConfig.ServerName+"-key.pem")
	utils.Check(err, "ListenAndServe: ")
}

// StartHTTP2 starts TCP HTTP/2 server
func StartHTTP2() {
	//startTi := time.Now()
	listenToPort := strconv.Itoa(*myConfig.ListenToPort)
	mux := http.NewServeMux()
	mux.HandleFunc("/", serverHandler)

	tlsCfg := &tls.Config{
		PreferServerCipherSuites: true,
	}

	srv := &http.Server{
		Addr:              addr + listenToPort,
		Handler:           mux,
		TLSConfig:         tlsCfg,
		ReadHeaderTimeout: 5 * time.Second,
		ReadTimeout:       5 * time.Second,
		WriteTimeout:      1 * time.Second,
	}
	err := srv.ListenAndServeTLS("internal/certs/"+*myConfig.ServerName+".pem", "internal/certs/"+*myConfig.ServerName+"-key.pem")
	utils.Check(err, "ListenAndServeTLS")
}

// StartClientTCPGET starts a client for TCP requests with GET method
func StartClientTCPGET() []byte {
	connectToPort := strconv.Itoa(*myConfig.ConnectToPort)

	startTime := time.Now()

	tr := &http.Transport{
		MaxIdleConns:        100,
		IdleConnTimeout:     30 * time.Second,
		DisableCompression:  true,
		TLSHandshakeTimeout: 30 * time.Second,
		TLSClientConfig:     &tls.Config{InsecureSkipVerify: true},
	}
	client := &http.Client{Transport: tr}

	var body []byte
	retry.Attempts(5)
	retry.Delay(1 * time.Second)

	err := retry.Do(
		func() error {
			resp, err := client.Get(protocol + *myConfig.Host + ":" + connectToPort)
			if err != nil {
				return err
			}
			defer resp.Body.Close()
			body, err = ioutil.ReadAll(resp.Body)
			if err != nil {
				return err
			}

			return nil
		},
		retry.OnRetry(func(n uint, err error) {
			utils.Check(err, "Client TCP GET retry "+fmt.Sprint(n))
		}),
	)
	utils.Check(err, "Client TCP GET error after retry")

	json := SetJSONOnResponse(body, startTime)

	return json
}

// StartClientTCPPOST starts a client for TCP requests with POST method
func StartClientTCPPOST(jsonPayload []byte) []byte {
	connectToPort := strconv.Itoa(*myConfig.ConnectToPort)
	startTime := time.Now()

	tr := &http.Transport{
		MaxIdleConns:        100,
		IdleConnTimeout:     30 * time.Second,
		DisableCompression:  true,
		TLSHandshakeTimeout: 30 * time.Second,
		TLSClientConfig:     &tls.Config{InsecureSkipVerify: true},
	}

	client := &http.Client{Transport: tr}

	var body []byte
	retry.Attempts(5)
	retry.Delay(1 * time.Second)

	err := retry.Do(
		func() error {

			resp, err := client.Post(protocol+*myConfig.Host+":"+connectToPort, "application/json", bytes.NewBuffer(jsonPayload))
			if err != nil {
				return err
			}
			defer resp.Body.Close()
			body, err = ioutil.ReadAll(resp.Body)
			if err != nil {
				return err
			}

			return nil
		},
		retry.OnRetry(func(n uint, err error) {
			utils.Check(err, "Client TCP POST retry "+fmt.Sprint(n))
		}),
	)
	utils.Check(err, "Client TCP POST error after retry")

	jsonResponse := SetJSONOnResponse(body, startTime)

	return jsonResponse
}
