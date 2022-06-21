package main

import (
	"bufio"
	"os"
	"os/exec"
	"strings"

	"github.com/terraform-linters/tflint-plugin-sdk/plugin"
	"github.com/terraform-linters/tflint-plugin-sdk/tflint"
	"github.com/terraform-linters/tflint-ruleset-template/rules"
)

func main() {
	plugin.Serve(&plugin.ServeOpts{
		RuleSet: &tflint.BuiltinRuleSet{
			Name:    "template",
			Version: "0.1.0",
			Rules: []tflint.Rule{
				rules.NewAwsInstanceExampleTypeRule(),
			},
		},
	})
}

func popMap(fileName string) map[string]string {
	myMap := map[string]string{}
	file, ferr := os.Open(fileName)
	if ferr != nil {
		panic(ferr)
	}
	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		line := scanner.Text()
		items := strings.Split(line, ":")
		myMap[items[0]] = items[1]
	}
	return myMap
}

func execute() string {

	// here we perform the pwd command.
	// we can store the output of this in our out variable
	// and catch any errors in err
	cmd := `terraform show -json | jq '.values.root_module.resources[] | select(.address=="aws_instance.showcase-1") | .values.id'`
	out, err := exec.Command("bash", "-c", cmd).Output()
	//out := os.Getenv("MY_VAR")

	// if there is an error with our execution
	// handle it here
	if err != nil {
		//fmt.Printf("%s", err)
		return "Error while doing ls"
	}
	// as the out variable defined above is of type []byte we need to convert
	// this to a string or else we will see garbage printed out in our console
	// this is how we convert it to a string
	//fmt.Println("Command Successfully Executed")
	output := string(out[:])
	//fmt.Println(output)

	// let's try the pwd command herer
	// out, err = exec.Command("pwd").Output()
	// if err != nil {
	// 	fmt.Printf("%s", err)
	// }
	// fmt.Println("Command Successfully Executed")
	// output = string(out[:])
	// fmt.Println(output)
	return output
}

func getIDtoTags() map[string]string {
	idToTag := map[string]string{}
	resources, err := exec.Command("terraform", "state", "list").Output()
	if err != nil {
		return idToTag
	}
	resourcesString := string(resources[:])
	_, err2 := exec.Command("bash", "-c", "terraform show -json > output.json").Output()
	if err2 != nil {
		return idToTag
	}
	baseString := `cat output.json | jq '.values.root_module.`
	resourceArrString := `resources[]`
	childModuleString := `child_modules[]`
	selectAddressString := `select(.address==`
	valuesString := `.values.`
	resourcesByLine := strings.Split(resourcesString, "\n")
	var commandString string
	for _, resourceLine := range resourcesByLine {
		splitByPeriod := strings.Split(resourceLine, ".")
		if splitByPeriod[0] != "module" { //resource belongs to the root module
			commandString = baseString + resourceArrString + " | " + selectAddressString + `"` + resourceLine + `") | ` + valuesString

		} else { //resource belongs to child Module
			commandString = baseString + childModuleString + " | " + selectAddressString + `"` + splitByPeriod[0] + "." + splitByPeriod[1] + `")|.` + resourceArrString + " | " + selectAddressString + `"` + resourceLine + `") | ` + valuesString
		}
		AWSResourceIDString := commandString + `id'`
		yorTagString := commandString + `tags.yor_trace'`
		AWSResourceIDBytes, err := exec.Command("bash", "-c", AWSResourceIDString).Output()
		if err != nil {
			return idToTag
		}
		yorTagBytes, err := exec.Command("bash", "-c", yorTagString).Output()
		if err != nil {
			return idToTag
		}
		AWSResourceID := string(AWSResourceIDBytes[:])
		AWSResourceIDStrip := strings.Trim(AWSResourceID, "\n")
		AWSResourceIDTrim := strings.Trim(AWSResourceIDStrip, `"`)
		//fmt.Printf(AWSResourceIDTrim)
		//AWSResourceIDTrim = AWSResourceIDTrim[:len(AWSResourceIDTrim)-1]
		yorTag := string(yorTagBytes[:])
		yorTagStrip := strings.Trim(yorTag, "\n")
		yorTagTrim := strings.Trim(yorTagStrip, `"`)
		//fmt.Printf(yorTagTrim)
		if yorTagTrim == "" || AWSResourceIDTrim == "" {
			continue
		}
		idToTag[yorTagTrim] = AWSResourceIDTrim
	}
	return idToTag
}
