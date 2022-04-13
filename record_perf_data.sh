#!/bin/bash

sudo perf record --call-graph dwarf -p $(pgrep shotover)
