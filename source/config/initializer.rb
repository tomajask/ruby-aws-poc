# frozen_string_literal: true

Dir[File.join(ROOT_PATH, 'app', '**', '*.rb')].sort.each { |file| require(file) }
