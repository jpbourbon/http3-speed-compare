package services

import (
	"io/ioutil"
	"strconv"

	"bitbucket.org/jpbourbon/http3-speed-compare/internal/utils"
)

var testMap = map[string]string{
	"A1":  "small.json",
	"A2":  "small.json",
	"A3":  "small.json",
	"A4":  "medium.json",
	"A5":  "medium.json",
	"A6":  "medium.json",
	"A7":  "large.json",
	"A8":  "large.json",
	"A9":  "large.json",
	"A10": "small.json",
	"A11": "small.json",
	"A12": "small.json",
	"A13": "medium.json",
	"A14": "medium.json",
	"A15": "medium.json",
	"A16": "large.json",
	"A17": "large.json",
	"A18": "large.json",
	"B1":  "small.json",
	"B2":  "medium.json",
	"B3":  "large.json",
}

func PrepareTestPayload() string {

	if myConfig.FileContents != "" {
		return myConfig.FileContents
	}

	name := *myConfig.TestSuite + strconv.Itoa(*myConfig.Scenario)

	myConfig.FileContents = utils.BytesToString(readFile(testMap[name]))

	return myConfig.FileContents
}

// readFile reads a file
func readFile(name string) []byte {
	dat, err := ioutil.ReadFile(myConfig.FilePath + name)
	utils.Check(err, "Read file")

	return dat
}
