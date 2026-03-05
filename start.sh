#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' 

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${BLUE}"
echo "╔═════════════════════════╗"
echo "║   SAS-CAM               ║"
echo "║   Version 1.0.0         ║"
echo "╚═════════════════════════╝"
echo -e "${NC}"

if ! command -v python3 &> /dev/null; then
    echo -e "${RED}✗ Error: Python 3 is not installed${NC}"
    echo -e "${YELLOW}Please install Python 3.6 or higher:${NC}"
    echo "  Ubuntu/Debian: sudo apt install python3 python3-pip"
    echo "  Fedora/CentOS: sudo dnf install python3 python3-pip"
    echo "  Termux: pkg install python3 python3-pip"
    exit 1
fi

PYTHON_VERSION=$(python3 --version 2>&1 | grep -oP '\d+\.\d+')
echo -e "${GREEN}✓ Python $PYTHON_VERSION found${NC}"

if ! command -v pip3 &> /dev/null; then
    echo -e "${RED}✗ Error: pip3 is not installed${NC}"
    echo -e "${YELLOW}Installing pip3...${NC}"
    python3 -m ensurepip --upgrade 2>/dev/null || {
        echo -e "${RED}Failed to install pip. Please install manually.${NC}"
        exit 1
    }
fi

if [ ! -d "$SCRIPT_DIR/venv" ]; then
    echo -e "${YELLOW}Virtual environment not found. Creating...${NC}"
    python3 -m venv "$SCRIPT_DIR/venv"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Virtual environment created successfully${NC}"
    else
        echo -e "${RED}✗ Failed to create virtual environment${NC}"
        exit 1
    fi
fi

source "$SCRIPT_DIR/venv/bin/activate"
echo -e "${GREEN}✓ Virtual environment activated${NC}"

echo -e "${YELLOW}Checking dependencies...${NC}"
if [ -f "$SCRIPT_DIR/requirements.txt" ]; then
    
    pip show requests > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo -e "${YELLOW}Installing dependencies from requirements.txt...${NC}"
        pip install -q -r "$SCRIPT_DIR/requirements.txt"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Dependencies installed successfully${NC}"
        else
            echo -e "${RED}✗ Failed to install dependencies${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}✓ All dependencies are already installed${NC}"
    fi
else
    echo -e "${RED}✗ requirements.txt not found${NC}"
    exit 1
fi

echo -e "${BLUE}"
echo "═══════════════════════════════════════════════════════"
echo -e "${NC}"
echo -e "${GREEN}Launching SAS-CAM...${NC}\n"

cd "$SCRIPT_DIR"
python3 start.py

deactivate 2>/dev/null
echo -e "\n${GREEN}Thank you for using SAS-CAM!${NC}"
