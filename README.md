# Bootkit Project

This is a simple bootkit written in x86 assembly language. It demonstrates how to create a bootloader that loads and executes a custom payload before restoring the original Master Boot Record (MBR).

## Table of Contents
1. [Overview](#overview)
2. [Requirements](#requirements)
3. [Setup](#setup)
4. [Assembling the Code](#assembling-the-code)
5. [Testing the Bootkit](#testing-the-bootkit)
6. [Disclaimer](#disclaimer)

---

## Overview
The bootkit is a 16-bit assembly program that:
1. Saves the original MBR.
2. Loads a second-stage payload.
3. Executes the payload.
4. Restores the original MBR.
5. Continues the normal boot process.

This project is for **educational purposes only**. Do not use it for malicious activities.

---

## Requirements
- **NASM**: Netwide Assembler (to assemble the code).
- **QEMU**: A virtual machine emulator (to test the bootkit).
- **Git**: To clone and manage the repository.

---

## Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/ViperDroid/bootkit-project.git
   cd bootkit-project
