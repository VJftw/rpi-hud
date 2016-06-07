package main

import (
	"archive/tar"
	"compress/gzip"
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"os"
)

func main() {

	var latestRelease githubLatestRelease
	err := json.Unmarshal(httpGet("https://api.github.com/repos/vjftw/rpi-hud/releases/latest"), &latestRelease)
	if err != nil {
		log.Fatal(err)
		os.Exit(1)
	}
	fmt.Printf("\nLatest Version: %v\n\n", latestRelease.TagName)

	for _, asset := range latestRelease.Assets {
		if asset.Name == fmt.Sprintf("frontend-%v.tar.gz", latestRelease.TagName) {
			download(asset.BrowserDownloadURL, "/tmp/hud-frontend.tar.gz")
			extractToDir("/tmp/hud-frontend.tar.gz", "/hud/web")
		} else if asset.Name == fmt.Sprintf("api-%v.tar.gz", latestRelease.TagName) {
			download(asset.BrowserDownloadURL, "/tmp/hud-api.tar.gz")
			extractToDir("/tmp/hud-api.tar.gz", "/hud/api")
		}

		fmt.Println()
	}
}

func download(uri string, outputFilepath string) {
	fmt.Printf("Downloading %v\n", uri)

	out, err := os.Create(outputFilepath)
	defer out.Close()

	resp, err := http.Get(uri)
	defer resp.Body.Close()

	_, err = io.Copy(out, resp.Body)

	if err != nil {
		log.Fatal(err)
		fmt.Println(err)
		os.Exit(1)
	}
}

func extractToDir(filePath string, dir string) {
	fmt.Printf("Extracting %v to %v\n", filePath, dir)

	untarIt(filePath, dir)
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

func untarIt(mpath string, dir string) {
	fr, err := read(mpath)
	defer fr.Close()
	if err != nil {
		panic(err)
	}
	gr, err := gzip.NewReader(fr)
	defer gr.Close()
	if err != nil {
		panic(err)
	}
	tr := tar.NewReader(gr)
	for {
		hdr, err := tr.Next()
		if err == io.EOF {
			// end of tar archive
			break
		}
		if err != nil {
			panic(err)
		}
		path := fmt.Sprintf("%v/%v", dir, hdr.Name)
		fmt.Printf("\t%v\n", path)
		switch hdr.Typeflag {
		case tar.TypeDir:
			if err := os.MkdirAll(path, os.FileMode(hdr.Mode)); err != nil {
				panic(err)
			}
		case tar.TypeReg:
			ow, err := overwrite(path)
			defer ow.Close()
			if err != nil {
				panic(err)
			}
			if _, err := io.Copy(ow, tr); err != nil {
				panic(err)
			}
		default:
			fmt.Printf("Can't: %c, %s\n", hdr.Typeflag, path)
		}
	}
}

func overwrite(mpath string) (*os.File, error) {
	f, err := os.OpenFile(mpath, os.O_RDWR|os.O_TRUNC, 0777)
	if err != nil {
		f, err = os.Create(mpath)
		if err != nil {
			return f, err
		}
	}
	return f, nil
}

func read(mpath string) (*os.File, error) {
	f, err := os.OpenFile(mpath, os.O_RDONLY, 0444)
	if err != nil {
		return f, err
	}
	return f, nil
}
