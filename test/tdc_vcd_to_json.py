#!/usr/bin/env python
from vcd2json.vcd2json import WaveExtractor

def process_vcd(path_list, vcd, json):
    extractor = WaveExtractor('test.vcd', 'timer.json', path_list)
    extractor.execute()

if __name__ == '__main__':
    path_list = [
        "tb.clk_launch",
        "tb.clk_capt"   
    ]
    process_vcd(path_list, "test.vcd", "test_wf.json")

