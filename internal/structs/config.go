package structs

import (
	"database/sql"
	"math/rand"
	"strconv"
	"time"

	"bitbucket.org/jpbourbon/http3-speed-compare/internal/utils"
)

type Config struct {
	HttpVersion   *string
	Microservice  *string
	TestSuite     *string
	Scenario      *int
	ConnectToPort *int
	ListenToPort  *int
	Method        string
	FilePath      string
	FileContents  string
	ClientID      string
	DB            *sql.DB
	Originator    bool
	DBName        *string
	DBAddress     *string
	DBPort        *int
	DBTable       string
	DBTableExists bool
	DBUsername    *string
	DBPassword    *string
	Delay         *string
	Verbose       *bool
	Host          *string
	ServerName    *string
	IPServer			*string
}

var validHttpVersions = []string{"1.1", "2", "3"}
var validMicroservices = []string{"A", "B", "C", "D"}
var validTestSuites = []string{"A", "B"}
var validScenarios = utils.MakeRange(1, 16)
var validPorts = utils.MakeRange(8000, 8002)
var validMethods = make(map[string]string)
var validFilePath = "internal/files/"

var myConfig Config
var logger utils.Logger

func ValidateConfig(myCfg Config, lgr utils.Logger) (Config, bool) {
	myConfig = myCfg
	logger = lgr

	validMethods["A"] = "POST"
	validMethods["B"] = "GET"

	if !validateHttpVersion() {
		return myConfig, false
	}

	if !validateMicroservice() {
		return myConfig, false
	}

	if !validateTestSuite() {
		return myConfig, false
	}

	if !validateScenario() {
		return myConfig, false
	}

	if !validatePorts() {
		return myConfig, false
	}

	if *myConfig.Microservice == "A" {
		return myConfig, configureDB()
	}

	return myConfig, true
}

func configureDB() bool {
	if *myConfig.Microservice == "A" {
		rand.Seed(time.Now().UnixNano())
		myConfig.ClientID = "A-" + utils.RandStringBytes(3)
	}
	myConfig.DBTable = *myConfig.TestSuite + strconv.Itoa(*myConfig.Scenario)
	myConfig.DBTableExists = false

	return true
}

func validateHttpVersion() bool {
	if utils.StringInSlice(*myConfig.HttpVersion, validHttpVersions) {
		logger.Infof("Protocol: HTTP/%s", *myConfig.HttpVersion)
		return true
	} else {
		logger.Errorf("%s is not a supported Http version! Aborting", *myConfig.HttpVersion)
		return false
	}
}

func validateMicroservice() bool {
	if utils.StringInSlice(*myConfig.Microservice, validMicroservices) {
		logger.Infof("Identity: M-%s", *myConfig.Microservice)
		return true
	} else {
		logger.Errorf("%s is not a valid identifier! Aborting", *myConfig.Microservice)
		return false
	}
}

func validateTestSuite() bool {
	myConfig.Originator = false
	myConfig.Originator = false
	if !utils.StringInSlice(*myConfig.TestSuite, validTestSuites) {
		logger.Errorf("%s is not a valid test suite! Aborting", *myConfig.TestSuite)
		return false
	} else {
		if *myConfig.TestSuite == *myConfig.Microservice {
			myConfig.Originator = true
		}
		logger.Infof("Test Suite: %s", *myConfig.TestSuite)
		myConfig.Method = validMethods[*myConfig.TestSuite]
		myConfig.FilePath = validFilePath

		return true
	}
}

func validateScenario() bool {
	if utils.IntInSlice(*myConfig.Scenario, validScenarios) {
		logger.Infof("Scenario: %d", *myConfig.Scenario)
		return true
	} else {
		logger.Errorf("%d is not a valid scenario! Aborting", *myConfig.Scenario)
		return false
	}
}

func validatePorts() bool {
	switch *myConfig.Microservice {
	case "A":
		// A is not a server
		if *myConfig.ListenToPort != 0 {
			logger.Errorf("M-A can't have a listening port! Aborting")
			return false
		}
		// A needs a valid port to connect to
		if utils.IntInSlice(*myConfig.ConnectToPort, validPorts) {
			logger.Infof("Client for: %d", *myConfig.ConnectToPort)
		} else {
			logger.Errorf("%d is not a valid connection port! Aborting", *myConfig.ConnectToPort)
			return false
		}
	case "B":
		// B is not a client on testsuite B
		if myConfig.Originator && *myConfig.ConnectToPort != 0 {
			logger.Errorf("Microservice %s cannot set up a client on test suite %s! Aborting", *myConfig.Microservice, *myConfig.TestSuite)
			return false
		} else if !myConfig.Originator {
			if utils.IntInSlice(*myConfig.ConnectToPort, validPorts) {
				logger.Infof("Client for: %d", *myConfig.ConnectToPort)
			} else {
				logger.Errorf("%d is not a valid connection port! Aborting", *myConfig.ConnectToPort)
				return false
			}
		}
		if utils.IntInSlice(*myConfig.ListenToPort, validPorts) {
			logger.Infof("Serving on: %d", *myConfig.ListenToPort)
		} else {
			logger.Errorf("%d is not a valid server port! Aborting", *myConfig.ListenToPort)
			return false
		}
	case "C":
		if utils.IntInSlice(*myConfig.ConnectToPort, validPorts) {
			logger.Infof("Client for: %d", *myConfig.ConnectToPort)
		} else {
			logger.Errorf("%d is not a valid connection port! Aborting", *myConfig.ConnectToPort)
			return false
		}
		if utils.IntInSlice(*myConfig.ListenToPort, validPorts) {
			logger.Infof("Serving on: %d", *myConfig.ListenToPort)
		} else {
			logger.Errorf("%d is not a valid server port! Aborting", *myConfig.ListenToPort)
			return false
		}
	case "D":
		// D is needs a valid port to listen to
		if utils.IntInSlice(*myConfig.ListenToPort, validPorts) {
			logger.Infof("Serving on: %d", *myConfig.ListenToPort)
		} else {
			logger.Errorf("%d is not a valid server port! Aborting", *myConfig.ListenToPort)
			return false
		}
		// D is not a client
		if *myConfig.ConnectToPort != 0 {
			panic("M-D can't have a connect to port! Aborting")
		}
	}

	if *myConfig.ConnectToPort == *myConfig.ListenToPort {
		logger.Errorf("Microservices can't use the same port as client and server! Aborting")
		return false

	}

	return true
}
