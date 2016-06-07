package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"os/exec"
)

func main() {

	var latestRelease githubLatestRelease
	err := json.Unmarshal(httpGet("https://api.github.com/repos/vjftw/rpi-hud/releases/latest"), &latestRelease)
	if err != nil {
		log.Fatal(err)
		os.Exit(1)
	}
	fmt.Println(latestRelease)
	fmt.Printf("Latest Version: %v\n", latestRelease.TagName)

	for _, asset := range latestRelease.Assets {
		fmt.Printf("Updating %v\n", asset.Name)
		if asset.Name == fmt.Sprintf("frontend-%v.tar.gz", latestRelease.TagName) {
			downloadViaCurl(asset.BrowserDownloadURL, "/tmp/hud-frontend.tar.gz")
			extractToDir("/tmp/hud-frontend.tar.gz", "/hud/web")
		} else if asset.Name == fmt.Sprintf("api-%v.tar.gz", latestRelease.TagName) {
			downloadViaCurl(asset.BrowserDownloadURL, "/tmp/hud-api.tar.gz")
			extractToDir("/tmp/hud-api.tar.gz", "/hud/api")
		}
	}
}

func downloadViaCurl(uri string, outputFilepath string) {
	cmd := exec.Command("/usr/bin/curl", "-s", "-o", outputFilepath, uri)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	err := cmd.Run()
	// fmt.Println(out)

	if err != nil {
		log.Fatal(err)
		fmt.Println(err)
		os.Exit(1)
	}
}

func extractToDir(filePath string, dir string) {
	cmd := exec.Command("rm", "-rf", fmt.Sprintf("%v/*", dir))
	err := cmd.Run()

	if err != nil {
		log.Fatal(err)
		os.Exit(1)
	}

	cmd = exec.Command("tar", "-xzf", "-C", dir, filePath)
	err = cmd.Run()

	if err != nil {
		log.Fatal(err)
		os.Exit(1)
	}
}

type githubLatestRelease struct {
	AssetsURL string        `json:"assets_url"`
	TagName   string        `json:"tag_name"`
	Assets    []githubAsset `json:"assets"`
}

type githubAsset struct {
	BrowserDownloadURL string `json:"browser_download_url"`
	Name               string `json:"name"`
}

func httpGet(uri string) []byte {
	res, err := http.Get(uri)
	if err != nil {
		log.Fatal(err)
		os.Exit(1)
	}
	if res.StatusCode != http.StatusOK {
		log.Fatal(err)
	}
	body, err := ioutil.ReadAll(res.Body)
	res.Body.Close()
	if err != nil {
		log.Fatal(err)
		os.Exit(1)
	}

	return body
}
