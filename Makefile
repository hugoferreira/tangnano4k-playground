# Define variables for reusability and clarity
VERILOG_SOURCE=led.v
JSON_TARGET=led.json
PNR_JSON_TARGET=led_pnr.json
FINAL_BITSTREAM=led.fs
DEVICE=GW1NSR-LV4CQN48PC7/I6
PACK_DEVICE=GW1NS-4
CONSTRAINT=tangnano4k.cst
TOP_MODULE=led
BOARD=tangnano4k

# Default target to run when no arguments are given to make
all: upload

# Target for synthesis
$(JSON_TARGET): $(VERILOG_SOURCE)
	yosys -p "read_verilog $(VERILOG_SOURCE); synth_gowin -top $(TOP_MODULE) -json $@"

# Target for place and route
$(PNR_JSON_TARGET): $(JSON_TARGET)
	nextpnr-himbaechel --json $< --write $@ --device $(DEVICE) --vopt cst=$(CONSTRAINT)

# Target for packing the bitstream
$(FINAL_BITSTREAM): $(PNR_JSON_TARGET)
	gowin_pack -d $(PACK_DEVICE) -o $@ $<

# Target to upload the bitstream to the FPGA board
upload: $(FINAL_BITSTREAM)
	openFPGALoader -b $(BOARD) -f $<

# Clean up generated files
clean:
	rm -f $(JSON_TARGET) $(PNR_JSON_TARGET) $(FINAL_BITSTREAM)

# Phony targets are not files
.PHONY: all upload clean

