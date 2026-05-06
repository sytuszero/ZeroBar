#!/usr/bin/env python3
import sys
import json
import re

def update_modules(config_path, modules):
    with open(config_path, 'r') as f:
        lines = f.readlines()
    
    result = []
    in_modules_left = False
    bracket_count = 0
    
    for line in lines:
        if '"modules-left"' in line:
            result.append(line)
            in_modules_left = True
            continue
        
        if in_modules_left:
            if '[' in line:
                result.append(line)
                # Add our modules
                for module in modules:
                    result.append(f'    "{module}",\n')
                bracket_count = 1
                continue
            if ']' in line or '],' in line:
                result.append(line)
                in_modules_left = False
                continue
            # Skip lines inside modules-left array
            continue
        
        result.append(line)
    
    with open(config_path, 'w') as f:
        f.writelines(result)

if __name__ == '__main__':
    config_path = sys.argv[1]
    modules = sys.argv[2].split()
    update_modules(config_path, modules)
