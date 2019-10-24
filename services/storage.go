package services

import (
	"database/sql"
	"strconv"

	"bitbucket.org/jpbourbon/http3-speed-compare/internal/utils"
	_ "github.com/go-sql-driver/mysql"
	"github.com/tidwall/gjson"
)

func StoreTestsuteB(message []byte) bool {
	dbConnect()
	if *myConfig.TestSuite == "A" {
		executeA(message)
	} else {
		executeB(message)
	}

	defer myConfig.DB.Close()

	return true
}

func executeA(message []byte) bool {
	if !myConfig.DBTableExists {
		createTableA()
	}
	insertRecordA(message)

	return true
}

func executeB(message []byte) bool {
	if !myConfig.DBTableExists {
		createTableB()
	}
	insertRecordB(message)

	return true
}

func dbConnect() bool {
	db, err := sql.Open("mysql", *myConfig.DBUsername+":"+*myConfig.DBPassword+"@tcp("+*myConfig.DBAddress+":"+strconv.Itoa(*myConfig.DBPort)+")/"+*myConfig.DBName)
	utils.Check(err, "Database")
	myConfig.DB = db

	return true
}

func createTableA() bool {
	db := *myConfig.DB
	_, err := db.Exec("CREATE TABLE IF NOT EXISTS `httpcompare`.`" + myConfig.DBTable + "` (`id` INT UNSIGNED NOT NULL AUTO_INCREMENT, `http` VARCHAR(3), `method` VARCHAR(4), `elapsedABCDCBA` BIGINT, `elapsedAB` BIGINT, `elapsedBA` BIGINT, `startMicroserviceA` VARCHAR(32), `endMicroserviceA` VARCHAR(32), `touchMicroserviceB` VARCHAR(32), `elapsedBC` BIGINT, `elapsedCB` BIGINT, `startMicroserviceB` VARCHAR(32), `endMicroserviceB` VARCHAR(32), `touchMicroserviceC` VARCHAR(32), `elapsedCD` BIGINT, `elapsedDC` BIGINT, `startMicroserviceC` VARCHAR(32), `endMicroserviceC` VARCHAR(32), `touchMicroserviceD` VARCHAR(32), `payloadReadyOnMicroserviceA` VARCHAR(32), PRIMARY KEY (`id`))")

	utils.Check(err, "Create table") // ? = placeholder

	myConfig.DBTableExists = true
	return true
}

func insertRecordA(message []byte) bool {
	json := utils.BytesToString(message)
	meta := "message.meta."
	v := gjson.Get(json, meta+"elapsedABCDCBA")
	elapsedABCDCBA := strconv.FormatInt(v.Int(), 10)
	v = gjson.Get(json, meta+"elapsedAB")
	elapsedAB := strconv.FormatInt(v.Int(), 10)
	v = gjson.Get(json, meta+"elapsedBA")
	elapsedBA := strconv.FormatInt(v.Int(), 10)
	v = gjson.Get(json, meta+"startMicroserviceA")
	startMicroserviceA := v.String()
	v = gjson.Get(json, meta+"endMicroserviceA")
	endMicroserviceA := v.String()
	v = gjson.Get(json, meta+"touchMicroserviceB")
	touchMicroserviceB := v.String()
	v = gjson.Get(json, meta+"payloadReadyOnMicroserviceA")
	payloadReadyOnMicroserviceA := v.String()
	v = gjson.Get(json, meta+"elapsedBC")
	elapsedBC := strconv.FormatInt(v.Int(), 10)
	v = gjson.Get(json, meta+"elapsedCB")
	elapsedCB := strconv.FormatInt(v.Int(), 10)
	v = gjson.Get(json, meta+"startMicroserviceB")
	startMicroserviceB := v.String()
	v = gjson.Get(json, meta+"endMicroserviceB")
	endMicroserviceB := v.String()
	v = gjson.Get(json, meta+"touchMicroserviceC")
	touchMicroserviceC := v.String()
	v = gjson.Get(json, meta+"elapsedCD")
	elapsedCD := strconv.FormatInt(v.Int(), 10)
	v = gjson.Get(json, meta+"elapsedDC")
	elapsedDC := strconv.FormatInt(v.Int(), 10)
	v = gjson.Get(json, meta+"startMicroserviceC")
	startMicroserviceC := v.String()
	v = gjson.Get(json, meta+"endMicroserviceC")
	endMicroserviceC := v.String()
	v = gjson.Get(json, meta+"touchMicroserviceD")
	touchMicroserviceD := v.String()

	db := myConfig.DB

	stmt, err := db.Prepare("INSERT INTO `" + myConfig.DBTable + "` (`http`, `method`, `elapsedABCDCBA`, `elapsedAB`, `elapsedBA`, `startMicroserviceA`, `endMicroserviceA`, `touchMicroserviceB`, `elapsedBC`, `elapsedCB`, `startMicroserviceB`, `endMicroserviceB`, `touchMicroserviceC`, `elapsedCD`, `elapsedDC`, `startMicroserviceC`, `endMicroserviceC`, `touchMicroserviceD`, `payloadReadyOnMicroserviceA`) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)")

	utils.Check(err, "Prepare record")

	defer stmt.Close()

	_, err = stmt.Exec(*myConfig.HttpVersion, myConfig.Method, elapsedABCDCBA, elapsedAB, elapsedBA, startMicroserviceA, endMicroserviceA, touchMicroserviceB, elapsedBC, elapsedCB, startMicroserviceB, endMicroserviceB, touchMicroserviceC, elapsedCD, elapsedDC, startMicroserviceC, endMicroserviceC, touchMicroserviceD, payloadReadyOnMicroserviceA)

	utils.Check(err, "Record")

	return true
}

func createTableB() bool {
	db := *myConfig.DB
	_, err := db.Exec("CREATE TABLE IF NOT EXISTS `httpcompare`.`" + myConfig.DBTable + "` (`id` INT UNSIGNED NOT NULL AUTO_INCREMENT, `http` VARCHAR(3), `method` VARCHAR(4), `clientID` VARCHAR(12), `elapsedABA` BIGINT, `elapsedAB` BIGINT, `elapsedBA` BIGINT, `startMicroserviceA` VARCHAR(32), `endMicroserviceA` VARCHAR(32), `touchMicroserviceB` VARCHAR(32), `payloadReadyOnMicroserviceB` VARCHAR(32), PRIMARY KEY (`id`))")

	utils.Check(err, "Create table") // ? = placeholder

	myConfig.DBTableExists = true
	return true
}

func insertRecordB(message []byte) bool {
	json := utils.BytesToString(message)
	meta := "message.meta."
	v := gjson.Get(json, meta+"elapsedABA")
	elapsedABA := strconv.FormatInt(v.Int(), 10)
	v = gjson.Get(json, meta+"elapsedAB")
	elapsedAB := strconv.FormatInt(v.Int(), 10)
	v = gjson.Get(json, meta+"elapsedBA")
	elapsedBA := strconv.FormatInt(v.Int(), 10)
	v = gjson.Get(json, meta+"startMicroserviceA")
	startMicroserviceA := v.String()
	v = gjson.Get(json, meta+"endMicroserviceA")
	endMicroserviceA := v.String()
	v = gjson.Get(json, meta+"touchMicroserviceB")
	touchMicroserviceB := v.String()
	v = gjson.Get(json, meta+"payloadReadyOnMicroserviceB")
	payloadReadyOnMicroserviceB := v.String()

	db := myConfig.DB

	stmt, err := db.Prepare("INSERT INTO `" + myConfig.DBTable + "` (`http`, `method`, `clientID`, `elapsedABA`, `elapsedAB`, `elapsedBA`, `startMicroserviceA`, `endMicroserviceA`, `touchMicroserviceB`, `payloadReadyOnMicroserviceB`) VALUES (?,?,?,?,?,?,?,?,?,?)")

	utils.Check(err, "Prepare record")

	defer stmt.Close()

	_, err = stmt.Exec(*myConfig.HttpVersion, myConfig.Method, myConfig.ClientID, elapsedABA, elapsedAB, elapsedBA, startMicroserviceA, endMicroserviceA, touchMicroserviceB, payloadReadyOnMicroserviceB)

	utils.Check(err, "Record")

	return true
}
