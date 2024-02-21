<!--
 Copyright (c) 2022 Rithvik Arun, Joseph Hale, Jacob Hreshchyshyn, Jacob Janes, Sai Nishanth Vaka
 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->

# Codeable
A sleek, highly readable programming langugage designed with novices in mind.

<!-- BADGES -->
[![](https://badgen.net/github/license/thehale/codeable)](https://github.com/thehale/codeable/blob/master/LICENSE)
[![](https://badgen.net/badge/icon/Sponsor/pink?icon=github&label)](https://github.com/sponsors/thehale)
[![Joseph Hale's software engineering blog](https://img.shields.io/badge/jhale.dev-black.svg?style=plastic&logo=data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNCIgaGVpZ2h0PSI0IiB2aWV3Qm94PSIwIDAgMS4wNTggMS4wNTgiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGcgY29sb3I9IiMwMDAiIHBhaW50LW9yZGVyPSJmaWxsIG1hcmtlcnMgc3Ryb2tlIj48cGF0aCBkPSJNLjY0My43NTJhLjE1Ni4xNTYgMCAwMC0uMTMuMDU5Qy40NzYuODUuNDcuOTE3LjQ2OS45M2EuMDI1LjAyNSAwIDAwLjAyNi4wMjhoLjA2NmEuMDI1LjAyNSAwIDAwLjAyNC0uMDIuMTIuMTIgMCAwMS4wMi0uMDUyQy42MTguODcuNjMyLjg2OS42NTUuODY5aC4xMjJjMC0uMDAyLjA3Ni4wMDcuMTI5LS4wNUEuMTQzLjE0MyAwIDAwLjkyOC43ODcuMDI1LjAyNSAwIDAwLjkwNi43NTJILjY0M3oiIGZpbGw9IiMwNTAiLz48cGF0aCBkPSJNLjM5My40MWEuMDIuMDIgMCAwMC0uMDIuMDJ2LjI2YzAgLjAxMi4wMDEuMDI5LS4wMTQuMDQ0Qy4zMy43NTkuMjgyLjc1LjI2Ny43MzYuMjU3LjcyOC4yNS43MTMuMjQ0LjY4N0EuMDI1LjAyNSAwIDAwLjIyLjY3SC4xNTNhLjAyNC4wMjQgMCAwMC0uMDI1LjAyNmMuMDA0LjA1Mi4wMjUuMDkuMDUxLjExOWEuMTY3LjE2NyAwIDAwLjExMy4wNTJoLjAzNWEuMTg0LjE4NCAwIDAwLjExNS0uMDVBLjE4Mi4xODIgMCAwMC40OS42OTRWLjQzMUEuMDIuMDIgMCAwMC40Ny40MXpNLjc4Ny4zOWEuMDIuMDIgMCAwMC0uMDIuMDJ2LjI0MmMwIC4wMTEuMDA5LjAyLjAyLjAyaC4wNzdhLjAyLjAyIDAgMDAuMDItLjAyVi40MTFhLjAyLjAyIDAgMDAtLjAyLS4wMnpNLjM5My4yMThhLjAyLjAyIDAgMDAtLjAyLjAydi4wNzdjMCAuMDExLjAwOC4wMi4wMi4wMkguNDdhLjAyLjAyIDAgMDAuMDItLjAyVi4yMzhhLjAyLjAyIDAgMDAtLjAyLS4wMnpNLjU5LjFhLjAyLjAyIDAgMDAtLjAyLjAydi41MzJjMCAuMDExLjAwOS4wMi4wMi4wMmguMDc3YS4wMi4wMiAwIDAwLjAyLS4wMlYuMTJBLjAyLjAyIDAgMDAuNjY3LjF6IiBmaWxsPSIjMDBkNDAwIi8+PC9nPjwvc3ZnPg==)](https://jhale.dev)
[![](https://img.shields.io/badge/Follow-thehale-0A66C2?logo=linkedin)](https://www.linkedin.com/comm/mynetwork/discovery-see-all?usecase=PEOPLE_FOLLOWS&followMember=thehale)

Codeable was created by Joseph Hale, Jacob Janes, Rithvik Arun, 
Sai Nishanth Vaka, and Jacob Hreshchyshyn as part of their coursework in Dr. Ajay Bansal's SER502 course at Arizona State University in Spring 2022.

## Installation

### Usage in a Web Browser
Codeable can be run from the web browser with no installation required. 

1. Launch [VS Code](https://code.visualstudio.com/)
2. Enable the [Live Server Extension](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer)
3. Open the folder `src/runtime` in VS Code.
4. Right-click `ide.html` and select **Open with Live Server**

A browser based development environment will then open in your browser.

### Command Line Usage
Codeable can also be run entirely on the command line.

1. Install [Node.js](https://nodejs.org/en/) (version 16 or later)
2. Open the folder `src/runtime` in a terminal.
3. Execute the command `npm install` to download all required dependencies.

Codeable code can then be execuated using the following command.
```
node .\codeable_cli.js "PATH_TO_DOT_CODE_FILE" 
```

For example, running a sample program
```
node .\codeable_cli.js "../../example/hello_world.code" 
```

## Video Demonstration
https://youtu.be/ernDGFt_-Ms
