package modules

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"time"

	"github.com/gorilla/websocket"
)

// WeatherModule - Module for the Weather
type WeatherModule struct {
	Name string        `json:"name"`
	Data smartForecast `json:"data"`
}

type smartForecast struct {
	Location           string         `json:"location"`
	CurrentTemperature string         `json:"currentTemperature"`
	CurrentIcon        string         `json:"icon"`
	CurrentSummary     string         `json:"currentSummary"`
	WeekForecast       [6]dayForecast `json:"weekForecast"`
	WeekSummary        string         `json:"weekSummary"`
}

type dayForecast struct {
	Name        string `json:"name"`
	Temperature string `json:"temperature"`
	Icon        string `json:"icon"`
}

// Run - Runs the module
func (weatherModule *WeatherModule) Run(ws *websocket.Conn) bool {

	weatherModule.Name = "weather"
	info := getLocation()
	weatherModule.Data.Location = fmt.Sprintf("%s, %s", info.City, info.Country)

	for {
		f := getForecast(info)

		weatherModule.Data.CurrentTemperature = fmt.Sprintf("%.0f", f.Currently.ApparentTemperature)
		weatherModule.Data.CurrentIcon = f.Currently.Icon
		weatherModule.Data.CurrentSummary = f.Hourly.Summary
		for i := 1; i < len(f.Daily.Data)-1; i++ {
			tm := time.Unix(f.Daily.Data[i].Time, 0)
			temp := fmt.Sprintf("%.0f", f.Daily.Data[i].ApparentTemperatureMax)
			weatherModule.Data.WeekForecast[i-1] = dayForecast{Name: tm.Weekday().String(), Temperature: temp, Icon: f.Daily.Data[i].Icon}
		}
		weatherModule.Data.WeekSummary = f.Daily.Summary

		sendModule(ws, weatherModule)

		time.Sleep(30 * time.Minute)
	}
}

func getLocation() *ipInfo {
	info := new(ipInfo)
	getJSON("http://www.ipinfo.io/json", info)

	return info
}

func getForecast(info *ipInfo) *forecastIO {
	apiKey := os.Getenv("FORECASTIO_API_KEY")
	forecastURL := fmt.Sprintf("https://api.forecast.io/forecast/%s/%s?units=si", apiKey, info.Loc)

	f := new(forecastIO)
	getJSON(forecastURL, f)

	return f
}

func getJSON(url string, target interface{}) error {
	r, err := http.Get(url)
	if err != nil {
		fmt.Println(err)
		return err
	}
	defer r.Body.Close()

	return json.NewDecoder(r.Body).Decode(target)
}

type ipInfo struct {
	IP       string `json:"ip"`
	Hostname string `json:"hostname"`
	City     string `json:"city"`
	Region   string `json:"region"`
	Country  string `json:"country"`
	Loc      string `json:"loc"`
	Org      string `json:"org"`
	Postal   string `json:"postal"`
}

type forecastIO struct {
	Currently forecastIOCurrently `json:"currently"`
	Hourly    forecastIOHourly    `json:"hourly"`
	Daily     forecastIODaily     `json:"daily"`
}

type forecastIOCurrently struct {
	ApparentTemperature float32 `json:"apparentTemperature"`
	Icon                string  `json:"icon"`
}

type forecastIOHourly struct {
	Summary string `json:"summary"`
}

type forecastIODaily struct {
	Summary string          `json:"summary"`
	Data    []forecastIODay `json:"data"`
}

type forecastIODay struct {
	Time                   int64   `json:"time"`
	Icon                   string  `json:"icon"`
	ApparentTemperatureMax float32 `json:"apparentTemperatureMax"`
}
