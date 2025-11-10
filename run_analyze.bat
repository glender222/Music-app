@echo off
flutter analyze > analyze_output.txt 2>&1
type analyze_output.txt
