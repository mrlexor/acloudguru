package main

import (
	"bufio"
	"encoding/csv"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"os"
	"strconv"
	"strings"

	"gopkg.in/yaml.v2"
)

const (
	usage = `usage: %s
Parse /etc/passwd options:
`
)

type User struct {
	Id    int    `json:"uid"`
	Name  string `json:"name"`
	Home  string `json:"home"`
	Shell string `json:"shell"`
}

func main() {
	path, format, uid := parseFlags()
	users := collectUsers(uid)
	createFile(format, path, users)
}

func parseFlags() (path, format string, uid int64) {
	flag.StringVar(&path, "path", "", "the path to the export file. The default output to stdout.")
	flag.StringVar(&format, "format", "json", "the output format for the user information. Available options are 'csv', 'json' and 'yaml'.")
	flag.Int64Var(&uid, "uid", 100, "the uid by that you need to find user greater than.")
	flag.Usage = func() {
		fmt.Fprintf(flag.CommandLine.Output(), usage, os.Args[0])
		flag.PrintDefaults()
	}
	flag.Parse()

	format = strings.ToLower(format)

	if format != "csv" && format != "json" && format != "yaml" {
		fmt.Println("Error: invalid format. Use 'json' or 'csv' instead.")
		flag.Usage()
		os.Exit(1)
	}

	return

}

func handleError(err error) {
	if err != nil {
		fmt.Println("Error:", err)
		os.Exit(1)
	}
}

func collectUsers(uid int64) (users []User) {
	f, err := os.Open("/etc/passwd")
	handleError(err)
	defer f.Close()

	br := bufio.NewReader(f)

	var line string
	for {
		s, err := br.ReadString('\n')
		if err != nil {
			handleError(err)
		}
		if len(s) == 0 || s[0] != '#' {
			line = s
			break
		}
	}

	reader := csv.NewReader(io.MultiReader(strings.NewReader(line), br))
	reader.Comma = ':'

	lines, err := reader.ReadAll()
	handleError(err)

	for _, line := range lines {
		id, err := strconv.ParseInt(line[2], 10, 64)
		handleError(err)

		if id < uid {
			continue
		}

		user := User{
			Name:  line[0],
			Id:    int(id),
			Home:  line[5],
			Shell: line[6],
		}

		users = append(users, user)
	}

	if len(users) < 1 {
		fmt.Println("Users not found.")
		os.Exit(0)
	}
	return
}

func createFile(format, path string, users []User) {
	var output io.Writer

	if path != "" {
		f, err := os.Create(path)
		handleError(err)
		defer f.Close()
		output = f
	} else {
		output = os.Stdout
	}

	if format == "json" {
		data, err := json.MarshalIndent(users, "", "  ")
		handleError(err)
		output.Write(data)
	} else if format == "csv" {

		output.Write([]byte("name,id,home,shell\n"))
		writer := csv.NewWriter(output)
		for _, user := range users {
			err := writer.Write([]string{user.Name, strconv.Itoa(user.Id), user.Home, user.Shell})
			handleError(err)
		}
		writer.Flush()
	} else if format == "yaml" {
		data, err := yaml.Marshal(users)
		handleError(err)
		output.Write(data)
	}
}
