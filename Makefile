
## ---------------------------------------------------------Author : Sangeeth KS < getsangeethks@gmail.com > --------------------------------------------------------------------------------

ARMGNU ?= arm-none-eabi

XCPU = -mcpu=cortex-m0

AOPS = --warn --fatal-warnings $(XCPU)
COPS = -Wall -O2 -ffreestanding $(XCPU)
LOPS = -nostdlib 
FolderPath_BaseFolder = $(CURDIR)
FolderPath_CurrentProject = $(FolderPath_BaseFolder)/01_Projects/$(MAKECMDGOALS)
FolderPath_Startup = $(FolderPath_BaseFolder)/02_Common/Startup
FolderPath_uf2Converter = $(FolderPath_BaseFolder)/03_Tools/uf2Converter
FolderPath_temp = $(FolderPath_BaseFolder)/04_Build/temp
FolderPath_Output = $(FolderPath_BaseFolder)/04_Build/Output
FolderPath_CurrentprjOutput = $(FolderPath_BaseFolder)/04_Build/Output/$(MAKECMDGOALS)

##----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Convert2uf2 : output makeuf2 
	./makeuf2 $(FolderPath_CurrentprjOutput)/$(MAKECMDGOALS).bin $(FolderPath_CurrentprjOutput)/$(MAKECMDGOALS).uf2

##----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

clean:
	rm -f $(FolderPath_temp)/*
	rm -f makeuf2

##----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


output :               memmap.ld Addstartup 
	$(ARMGNU)-ld $(LOPS) -T memmap.ld $(FolderPath_temp)/start.o $(FolderPath_temp)/main.o -o $(FolderPath_CurrentprjOutput)/$(MAKECMDGOALS).elf -Map=$(FolderPath_CurrentprjOutput)/$(MAKECMDGOALS).map
	$(ARMGNU)-objdump -D $(FolderPath_CurrentprjOutput)/$(MAKECMDGOALS).elf > $(FolderPath_CurrentprjOutput)/$(MAKECMDGOALS).list
	$(ARMGNU)-objcopy -O binary $(FolderPath_CurrentprjOutput)/$(MAKECMDGOALS).elf $(FolderPath_CurrentprjOutput)/$(MAKECMDGOALS).bin

##----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	
makeuf2 : $(FolderPath_uf2Converter)/makeuf2.c $(FolderPath_uf2Converter)/crcpico.h
	gcc -O2 $(FolderPath_uf2Converter)/makeuf2.c -o makeuf2
	
##----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Addstartup : $(FolderPath_Startup)/start.s
	$(ARMGNU)-as $(AOPS) $(FolderPath_Startup)/start.s -o $(FolderPath_temp)/start.o

##----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Blinker : FilesUsedforBlinker Convert2uf2 clean

##-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

FilesUsedforBlinker : $(FolderPath_CurrentProject)/main.c
	$(ARMGNU)-gcc $(COPS) -mthumb -c $(FolderPath_CurrentProject)/main.c -o $(FolderPath_temp)/main.o

##----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



