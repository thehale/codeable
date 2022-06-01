<!--
 Copyright (c) 2022 Rithvik Arun, Joseph Hale, Jacob Hreshchyshyn, Jacob Janes, Sai Nishanth Vaka
 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->

# Codeable
A sleek, highly readable programming langugage designed with novices in mind.

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
