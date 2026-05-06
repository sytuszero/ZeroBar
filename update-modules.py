#!/usr/bin/env python3
import json
import sys

def update_modules(config_path, installed_modules):
    with open(config_path, 'r') as f:
        content = f.read()
    
    # Parse JSON (handle JSONC comments)
    lines = content.split('\n')
    in_modules_left = False
    brace_depth = 0
    result = []
    
    i = 0
    while i < len(lines):
        line = lines[i]
        
        if '"modules-left"' in line:
            result.append(line)
            # Skip until we find the opening bracket
            i += 1
            while i < len(lines) and '[' not in lines[i]:
                result.append(lines[i])
                i += 1
            result.append(lines[i])  # Add the line with [
            i += 1
            
            # Add our modules
            for module in installed_modules:
                result.append(f'    "{module}",')
            
            # Skip until we find the closing bracket
            while i < len(lines) and ']' not in lines[i]:
                i += 1
            result.append(lines[i])  # Add the line with ]
        else:
            result.append(line)
        
        i += 1
    
    with open(config_path, 'w') as f:
        f.write('\n'.join(result))

if __name__ == '__main__':
    config_path = sys.argv[1]
    installed_modules = sys.argv[2].split(',')
    update_modules(config_path, installed_modules)
