# STM32-UART-Flashing

## Overview

This project leverages the STM32F072’s built-in bootloader to program firmware over UART. The bootloader mode is activated when the BOOT0 pin is high and the internal boot configuration bit (nBOOT1) is at its default value of 1 (as specified in RM0091 and AN2606). Communication occurs over USART1 (PA9/PA10), following the protocol detailed in AN3155.

Each of the four firmware files in the repository causes one of the four user LEDs to blink:
- **firmware1.bin:** Blinks **LD3** (Red, PC6)
- **firmware2.bin:** Blinks **LD4** (Orange, PC8)
- **firmware3.bin:** Blinks **LD5** (Green, PC9)
- **firmware4.bin:** Blinks **LD6** (Blue, PC7)

---

## Features

- **UART-Based Flashing:** Uses the built-in bootloader over USART1 for firmware programming.
- **Multiple Firmware Images:** Four firmware binaries are provided to demonstrate flashing different LED outputs.
- **Simple Bootloader Activation:** Uses the FTDI adapter’s DTR pin (connected to BOOT0) to trigger bootloader mode.
- **Standards-Compliant:** Adheres to the bootloader command set as defined in ST’s AN3155 and boot mode activation in AN2606.
- **User-Friendly Instructions:** Detailed steps and command examples make it easy for beginners and experienced developers alike.

---

## Hardware Setup

1. **Connections:**
   - **USART1 Interface:**
     - **PA9 (TX)** of the STM32 board → **RX** of the FTDI adapter.
     - **PA10 (RX)** of the STM32 board → **TX** of the FTDI adapter.
   - **Ground:** Connect the board’s GND to the FTDI adapter’s GND.
   - **BOOT0 Activation:** Connect the FTDI adapter’s **DTR** pin to the STM32 board’s **BOOT0** pin.

2. **Powering the Board:**
   - Disconnect the ST-Link USB cable (if used for debugging/powering) to avoid interference.
   - Power the board (using the FTDI adapter or an external supply) so that the DTR line (normally high) drives BOOT0 high. This ensures the MCU enters bootloader mode on reset.

---

## Flashing Procedure

1. Clone the repo
```
git clone https://github.com/Tabrez-dev/STM32-UART-Flashing.git
cd STM32-UART-Flashing
```
2. **Extract and Build the Utility:**
   - Uncompress the included `stm32flash-0.5.tar.gz`:
     ```sh
     tar -xvzf stm32flash-0.5.tar.gz
     cd stm32flash-0.5
     make
     ```
3. **Flash the Firmware:**
   - To flash a specific firmware (for example, `firmware1.bin`), run:
     ```sh
     ./stm32flash -b 115200 -R -i dtr:-dtr -v -w ../firmware1.bin /dev/ttyUSB0
     ```
   - Replace `firmware1.bin` with `firmware2.bin`, `firmware3.bin`, or `firmware4.bin` to flash the other binaries.

4. **Complete the Process:**
   - After flashing, disconnect the DTR connection from BOOT0.
   - Reconnect the board’s usual power source (e.g., via the ST-Link USB port).
   - Press the board’s reset button. With BOOT0 now low, the MCU will boot from the main flash and run the new firmware.

---

## Command Explanation

The flashing command used is:

```sh
./stm32flash -b 115200 -R -i dtr:-dtr -v -w firmwareX.bin /dev/ttyUSB0
```

- **`-b 115200`**: Sets the baud rate for UART communication.
- **`-R`**: Resets the device after flashing.
- **`-i dtr:-dtr`**: Uses the FTDI adapter’s DTR line to generate a pulse. This pulse forces BOOT0 high during reset to invoke the bootloader, and then sets BOOT0 low to allow normal booting from flash.
- **`-v`**: Verifies that the firmware was correctly written to flash.
- **`-w firmwareX.bin`**: Specifies which firmware binary to flash.
- **`/dev/ttyUSB0`**: The serial port device for the FTDI adapter.

This command conforms to the bootloader protocol described in AN3155 and the boot mode activation conditions of AN2606.

---

## Technical References

- **AN2606**: STM32 Microcontroller System Memory Boot Mode  
- **AN3155**: USART Protocol Used in the STM32 Bootloader  
- **RM0091**: STM32F0 Reference Manual  
- **RM0091**: STM32F0 data sheet  

---

## Documentation and Schematics

Below are key images referenced from the official ST documentation and datasheets (e.g. RM0091, AN2606, AN3155). These visuals explain critical aspects of the boot mode configuration and hardware setup used in this project.

- **Table 3. Boot Modes:**  
 
![image](https://github.com/user-attachments/assets/1e7b9315-87b9-45ff-b0cf-337692991307)

*From RM0091 – This table summarizes the various boot modes available for STM32F0 devices. It illustrates how the combination of the BOOT0 pin state and the nBOOT1 option bit (default set to 1) determines whether the MCU boots from main flash, system memory (bootloader), or embedded SRAM. This configuration is crucial for reliably triggering the built-in bootloader via UART. So all we need to do is to set BOOT0 pin high during power up and system memory will be selected as boot area.*

![image](https://github.com/user-attachments/assets/b2915a18-d8bc-4262-b8a4-156e022f816f)

From https://www.st.com/en/microcontrollers-microprocessors/stm32f072rb.html
  
- **On Board LED Schematic:**  
 ![image](https://github.com/user-attachments/assets/80e6d529-21ee-4845-93a4-98a2c79b4e57)

![image](https://github.com/user-attachments/assets/e5beb75c-1ef3-4885-bacc-863fb69833f7)


*This schematic shows how the user LEDs are connected on the STM32F072RBT6 Discovery board. The LEDs are assigned as follows: LD3 (red) on PC6, LD4 (orange) on PC8, LD5 (green) on PC9, and LD6 (blue) on PC7. Each firmware binary in this repository is designed to blink a specific LED, providing visual confirmation of successful firmware flashing.*

- **TX and RX:**

![image](https://github.com/user-attachments/assets/da685496-754f-4b47-a24f-d79be5689e54)

*This diagram highlights the USART1 interface connections used for UART flashing. PA9 (TX) and PA10 (RX) serve as the communication channels between the STM32’s built-in bootloader and the flashing tool. According to AN3155, these pins are configured for 8 data bits, even parity, and one stop bit to ensure reliable data transfer during the flashing process.*

- **Table 28. STM32F071xx/072xx Configuration in System Memory Boot Mode:**
 ![image](https://github.com/user-attachments/assets/d04a5165-4632-41d3-8079-f088668105cc)

*Found in AN2606 (Section 14.1), this table details the configuration of the system memory boot mode for STM32F071xx/072xx devices. It provides key parameters such as the bootloader’s location in system memory and the amount of RAM reserved for bootloader operation. This information underpins the method used to enter bootloader mode for UART flashing. From this its confirmed that we can use USART1 in bootloader mode*  

- **USART Bootloader Code Sequence :**
  
 ![image](https://github.com/user-attachments/assets/ca15dfc3-3e43-46e6-bce9-d34a565ca5ba)

*This figure illustrates the USART bootloader code sequence, commonly executed as the BL_USART_Loop. As described in AN3155, the bootloader continuously waits for and processes commands (e.g., “Get Version”, “Erase Memory”, “Write Memory”) received over USART1. This sequence is critical for understanding how the stm32flash tool interacts with the bootloader during the flashing process.*

As shown in AN2606:

![image](https://github.com/user-attachments/assets/347af418-23df-44a2-b1ce-7f9feed473da)

- **User and read protection option byte:**

![image](https://github.com/user-attachments/assets/83f32b1c-01ba-4e84-9bc2-7e1f4fe4aadf)

*Here I observed that nBoot1 is 1 by default becuase of ST production value: 0x00FF 55AA.*

---

## My Other UART-based Projects

Here are some related projects I have worked on, which implement UART communication using different approaches and techniques:

1. **[STM32 UART Interrupt-Based Driver](https://github.com/Tabrez-dev/STM32-UART-Interrupt-Based-Driver)**: This project demonstrates how to implement UART communication using interrupts on STM32 microcontrollers.

2. **[STM32 Printf UART Redirection Using CMSIS (Cortex-M0)](https://github.com/Tabrez-dev/STM32-Printf-UART-Redirection-Using-CMSIS-Cortex-M0)**: A project that shows how to use CMSIS for redirection of `printf` output to UART for debugging on STM32 Cortex-M0 microcontrollers.

3. **[Baremetal Printf to UART](https://github.com/Tabrez-dev/Baremetal-Printf-to-UART)**: This project explains how to implement `printf` redirection to UART in a bare-metal environment without using any libraries.

4. **[STM32 Baremetal UART Device Driver from Scratch](https://github.com/Tabrez-dev/STM32-Baremetal-UART-Device-Driver-from-Scratch)**: A bare-metal UART driver implementation for STM32 from scratch, focusing on low-level hardware access and driver development.

5. **[STM32 UART DMA](https://github.com/Tabrez-dev/STM32-UART-DMA)**: This project implements UART communication using Direct Memory Access (DMA) for efficient data transfer, reducing CPU overhead.  

