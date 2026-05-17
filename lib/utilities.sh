#!/bin/bash


function output() {
  printf '%s\n' "${1}"
}


function warn() {
  output "Warning:  ${1}" >&2
}


function error() {
  output "Error:  ${1}" >&2
}


function fail() {
  error "${1}"
  exit "${2:-1}"
}
