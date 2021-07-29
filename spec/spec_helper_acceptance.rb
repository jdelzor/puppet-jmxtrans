# This file is copied from what Vox Pupuli pushes out via modulesync
require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker(modules: :fixtures)

Dir['./spec/support/acceptance/**/*.rb'].sort.each { |f| require f }
