package services

import (
	"bytes"
	"crypto/tls"
	"fmt"
	"io/ioutil"
	"net/http"
	"strconv"
	"strings"
	"time"

	"bitbucket.org/jpbourbon/http3-speed-compare/internal/testdata"
	"bitbucket.org/jpbourbon/http3-speed-compare/internal/utils"
	retry "github.com/avast/retry-go"
	"github.com/lucas-clemente/quic-go"
	"github.com/lucas-clemente/quic-go/http3"
)

type binds []string

func (b binds) String() string {
	return strings.Join(b, ",")
}

func (b *binds) Set(v string) error {
	*b = strings.Split(v, ",")
	return nil
}

// Size is needed by the /demo/upload handler to determine the size of the uploaded file
type Size interface {
	Size() int64
}

// StartHTTP3 start a server that echos all data on the first stream opened by the client
func StartHTTP3() {
	//startTi := time.Now()
	listenToPort := strconv.Itoa(*myConfig.ListenToPort)

	mux := http.NewServeMux()
	mux.HandleFunc("/", serverHandler)

	//http.HandleFunc("/", serverHandler)

	tlsCfg := &tls.Config{
		PreferServerCipherSuites: true,
		InsecureSkipVerify:       true,
	}

	server := http3.Server{
		Server: &http.Server{
			Addr:              addr + listenToPort,
			Handler:           mux,
			TLSConfig:         tlsCfg,
			ReadHeaderTimeout: 5 * time.Second,
			ReadTimeout:       5 * time.Second,
			WriteTimeout:      1 * time.Second,
		},
		QuicConfig: &quic.Config{ConnectionIDLength: 4,
			MaxIncomingStreams:    500,
			MaxIncomingUniStreams: 500,
			KeepAlive:             true,
			HandshakeTimeout:      30 * time.Second,
			IdleTimeout:           30 * time.Second,
		},
	}

	err := server.ListenAndServeTLS(testdata.GetCertificatePaths(*myConfig.ServerName))
	//endTi = time.Now()
	utils.Check(err, "ListenAndServeTLS")
}

// StartClientQUICGET() starts the QUIC client for requests using GET method
func StartClientQUICGET() []byte {
	connectToPort := strconv.Itoa(*myConfig.ConnectToPort)
	startTime := time.Now() //XMK: was at the beggining of func.

	//,
	roundTripper := &http3.RoundTripper{
		DisableCompression: true,
		TLSClientConfig: &tls.Config{
			RootCAs:            testdata.GetRootCA(),
			InsecureSkipVerify: true,
		},
		QuicConfig: &quic.Config{ConnectionIDLength: 4,
			KeepAlive:             true,
			MaxIncomingStreams:    500,
			MaxIncomingUniStreams: 500,
			HandshakeTimeout:      30 * time.Second,
			IdleTimeout:           30 * time.Second,
		},
	}
	defer roundTripper.Close()

	h3Client := &http.Client{
		Transport: roundTripper,
	}

	var body []byte
	retry.Attempts(5)
	retry.Delay(1 * time.Second)

	err := retry.Do(
		func() error {

			resp, err := h3Client.Get(protocol + *myConfig.Host + ":" + connectToPort)
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
			utils.Check(err, "Client QUIC GET retry "+fmt.Sprint(n))
		}),
	)
	utils.Check(err, "Client QUIC GET error after retry")

	json := SetJSONOnResponse(body, startTime)

	return json
}

// StartClientQUICPOST() starts the QUIC client for requests using POST method
func StartClientQUICPOST(jsonPayload []byte) []byte {
	connectToPort := strconv.Itoa(*myConfig.ConnectToPort)
	startTime := time.Now()

	//InsecureSkipVerify: true,
	roundTripper := &http3.RoundTripper{
		DisableCompression: true,
		TLSClientConfig: &tls.Config{
			RootCAs:            testdata.GetRootCA(),
			InsecureSkipVerify: true,
		},
		QuicConfig: &quic.Config{ConnectionIDLength: 4,
			KeepAlive:             true,
			MaxIncomingStreams:    500,
			MaxIncomingUniStreams: 500,
			HandshakeTimeout:      30 * time.Second,
			IdleTimeout:           30 * time.Second,
		},
	}

	defer roundTripper.Close()

	h3Client := &http.Client{
		Transport: roundTripper,
	}

	var body []byte
	retry.Attempts(5)
	retry.Delay(1 * time.Second)

	err := retry.Do(
		func() error {

			resp, err := h3Client.Post(protocol+*myConfig.Host+":"+connectToPort, "application/json", bytes.NewBuffer(jsonPayload))
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
			utils.Check(err, "Client QUIC POST retry "+fmt.Sprint(n))
		}),
	)
	utils.Check(err, "Client QUIC POST error after retry")
	//final := append(message, body...)
	jsonResponse := SetJSONOnResponse(body, startTime)

	return jsonResponse
}
