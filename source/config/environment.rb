# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'production'

ROOT_PATH = File.dirname(File.dirname(__FILE__))
$LOAD_PATH.unshift ROOT_PATH

require 'bundler'
Bundler.setup

require File.join(ROOT_PATH, 'config', 'initializer.rb')
