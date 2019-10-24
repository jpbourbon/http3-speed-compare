package main

import (
	"flag"
	"fmt"
	"time"

	"bitbucket.org/jpbourbon/http3-speed-compare/internal/structs"
	"bitbucket.org/jpbourbon/http3-speed-compare/internal/utils"
	"bitbucket.org/jpbourbon/http3-speed-compare/services"
)

// Instantiates the Config struct to myConfig
var myConfig structs.Config

func main() {

	// Populates the Config struct and parses CLI params
	myConfig.Verbose = flag.Bool("v", false, "verbose")
	myConfig.HttpVersion = flag.String("http", "1.1", "1.1, 2, 3")
	myConfig.Microservice = flag.String("ms", "A", "A to D")
	myConfig.TestSuite = flag.String("ts", "A", "A or B")
	myConfig.Scenario = flag.Int("s", 1, "Scenarion number")
	myConfig.ConnectToPort = flag.Int("conn", 0, "Server port to connect to. 0 for M-D")
	myConfig.ListenToPort = flag.Int("serv", 0, "Listening port of this server, 0 for M-A")
	myConfig.Host = flag.String("host", "", "To connect to {msa,msb,msc,msd}.jpbourbon-httpspeed.io")
	myConfig.ServerName = flag.String("nameserv", "", "Server name for certificates {msa,msb,msc,msd}.jpbourbon-httpspeed.io")
	myConfig.IPServer = flag.String("ipserv", "", "IP address of server")
	myConfig.DBAddress = flag.String("dbhost", "127.0.0.1", "DB host address (only M-A)")
	myConfig.DBPort = flag.Int("dbport", 3306, "DB port (only M-A)")
	myConfig.DBUsername = flag.String("dbuser", "root", "DB username (only M-A)")
	myConfig.DBPassword = flag.String("dbpass", "", "DB password (only for M-A)")
	myConfig.DBName = flag.String("dbname", "httpcompare", "DB name (only for M-A)")
	myConfig.Delay = flag.String("delay", "0", "Request delay in miliseconds")

	flag.Parse()

	// Instantiate logger and initializes verbosity level
	logger := utils.DefaultLogger

	if *myConfig.Verbose {
		logger.SetLogLevel(utils.LogLevelDebug)
	} else {
		logger.SetLogLevel(utils.LogLevelInfo)
	}

	myCfg, valid := structs.ValidateConfig(myConfig, logger)
	if !valid {
		return
	}
	myConfig = myCfg

	fmt.Println(" Address ==" + *myConfig.IPServer)
	// Start processes
	runHttp()
}

func runHttp() {
	services.SetupBootstrap(myConfig)

	switch *myConfig.Microservice {
	case "A":
		number_clients := 2000
		for i := 0; i < number_clients; i++ {
			final := services.StartClient([]byte{})
			services.StoreTestsuteB(final)
			//fmt.Printf("\n %d ", i)
			d, _ := time.ParseDuration(*myConfig.Delay + "ms")
			//fmt.Printf("%s", utils.BytesToString(final))
			//time.Sleep(200 * time.Millisecond)
			time.Sleep(d)
		}
		fmt.Printf("Finished testsuite %s, scenario %d", *myConfig.TestSuite, *myConfig.Scenario)
		return
	default:
		services.StartServer()
	}
}
