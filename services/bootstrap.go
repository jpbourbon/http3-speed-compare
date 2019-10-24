package services

import (
	"io/ioutil"
	"net/http"
	"fmt"

	"bitbucket.org/jpbourbon/http3-speed-compare/internal/structs"
)


//const addr = "localhost:"
const protocol = "https://"
var myConfig structs.Config
var addr string

func SetupBootstrap(config structs.Config) {
	myConfig = config
	if (len(*myConfig.IPServer) > 0){
		addr = "" + *myConfig.IPServer +":"
	}else{
		addr = "server:"
	}
	fmt.Println("address =" + addr)
}

// StartServer boilerplate function to start the required server
func StartServer() {
	switch *myConfig.HttpVersion {
	case "1.1":
		StartHTTP1()
	case "2":
		StartHTTP2()
	case "3":
		StartHTTP3()
	}
}

// StartClient boilerplate function to start the required client
func StartClient(jsonPayload []byte) []byte {
	var final []byte

	switch *myConfig.HttpVersion {
	case "1.1":
		if *myConfig.TestSuite == "A" {
			if *myConfig.Microservice == "A" {
				jsonPayload = CreatePayloadJSON()
			}
			final = StartClientTCPPOST(jsonPayload)
		} else {
			final = StartClientTCPGET()
		}
	case "2":
		if *myConfig.TestSuite == "A" {
			if *myConfig.Microservice == "A" {
				jsonPayload = CreatePayloadJSON()
			}
			final = StartClientTCPPOST(jsonPayload)
		} else {
			final = StartClientTCPGET()
		}
	case "3":
		if *myConfig.TestSuite == "A" {
			if *myConfig.Microservice == "A" {
				jsonPayload = CreatePayloadJSON()
			}
			final = StartClientQUICPOST(jsonPayload)
		} else {
			final = StartClientQUICGET()
		}
	}

	return final
}

// serverHandler(w http.ResponseWriter, local function for handling all server requests r *http.Request)
func serverHandler(rw http.ResponseWriter, req *http.Request) {
	rw.Header().Set("Content-Type", "application/json")

	if *myConfig.Microservice != "D" {
		if *myConfig.Microservice == "B" && myConfig.Originator {
			jsonPayload := CreatePayloadJSON()
			jsonPayload = SetJSONOnTouch(jsonPayload)
			rw.Write(jsonPayload)
		} else {
			jsonPayload, _ := ioutil.ReadAll(req.Body)
			jsonPayload = SetJSONOnTouch(jsonPayload)
			jsonPayload = StartClient(jsonPayload)
			rw.Write(jsonPayload)

		}
	} else {
		jsonPayload, _ := ioutil.ReadAll(req.Body)
		jsonPayload = SetJSONOnTouch(jsonPayload)
		rw.Write(jsonPayload)
	}

}
