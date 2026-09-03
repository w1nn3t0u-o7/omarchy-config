#!/usr/bin/env bash
# Shared logging helpers for omarchy-config scripts

if [[ -t 1 ]]; then
  _LOG_BOLD=$'\033[1m'
  _LOG_CYAN=$'\033[36m'
  _LOG_GREEN=$'\033[32m'
  _LOG_YELLOW=$'\033[33m'
  _LOG_RED=$'\033[31m'
  _LOG_RESET=$'\033[0m'
else
  _LOG_BOLD=""; _LOG_CYAN=""; _LOG_GREEN=""; _LOG_YELLOW=""; _LOG_RED=""; _LOG_RESET=""
fi

_LOG_TAG="${_LOG_BOLD}${_LOG_CYAN}[dotfiles]${_LOG_RESET}"

log_phase() { printf '%s %s\n' "$_LOG_TAG" "$*"; }

log_step() { printf '%s   -> %s\n' "$_LOG_TAG" "$*"; }

log_ok() { printf '%s   %s%s%s\n' "$_LOG_TAG" "$_LOG_GREEN" "$*" "$_LOG_RESET"; }

log_warn() { printf '%s   %sWARNING:%s %s\n' "$_LOG_TAG" "$_LOG_YELLOW" "$_LOG_RESET" "$*" >&2; }

log_err() { printf '%s   %sERROR:%s %s\n' "$_LOG_TAG" "$_LOG_RED" "$_LOG_RESET" "$*" >&2; }
