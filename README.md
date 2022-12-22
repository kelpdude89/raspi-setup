# raspi-setup

Makes setting up a headless raspberry pi easy

## Installation

to start boot a fresh raspberry-pi using raspberry os (raspberry os lite 32-bit recommended)

install git
```
sudo apt install git -y
```
download the script

```bash
git clone https://github.com/kelpdude89/raspi-setup.git
```
navigate to raspi-setup
```
cd /raspi-setup
```
give quickstart.sh executable privileges:
```
chmod +x quickstart.sh
```
run quickstart.sh as root
```
sudo ./quickstart.sh
```
or do it all with one command
```
sudo apt install git -y && git clone https://github.com/kelpdude89/raspi-setup.git && cd /raspi-setup && chmod +x quickstart.sh && sudo ./quickstart.sh
```

## Usage

quickstart.sh will take you through the setup and will ask what features you want to enable/disable

## credit:
most of the script is sourced from [jeffvader84's lowfatPi](https://github.com/jeffvader84/lowfatPi) and i have made improvements.

## License

[GPL-3.0](https://choosealicense.com/licenses/gpl-3.0/)
