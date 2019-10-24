package services

import (
	"time"

	"bitbucket.org/jpbourbon/http3-speed-compare/internal/utils"

	"github.com/tidwall/gjson"
	"github.com/tidwall/sjson"
)

// CreatePayloadJSON reads a JSON file to create the initial payload for the request body
func CreatePayloadJSON() []byte {
	fileBody := PrepareTestPayload()

	// Time counts only after file is read
	t := time.Now()
	json, _ := sjson.Set(fileBody, "message.meta.payloadReadyOnMicroservice"+*myConfig.Microservice, t)

	return []byte(json)
}

func SetJSONOnTouch(jsonPayload []byte) []byte {
	t := time.Now()
	json := utils.BytesToString(jsonPayload)

	json, _ = sjson.Set(json, "message.meta.touchMicroservice"+*myConfig.Microservice, t)
	if *myConfig.TestSuite == "A" && *myConfig.Microservice == "D" {
		json, _ = sjson.Delete(json, "message.body")
	}

	return []byte(json)
}

func SetJSONOnResponse(jsonPayload []byte, startTime time.Time) []byte {
	json := utils.BytesToString(jsonPayload)
	endTime := time.Now()
	msg := "message."

	switch *myConfig.TestSuite {
	case "A":
		switch *myConfig.Microservice {
		case "A":

			json, _ = sjson.Set(json, msg+"meta.startMicroserviceA", startTime)
			json, _ = sjson.Set(json, msg+"meta.endMicroserviceA", endTime)
			v := gjson.Get(json, msg+"meta.startMicroserviceB")
			startServer := v.Time()
			v = gjson.Get(json, msg+"meta.endMicroserviceB")
			endServer := v.Time()
			json, _ = sjson.Set(json, msg+"meta.elapsedBA", endTime.Sub(endServer))
			json, _ = sjson.Set(json, msg+"meta.elapsedAB", startServer.Sub(startTime))
			json, _ = sjson.Set(json, msg+"meta.elapsedABCDCBA", endTime.Sub(startTime))

		case "B":

			json, _ = sjson.Set(json, msg+"meta.startMicroserviceB", startTime)
			json, _ = sjson.Set(json, msg+"meta.endMicroserviceB", endTime)
			v := gjson.Get(json, msg+"meta.startMicroserviceC")
			startServer := v.Time()
			v = gjson.Get(json, msg+"meta.endMicroserviceC")
			endServer := v.Time()
			json, _ = sjson.Set(json, msg+"meta.elapsedCB", endTime.Sub(endServer))
			json, _ = sjson.Set(json, msg+"meta.elapsedBC", startServer.Sub(startTime))
			json, _ = sjson.Set(json, msg+"meta.elapsedBCB", endTime.Sub(startTime))

		case "C":

			json, _ = sjson.Set(json, msg+"meta.startMicroserviceC", startTime)
			json, _ = sjson.Set(json, msg+"meta.endMicroserviceC", endTime)
			v := gjson.Get(json, msg+"meta.touchMicroserviceD")
			touchServer := v.Time()
			json, _ = sjson.Set(json, msg+"meta.elapsedDC", endTime.Sub(touchServer))
			json, _ = sjson.Set(json, msg+"meta.elapsedCD", touchServer.Sub(startTime))
			json, _ = sjson.Set(json, msg+"meta.elapsedCDC", endTime.Sub(startTime))

		case "D":

			// Nothing needed

		default:
			//
		}
		//
	case "B":
		switch *myConfig.Microservice {
		case "A":
			json, _ = sjson.Set(json, msg+"meta.startMicroserviceA", startTime)
			json, _ = sjson.Set(json, msg+"meta.endMicroserviceA", endTime)
			v := gjson.Get(json, msg+"meta.touchMicroserviceB")
			touchServer := v.Time()
			json, _ = sjson.Set(json, msg+"meta.elapsedBA", endTime.Sub(touchServer))
			json, _ = sjson.Set(json, msg+"meta.elapsedAB", touchServer.Sub(startTime))
			json, _ = sjson.Set(json, msg+"meta.elapsedABA", endTime.Sub(startTime))

		case "B":
			// Nothing is needed as the touch is already done
		default:
			//
		}
	default:
		//
	}

	return []byte(json)
}
