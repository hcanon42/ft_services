#!/bin/bash

sudo usermod -aG docker $(whoami)
sudo reboot
